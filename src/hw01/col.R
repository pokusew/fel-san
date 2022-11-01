T <- matrix(
  c(
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12
  ),
  nrow = 4,
  ncol = 3,
  byrow = TRUE
)

T1 <- matrix(
  c(
    # x1 x2 x3
    0, 0, 0,
    1, 1, 0,
    1, 0, 1
  ),
  nrow = 3,
  ncol = 3,
  byrow = TRUE
)

F1 <- T %*% T1


F1

