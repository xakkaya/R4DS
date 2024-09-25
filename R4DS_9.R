library(tidyverse)
mpg

ggplot(mpg, aes(x = displ, y = hwy, color=class)) + 
  geom_point()

# The shape palette can deal with a maximum of 6 discrete values
# Warning: Using size for a discrete variable is not advised.
# Warning: Using alpha for a discrete variable is not advised.

# Create a scatterplot of hwy vs. displ where the points are pink filled in triangles.
ggplot(mpg, aes(x = displ, y = hwy, color=class)) + 
  geom_point(color = "pink", shape = "triangle")

# Why did the following code not result in a plot with blue points?
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy, color = "blue"))
# Color should not be inside of aes

# What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(stroke = 2), shape = 21)
# Stroke controls the width of the border (outline) around certain point shapes (21-25)

# What happens if you map an aesthetic to something other than a variable name, like aes(color = displ < 5)?
# Note, you’ll also need to specify x and y.
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = displ < 5))
# it makes it true or false. if it is smaller than 5 then it makes it blue

ggplot(mpg, aes(x = displ, y = hwy, linetype = drv)) + 
  geom_smooth()
# geom_smooth() separates the cars into three lines based on their drv value, which describes a car’s drive train.
# One line describes all of the points that have a 4 value, one line describes all of the points that have an f value,
# one line describes all of the points that have an r value.
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point() +
  geom_smooth(aes(linetype = drv))

ggplot(mpg, aes(x = displ, y = hwy)) + geom_smooth()
ggplot(mpg, aes(x = displ, y = hwy)) + geom_smooth(aes(group = drv))
ggplot(mpg, aes(x = displ, y = hwy)) + geom_smooth(aes(color = drv))

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    color = "red"
  ) +
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    shape = "circle open", size = 3, color = "red"
  )

ggplot(mpg, aes(x = hwy)) + geom_histogram(binwidth = 2)
ggplot(mpg, aes(x = hwy)) + geom_density()
ggplot(mpg, aes(x = hwy)) + geom_boxplot()

# Exercises 9.3.1

# What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
# line chart -> geom_line(), boxplot -> geom_boxplot(), histogram -> geom_histogram(), area chart -> geom_area()

#   Earlier in this chapter we used show.legend without explaining it:
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE)
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv))
# it removes the legend for colors

# What does the se argument to geom_smooth() do?
# shows or hides the confidence interval (its like a shadow)
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(se = TRUE)
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(size=2)) +
  geom_smooth(se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(size=2)) +
  geom_smooth(aes(group = drv), se = FALSE)

#####################################################################################################################

# facets
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_wrap(~cyl)
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl)
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl, scales = "free") # free_x, free_y

# Exercises 9.4.1

# What happens if you facet on a continuous variable?
?mpg
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_wrap(~cty)

# What do the empty cells in the plot above with facet_grid(drv ~ cyl) mean?
# Run the following code. How do they relate to the resulting plot?
ggplot(mpg) + 
  geom_point(aes(x = drv, y = cyl))
# for exmaple, there are no cars with 5 cylinders and rear wheel drive

# What plots does the following code make? What does . do?
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
# dont facet across columns
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
# dont facet across rows

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~ cyl, nrow = 2)
# What are the advantages to using faceting instead of the color aesthetic?
# What are the disadvantages? How might the balance change if you had a larger dataset?
# it splits the screen by different plots so this makes it easier to examine them individually
# but it makes it harder to dintinguish plots visually, colors are better for this

# Read ?facet_wrap. What does nrow do? What does ncol do?
# What other options control the layout of the individual panels?
# Why doesn’t facet_grid() have nrow and ncol arguments?
?facet_wrap
# nrow, ncol: Number of rows and columns.
# facet_grid() The number of rows and columns is automatically determined.

# Which of the following plots makes it easier to compare engine size (displ) across cars with different drive trains?
# What does this say about when to place a faceting variable across rows or columns?
ggplot(mpg, aes(x = displ)) + 
  geom_histogram() + 
  facet_grid(drv ~ .)
ggplot(mpg, aes(x = displ)) + 
  geom_histogram() +
  facet_grid(. ~ drv)
# first one. histograms are more clear.

# Recreate the following plot using facet_wrap() instead of facet_grid().
# How do the positions of the facet labels change?
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(drv ~ .)
# facet grid used rows, facet wrap used columns
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(~drv, nrow = 3)

#####################################################################################################################

ggplot(diamonds, aes(x = cut)) + 
  geom_bar()

# Many graphs, like scatterplots, plot the raw values of your dataset. Other graphs, calculate new values to plot:
# Bar charts, histograms, and frequency polygons bin your data and then plot bin counts,
# the number of points that fall in each bin.
# Smoothers fit a model to your data and then plot predictions from the model.
# Boxplots compute the five-number summary of the distribution and
# then display that summary as a specially formatted box.

# The algorithm used to calculate new values for a graph is called a stat, statistical transformation

?geom_bar
# geom, stat: Override the default connection between geom_bar() and stat_count(). stat = "count"
#geom_bar() uses stat_count() by default: it counts the number of cases at each x position.

# We change the stat of geom_bar() from count (the default) to identity
diamonds |>
  count(cut) |>
  ggplot(aes(x = cut, y = n)) +
  geom_bar(stat = "identity")

# You might want to override the def mapping from transformed vars to aesthetics.
# You might want to display a bar chart of proportions, rather than counts:
ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) + 
  geom_bar()

