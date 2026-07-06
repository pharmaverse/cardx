# Convert McNemar's test to ARD

Convert McNemar's test to ARD

## Usage

``` r
.format_mcnemartest_results(by, variable, lst_tidy, ...)
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

  passed to `stats::mcnemar.test(...)`

## Value

ARD data frame

## Examples

``` r
cardx:::.format_mcnemartest_results(
  by = "ARM",
  variable = "AGE",
  lst_tidy =
    cards::eval_capture_conditions(
      stats::mcnemar.test(cards::ADSL[["SEX"]], cards::ADSL[["EFFFL"]]) |>
        broom::tidy()
    )
)
#> {cards} data frame: 5 x 9
#>   group1 variable   context stat_name stat_label      stat
#> 1    ARM      AGE stats_mc… statistic  X-square…    111.91
#> 2    ARM      AGE stats_mc…   p.value    p-value         0
#> 3    ARM      AGE stats_mc… parameter  Degrees …         1
#> 4    ARM      AGE stats_mc…    method     method McNemar'…
#> 5    ARM      AGE stats_mc…   correct    correct      TRUE
#> ℹ 3 more variables: fmt_fun, warning, error
```
