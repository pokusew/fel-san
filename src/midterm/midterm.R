set.seed(1)
x1 <- runif(100)
x2 <- 0.5 * x1 + rnorm(100) / 10
y <- 2 + 2 * x1 + 0.3 * x2 + rnorm(100)
# y = 2 + 2 * x1 + 0.15 * x1 + 0.3 * (rnorm(100) / 10) + rnorm(100)

data <- data.frame(
  y = y,
  x1 = x1,
  x2 = x2
)

# 1. OLS using all variables
ols_full_model <- lm(y ~ x1 + x2, data = data)
summary(ols_full_model)
# F-statistic is greater than 1, model is singnificant
# the estimated coeficients are:
#   beta_0 = 2.1305 (while the true value is 2)
#   beta_1 = 1.4396 (while the true value is 2)
#   beta_2 = 1.0097 (while the true value is 0.3)

# 2. OLS using only x1, resp. x2 variable
ols_x1_model <- lm(y ~ x1, data = data)
summary(ols_x1_model)
# the estimated coeficients are:
#   beta_0 = 2.1124
#   beta_1 = 1.9759
ols_x2_model <- lm(y ~ x2, data = data)
# the estimated coeficients are:
#   beta_0 = 2.3899
#   beta_1 = 2.8996
summary(ols_x2_model)

# 3. new observation
data_v2 <- data.frame(
  y = c(y, 6),
  x1 = c(x1, 0.1),
  x2 = c(x2, 0.8)
)
ols_full_model_v2 <- lm(y ~ x1 + x2, data = data_v2)
summary(ols_full_model_v2)
# the estimated coeficients are:
#   beta_0 = 2.2267 (while the true value is 2)
#   beta_1 = 0.5394 (while the true value is 2)
#   beta_2 = 2.5146 (while the true value is 0.3)
y_v2_real <- 2 + 2 * (0.1) + 0.3 * (0.8) # == 2.44 (vs 6 we added)
# The observation signifcatly changes the estimated coeficients' values.
# beta_1 is now much lower than it should be and it is not even siginicant anymore
# The REASON for this influence is that our newly added observtion is an outlier.
plot(ols_full_model_v2)
# From the "Residuals vs Leverage" plot we can see that our newly added data point
# is an influential point (big leverage, big error).
# If we remove this observation, the coefficients of the model will change significantly.
