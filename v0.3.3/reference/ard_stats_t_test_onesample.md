# ARD one-sample t-test

Analysis results data for one-sample t-tests. Result may be stratified
by including the `by` argument.

## Usage

``` r
ard_stats_t_test_onesample(
  data,
  variables,
  by = dplyr::group_vars(data),
  conf.level = 0.95,
  ...
)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be analyzed. Independent t-tests will be computed for
  each variable.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  optional column name to stratify results by.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to [`t.test()`](https://rdrr.io/r/stats/t.test.html)

## Value

ARD data frame

## Examples

``` r
cards::ADSL |>
  ard_stats_t_test_onesample(by = ARM, variables = AGE)
#> {cards} data frame: 30 x 10
#>    group1 group1_level variable   stat_name stat_label      stat
#> 1     ARM      Placebo      AGE    estimate       Mean    75.209
#> 2     ARM      Placebo      AGE   statistic  t Statis…    81.193
#> 3     ARM      Placebo      AGE     p.value    p-value         0
#> 4     ARM      Placebo      AGE   parameter  Degrees …        85
#> 5     ARM      Placebo      AGE    conf.low  CI Lower…    73.368
#> 6     ARM      Placebo      AGE   conf.high  CI Upper…    77.051
#> 7     ARM      Placebo      AGE      method     method One Samp…
#> 8     ARM      Placebo      AGE alternative  alternat… two.sided
#> 9     ARM      Placebo      AGE          mu    H0 Mean         0
#> 10    ARM      Placebo      AGE  conf.level  CI Confi…      0.95
#> ℹ 20 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 4 more variables: context, fmt_fun, warning, error
```
