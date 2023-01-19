# very simple manual tests to verify correct implementation

source("parzen.R")

test_parzen <- function() {

  output1 <- parzen(x = c(1, 2, 3), training_data = c(-1, 0, 2, 1.5, 0), kernel_bandwidth = 3.0)
  expected_output1 <- c(0.12300249, 0.11154992, 0.09182667)
  diff1 <- output1 - expected_output1
  print(diff1)
  print(diff1 < 1e-8)

  output2 <- parzen(x = c(1, 2, 3), training_data = c(-1, 0, 2, 1.5, 0), kernel_bandwidth = 1.0)
  expected_output2 <- c(0.22639369, 0.17268428, 0.07609717)
  diff2 <- output2 - expected_output2
  print(diff2)
  print(diff2 < 1e-8)

}

test_parzen()