# Computed variables: These are calculated by the 'stat' part of layers and can be accessed with delayed evaluation.
# after_stat(count): number of points in bin.
# after_stat(prop): groupwise proportion

ggplot(diamonds) + 
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

# Exercises 9.5.1

# What is the default geom associated with stat_summary()?
# How could you rewrite the previous plot to use that geom function instead of the stat function?
diamonds |> group_by(cut) |>
  summarize(
    lower = min(depth),
    upper = max(depth),
    midpoint = median(depth)
  ) |>
  ggplot(aes(x = cut, y = midpoint)) +
  geom_pointrange(aes(ymin = lower, ymax = upper))

# What does geom_col() do? How is it different from geom_bar()?
# geom_col() expects data in a summarized form.
# geom_bar() take raw data and counts the occurrences automatically.

# Most geoms and stats come in pairs that are almost always used in concert. Make a list of all the pairs.
# What do they have in common? (Hint: Read through the documentation.)
# Some stats and geoms that are paired are:
# geom_violin() and stat_ydensity()
# geom_histogram() and stat_bin()
# geom_contour() and stat_contour()
# geom_function() and stat_function()
# geom_bin_2d() and stat_bin_2d()
# geom_boxplot() and stat_boxplot()
# geom_count() and stat_sum()
# geom_density() and stat_density()
# geom_density_2d() and stat_density_2d()
# geom_hex() and stat_binhex()
# geom_quantile() and stat_quantile()
# geom_smooth() and stat_smooth()

# What variables does stat_smooth() compute? What arguments control its behavior?
# stat_smooth() computes the values necessary to plot a smooth line (e.g., a regression line)
# y: The predicted (smoothed) value for each x.
# ymin: The lower bound of the confidence interval around the smoothed values (if se = TRUE).
# ymax: The upper bound of the confidence interval around the smoothed values (if se = TRUE).
# se: Logical, whether or not to display a confidence interval around the smoothed line.

# In our proportion bar chart, we needed to set group = 1. Why?
In other words, what is the problem with these two graphs?
ggplot(diamonds, aes(x = cut, y = after_stat(prop))) + 
  geom_bar()
ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop))) + 
  geom_bar()
# The reason you needed to set group = 1 in your proportion bar chart is to ensure that the 
# proportions are calculated correctly. Without it, ggplot2 will try to group the data by the x var.
ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) + 
  geom_bar()
ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop), group = color)) + 
  geom_bar()

#####################################################################################################################

ggplot(mpg, aes(x = drv, color = drv)) + # border
  geom_bar()
ggplot(mpg, aes(x = drv, fill = drv)) + 
  geom_bar()
# The stacking is performed automatically using the position adjustment specified by the position argument.
# If you don’t want a stacked bar chart, you can use one of three other options: "identity", "dodge" or "fill".
# position = "identity" will place each object exactly where it falls in the context of the graph.
# This is not very useful for bars, because it overlaps them. 
# position = "fill" works like stacking, but makes each set of stacked bars the same height.
# This makes it easier to compare proportions across groups.
# position = "dodge" places overlapping objects directly beside one another.
# This makes it easier to compare individual values.
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "fill")
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "dodge")

# Exercises 9.6.1

# What is the problem with the following plot? How could you improve it?
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point()
# We can add randomness
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point(position = "jitter")

# What, if anything, is the difference between the two plots? Why?
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(position = "identity")
# They are the same

# What parameters to geom_jitter() control the amount of jittering?
# width, height: Amount of vertical and horizontal jitter. 

# Compare and contrast geom_jitter() with geom_count().
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_jitter()
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_count()
# Both add randomness but geom_count adds it based on the count
# geom_jitter() adds random noise to separate overlapping points, preserving individual observations,
# while geom_count() represents overlapping points by varying their size based on the number of overlaps

# What’s the default position adjustment for geom_boxplot()?
# Create a visualization of the mpg dataset that demonstrates it.
# position = "dodge2"
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_boxplot()
# Warning: Continuous x aesthetic
# ℹ did you forget `aes(group = ...)`?
ggplot(mpg, aes(x = cty, y = displ)) +
  geom_boxplot(position = "dodge2")
# Warning: Continuous x aesthetic
# ℹ did you forget `aes(group = ...)`?

#####################################################################################################################

# The def coordinate system is the Cartesian coordinate system where the x and y positions act independently.

nz <- map_data("nz")
ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

# coord_quickmap() sets the aspect ratio correctly for geographic maps.
ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

# coord_polar() uses polar coord. Polar coord.s reveal an interesting conn. between a bar chart and a Coxcomb chart.
ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = clarity, fill = clarity), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) + 
  coord_flip() + 
  coord_polar()

# Exercises 9.7.1

# Turn a stacked bar chart into a pie chart using coord_polar().
ggplot(mpg, aes(x = drv, fill = drv)) + 
  geom_bar() +
  coord_polar()

# What’s the difference between coord_quickmap() and coord_map()?
# coord_quickmap() approximates the correct aspect ratio for maps without heavy computation,
# coord_map() provides more accurate map projections but is slower due to its complex calculations.

# What does the following plot tell you about the relationship between city and highway mpg?
# Why is coord_fixed() important? What does geom_abline() do?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()
# Highway mpg is always higher than city mpg
# coord_fixed() ensures that the aspect ratio of the plot is fixed, with equal units on both the x and y axes.
# This is important for this plot because it ensures that a 45-degree line (added with geom_abline())
# geom_abline() adds x=y line.

#####################################################################################################################
