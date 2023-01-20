#' Parzen window density estimation with normal kernel N(0, h^2) where h is the kernel bandwidth.
#'
#' @param x vector of N data points (scalars) where the probability density functions should be evaluated
#' @param training_data vector of M points (scalars)
#' @param kernel_bandwidth kernel bandwidth, a positive scalar, (also denoted h) (hyperparameter)
#'
#' @seealso https://en.wikipedia.org/wiki/Kernel_density_estimation
#' @seealso https://cw.fel.cvut.cz/wiki/courses/be5b33rpz/labs/05_parzen/start
#'
#' @return vector of estimated densities evaluated at values given by x
#'
parzen <- function(x, training_data, kernel_bandwidth) {

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
