# Convert t-test to ARD

Convert t-test to ARD

## Usage

``` r
.format_ttest_results(by = NULL, variable, lst_tidy, paired, ...)
```

## Arguments

- by:

  (`string`)\
  by column name

- variable:

  (`string`)\
  variable column name

- lst_tidy:

  (named `list`)\
  list of tidied results constructed with
  [`eval_capture_conditions()`](https://insightsengineering.github.io/cards/latest-tag/reference/eval_capture_conditions.html),
  e.g.
  `eval_capture_conditions(t.test(mtcars$mpg ~ mtcars$am) |> broom::tidy())`.

- paired:

  a logical indicating whether you want a paired t-test.

- ...:

  passed to `t.test(...)`

## Value

ARD data frame

## Examples

``` r
cardx:::.format_ttest_results(
  by = "ARM",
  variable = "AGE",
  paired = FALSE,
  lst_tidy =
    cards::eval_capture_conditions(
      stats::t.test(ADSL[["AGE"]] ~ ADSL[["ARM"]], paired = FALSE) |>
        broom::tidy()
    )
)
#> {cards} data frame: 14 x 9
#>    group1 variable   stat_name stat_label  stat     error
#> 1     ARM      AGE    estimate  Mean Dif…       cannot u…
#> 2     ARM      AGE   estimate1  Group 1 …       cannot u…
#> 3     ARM      AGE   estimate2  Group 2 …       cannot u…
#> 4     ARM      AGE   statistic  t Statis…       cannot u…
#> 5     ARM      AGE     p.value    p-value       cannot u…
#> 6     ARM      AGE   parameter  Degrees …       cannot u…
#> 7     ARM      AGE    conf.low  CI Lower…       cannot u…
#> 8     ARM      AGE   conf.high  CI Upper…       cannot u…
#> 9     ARM      AGE      method     method       cannot u…
#> 10    ARM      AGE alternative  alternat…       cannot u…
#> 11    ARM      AGE          mu    H0 Mean     0 cannot u…
#> 12    ARM      AGE      paired  Paired t… FALSE cannot u…
#> 13    ARM      AGE   var.equal  Equal Va… FALSE cannot u…
#> 14    ARM      AGE  conf.level  CI Confi…  0.95 cannot u…
#> ℹ 3 more variables: context, fmt_fun, warning
```
