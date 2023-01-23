# very simple manual tests to verify correct implementation

# data manipulation (dplyr), visualization (ggplot2), string utils (stringr::str_glue)
# see https://www.tidyverse.org/packages/
library(tidyverse)

source("parzen.R")

x <- matrix(
  c(
    1, 1,
    2, 1,
    3, 2
  ),
  nrow = 3, ncol = 2
)

training_data <- matrix(
  c(
    -1, -1,
    0, 1,
    2, 1,
    1.5, 1,
    0, 0
  ),
  nrow = 5, ncol = 2
)

# make sure we uderstand what dist does
t1 <- dist(training_data)
t1.m <- as.matrix(t1)
abs(t1.m[2, 3] - sqrt(sum((training_data[2,] - training_data[3,])^2))) < 1e-5

# make sure we uderstand what pdist does
t2 <- pdist::pdist(x, training_data)
t2.m <- as.matrix(t2)
abs(t2.m[2, 3] - sqrt(sum((x[2,] - training_data[3,])^2))) < 1e-5

test_parzen <- function() {

  output1 <- parzen(
    x = c(1, 2, 3),
    training_data = c(-1, 0, 2, 1.5, 0),
    kernel_bandwidth = 3.0
  )
  expected_output1 <- c(0.12300249, 0.11154992, 0.09182667)
  diff1 <- output1 - expected_output1
  # print(diff1)
  stopifnot(all(diff1 < 1e-8))

  output2 <- parzen(
    x = c(1, 2, 3),
    training_data = c(-1, 0, 2, 1.5, 0),
    kernel_bandwidth = 1.0
  )
  expected_output2 <- c(0.22639369, 0.17268428, 0.07609717)
  diff2 <- output2 - expected_output2
  # print(diff2)
  stopifnot(all(diff2 < 1e-8))

  print(str_glue("[test_parzen] all tests passed"))

}

test_parzen_multi <- function() {

  output1a <- parzen_multi(
    x = x,
    training_data = training_data,
    kernel_bandwidth = 3.0
  )
  output1b <- parzen_multi_efficient(
    x = x,
    training_data = training_data,
    kernel_bandwidth = 3.0
  )
  expected_output1 <- c(0.11641637, 0.08738373, 0.09275637)
  diff1a <- output1a - expected_output1
  diff1b <- output1b - expected_output1
  # print(diff1a)
  # print(diff1b)
  stopifnot(all(diff1a < 1e-8))
  stopifnot(all(diff1b < 1e-8))

  print(str_glue("[test_parzen_multi] all tests passed"))

}

test_parzen()
test_parzen_multi()
