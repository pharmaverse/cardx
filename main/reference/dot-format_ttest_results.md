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
#> # An ARD data frame: 14 × 9
#>    group1 variable context     stat_name stat_label stat   fmt_fun warning error
#>    <chr>  <chr>    <chr>       <chr>     <chr>      <name> <named> <named> <nam>
#>  1 ARM    AGE      stats_t_te… estimate  Mean Diff… <NULL> <NULL>  <NULL>  cann…
#>  2 ARM    AGE      stats_t_te… estimate1 Group 1 M… <NULL> <NULL>  <NULL>  cann…
#>  3 ARM    AGE      stats_t_te… estimate2 Group 2 M… <NULL> <NULL>  <NULL>  cann…
#>  4 ARM    AGE      stats_t_te… statistic t Statist… <NULL> <NULL>  <NULL>  cann…
#>  5 ARM    AGE      stats_t_te… p.value   p-value    <NULL> <NULL>  <NULL>  cann…
#>  6 ARM    AGE      stats_t_te… parameter Degrees o… <NULL> <NULL>  <NULL>  cann…
#>  7 ARM    AGE      stats_t_te… conf.low  CI Lower … <NULL> <NULL>  <NULL>  cann…
#>  8 ARM    AGE      stats_t_te… conf.high CI Upper … <NULL> <NULL>  <NULL>  cann…
#>  9 ARM    AGE      stats_t_te… method    method     <NULL> <NULL>  <NULL>  cann…
#> 10 ARM    AGE      stats_t_te… alternat… alternati… <NULL> <NULL>  <NULL>  cann…
#> 11 ARM    AGE      stats_t_te… mu        H0 Mean    0      1       <NULL>  cann…
#> 12 ARM    AGE      stats_t_te… paired    Paired t-… FALSE  <NULL>  <NULL>  cann…
#> 13 ARM    AGE      stats_t_te… var.equal Equal Var… FALSE  <NULL>  <NULL>  cann…
#> 14 ARM    AGE      stats_t_te… conf.lev… CI Confid… 0.95   1       <NULL>  cann…
```
