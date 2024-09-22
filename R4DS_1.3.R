library(tidyverse)
library(palmerpenguins)
library(ggthemes)

# categorical - bar chart
# fct_infreq(species) -> reorder the bars based on their frequencies
ggplot(penguins, aes(x = fct_infreq(species))) +
  geom_bar()

# numerical
# You can set the width of the intervals in a histogram with the binwidth argument,
# which is measured in the units of the x variable
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)

ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

# Exercises 1.4.3

# Make a bar plot of species of penguins, where you assign species to the y aesthetic. How is this plot different?
ggplot(penguins, aes(y = species)) +
  geom_bar()
# It creates horizontal lines instead of vertical

# How are the following two plots different? Which aesthetic, color or fill, is more useful for changing the color of bars?
ggplot(penguins, aes(x = species)) +
  geom_bar(color = "red")

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red")
# color arg just colors the borders red, while fill arg fills the bars red.
# fill is more useful.

# What does the bins argument in geom_histogram() do?
# bins = Number of bins. Overridden by binwidth. Defaults to 30.

# Make a histogram of the carat variable in the diamonds dataset that is available when you load the tidyverse package.
# Experiment with different binwidths. What binwidth reveals the most interesting patterns?
ggplot(diamonds, aes(x=carat)) + geom_histogram(binwidth = 0.01)
ggplot(diamonds, aes(x=carat)) + geom_histogram(binwidth = 0.1)
ggplot(diamonds, aes(x=carat)) + geom_histogram(binwidth = 1)
# binwidth of 0.1 is the most useful one for me in this case.

# 1.5 Visualizing relationships

# To visualize the relationship between a numerical and a categorical variable we can use side-by-side box plots.
# A boxplot is a type of visual shorthand for measures of position (percentiles) that describe a distribution.
# It is also useful for identifying potential outliers.

# A box that indicates the range of the middle half of the data, a distance known as the interquartile range (IQR),
# stretching from the 25th percentile of the distribution to the 75th percentile.
# In the middle of the box is a line that displays the median, i.e. 50th percentile, of the distribution.
# These three lines give you a sense of the spread of the distribution
# and whether or not the distribution is symmetric about the median or skewed to one side.
# 
# Visual points that display observations that fall more than 1.5 times the IQR from either edge of the box.
# These outlying points are unusual so are plotted individually.
# 
# A line (or whisker) that extends from each end of the box and goes to the farthest non-outlier point in the distribution.

ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()

ggplot(penguins, aes(x = body_mass_g, color = species)) +
  geom_density(linewidth = 0.75)

ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density(alpha = 0.5)

# We can use stacked bar plots to visualize the relationship between two categorical variables
# The following two stacked bar plots both display the relationship between island and species,
# or specifically, visualizing the distribution of species within each island.

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()

# Using next plot we can see Gentoo penguins all live on Biscoe island and make up roughly 75% of the penguins on that island,
# Chinstrap all live on Dream island and make up roughly 50% of the penguins on that island,
# and Adelie live on all three islands and make up all of the penguins on Torgersen.

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))

# Another way, which is particularly useful for categorical variables,
# is to split your plot into facets, subplots that each display one subset of the data.
# To facet your plot by a single variable, use facet_wrap().
# The first argument of facet_wrap() is a formula3, which you create with ~ followed by a variable name.
# The variable that you pass to facet_wrap() should be categorical.
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)

# Exercises 1.5.5

# The mpg data frame that is bundled with the ggplot2 package contains 234 observations collected by the US Environmental Protection Agency on 38 car models.
# Which variables in mpg are categorical? Which variables are numerical? (Hint: Type ?mpg to read the documentation for the dataset.) How can you see this information when you run mpg?
?mpg
View(mpg)
# numerical: displ, year, cyl, cty, hwy
# categorical: trans, drv, fl, class, model, manufacturer

# Make a scatterplot of hwy vs. displ using the mpg data frame.
# Next, map a third, numerical variable to color, then size, then both color and size, then shape.
# How do these aesthetics behave differently for categorical vs. numerical variables?
ggplot(mpg, aes(x=hwy, y=displ, color=cty)) + geom_point()
ggplot(mpg, aes(x=hwy, y=displ, size=cty)) + geom_point()
ggplot(mpg, aes(x=hwy, y=displ, color=cty, size=cty)) + geom_point()
# ggplot(mpg, aes(x=hwy, y=displ, shape=year))+geom_point()
# numerical var. does not work with shape
ggplot(mpg, aes(x=hwy, y=displ, color=cty, size=cty, shape=drv)) + geom_point()

# In the scatterplot of hwy vs. displ, what happens if you map a third variable to linewidth?
ggplot(mpg, aes(x=hwy, y=displ, linewidth = cty)) + geom_point()
# Nothing happens

# What happens if you map the same variable to multiple aesthetics?
ggplot(mpg, aes(x=drv, y=drv, color=drv, size=drv, shape=drv)) + geom_point()
# not useful

# Make a scatterplot of bill_depth_mm vs. bill_length_mm and color the points by species.
# What does adding coloring by species reveal about the relationship between these two variables? What about faceting by species?
ggplot(penguins, aes(x=bill_depth_mm, y=bill_length_mm, color=species)) + geom_point()
# Adelies tend to have deeper bills while Gentoos have longer ones. Chinstraps have longer and deeper bills.
ggplot(penguins, aes(x=bill_depth_mm, y=bill_length_mm, color=species)) + 
  geom_point() + 
  facet_wrap(~species)

# Why does the following yield two separate legends? How would you fix it to combine the two legends?
ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm, 
    color = species, shape = species
  )
) +
  geom_point() +
  labs(color = "Species", shape="Species")
# add shape="Species" to labs

# Create the two following stacked bar plots.
# Which question can you answer with the first one? Which question can you answer with the second one?
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")
ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill")
# 1st: Stacked by Species within Each Island
# How many different species do islands have?
# 2nd: Stacked by Island within Each Species
# How each species spread across different islands?

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + geom_point()
# ggsave(filename = "penguin-plot.png")
# if you want to save
