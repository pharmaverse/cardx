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
#> # An ARD data frame: 4 × 9
#>   group1 variable context      stat_name stat_label stat   fmt_fun warning error
#>   <chr>  <chr>    <chr>        <chr>     <chr>      <name> <named> <named> <nam>
#> 1 SEX    AGE      stats_mood_… statistic Z-Statist… <NULL> <NULL>  <NULL>  obje…
#> 2 SEX    AGE      stats_mood_… p.value   p-value    <NULL> <NULL>  <NULL>  obje…
#> 3 SEX    AGE      stats_mood_… method    method     <NULL> <NULL>  <NULL>  obje…
#> 4 SEX    AGE      stats_mood_… alternat… Alternati… <NULL> <NULL>  <NULL>  obje…
```
