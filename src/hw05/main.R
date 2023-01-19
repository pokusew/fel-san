# data manipulation (dplyr), visualization (ggplot2), string utils (stringr::str_glue)
# see https://www.tidyverse.org/packages/
library(tidyverse)

datasets <- list.dirs(path = "data", full.names = FALSE, recursive = FALSE)

dataset <- "magic-telescope"

print(str_glue("using {dataset}"))

# load the data of the given dataset
data_anomalous <- read.table(str_glue("data/{dataset}/anomalous.txt"), header = FALSE)
rownames(data_anomalous) <- paste0("A", rownames(data_anomalous))
data_normal <- read.table(str_glue("data/{dataset}/normal.txt"), header = FALSE)
rownames(data_normal) <- paste0("N", rownames(data_normal))

# data_all <- rbind(data_anomalous %>% mutate(anomaly = TRUE), data_normal %>% mutate(anomaly = FALSE))
# # vizualize the first two dimensions to get at least some idea what we are dealing with
# data_all %>%
#   ggplot(aes(x = V1, y = V2, color = anomaly)) +
#   geom_point()

# randomly split the data into training, validation and testing sets
# the training and the validation set will contain only normal data
# the testing set has to contain anomalous data (in addition to normal data)
#   data_normal:
#     - 50 % to the training set
#     - 25 % to the validation set
#     - 25 % to the testing set
#   data_anomalous:
#     - 100 % to the testing set

# randomly shuffle the normal data
data_normal_shuffled <- data_normal[sample(nrow(data_normal)), ]
# randomly split the normal data into 4 groups (each contains roughly 25 %)
data_normal_splits <- cut(seq_len(nrow(data_normal)), breaks = 4, labels = FALSE)

# training set for fitting the models (50 % of normal samples)
data_normal_training_idxs <- which(data_normal_splits <= 2, arr.ind = TRUE)
data_training <- data_normal_shuffled[data_normal_training_idxs, ]

# validation set for selecting hyper-parameters (25 % of normal samples)
data_normal_validation_idxs <- which(data_normal_splits == 3, arr.ind = TRUE)
data_validation <- data_normal_shuffled[data_normal_validation_idxs, ]

# testing set for evaluation (25 % of normal samples + 100 % of anomalous samples)
data_normal_testing_idxs <- which(data_normal_splits == 4, arr.ind = TRUE)
data_testing_normal <- data_normal_shuffled[data_normal_testing_idxs, ]
# note: we don't need to shuffle the anomalous data or mix up them with the selected part of the normal data
data_testing <- rbind(data_testing_normal, data_anomalous)
