# ARD one-sample Wilcox Rank-sum

Analysis results data for one-sample Wilcox Rank-sum. Result may be
stratified by including the `by` argument.

## Usage

``` r
ard_stats_wilcox_test_onesample(
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
  column names to be analyzed. Independent Wilcox Rank-sum tests will be
  computed for each variable.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  optional column name to stratify results by.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to `wilcox.test(...)`

## Value

ARD data frame

## Examples

``` r
cards::ADSL |>
  ard_stats_wilcox_test_onesample(by = ARM, variables = AGE)
#> {cards} data frame: 27 x 10
#>    group1 group1_level variable   stat_name stat_label      stat
#> 1     ARM      Placebo      AGE   statistic  t Statis…      3741
#> 2     ARM      Placebo      AGE     p.value    p-value         0
#> 3     ARM      Placebo      AGE      method     method Wilcoxon…
#> 4     ARM      Placebo      AGE alternative  alternat… two.sided
#> 5     ARM      Placebo      AGE          mu    H0 Mean         0
#> 6     ARM      Placebo      AGE    conf.int   conf.int     FALSE
#> 7     ARM      Placebo      AGE    tol.root   tol.root         0
#> 8     ARM      Placebo      AGE digits.rank  digits.r…       Inf
#> 9     ARM      Placebo      AGE  conf.level  CI Confi…      0.95
#> 10    ARM    Xanomeli…      AGE   statistic  t Statis…      3570
#> ℹ 17 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 4 more variables: context, fmt_fun, warning, error
```
