library(nycflights13)
library(tidyverse)
?flights # On-time data for all flights that departed NYC (i.e. JFK, LGA or EWR) in 2013.
flights
# flights is a tibble, a special type of data frame used by the tidyverse to avoid some common gotchas.
# The most important difference between tibbles and data frames is the way tibbles print;
# they are designed for large datasets, so they only show the first few rows and only the columns that fit on one screen.

# View(flights)
# print(flights, width = Inf)
# glimpse(flights)

flights |> filter(dep_delay > 120)
flights |> filter(month == 1 & day == 1)

# same ones
flights |> filter(month == 1 | month == 2)
flights |> filter(month %in% c(1, 2))

# jan1 <- flights |> filter(month == 1 & day == 1)

# arrange() changes the order of the rows
# flights |> arrange(year, month, day, dep_time)
# flights |> arrange(desc(dep_delay))

# flights |> distinct(origin, dest)
# flights |> distinct(origin, dest, .keep_all = TRUE)
# flights |> count(origin, dest, sort = TRUE)

# Exercises 3.2.5

# In a single pipeline for each condition, find all flights that meet the condition:
# Had an arrival delay of two or more hours
flights |> filter(arr_delay >= 120)
# Flew to Houston (IAH or HOU)
flights |> filter(dest == "IAH" | dest == "HOU")
# Were operated by United, American, or Delta
flights |> filter(carrier %in% c("UA", "AA", "DL"))
# Departed in summer (July, August, and September)
flights |> filter(month %in% c(7, 8, 9))
# Arrived more than two hours late but didn’t leave late
flights |> filter(arr_delay > 120 & dep_delay <= 0)
# Were delayed by at least an hour, but made up over 30 minutes in flight
flights |> filter(dep_delay >= 60 & dep_delay - arr_delay > 30)

# Sort flights to find the flights with the longest departure delays. Find the flights that left earliest in the morning.
flights |> arrange(desc(dep_delay))
flights |> arrange(dep_time)

# Sort flights to find the fastest flights. (Hint: Try including a math calculation inside of your function.)
flights |> arrange(desc(distance / (air_time / 60)))
flights |> mutate(speed = distance / (air_time / 60)) |> 
  arrange(desc(speed)) |> 
  select(flight, origin, dest, distance, air_time, speed)

# Was there a flight on every day of 2013?
flights |> distinct(year, month, day) # 365 rows so yes
flights |> distinct(year, month, day) |> count()

# Which flights traveled the farthest distance? Which traveled the least distance?
flights |> arrange(desc(distance)) |> 
  select(flight, origin, dest, distance)
flights |> arrange(distance) |> 
  select(flight, origin, dest, distance)

# Does it matter what order you used filter() and arrange() if you’re using both? Why/why not?
# Think about the results and how much work the functions would have to do.
# No, order does not matter.

flights |> mutate(speed = distance / air_time * 60, .after = day)
flights |> mutate(speed = distance / air_time * 60, .keep = "used")
# .before = 1

flights |> select(year:day)
flights |> select(!year:day)
flights |> select(where(is.character))
# starts_with("abc"), ends_with("xyz"), contains("ijk")
# num_range("x", 1:3): matches x1, x2 and x3
flights |> select(tail_num = tailnum)

flights |> rename(tail_num = tailnum)

flights |> relocate(time_hour, air_time)
# .after .before can be used

# Exercises

# Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
flights |> select(dep_time, dep_delay, sched_dep_time)
# sched_dep_time + dep_delay = dep_time

# Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
flights |> select(dep_time, dep_delay, arr_time, arr_delay)
flights |> select(dep_time:arr_delay)

# What happens if you specify the name of the same variable multiple times in a select() call?
flights |> select(dep_time, dep_time, dep_time)
# just one column with dep_time

# What does the any_of() function do? Why might it be helpful in conjunction with this vector?
variables <- c("year", "month", "day", "dep_delay", "arr_delay")
flights |> select(any_of(variables))

