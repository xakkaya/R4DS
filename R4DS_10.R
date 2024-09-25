# Exploratory data analysis EDA

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.5)

# Which values are the most common? Why?
# Which values are rare? Why? Does that match your expectations?
# Can you see any unusual patterns? What might explain them?
  
smaller <- diamonds |> 
  filter(carat < 3)
ggplot(smaller, aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

# Why are there more diamonds at whole carats and common fractions of carats?
# Why are there more diamonds slightly to the right of each peak than there are slightly to the left of each peak?

# subgroups?
# How are the observations within each subgroup similar to each other?
# How are the observations in separate clusters different from each other?
# How can you explain or describe the clusters?
# Why might the appearance of clusters be misleading?

# outliers
ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.5)
# zoom into the x-axis or y-axis
ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

# unusual values: 0, ~30, and ~60
unusual <- diamonds |> 
  filter(y < 3 | y > 20) |> 
  select(price, x, y, z) |>
  arrange(y)
unusual

# Exercises 10.3.3

# Explore the distribution of each of the x, y, and z variables in diamonds. What do you learn?
# Think about a diamond and how you might decide which dimension is the length, width, and depth.
?diamonds
# x = length, y = width, z = depth

# Explore the distribution of price. Do you discover anything unusual or surprising?
# (Hint: Carefully think about the binwidth and make sure you try a wide range of values.)
ggplot(diamonds, aes(x = price)) +
  geom_histogram(binwidth = 500)
# smaller number of very expensive items
ggplot(diamonds, aes(x = price, y = carat)) +
  geom_smooth()
ggplot(diamonds, aes(x = price)) +
  geom_histogram(binwidth = 100) + 
  coord_cartesian(xlim = c(0, 2500))
# why there is small number of items at price = 1500?

# How many diamonds are 0.99 carat? How many are 1 carat? What do you think is the cause of the difference?
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.01) + 
  coord_cartesian(xlim = c(0.98, 1.01))
# 1 carat is more than 0.99 carat

diamonds |>
  filter(carat == 0.99) |>
  nrow()
diamonds |>
  filter(carat == 1.00) |>
  nrow()
# 23 & 1558

# Compare and contrast coord_cartesian() vs. xlim() or ylim() when zooming in on a histogram.
# What happens if you leave binwidth unset? What happens if you try and zoom so only half a bar shows?
# coord_cartesian() allows you to zoom in on a histogram without excluding any data points,
# xlim() & ylim() set axis limits by removing data outside ranges; leaving binwidth unset can lead to inconsistent
# bin sizes, and trying to zoom to only half a bar may create misleading visualizations that obscure important data.

#####################################################################################################################

diamonds2 <- diamonds |> 
  mutate(y = if_else(y < 3 | y > 20, NA, y))
ggplot(diamonds2, aes(x = x, y = y)) + 
  geom_point()

nycflights13::flights |> 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  ) |> 
  ggplot(aes(x = sched_dep_time)) + 
  geom_freqpoly(aes(color = cancelled), binwidth = 1/4)

# Exercises 10.4.1

# What happens to missing values in a histogram? What happens to missing values in a bar chart?
# Why is there a difference in how missing values are handled in histograms and bar charts?
# Histograms: Missing values are ignored, as they are excluded from the data used to create the bins.
# Bar Charts: Missing values can result in bars being omitted from the chart, but if the missing values
# are in the categorical variable used for grouping, they may not affect the displayed categories.

# What does na.rm = TRUE do in mean() and sum()?
# na.rm = TRUE arg in mean() and sum() tells the func. to remove any missing values before performing the calculation

# Recreate the frequency plot of scheduled_dep_time colored by whether the flight was cancelled or not.
# Also facet by the cancelled variable. Experiment with different values of the scales variable in the
# faceting function to mitigate the effect of more non-cancelled flights than cancelled flights.

