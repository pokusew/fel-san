#' Gaussian mixture model (GMM) with Expectation Maximization (EM) algorithm.
#'
#' @param x matrix (num_sample_points x dim) of data points where the probability density functions should be evaluated
#' @param training_data training data (num_training_points x dim)
#' @param num_components number of Gaussian components (hyperparameter)
#'
#' @seealso https://people.csail.mit.edu/rameshvs/content/gmm-em.pdf
#' @seealso https://en.wikipedia.org/wiki/Mixture_model#Multivariate_Gaussian_mixture_model
#' @seealso https://brilliant.org/wiki/gaussian-mixture-model/
#'
#' @return vector (of size num_sample_points) of estimated densities evaluated at values given by x
#'
gmm_em <- function (x, training_data, num_components, num_steps = 60) {

  num_samples <- dim(x)[1]
  d <- dim(x)[2]

  # initilization step

  c_alphas <- rep(1/num_components, times = num_components)
  c_means <- sample(training_data, size = num_components, replace = FALSE)
  c_cov_matrices <- matrix(list(matrix(0, 2, 2)), 3, 1)


  for (step in seq_len(num_steps)) {

    # expectation (E) step


    # maximization (M) step

  }

  p <- rep(0, times = n)

  for (i in seq_len(n)) {
    x_minus_traning_data <- x[i] - training_data
    # compute the scaled kernels for each training point
    # (h denotes the kernel_bandwidth)
    # scaled kernel K_h(x) = 1/h * K(x/h) where K is the kernel
    K_h <- dnorm(x_minus_traning_data, mean = 0, sd = num_components)
    # sum the kernels from each training point and divide by number of the training points
    p[i] <- mean(K_h)
  }

  return(p)

}
