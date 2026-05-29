# Convert mood test results to ARD

Convert mood test results to ARD

## Usage

``` r
.format_moodtest_results(by, variable, lst_tidy, ...)
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

- ...:

  passed to `mood.test(...)`

## Value

ARD data frame

## Examples

``` r
cardx:::.format_moodtest_results(
  by = "SEX",
  variable = "AGE",
  lst_tidy =
    cards::eval_capture_conditions(
      stats::mood.test(ADSL[["AGE"]] ~ ADSL[["SEX"]]) |>
        broom::tidy()
    )
)
#> {cards} data frame: 4 x 9
#>   group1 variable   stat_name stat_label stat     error
#> 1    SEX      AGE   statistic  Z-Statis…      object '…
#> 2    SEX      AGE     p.value    p-value      object '…
#> 3    SEX      AGE      method     method      object '…
#> 4    SEX      AGE alternative  Alternat…      object '…
#> ℹ 3 more variables: context, fmt_fun, warning
```
