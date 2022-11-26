mydata <- read.csv("data.csv", header = FALSE)

myknn <- function(data, k) {

  n <- nrow(data)

  nn.index <- matrix(0L, nrow = n, ncol = k)
  nn.dist <- matrix(0, nrow = n, ncol = k)

  # it seems that `sweep` works correctly only with matrices
  D <- as.matrix(data)
  rownames(D) <- rownames(data)

  for (i in seq(n)) {
    vector_i <- D[i,]
    other_data <- D[-i,]
    # calculate Euclidean distances between vector_i and all the other vectors
    dist <- sqrt(rowSums(sweep(other_data, 2, vector_i)^2))
    # first k nearest neighbors
    neighbors <- sort(dist)[1:k]
    nn.index[i,] <- as.integer(names(neighbors))
    nn.dist[i,] <- neighbors
  }

  return(
    list(
      nn.dist = nn.dist,
      nn.index = nn.index
    )
  )

}

library(FNN)
lib_output <- get.knn(mydata, k = 5)

my_output <- myknn(mydata, 5)

diff_dist <- sum(lib_output$nn.dist - my_output$nn.dist)
diff_index <- sum(lib_output$nn.index - my_output$nn.index)

# in order to use the lib/my_output to classify data
# check the labels of the found k-nearest neighbors
# and classify the datapoint with the label that has majority of its k-nearest neighbors
