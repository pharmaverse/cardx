# ARD Proportion Confidence Intervals

Calculate confidence intervals for proportions.

## Usage

``` r
ard_categorical_ci(data, ...)

# S3 method for class 'data.frame'
ard_categorical_ci(
  data,
  variables,
  by = dplyr::group_vars(data),
  method = c("waldcc", "wald", "clopper-pearson", "wilson", "wilsoncc", "strat_wilson",
    "strat_wilsoncc", "agresti-coull", "jeffreys"),
  denominator = c("column", "row", "cell"),
  conf.level = 0.95,
  value = list(where(is_binary) ~ 1L, where(is.logical) ~ TRUE),
  strata = NULL,
  weights = NULL,
  max.iterations = 10,
  ...
)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame

- ...:

  Arguments passed to methods.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  columns to include in summaries. Columns must be class `<logical>` or
  `<numeric>` values coded as `c(0,1)`.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  columns to stratify calculations by.

- method:

  (`string`)\
  string indicating the type of confidence interval to calculate. Must
  be one of . See
  [`?proportion_ci`](https://insightsengineering.github.io/cardx/reference/proportion_ci.md)
  for details.

- denominator:

  (`string`)\
  Must be one of `'column'` (default), `'row'`, and `'cell'`, which
  specifies the direction of the calculation/denominator. Argument is
  similar to `cards::ard_tabulate(denominator)`.

- conf.level:

  (scalar `numeric`)\
  a scalar in `(0,1)` indicating the confidence level. Default is `0.95`

- value:

  ([`formula-list-selector`](https://insightsengineering.github.io/cards/latest-tag/reference/syntax.html))\
  function will calculate the CIs for all levels of the variables
  specified. Use this argument to instead request only a single level by
  summarized. Default is
  `list(where(is_binary) ~ 1L, where(is.logical) ~ TRUE)`, where columns
  coded as `0`/`1` and `TRUE`/`FALSE` will summarize the `1` and `TRUE`
  levels.

- strata, weights, max.iterations:

  arguments passed to
  [`proportion_ci_strat_wilson()`](https://insightsengineering.github.io/cardx/reference/proportion_ci.md),
  when `method='strat_wilson'`

## Value

an ARD data frame

## Examples

``` r
# compute CI for binary variables
ard_categorical_ci(mtcars, variables = c(vs, am), method = "wilson")
#> {cards} data frame: 22 x 9
#>    variable variable_level   context  stat_name stat_label      stat
#> 1        vs              1 proporti…          N          N        32
#> 2        vs              1 proporti…          n          n        14
#> 3        vs              1 proporti… conf.level  conf.lev…      0.95
#> 4        vs              1 proporti…   estimate   estimate     0.438
#> 5        vs              1 proporti…  statistic  statistic       0.5
#> 6        vs              1 proporti…    p.value    p.value      0.48
#> 7        vs              1 proporti…  parameter  parameter         1
#> 8        vs              1 proporti…   conf.low   conf.low     0.282
#> 9        vs              1 proporti…  conf.high  conf.high     0.607
#> 10       vs              1 proporti…     method     method Wilson C…
#> ℹ 12 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 3 more variables: fmt_fun, warning, error

# compute CIs for each level of a categorical variable
ard_categorical_ci(mtcars, variables = cyl, method = "jeffreys")
#> {cards} data frame: 21 x 9
#>    variable variable_level   context  stat_name stat_label      stat
#> 1       cyl              4 proporti…          N          N        32
#> 2       cyl              4 proporti…          n          n        11
#> 3       cyl              4 proporti…   estimate   estimate     0.344
#> 4       cyl              4 proporti…   conf.low   conf.low     0.198
#> 5       cyl              4 proporti…  conf.high  conf.high     0.516
#> 6       cyl              4 proporti… conf.level  conf.lev…      0.95
#> 7       cyl              4 proporti…     method     method Jeffreys…
#> 8       cyl              6 proporti…          N          N        32
#> 9       cyl              6 proporti…          n          n         7
#> 10      cyl              6 proporti…   estimate   estimate     0.219
#> ℹ 11 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 3 more variables: fmt_fun, warning, error
```
