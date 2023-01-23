#' Parzen window density estimation with normal kernel N(0, h^2) where h is the kernel bandwidth.
#'
#' @param x vector of N data points (scalars) where the probability density functions should be evaluated
#' @param training_data vector of M points (scalars)
#' @param kernel_bandwidth kernel bandwidth, a positive scalar double, also denoted h (hyperparameter)
#'
#' @seealso https://en.wikipedia.org/wiki/Kernel_density_estimation
#' @seealso https://cw.fel.cvut.cz/wiki/courses/be5b33rpz/labs/05_parzen/start
#'
#' @return vector of estimated densities evaluated at values given by x
#'
parzen <- function(x, training_data, kernel_bandwidth) {

  if (
    !is.numeric(kernel_bandwidth) ||
      length(kernel_bandwidth) != 1 ||
      kernel_bandwidth <= 0
  ) {
    stop("invalid value for kernel_bandwidth argument given")
  }

  n <- length(x)

  p <- rep(0, times = n)

  for (i in seq_len(n)) {
    x_minus_traning_data <- x[i] - training_data
    # compute the scaled kernels for each training point
    # (h denotes the kernel_bandwidth)
    # scaled kernel K_h(x) = 1/h * K(x/h) where K is the kernel
    # explicit formula for PDF of N(0, h^2):
    # K_h <- exp((x_minus_traning_data / kernel_bandwidth)^2 / (-2)) / (kernel_bandwidth * sqrt(2 * pi))
    # using dnorm for PDF of N(0, h^2):
    K_h <- dnorm(x_minus_traning_data, mean = 0, sd = kernel_bandwidth)
    # sum the kernels from each training point and divide by number of the training points
    p[i] <- mean(K_h)
  }

  return(p)

}

#' Parzen window density estimation with normal kernel N(0, h^2) where h is the kernel bandwidth.
#'
#' This implementation supports multi-dimensional data.
#'
#' @param x matrix (num_sample_points x dim) of data points where the probability density function should be evaluated
#' @param training_data matrix of type (num_training_points x dim) with the training data
#' @param kernel_bandwidth kernel bandwidth, a positive scalar double, also denoted h (hyperparameter)
#'
#' @seealso https://en.wikipedia.org/wiki/Kernel_density_estimation
#' @seealso https://cw.fel.cvut.cz/wiki/courses/be5b33rpz/labs/05_parzen/start
#'
#' @return vector of estimated densities evaluated at values given by x
#'
parzen_multi <- function(x, training_data, kernel_bandwidth) {

  if (
    !is.numeric(kernel_bandwidth) ||
      length(kernel_bandwidth) != 1 ||
      kernel_bandwidth <= 0
  ) {
    stop("invalid value for kernel_bandwidth argument given")
  }

  num_samples <- nrow(x)
  # num_training_points <- nrow(training_data)

  if (ncol(x) != ncol(training_data)) {
    stop("dim of x does not match dim of training_data")
  }

  p <- rep(0, times = num_samples)

  for (i in seq_len(num_samples)) {
    x_minus_traning_data <- sweep(-training_data, MARGIN = 2, STATS = x[i,], FUN = `+`)
    # compute Euclidean vector norms
    scalars <- sqrt(rowSums(x_minus_traning_data^2))
    # compute the scaled kernels for each training point
    # (h denotes the kernel_bandwidth)
    # scaled kernel K_h(x) = 1/h * K(x/h) where K is the kernel
    # explicit formula for PDF of N(0, h^2):
    # K_h <- exp((scalars / kernel_bandwidth)^2 / (-2)) / (kernel_bandwidth * sqrt(2 * pi))
    # using dnorm for PDF of N(0, h^2):
    K_h <- dnorm(scalars, mean = 0, sd = kernel_bandwidth)
    # sum the kernels from each training point and divide by number of the training points
    p[i] <- mean(K_h)
  }

  return(p)

}

#' Parzen window density estimation with normal kernel N(0, h^2) where h is the kernel bandwidth.
#'
#' This implementation supports multi-dimensional data.
#'
#' @param x matrix (num_sample_points x dim) of data points where the probability density function should be evaluated
#' @param training_data matrix of type (num_training_points x dim) with the training data
#' @param kernel_bandwidth kernel bandwidth, a positive scalar double, also denoted h (hyperparameter)
#'
#' @seealso https://en.wikipedia.org/wiki/Kernel_density_estimation
#' @seealso https://cw.fel.cvut.cz/wiki/courses/be5b33rpz/labs/05_parzen/start
#'
#' @return vector of estimated densities evaluated at values given by x
#'
parzen_multi_efficient <- function(x, training_data, kernel_bandwidth) {

  if (
    !is.numeric(kernel_bandwidth) ||
      length(kernel_bandwidth) != 1 ||
      kernel_bandwidth <= 0
  ) {
    stop("invalid value for kernel_bandwidth argument given")
  }

  if (ncol(x) != ncol(training_data)) {
    stop("dim of x does not match dim of training_data")
  }

  # compute Euclidean distances between each sample point and each training point
  # distances is matrix (num_training_points x num_samples)
  # distances[s, t] is the Euclidean distance between the x[s, ] and training_data[t, ]
  distances <- as.matrix(pdist::pdist(x, training_data))

  # compute the scaled kernels for each sample point and each training point (distances matrix row)
  # (h denotes the kernel_bandwidth)
  # scaled kernel K_h(x) = 1/h * K(x/h) where K is the kernel
  # explicit formula for PDF of N(0, h^2):
  # K_h <- exp((distances / kernel_bandwidth)^2 / (-2)) / (kernel_bandwidth * sqrt(2 * pi))
  # using dnorm for PDF of N(0, h^2):
  K_h <- dnorm(distances, mean = 0, sd = kernel_bandwidth)

  # sum the kernels from each sample point and each training point (distances matrix row)
  # and divide by number of the training points
  p <- rowMeans(K_h)

  return(p)

}