nycflights13::flights |> 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  ) |> 
  ggplot(aes(x = sched_dep_time)) +
  geom_freqpoly(aes(color = cancelled), binwidth = 1/4) +
  #facet_wrap(~ cancelled, scales = "free")
  facet_wrap(~ cancelled, scales = "free_y")
  #facet_wrap(~ cancelled, scales = "fixed")

#####################################################################################################################

# Covariation is the tendency for the values of two or more variables to vary together in a related way.

ggplot(diamonds, aes(x = price)) + 
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)

ggplot(diamonds, aes(x = price, y = after_stat(density))) + 
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)
# it appears that fair diamonds (the lowest quality) have the highest average price!

ggplot(diamonds, aes(x = cut, y = price)) +
  geom_boxplot()
# It supports the counter-intuitive finding that better quality diamonds are typically cheaper!

# You might be interested to know how highway mileage varies across classes:
ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot()
# To make the trend easier to see, we can reorder class based on the median value of hwy
ggplot(mpg, aes(x = fct_reorder(class, hwy, median), y = hwy)) +
  geom_boxplot()
# 90°
ggplot(mpg, aes(x = hwy, y = fct_reorder(class, hwy, median))) +
  geom_boxplot()

# Exercises 10.5.1.1

# What variable in the diamonds dataset appears to be most important for predicting the price of a diamond?
# How is that variable correlated with cut?
# Why does the combination of those two relationships lead to lower quality diamonds being more expensive?
# carat is the most important var.
ggplot(diamonds, aes(x=carat, y=price, color=cut)) + 
  geom_smooth()
# for 4 and 5 carat, cut is fair but price is way more higher
# lower quality diamonds can be more expensive sometimes cause cut is premium | ideal

# Instead of exchanging the x and y variables, add coord_flip() as a new layer to the vertical boxplot to create
# a horizontal one. How does this compare to exchanging the variables?
ggplot(mpg, aes(x = fct_reorder(class, hwy, median), y = hwy)) +
  geom_boxplot() + 
  coord_flip()
# its the same w exchanging the vars

# One problem with boxplots is that they were developed in an era of much smaller datasets and tend to display
# a prohibitively large number of “outlying values”. One approach to remedy this problem is the letter value plot.
# Install the lvplot package, and try using geom_lv() to display the distribution of price vs. cut. What do you learn?
# How do you interpret the plots?
library("lvplot")
ggplot(diamonds, aes(x = cut, y = price, fill = cut)) + 
  geom_lv()

# Create a visualization of diamond prices vs. a categorical variable from the diamonds dataset using geom_violin(),
# then a faceted geom_histogram(), then a colored geom_freqpoly(), and then a colored geom_density().
# Compare and contrast the four plots. What are the pros and cons of each method of visualizing the distribution
# of a numerical variable based on the levels of a categorical variable?
ggplot(diamonds, aes(x = cut, y = price)) + 
  geom_violin(fill = "blue")
ggplot(diamonds, aes(x = price)) + 
  geom_histogram(binwidth = 500, fill = "blue", color = "black") + 
  facet_wrap(~ cut)
ggplot(diamonds, aes(x = price, color = cut)) + 
  geom_freqpoly(binwidth = 500)
ggplot(diamonds, aes(x = price, fill = cut)) + 
  geom_density(alpha = 0.5)

# If you have a small dataset, it’s sometimes useful to use geom_jitter() to avoid overplotting to more easily see
# the relationship between a continuous and categorical variable. The ggbeeswarm package provides a number of methods
# similar to geom_jitter(). List them and briefly describe what each one does.
# geom_beeswarm(): Arranges points to avoid overlapping while preserving the density of data points.
# It creates a visually appealing display where points are spread out horizontally within each category.
# geom_quasirandom(): Similar to geom_beeswarm(), it adds a small random noise to the x-position of the points,
# reducing overplotting while maintaining the general shape of the distribution.
# geom_violindot(): Combines the features of a violin plot and dot plot.
# It displays a violin plot's density while overlaying individual points.
# geom_sina(): Similar to geom_quasirandom(), it uses a combination of jittering and density estimation
# to spread out points, allowing for a clearer view of the data distribution and reducing overplotting.

