library(tidyverse)

students <- read_csv("https://pos.it/r4ds-students-csv", na = c("N/A", ""))
# students |>
#   rename(
#     student_id = `Student ID`,
#     full_name = `Full Name`
#   )

# to turn them all into snake case at once
students |> janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_integer(if_else(age == "five", "5", age))
    )
  
read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)
read_csv(
  "1,2,3
  4,5,6",
  col_names = FALSE
  # col_names = c("x", "y", "z")
)
read_csv(
  "The first line of metadata
  The second line of metadata
  # A comment I want to skip
  x,y,z
  1,2,3",
  skip = 2,
  comment = "#"
)

# Exercises 7.2.4

# What function would you use to read a file where fields were separated with “|”?
# read_delim(delim = "|")

# Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?
# all of them

# What are the most important arguments to read_fwf()?
# file, col_positions (fwf_widths(), fwf_positions(), fwf_empty())

# Sometimes strings in a CSV file contain commas. To prevent them from causing problems,
# they need to be surrounded by a quoting character, like " or '. By default, read_csv()
# assumes that the quoting character will be ". To read the following text into a data frame,
# what argument to read_csv() do you need to specify?
read_csv("x,y\n1,'a,b'")

# Identify what is wrong with each of the following inline CSV files. What happens when you run the code?
read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n1,2\n1,2,3,4")
read_csv("a,b\n\"1") # no rows
read_csv("a,b\n1,2\na,b")
read_csv("a;b\n1;3") # delimiter is ; but not specified

# Practice referring to non-syntactic names in the following data frame by:
# Extracting the variable called 1.
# Plotting a scatterplot of 1 vs. 2.
# Creating a new column called 3, which is 2 divided by 1.
# Renaming the columns to one, two, and three.
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying |> select(`1`)
annoying |> ggplot(aes(x = `2`, y = `1`)) + geom_point()
annoying |> mutate(`3` = `2` / `1`) |>
  rename(
    three = `3`,
    two = `2`,
    one = `1`,
)

simple_csv <- "
  x
  10
  .
  20
  30"
df <- read_csv(
  simple_csv, 
  col_types = list(x = col_double()),
  na = "."
)
problems(df)

# col_logical(), col_double(), col_integer(), col_character(), col_factor(), col_date(), col_datetime(), col_number(), col_skip()

another_csv <- "
x,y,z
1,2,3"
read_csv(
  another_csv, 
  col_types = cols(.default = col_character())
)
read_csv(
  another_csv,
  col_types = cols_only(x = col_character())
)

sales_files <- c(
  "https://pos.it/r4ds-01-sales",
  "https://pos.it/r4ds-02-sales",
  "https://pos.it/r4ds-03-sales"
)
read_csv(sales_files, id = "file")
# The id arg adds a new col "file" to the resulting data frame that identifies the file the data come from.

# write_csv(students, "students-2.csv")
# The var type info that you just set up is lost when you save to CSV
# because you’re starting over with reading from a plain text file again.
# write_rds(students, "students.rds")
# These store data in R’s custom binary format called RDS. This means that when you reload the object,
# you are loading the exact same R object that you stored.

# library(arrow)
# write_parquet(students, "students.parquet")
# read_parquet("students.parquet")
# Parquet tends to be much faster than RDS and is usable outside of R, but does require the arrow package.

tibble(
  x = c(1, 2, 5), 
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)
# tribble() = transposed tibble
tribble(
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)
