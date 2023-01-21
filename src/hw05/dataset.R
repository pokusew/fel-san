#' Loads the given dataset.
#'
#' @param name the dataset name
#'
#' @return the data, a list with named attributes name, anomalous (data.frame), normal (data.frame)
#'
load_dataset <- function(name) {
  # load the data of the given dataset
  data_anomalous <- read.table(stringr::str_glue("data/{name}/anomalous.txt"), header = FALSE)
  rownames(data_anomalous) <- paste0("A", rownames(data_anomalous))
  data_normal <- read.table(stringr::str_glue("data/{name}/normal.txt"), header = FALSE)
  rownames(data_normal) <- paste0("N", rownames(data_normal))
  dataset <- list()
  dataset$name <- name
  dataset$anomalous <- data_anomalous
  dataset$normal <- data_normal
  return(dataset)
}

#' Randomly splits the given data into a training, validation, and testing set.
#'
#' @param the data as retuned by [load_dataset()]
#'
#' @return the split, a list with named attributes
#'         training (matrix ntr x d), validation (matrix nval x d), testing (matrix ntest x dim)
#'
random_split_dataset <- function(dataset) {

  # randomly split the data into training, validation and testing sets
  # the training and the validation set will contain only normal data
  # the testing set has to contain anomalous data (in addition to normal data)
  #   data_normal:
  #     - 50 % to the training set
  #     - 25 % to the validation set
  #     - 25 % to the testing set
  #   data_anomalous:
  #     - 100 % to the testing set

  # randomly shuffle the normal data and convert them to matrix (from data.frame)
  data_normal_shuffled <- as.matrix(dataset$normal[sample(nrow(dataset$normal)),])
  # randomly split the normal data into 4 groups (each contains roughly 25 %)
  data_normal_splits <- cut(seq_len(nrow(dataset$normal)), breaks = 4, labels = FALSE)

  # training set for fitting the models (50 % of normal samples)
  data_normal_training_idxs <- which(data_normal_splits <= 2, arr.ind = TRUE)
  data_training <- data_normal_shuffled[data_normal_training_idxs,]

  # validation set for selecting hyper-parameters (25 % of normal samples)
  data_normal_validation_idxs <- which(data_normal_splits == 3, arr.ind = TRUE)
  data_validation <- data_normal_shuffled[data_normal_validation_idxs,]

  # testing set for evaluation (25 % of normal samples + 100 % of anomalous samples)
  data_normal_testing_idxs <- which(data_normal_splits == 4, arr.ind = TRUE)
  data_testing_normal <- data_normal_shuffled[data_normal_testing_idxs,]
  # note: we don't need to shuffle the anomalous data or mix up them with the selected part of the normal data
  data_testing <- rbind(data_testing_normal, as.matrix(dataset$anomalous))
  data_testing_labels <- c(rep(0L, times = nrow(data_testing_normal)), rep(1L, times = nrow(dataset$anomalous)))

  dataset_split <- list()
  dataset_split$training <- data_training
  dataset_split$validation <- data_validation
  dataset_split$testing <- data_testing
  dataset_split$testing_labels <- data_testing_labels

  return(dataset_split)

}
