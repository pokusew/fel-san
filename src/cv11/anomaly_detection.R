library(tidyverse)
library(FNN) # kNN
library(ggplot2) # visualizations

data_anomalous <- read.csv("problems/magic-telescope/anomalous.csv", header = FALSE) %>% mutate(anomaly = TRUE)
data_normal <- read.csv("problems/magic-telescope/normal.csv", header = FALSE) %>% mutate(anomaly = FALSE)
data_all <- rbind(data_anomalous, data_normal)

data_all %>%
  ggplot(aes(x = V1, y = V2, color = anomaly)) +
  geom_point()

kfolds <- 2
# randomly shuffle the training data (data_normal)
data_normal_shuffled <- data_normal[sample(nrow(data_normal)),]
# create `kfolds` equally size folds
folds <- cut(seq(1, nrow(data_normal)), breaks = kfolds, labels = FALSE)
acc <- rep(0, times = kfolds)
# `kfolds` fold cross validation
i <- 1
# for (i in 1:kfolds) {
# segment your data by fold using the which() function
test_indexes <- which(folds == i, arr.ind = TRUE)
test_data <- data_normal_shuffled[test_indexes,]
train_data <- data_normal_shuffled[-test_indexes,]
# model <- tree(formula = class ~ ., data = trainData)
# pre <- predict(model, newdata = testData, y = TRUE, type = "class")
# acc[i] <- sum(pre == testData$class) / length(testData$class)
# }


data_all %>%
  ggplot(aes(x = V1, y = V2, color = anomaly)) +
  geom_point()





k <- 5
# random half of the normal data
train_data <- train_data %>% select(-anomaly)
test_data <- data_anomalous %>% select(-anomaly)

knn_output_train <- get.knn(train_data, k = k)

knn_output_test <- get.knnx(train_data, test_data, k = k)

score_test <- rowMeans(knn_output_test$nn.dist)
score_train <- rowMeans(knn_output_train$nn.dist)

# ROC
roc <- matrix(0, nrow = nrow(test_data), ncol = 4)
colnames(roc) <- c("index", "t", "FP", "FN")
for (i in seq(nrow(test_data))) {
  t <- score[i]
  fp <-
  roc[i, 1] <- i
  roc[i, 2] <- t
  # TP, FP
  #
  roc[i, 3] <- mean(score_test > t) # FP
  roc[i, 4] <- mean(score_test <= t) # FN
  # mean(score <= t)
  # length(score[score <= t]) / length(score)
}

roc_d <- as.data.frame(roc)
roc_d %>%
  ggplot(aes(x = t, y = FN)) +
  geom_line()





# ROC source
# 1 data = boundary points
# 2 sort


# train data half normal
