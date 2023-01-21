# data manipulation (dplyr), visualization (ggplot2), string utils (stringr::str_glue)
# see https://www.tidyverse.org/packages/
library(tidyverse)

# AUC library for calculating the area under ROC curve
# see https://en.wikipedia.org/wiki/Receiver_operating_characteristic
# see https://www.rdocumentation.org/packages/AUC/versions/0.3.2
library(AUC)

source("dataset.R")
source("parzen.R")
source("mog.R")

datasets_names <- list.dirs(path = "data", full.names = FALSE, recursive = FALSE)

# for easy development:
# dataset_name <- "breast-cancer-wisconsin"  # determinant of the training data covariance matrix is 0
# dataset_name <- "cardiotocography"  # determinant of the training data covariance matrix is 0
dataset_name <- "magic-telescope"
# dataset_name <- "pendigits"
# dataset_name <- "pima-indians"
# dataset_name <- "wall-following-robot" # nice GMM-EM hyperparamter search chart
# dataset_name <- "waveform-1"
# dataset_name <- "waveform-2"
# dataset_name <- "yeast"

print(str_glue("using {dataset_name}"))

dataset <- load_dataset(dataset_name)

# data_all <- rbind(dataset$anomalous %>% mutate(anomaly = TRUE), dataset$normal %>% mutate(anomaly = FALSE))
# # vizualize the first two dimensions to get at least some idea what we are dealing with
# data_all %>%
#   ggplot(aes(x = V1, y = V2, color = anomaly)) +
#   geom_point()

# to get consistent results
set.seed(1)
dataset_split <- random_split_dataset(dataset)

# GMM beest hyperparameter search

log_likelihoods <- NULL

find_best_gmm_model <- function(min_num_components = 2, max_num_components = 10) {

  print(str_glue("[find_best_gmm_model] num_components range {min_num_components}:{max_num_components}, starting ..."))

  # `<<-` is global assignment
  log_likelihoods <<- data.frame(
    num_components = min_num_components:max_num_components,
    log_likelihood = 0,
    num_steps = 0L,
    covergence = FALSE
  )

  best_model <- NULL
  max_log_likelihood <- -Inf

  for (i in seq_len(nrow(log_likelihoods))) {

    num_components <- log_likelihoods$num_components[i]

    print(str_glue("[find_best_gmm_model] num_components={num_components}"))

    # to have the same starting conditions
    set.seed(1)

    model_i <- gmm_em_train(
      training_data = dataset_split$training,
      num_components = num_components,
      max_num_steps = 250L,
      stop_diff = 1e-4,
      .debug = TRUE
    )

    if (!model_i$em_covergence) {
      print(str_glue("[find_best_gmm_model] num_components={num_components} no convergence"))
    }

    estimates_i <- gmm_estimate(x = dataset_split$validation, model = model_i)

    # assert that the estimated densities make sense
    stopifnot(all(0 < estimates_i), all(estimates_i < 1))

    log_likelihood_i <- sum(log(estimates_i))
    print(str_glue("[find_best_gmm_model] num_components={num_components} -> log_likelihood={log_likelihood_i}"))

    log_likelihoods$log_likelihood[i] <<- log_likelihood_i
    log_likelihoods$covergence[i] <<- model_i$em_covergence
    log_likelihoods$num_steps[i] <<- model_i$em_num_steps

    if (log_likelihood_i > max_log_likelihood) {
      max_log_likelihood <- log_likelihood_i
      best_model <- model_i
    }

  }

  return(best_model)

}

model_gmm <- find_best_gmm_model(min_num_components = 10, max_num_components = 20)

log_likelihoods %>%
    ggplot(aes(x = num_components, y = log_likelihood)) +
    geom_line()

# print("parzen running ...")
# parzen_h <- data.frame(
#   h = seq(from = 0.01, to = 10, length.out = 100),
#   likelihood = rep(x = 0, times = 100)
# )
# for (i in seq_len(100)) {
#   h <- parzen_h$h[i]
#   print(str_glue("h={h} ..."))
#   p <- parzen(x = as.matrix(data_testing), training_data = as.matrix(data_training), kernel_bandwidth = h)
#   l <- sum(log(p))
#   parzen_h$likelihood[i] <- l
# }

# parzen_h %>%
#   ggplot(aes(x = h, y = likelihood)) +
#   geom_line()

# parzen_roc <- roc(predictions, labels)
# parzen_auc <- auc(parzen_roc, min = 0, max = 1)
