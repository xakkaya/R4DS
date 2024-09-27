library(tidyverse)
library(scales)
library(ggrepel)
library(patchwork)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    color = "Car type",
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )

# labs(
#   x = quote(x[i]),
#   y = quote(sum(x[i] ^ 2, i == 1, n))
# )

# the cars with the highest engine size in each drive type
label_info <- mpg |>
  group_by(drv) |>
  arrange(desc(displ)) |>
  slice_head(n = 1) |>
  mutate(
    drive_type = case_when(
      drv == "f" ~ "front-wheel drive",
      drv == "r" ~ "rear-wheel drive",
      drv == "4" ~ "4-wheel drive"
    )
  ) |>
  select(displ, hwy, drv, drive_type)

# geom_text
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_text(
    data = label_info, 
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 4, hjust = "right", vjust = "bottom"
  ) +
  theme(legend.position = "none")
# (theme(legend.position = "none") turns all the legends off
# hard to read because the labels overlap with each other, and with the points

# geom_label_repel
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_label_repel(
    data = label_info, 
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5, nudge_y = 2
  ) +
  theme(legend.position = "none")

# geom_text_repel
potential_outliers <- mpg |>
  filter(hwy > 40 | (hwy > 20 & displ > 5))
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_text_repel(data = potential_outliers, aes(label = model)) +
  geom_point(data = potential_outliers, color = "red") +
  geom_point(
    data = potential_outliers,
    color = "red", size = 3, shape = "circle open"
  )

# Use geom_hline() and geom_vline() to add reference lines. We often make them thick (linewidth = 2) and
# white (color = white), and draw them underneath the primary data layer. That makes them easy to see,
# without drawing attention away from the data.
# Use geom_rect() to draw a rectangle around points of interest. The boundaries of the rectangle are defined
# by aesthetics xmin, xmax, ymin, ymax. Alternatively, look into the ggforce package, specifically geom_mark_hull(),
# which allows you to annotate subsets of points with hulls.
# Use geom_segment() with the arrow argument to draw attention to a point with an arrow. Use aesthetics x and y
# to define the starting location, and xend and yend to define the end location.

# annotate()
trend_text <- "Larger engine sizes tend to have lower fuel economy." |>
  str_wrap(width = 30)
trend_text
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  annotate(
    geom = "label", x = 3.5, y = 38,
    label = trend_text,
    hjust = "left", color = "red"
  ) +
  annotate(
    geom = "segment",
    x = 3, y = 35, xend = 5, yend = 25, color = "red",
    arrow = arrow(type = "closed")
  )

# 11.3.1 Exercises

# Use geom_text() with infinite positions to place text at the four corners of the plot.
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_smooth() +
  geom_text(aes(x = -Inf, y = -Inf, label = "Bottom Left"), hjust = -0.1, vjust = -0.5) +
  geom_text(aes(x = Inf, y = -Inf, label = "Bottom Right"), hjust = 1.1, vjust = -0.5) +
  geom_text(aes(x = -Inf, y = Inf, label = "Top Left"), hjust = -0.1, vjust = 1.5) +
  geom_text(aes(x = Inf, y = Inf, label = "Top Right"), hjust = 1.1, vjust = 1.5)

# Use annotate() to add a point geom in the middle of your last plot without having to create a tibble.
# Customize the shape, size, or color of the point.
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  annotate(
    geom = "label", x = 3, y = 27.5,
    label = trend_text,
    hjust = "left", color = "red"
  ) +
  annotate(
    geom = "segment",
    x = 3, y = 40, xend = 5, yend = 30, color = "red",
    arrow = arrow(type = "closed")
  )

# How do labels with geom_text() interact with faceting? How can you add a label to a single facet?
# How can you put a different label in each facet? (Think about the dataset that is being passed to geom_text().)
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_smooth() +
  geom_text(aes(x = -Inf, y = -Inf, label = "Bottom Left"), hjust = -0.1, vjust = -0.5) +
  facet_wrap(~cut)

# What arguments to geom_label() control the appearance of the background box?
# label.padding: Amount of padding around label. Defaults to 0.25 lines.
# label.r: Radius of rounded corners. Defaults to 0.15 lines.
# label.size: Size of label border, in mm.

