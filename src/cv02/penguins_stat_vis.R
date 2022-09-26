## Run just once
install.packages("remotes")
remotes::install_github("allisonhorst/palmerpenguins")

library(tidyverse)
library(palmerpenguins)

View(penguins)

# Take care of missing values
penguins_clean <- penguins %>% drop_na()

# See, how many observations are for each species
peng_counts <- penguins_clean %>%
  group_by(species) %>%
  summarise(count = n())

# And plot the results
ggplot(data = peng_counts, aes(x = species, y = count, fill = species)) +
  geom_col() +
  theme_minimal()

# Try following:
#   - remove "fill=species"
#   - replace "fill=species" with "col=species"
#   - replace geom_point() with geom_col()?
#   - explore documentation of theme_minimal() to find other themes. Apply them.
#       - remove theme_minimal()

# Task 1
# Let's try a different graph (you can pipe data directly to the plotting function)
penguins_clean %>%
  ggplot(aes(x = flipper_length_mm, y = bill_length_mm, col = species)) +
  geom_point() +
  theme_minimal()

penguins_clean %>%
  ggplot(aes(x = flipper_length_mm, y = body_mass_g, col = species)) +
  geom_point() +
  theme_minimal()

# Task 2
# Let's see, how penguins in each island differ
penguins_clean %>%
  ggplot(aes(x = flipper_length_mm, y = body_mass_g, col = island)) +
  geom_point() +
  theme_minimal()

# To differentiate the meaning of color (species vs. island), try different palette
# You can get inspired at https://www.r-graph-gallery.com/38-rcolorbrewers-palettes
# Which palette(s) you think suits best?
install.packages("RColorBrewer")
library(RColorBrewer)

penguins_clean %>%
  ggplot(aes(x = flipper_length_mm, y = body_mass_g, col = island)) +
  geom_point() +
  theme_minimal() +
  scale_color_brewer(palette = "Dark2")

# Task 3
penguins_clean %>%
  ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(shape = island, color = species)) +
  theme_minimal() +
  scale_color_brewer(palette = "Paired")

# --------------------------- STATISTICAL ANALYSIS PART ----------------------------
# Compute the average weight for each species
summary_table <- penguins_clean %>%
  select(species, body_mass_g) %>%
  group_by(species) %>%
  summarise(mean_weight = mean(body_mass_g))

# But the mean is by itself useless. Why?
# Add standard deviation, which is a measure of how spread the values are
summary_table <- penguins_clean %>%
  select(species, body_mass_g) %>%
  group_by(species) %>%
  summarise(mean_weight_g = mean(body_mass_g),
            sd_weight_g = sd(body_mass_g))

# Are the differences in SD big or small? Let's visualize
penguins_clean %>%
  filter(species %in% c('Adelie', 'Chinstrap')) %>%
  ggplot(aes(x = species, y = body_mass_g, col = species)) +
  geom_point() +
  coord_flip() +
  theme_minimal()

# Task 1
# Compute standard deviation for Adelie species by hand - use functions mean(), nrow()
# Use the provided vector and check with the reference value
adelie_df <- penguins_clean %>%
  filter(species == 'Adelie')
# Reference value (uncomment)
#sd(adelie_df$body_mass_g)
adelie.var <- sum((000 - 000)^2) / (000 - 1)
adelie.sd <- sqrt(adelie.var)

# Better way to visualize the spread of values - histogram
penguins_clean %>%
  filter(species %in% c('Adelie', 'Chinstrap')) %>%
  ggplot(aes(x = body_mass_g, fill = species)) +
  geom_histogram() +
  theme_minimal()

# What does a normalized version resemble?
penguins_clean %>%
  filter(species %in% c('Adelie', 'Chinstrap')) %>%
  ggplot(aes(x = body_mass_g, col = species)) +
  geom_density(aes(y = ..density..)) +
  xlim(2000, 5000) +
  theme_minimal()

# --------------
# Draw graphs for each species
for (i in 1:nrow(summary_table)) {
  peng_mean <- summary_table$mean_weight_g[i]
  peng_sd <- summary_table$sd_weight_g[i]
  peng <- summary_table$species[i]

  peng_plot <- penguins_clean %>%
    filter(species == peng) %>%
    ggplot(aes(x = body_mass_g, fill = species)) +
    geom_density(aes(y = ..density..)) +
    xlim(2000, 7000) +
    # Draw mean and SD
    geom_vline(xintercept = peng_mean, size = 1) +
    geom_vline(xintercept = peng_mean - 2 * peng_sd) +
    geom_vline(xintercept = peng_mean - peng_sd) +
    geom_vline(xintercept = peng_mean + peng_sd) +
    geom_vline(xintercept = peng_mean + 2 * peng_sd) +
    theme_minimal()
  print(peng_plot)
}


