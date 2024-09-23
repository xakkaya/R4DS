library(tidyverse)
table1
table2
table3

table1 |> mutate(rate = cases / population * 10000)

table1 |> 
  group_by(year) |> 
  summarize(total_cases = sum(cases))

ggplot(table1, aes(x = year, y = cases)) +
  geom_line(aes(group = country)) +
  geom_point(aes(color = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000))

# Exercises 5.2.1

# For each of the sample tables, describe what each observation and each column represents.
# table2: country, year, type (cases or population), count
# table3: country, year, rate (cases / population)

# Sketch out the process you’d use to calculate the rate for table2 and table3.
# You will need to perform four operations:
# Extract the number of TB cases per country per year.
# Extract the matching population per country per year.
# Divide cases by population, and multiply by 10000.
# Store back in the appropriate place.

table2 |> 
  pivot_wider(
    names_from = type,
    values_from = count
  )

table3 |>
  separate(rate, into = c("cases", "population"), sep = "/")

billboard # billboard rank of songs in the year 2000
# we have 76 columns (wk1-wk76) that describe the rank of the song in each week

billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank"
  )

billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  )

billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week)
  ) |>
  ggplot(aes(x = week, y = rank, group = track)) + 
  geom_line()

# pivoting (reshaping)
# bp blood pressure
df <- tribble(
  ~id,  ~bp1, ~bp2,
  "A",  100,  120,
  "B",  140,  115,
  "C",  120,  125
)
df |> 
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
  )

# tuberculosis diagnoses
who2 |> 
  pivot_longer(
    cols = !(country:year),
    names_to = c("diagnosis", "gender", "age"), 
    names_sep = "_",
    values_to = "count",
    values_drop_na = TRUE
  )

# .value overrides the usual values_to argument to use the first component of the pivoted column name as a variable name in the output.
household |> 
  pivot_longer(
    cols = !family, 
    names_to = c(".value", "child"), 
    names_sep = "_", 
    values_drop_na = TRUE
  )

cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )

df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)
df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )
