## Illustrate linear regression
## This script stems from the lab accompanying Chapter 3 of Introduction to Statistical Learning

# collection of demo data sets and functions (we will use Boston dataset)
library("MASS")
# tutorial data sets
library("ISLR")
library(tidyverse)

## use Boston data set available in MASS to predict median house value in neighborhoods around Boston
help(Boston) # learn the structure of the dataset, 506 areas described by 14 variables, medv will serve as the target variable

# Plot the relationship between lstat (the percent of low socioeconomic households)
# and medv (median value of homes in $1000.)
Boston %>%
  ggplot(aes(x = lstat, y = medv)) +
  geom_point()

## Simple linear regression
lm_fit <- lm(medv ~ lstat, data = Boston)

# visualize the relationship between the independent and the dependent variable
Boston %>%
  ggplot(aes(x = lstat, y = medv)) +
  geom_point() +
  # visualize the fit
  geom_abline(slope = lm_fit$coefficients["lstat"],
              intercept = lm_fit$coefficients["(Intercept)"],
              size = 1, col = "red") +
  ggtitle("Relationship between lower status population and house prices")

summary(lm_fit) # show extensive metrics about the model

# ----------------------------------------- END OF THE 3rd LAB ----------------------------------------------
###################################
## Diagnosing a regression model ##
###################################
names(lm_fit)   # get all component names of the lm model
confint(lm_fit) # confidence intervals around the coefficient estimates

# see the diagnostic plots. The first command arranges the plots into a 2x2 grid
par(mfrow = c(2, 2))
plot(lm_fit)

## Summary
# There is an obvious relationship between the independent variable (household status) and the dependent variable (median house value).
# Both the F-stat for the whole model and t-stat for the predictor are significant, the predictor helps to explain more than 50% of the variance in the target variable.
# The median house price is around $34500, on average it decreases by $950 with one percent increase of households with low socioeconomical status.
# For lstat > 30%, the price virtually becomes $0 (the model does not extrapolate well for these unobserved values).
# Both the data plot and the residual plot suggest that the relationship is rather non-linear.
# Consequences: prediction could be improved with additional non-linear terms, assumptions are violated, estimations do not have to be perfect (namely p-values, confidence intervals).

##################################
## Polynomial linear regression ##
##################################
# Fit a degree 2 polynomial
nlm_fit <- lm(medv ~ poly(lstat, 2), data = Boston)

# Did we improve our model? Compare with the summary of lm_fit
summary(nlm_fit)

# Examine the new diagnostic plots. Which undesirable symptoms vanished? Which are still present?
plot(nlm_fit)

# Test, whether the second model is significantly better
anova(lm_fit, nlm_fit)
# We will look at ANOVA in next labs, but the concept is not new - it's an F-test that compares 2 models via their R2 scores


################################
## Multiple linear regression ##
################################
# Use multiple/all/relevant predictors in a single model
lm_fit_all <- lm(medv ~ ., data = Boston)

summary(lm_fit_all) # model improves again, only some of the variables seem to be unimportant, we may want to exclude them

lm_fit_exclude <- lm(medv ~ . - age - indus, data = Boston) #  exclude age and indus
summary(lm_fit_exclude) # the simpler model seems to maintain the performance of the previous model
anova(lm_fit_all, lm_fit_exclude) # no difference, the simpler model pref

## Finally, try some feature selection methods
step <- stepAIC(lm_fit_all, direction = "both") # stepwise regression, based on AIC criterion
step$anova # display results, actually does the same as we did manually, removes age and indus

################################################
## Shrinkage (or also Regularization) methods ##
################################################
library("glmnet") # enables LASSO and ridge

# Fit LASSO to remove unimportant predictors.
# First, create a vector of shrinkage parameters (lambda) to try
lambda_grid <- 10^seq(2, -2, length = 100)

# Extract the independent variables (the X matrix) for fitting purposes
BostonX <- Boston %>% dplyr::select(-medv) %>% as.matrix()

lasso_model <- glmnet(
  x = BostonX,
  y = Boston$medv,
  alpha = 1,
  lambda = lambda_grid,
  standardize = TRUE
)

# Look at this graph. What do you think it's showing?
plot(lasso_model, "lambda", label = TRUE)

# CV (cross validation) measures the performance of models associated with each lambda value
# Recall, that lambda controls the RMSE-vs-shrinkage trade-off.
lasso_cv_out <- cv.glmnet(
  x = BostonX,
  y = Boston$medv,
  alpha = 1
)
# Plot lambda vs. RMSE
plot(lasso_cv_out)
# Determine the 'optimal' lambda value
lasso_lambda <- lasso_cv_out$lambda.min
# Obtain the regression coefficients given by the optimal lambda
lasso_coefficients <- predict(lasso_model, type = "coefficients", s = lasso_lambda)

# Display the coefficients and selected variables
print("LASSO coefficients:")
# The absolute coefficient values influenced by the scale of the individual variables (e.g. nox has a small scale)
print(lasso_coefficients)
print(as.matrix(lasso_coefficients)[seq(2, length(Boston) - 1),] != 0)

## Questions for a bonus point:
# 1. What procedure is used to find the lambda?
# 2. Apart from lasso_cv_out$lambda.min there is another option for picking the lambda parameter - lasso_cv_out$lambda.1se
#      Compare their values and find them in the plot(lasso_cv_out).
#      How choosing the other lambda affects the model in terms of accuracy and complexity?
# 3. How LASSO differs from ridge and how would you perform ridge regression? (hint: look at what parameters were used in the glmnet function)

## Summary
# To avoid overfitting and increase simplicity and understandability of the model, only relevant features should be used.
# We have shown three different approaches to feature selection: p-values, stepwise regression and LASSO.
# All of them came to the same conclusion: two features should be removed from the model.
