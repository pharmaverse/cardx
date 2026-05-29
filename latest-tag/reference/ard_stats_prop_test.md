# ARD 2-sample proportion test

Analysis results data for a 2-sample test or proportions using
[`stats::prop.test()`](https://rdrr.io/r/stats/prop.test.html).

## Usage

``` r
ard_stats_prop_test(data, by, variables, conf.level = 0.95, ...)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to compare by

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Must be a binary column coded as
  `TRUE`/`FALSE` or `1`/`0`. Independent tests will be computed for each
  variable.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to `prop.test(...)`

## Value

ARD data frame

## Examples

``` r
mtcars |>
  ard_stats_prop_test(by = vs, variables = am)
#> {cards} data frame: 13 x 9
#>    group1 variable   context   stat_name stat_label      stat
#> 1      vs       am stats_pr…    estimate  Rate Dif…    -0.167
#> 2      vs       am stats_pr…   estimate1  Group 1 …     0.333
#> 3      vs       am stats_pr…   estimate2  Group 2 …       0.5
#> 4      vs       am stats_pr…   statistic  X-square…     0.348
#> 5      vs       am stats_pr…     p.value    p-value     0.556
#> 6      vs       am stats_pr…   parameter  Degrees …         1
#> 7      vs       am stats_pr…    conf.low  CI Lower…    -0.571
#> 8      vs       am stats_pr…   conf.high  CI Upper…     0.237
#> 9      vs       am stats_pr…      method     method 2-sample…
#> 10     vs       am stats_pr… alternative  alternat… two.sided
#> 11     vs       am stats_pr…           p          p          
#> 12     vs       am stats_pr…  conf.level  CI Confi…      0.95
#> 13     vs       am stats_pr…     correct  Yates' c…      TRUE
#> ℹ 3 more variables: fmt_fun, warning, error
```
