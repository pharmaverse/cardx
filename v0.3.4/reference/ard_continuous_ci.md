# ARD continuous CIs

One-sample confidence intervals for continuous variable means and
medians.

## Usage

``` r
ard_continuous_ci(data, ...)

# S3 method for class 'data.frame'
ard_continuous_ci(
  data,
  variables,
  by = dplyr::group_vars(data),
  conf.level = 0.95,
  method = c("t.test", "wilcox.test"),
  ...
)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- ...:

  arguments passed to [`t.test()`](https://rdrr.io/r/stats/t.test.html)
  or [`wilcox.test()`](https://rdrr.io/r/stats/wilcox.test.html)

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

- method:

  (`string`)\
  a string indicating the method to use for the confidence interval
  calculation. Must be one of `"t.test"` or `"wilcox.test"`

## Value

ARD data frame

## Examples

``` r
ard_continuous_ci(mtcars, variables = c(mpg, hp), method = "wilcox.test")
#> {cards} data frame: 24 x 8
#>    variable   context   stat_name stat_label      stat   warning
#> 1       mpg continuo…    estimate       Mean      19.6 cannot c…
#> 2       mpg continuo…   statistic  t Statis…       528 cannot c…
#> 3       mpg continuo…     p.value    p-value         0 cannot c…
#> 4       mpg continuo…    conf.low  CI Lower…      17.5 cannot c…
#> 5       mpg continuo…   conf.high  CI Upper…      22.1 cannot c…
#> 6       mpg continuo…      method     method Wilcoxon… cannot c…
#> 7       mpg continuo… alternative  alternat… two.sided cannot c…
#> 8        hp continuo…    estimate       Mean     142.5 cannot c…
#> 9        hp continuo…   statistic  t Statis…       528 cannot c…
#> 10       hp continuo…     p.value    p-value         0 cannot c…
#> ℹ 14 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 2 more variables: fmt_fun, error
ard_continuous_ci(mtcars, variables = mpg, by = am, method = "t.test")
#> {cards} data frame: 20 x 10
#>    group1 group1_level variable   stat_name stat_label      stat
#> 1      am            0      mpg    estimate       Mean    17.147
#> 2      am            0      mpg   statistic  t Statis…    19.495
#> 3      am            0      mpg     p.value    p-value         0
#> 4      am            0      mpg   parameter  Degrees …        18
#> 5      am            0      mpg    conf.low  CI Lower…    15.299
#> 6      am            0      mpg   conf.high  CI Upper…    18.995
#> 7      am            0      mpg      method     method One Samp…
#> 8      am            0      mpg alternative  alternat… two.sided
#> 9      am            0      mpg          mu    H0 Mean         0
#> 10     am            0      mpg  conf.level  CI Confi…      0.95
#> 11     am            1      mpg    estimate       Mean    24.392
#> 12     am            1      mpg   statistic  t Statis…    14.262
#> 13     am            1      mpg     p.value    p-value         0
#> 14     am            1      mpg   parameter  Degrees …        12
#> 15     am            1      mpg    conf.low  CI Lower…    20.666
#> 16     am            1      mpg   conf.high  CI Upper…    28.119
#> 17     am            1      mpg      method     method One Samp…
#> 18     am            1      mpg alternative  alternat… two.sided
#> 19     am            1      mpg          mu    H0 Mean         0
#> 20     am            1      mpg  conf.level  CI Confi…      0.95
#> ℹ 4 more variables: context, fmt_fun, warning, error
```
