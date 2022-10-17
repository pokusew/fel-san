library(dplyr)
library(ggplot2)

# Generate synthetic data on Marketing vs. Sales
XLABEL <- "Marketing investment"
YLABEL <- "Revenue"
SAMPLES <- 100

x <- seq(SAMPLES)

# Compare 2 industries
y_airlines_industry <- 0.005 * x + rnorm(SAMPLES, sd = 0.75)
y_food_industry <- 0.005 * x + rnorm(SAMPLES, sd = 0.15)

df_air <- data.frame(
  x = x,
  y = y_airlines_industry
)

df_food <- data.frame(
  x = x,
  y = y_food_industry
)

# Plot the Airlines industry
p1 <- df_air %>%
  ggplot(aes(x = x, y = y)) +
  geom_point()
p1

# Plot the Food industry
p2 <- df_food %>%
  ggplot(aes(x = x, y = y)) +
  geom_point() +
  ylim(-1, 2)
p2

# Add a regression line to both graphs
p2 + geom_smooth(method = 'lm')
p1 + geom_smooth(method = 'lm')

# Why do you "trust" the food industry regression more?

summary(lm(y ~ x, data = df_air))