#####################################################################################################################

ggplot(diamonds, aes(x = cut, y = color)) +
  geom_count()

diamonds |> 
  count(color, cut) |>  
  ggplot(aes(x = color, y = cut)) +
  geom_tile(aes(fill = n))

# Exercises 10.5.2.1

# How could you rescale the count dataset above to more clearly show the distribution of
# cut within color, or color within cut?
diamonds |> 
  count(color, cut) |>  
  ggplot(aes(y = color, x = cut)) +
  geom_tile(aes(fill = n))

# What different data insights do you get with a segmented bar chart if color is mapped to the x aesthetic
# and cut is mapped to the fill aesthetic? Calculate the counts that fall into each of the segments.
diamonds |> 
  count(color, cut) |>  
  ggplot(aes(x = color, fill = cut)) +
  geom_bar()

# Use geom_tile() together with dplyr to explore how average flight departure delays vary by destination and month
# of year. What makes the plot difficult to read? How could you improve it?
nycflights13::flights |>
  group_by(month, dest) |>
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) |>
  ggplot(aes(x = month, y = dest, fill = dep_delay)) +
  geom_tile()
# There are so many destinations
  
#####################################################################################################################

# geom_bin2d() and geom_hex() divide the coord. plane into 2d bins, use a fill color to display how many points
# fall into each bin. geom_bin2d() creates rectangular bins. geom_hex() creates hexagonal bins.
ggplot(smaller, aes(x = carat, y = price)) +
  geom_bin2d()
ggplot(smaller, aes(x = carat, y = price)) +
  geom_hex()

ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_width(carat, 0.1)))
  
# Exercises 10.5.3.1

# Instead of summarizing the conditional distribution with a boxplot, you could use a frequency polygon.
# What do you need to consider when using cut_width() vs. cut_number()?
# How does that impact a visualization of the 2d distribution of carat and price?
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_number(carat, 10)))
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_width(carat, 0.1)))

ggplot(smaller, aes(x = price, color = cut_number(carat, 5))) +
  geom_freqpoly()

# Visualize the distribution of carat, partitioned by price.
ggplot(smaller, aes(x = cut_number(price, 10), y = carat)) + 
  geom_boxplot() +
  coord_flip()

# Combine two of the techniques you’ve learned to visualize the combined distribution of cut, carat, and price.
ggplot(smaller, aes(x = cut_number(price, 3), y = carat, colour = cut)) +
  geom_boxplot() + 
  coord_flip()

# Two dimensional plots reveal outliers that are not visible in one dimensional plots. For example,
# some points in the following plot have an unusual combination of x and y values, which makes the points
# outliers even though their x and y values appear normal when examined separately.
# Why is a scatterplot a better display than a binned plot for this case?
diamonds |> 
  filter(x >= 4) |> 
  ggplot(aes(x = x, y = y)) +
  geom_point() +
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))
# it makes it easier to examine single points

# Instead of creating boxes of equal width with cut_width(), we could create boxes that contain roughly
# equal number of points with cut_number(). What are the advantages and disadvantages of this approach?
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_number(carat, 20)))
# bins have different widths

#####################################################################################################################

library(tidymodels)

diamonds <- diamonds |>
  mutate(
    log_price = log(price),
    log_carat = log(carat)
  )

diamonds_fit <- linear_reg() |>
  fit(log_price ~ log_carat, data = diamonds)

diamonds_aug <- augment(diamonds_fit, new_data = diamonds) |>
  mutate(.resid = exp(.resid))

ggplot(diamonds_aug, aes(x = carat, y = .resid)) + 
  geom_point()

# relative to their size, better quality diamonds are more expensive.

ggplot(diamonds_aug, aes(x = cut, y = .resid)) + 
  geom_boxplot()
