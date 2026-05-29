# ARD t-test

Analysis results data for paired and non-paired t-tests.

## Usage

``` r
ard_stats_t_test(data, variables, by = NULL, conf.level = 0.95, ...)

ard_stats_paired_t_test(data, by, variables, id, conf.level = 0.95, ...)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent t-tests will be computed for
  each variable.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  optional column name to compare by.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to [`t.test()`](https://rdrr.io/r/stats/t.test.html)

- id:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name of the subject or participant ID

## Value

ARD data frame

## Details

For the `ard_stats_t_test()` function, the data is expected to be one
row per subject. The data is passed as
`t.test(data[[variable]] ~ data[[by]], paired = FALSE, ...)`.

For the `ard_stats_paired_t_test()` function, the data is expected to be
one row per subject per by level. Before the t-test is calculated, the
data are reshaped to a wide format to be one row per subject. The data
are then passed as
`t.test(x = data_wide[[<by level 1>]], y = data_wide[[<by level 2>]], paired = TRUE, ...)`.

## Examples

``` r
cards::ADSL |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  ard_stats_t_test(by = ARM, variables = c(AGE, BMIBL))
#> {cards} data frame: 28 x 9
#>    group1 variable   context   stat_name stat_label      stat
#> 1     ARM      AGE stats_t_…    estimate  Mean Dif…     0.828
#> 2     ARM      AGE stats_t_…   estimate1  Group 1 …    75.209
#> 3     ARM      AGE stats_t_…   estimate2  Group 2 …    74.381
#> 4     ARM      AGE stats_t_…   statistic  t Statis…     0.655
#> 5     ARM      AGE stats_t_…     p.value    p-value     0.513
#> 6     ARM      AGE stats_t_…   parameter  Degrees …   167.362
#> 7     ARM      AGE stats_t_…    conf.low  CI Lower…    -1.668
#> 8     ARM      AGE stats_t_…   conf.high  CI Upper…     3.324
#> 9     ARM      AGE stats_t_…      method     method Welch Tw…
#> 10    ARM      AGE stats_t_… alternative  alternat… two.sided
#> ℹ 18 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 3 more variables: fmt_fun, warning, error

# constructing a paired data set,
# where patients receive both treatments
cards::ADSL[c("ARM", "AGE")] |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  dplyr::mutate(.by = ARM, USUBJID = dplyr::row_number()) |>
  dplyr::arrange(USUBJID, ARM) |>
  ard_stats_paired_t_test(by = ARM, variables = AGE, id = USUBJID)
#> {cards} data frame: 12 x 9
#>    group1 variable   context   stat_name stat_label      stat
#> 1     ARM      AGE stats_t_…    estimate  Mean Dif…     0.798
#> 2     ARM      AGE stats_t_…   statistic  t Statis…     0.628
#> 3     ARM      AGE stats_t_…     p.value    p-value     0.531
#> 4     ARM      AGE stats_t_…   parameter  Degrees …        83
#> 5     ARM      AGE stats_t_…    conf.low  CI Lower…    -1.727
#> 6     ARM      AGE stats_t_…   conf.high  CI Upper…     3.322
#> 7     ARM      AGE stats_t_…      method     method Paired t…
#> 8     ARM      AGE stats_t_… alternative  alternat… two.sided
#> 9     ARM      AGE stats_t_…          mu    H0 Mean         0
#> 10    ARM      AGE stats_t_…      paired  Paired t…      TRUE
#> 11    ARM      AGE stats_t_…   var.equal  Equal Va…     FALSE
#> 12    ARM      AGE stats_t_…  conf.level  CI Confi…      0.95
#> ℹ 3 more variables: fmt_fun, warning, error
```
