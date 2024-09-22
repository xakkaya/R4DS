# R for Data Science (2e) - Chapter 1 

library(tidyverse)
library(palmerpenguins)
library(ggthemes)

# Do penguins with longer flippers weigh more or less than penguins with shorter flippers?

# A data frame is a rectangular collection of variables (in the columns) and observations (in the rows).

#penguins
#glimpse(penguins)
View(penguins)

#?penguins

# aes = aesthetics, geom = geometrical object
# Bar charts use bar geoms (geom_bar()), line charts use line geoms (geom_line()),
# boxplots use boxplot geoms (geom_boxplot()), scatterplots use point geoms (geom_point()).
# Does the relationship between flipper length and body mass differ by species? (color = species)
# lm = linear model, labs = labels

ggplot(
  data = penguins,
  mapping = aes(x=flipper_length_mm, y=body_mass_g)
) + geom_point(mapping = aes(color = species, shape = species)) +
geom_smooth(method = "lm") +
labs(
  title = "Body mass and flipper length",
  subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
  x = "Flipper length (mm)", y = "Body mass (g)",
  color = "Species", shape = "Species"
) + scale_color_colorblind()

####################################################################################################################

# Exercises 1.2.5

# How many rows are in penguins? How many columns?
?penguins
# 344 rows and 8 columns

# What does the bill_depth_mm variable in the penguins data frame describe? Read the help for ?penguins to find out.
# bill_depth_mm: a number denoting bill depth (millimeters)

# Make a scatterplot of bill_depth_mm vs. bill_length_mm.
# That is, make a scatterplot with bill_depth_mm on the y-axis and bill_length_mm on the x-axis.
# Describe the relationship between these two variables.
ggplot(data = penguins, mapping = aes(x=bill_length_mm, y=bill_depth_mm, color=species)) + geom_point()
# When we color the plot, we see Gentoo penguins have significantly longer bills with shallow depths,
# while Adelie penguins have shorter but deeper bills. Chinstrap penguins fall in between.

# What happens if you make a scatterplot of species vs. bill_depth_mm? What might be a better choice of geom?
ggplot(data = penguins, mapping = aes(x=bill_depth_mm, y=species)) + geom_point()

# Why does the following give an error and how would you fix it?
# ggplot(data = penguins) + 
#   geom_point()
# `geom_point()` requires the following missing aesthetics: x and y.
# We need to add x and y parameters with aesthetic mapping

# What does the na.rm argument do in geom_point()? What is the default value of the argument?
# Create a scatterplot where you successfully use this argument set to TRUE.
ggplot(data = penguins, mapping = aes(x=bill_length_mm, y=bill_depth_mm, color=species)) + geom_point(na.rm = TRUE)
# When it is TRUE it removes missing values without warning in the console. Default is FALSE.

# Add the following caption to the plot you made in the previous exercise:
# “Data come from the palmerpenguins package.” Hint: Take a look at the documentation for labs().
ggplot(data = penguins, mapping = aes(x=bill_length_mm, y=bill_depth_mm, color=species)) + geom_point(na.rm = TRUE) +
  labs(caption = "Data come from the palmerpenguins package.")

# Recreate the following visualization. What aesthetic should bill_depth_mm be mapped to?
# And should it be mapped at the global level or at the geom level?
ggplot(data = penguins, mapping = aes(x=flipper_length_mm, y=body_mass_g, color=bill_depth_mm))+geom_point()+geom_smooth()
# bill_depth_mm mapped to color aesthetic, and mapped at the global level

# Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE)

# Will these two graphs look different? Why/why not?
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) +
  geom_smooth(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )
# They will look the same: aesthetic mappings that are at the global level will pass down to both local levels.