# What are the four arguments to arrow()? How do they work? Create a series of plots that demonstrate
# the most important options.
# angle: The angle of the arrowhead in degrees (default is 30).
# length: A unit object specifying the length of the arrowhead (default is unit(0.25, "inches")).
# ends: Specifies which end of the line the arrow appears on: "last" (default), "first", "both".
# type: "open" (default), "closed" (filled).

######################################################################################################################

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point()
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5)) 
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL) +
  scale_color_discrete(labels = c("4" = "4-wheel", "f" = "front", "r" = "rear"))

# $10,000 vs. $10K
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(labels = label_dollar())
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(
    labels = label_dollar(scale = 1/1000, suffix = "K"), 
    breaks = seq(1000, 19000, by = 6000)
  )

# label_percent
ggplot(diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill")
ggplot(diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill") +
  scale_y_continuous(name = "Percentage", labels = label_percent())

# when each US president started and ended their term.
presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_x_date(name = NULL, breaks = presidential$start, date_labels = "'%y")

base <- ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class))
base + theme(legend.position = "right") # the default
base + theme(legend.position = "left")
base + 
  theme(legend.position = "top") +
  guides(color = guide_legend(nrow = 3))
base + 
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 3))

ggplot(diamonds, aes(x = carat, y = price)) +
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()
# same
# ggplot(diamonds, aes(x = log10(carat), y = log10(price))) +
#   geom_bin2d()

presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3"))
# For continuous color, you can use scale_color_gradient(), scale_fill_gradient().
# If you have a diverging scale, you can use scale_color_gradient2().

# 11.4.6 Exercises

# Why doesn’t the following code override the default scale?
df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)
ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_color_gradient(low = "white", high = "red") +
  coord_fixed()
# we need to use fill, not color
ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_fill_gradient(low = "white", high = "red") +
  coord_fixed()

# What is the first argument to every scale? How does it compare to labs()?
# label

# First, create the following plot. Then, modify the code using override.aes to make the legend easier to see.
ggplot(diamonds, aes(carat, price)) +
  geom_point(aes(color = cut), alpha = 1 / 20)
ggplot(diamonds, aes(carat, price)) +
  geom_point(aes(color = cut), alpha = 1 / 20) +
  guides(color = guide_legend(override.aes = list(alpha = 1)))

######################################################################################################################

# Themes

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_bw()
  # light classic linedraw dark minimal gray void

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal",
    legend.box.background = element_rect(color = "black"),
  )

######################################################################################################################

p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 1")
p2 <- ggplot(mpg, aes(x = drv, y = hwy)) + 
  geom_boxplot() + 
  labs(title = "Plot 2")
p1 + p2

p3 <- ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 3")
(p1 | p3) / p2

p1 <- ggplot(mpg, aes(x = drv, y = cty, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 1")
p2 <- ggplot(mpg, aes(x = drv, y = hwy, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 2")
p3 <- ggplot(mpg, aes(x = cty, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 3")
p4 <- ggplot(mpg, aes(x = hwy, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 4")
p5 <- ggplot(mpg, aes(x = cty, y = hwy, color = drv)) + 
  geom_point(show.legend = FALSE) + 
  facet_wrap(~drv) +
  labs(title = "Plot 5")
(guide_area() / (p1 + p2) / (p3 + p4) / p5) +
  plot_annotation(
    title = "City and highway mileage for cars with different drive trains",
    caption = "Source: https://fueleconomy.gov."
  ) +
  plot_layout(
    guides = "collect",
    heights = c(1, 3, 2, 4)
  ) &
  theme(legend.position = "top")

# 11.6.1 Exercises

# What happens if you omit the parentheses in the following plot layout. Can you explain why this happens?
p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 1")
p2 <- ggplot(mpg, aes(x = drv, y = hwy)) + 
  geom_boxplot() + 
  labs(title = "Plot 2")
p3 <- ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 3")
# (p1 | p2) / p3
p1 | p2 / p3
# It makes plot1 to sit on the leftside and plot2 and plot3 on the rightside top and bottom.

# Using the three plots from the previous exercise, recreate the following patchwork.
(p1) / (p2 | p3)