# Does the result of running the following code surprise you?
# How do the select helpers deal with upper and lower case by default? How can you change that default?
flights |> select(contains("TIME")) # contains ignores case
flights |> select(contains("TIME", ignore.case = "FALSE"))

# Rename air_time to air_time_min to indicate units of measurement and move it to the beginning of the data frame.
flights |> rename(air_time_min = air_time, .before=1)

# Why doesn’t the following work, and what does the error mean?
# flights |> select(tailnum) |> arrange(arr_delay)
# object 'arr_delay' not found
# Cause we selected tailnum and ignored the other columns

# the average departure delay by month
# n() returns the number of rows in each group
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )

# df |> slice_head(n = 1), df |> slice_tail(n = 1)
# df |> slice_min(x, n = 1), df |> slice_max(x, n = 1)
# df |> slice_sample(n = 1) takes one random row
# with_ties = FALSE

flights |> group_by(year, month, day) |> summarize(n = n()) # how many flights each day

flights |> summarize(delay = mean(dep_delay, na.rm = TRUE), n = n(), .by = month) # avg delay by month
flights |> summarize(delay = mean(dep_delay, na.rm = TRUE), n = n(), .by = c(origin, dest)) # avg delay by every unique origin&dest pair

# Exercise 3.5.7

# Which carrier has the worst average delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers?
# Why/why not? (Hint: think about flights |> group_by(carrier, dest) |> summarize(n()))
flights |> group_by(carrier) |> 
  summarize(avg_delay = mean(dep_delay, na.rm = TRUE), n= n()) |> 
  arrange(desc(avg_delay))
# F9 is the worst

# Find the flights that are most delayed upon departure from each destination.
flights |> group_by(dest) |> 
  arrange(dest, desc(dep_delay)) |> 
  relocate(dest, dep_delay)

# How do delays vary over the course of the day? Illustrate your answer with a plot.
flights |> group_by(hour) |> 
  summarize(avg_delay = mean(dep_delay, na.rm = TRUE), n= n()) |>
  ggplot(aes(x=hour, y=avg_delay)) + geom_smooth()
# It increases until 7.30 p.m. then starts decreasing

# What happens if you supply a negative n to slice_min() and friends?
flights |> group_by(dest) |> slice_min(dep_delay, n=-10)
# It takes it as a positive number.

# Explain what count() does in terms of the dplyr verbs you just learned.
# What does the sort argument to count() do?
# count() is a combination of group_by() and summarise().
flights |> count(origin)
flights |> group_by(origin) |> summarise(n = n())

# Suppose we have the following tiny data frame:
df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)

df |> group_by(y)

df |> arrange(y) # Sorts y vals - asc

df |> group_by(y) |> summarize(mean_x = mean(x))
# for "a" x vals are 1, 3, 4 so mean is 8/3=2.67
# for "b" x vals are 2 and 5 so mean is 7/2=3.5

df |> group_by(y, z) |> summarize(mean_x = mean(x))
# for "a" and "K" x val is 1 so mean is 1
# for "a" and "L" x vals are 3,4 so mean is 3.5
# for "b" and "K" x vals are 2,5 so mean is 3.5

df |> group_by(y, z) |> summarize(mean_x = mean(x), .groups = "drop")
#same but the result data frame is not grouped.

df |> group_by(y, z) |> summarize(mean_x = mean(x)) # 3 rows
df |> group_by(y, z) |> mutate(mean_x = mean(x)) # 5 rows same as original df

Lahman::Batting |> group_by(playerID) |>
  summarize(performance=sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE), n = sum(AB, na.rm = TRUE)) |>
  ggplot(aes(x=n, y=performance)) + geom_point() + geom_smooth(se=FALSE)
# h = hits, ab = at bats
?Lahman::Batting
# se = FALSE will turn off the standard error/confidence intervals for the line
