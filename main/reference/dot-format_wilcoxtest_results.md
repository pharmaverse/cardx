# Convert Wilcoxon test to ARD

Convert Wilcoxon test to ARD

## Usage

``` r
.format_wilcoxtest_results(by = NULL, variable, lst_tidy, paired, ...)
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

  a logical indicating whether you want a paired test.

- ...:

  passed to `stats::wilcox.test(...)`

## Value

ARD data frame

## Examples

``` r
# Pre-processing ADSL to have grouping factor (ARM here) with 2 levels
ADSL <- cards::ADSL |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  ard_stats_wilcox_test(by = "ARM", variables = "AGE")

cardx:::.format_wilcoxtest_results(
  by = "ARM",
  variable = "AGE",
  paired = FALSE,
  lst_tidy =
    cards::eval_capture_conditions(
      stats::wilcox.test(ADSL[["AGE"]] ~ ADSL[["ARM"]], paired = FALSE) |>
        broom::tidy()
    )
)
#> # An ARD data frame: 12 × 9
#>    group1 variable context     stat_name stat_label stat   fmt_fun warning error
#>    <chr>  <chr>    <chr>       <chr>     <chr>      <name> <named> <named> <nam>
#>  1 ARM    AGE      stats_wilc… statistic X-squared… <NULL> <NULL>  <NULL>  cann…
#>  2 ARM    AGE      stats_wilc… p.value   p-value    <NULL> <NULL>  <NULL>  cann…
#>  3 ARM    AGE      stats_wilc… method    method     <NULL> <NULL>  <NULL>  cann…
#>  4 ARM    AGE      stats_wilc… alternat… alternati… <NULL> <NULL>  <NULL>  cann…
#>  5 ARM    AGE      stats_wilc… mu        mu         0      1       <NULL>  cann…
#>  6 ARM    AGE      stats_wilc… paired    Paired te… FALSE  <NULL>  <NULL>  cann…
#>  7 ARM    AGE      stats_wilc… exact     exact      <NULL> <NULL>  <NULL>  cann…
#>  8 ARM    AGE      stats_wilc… correct   correct    TRUE   <NULL>  <NULL>  cann…
#>  9 ARM    AGE      stats_wilc… conf.int  conf.int   FALSE  <NULL>  <NULL>  cann…
#> 10 ARM    AGE      stats_wilc… conf.lev… CI Confid… 0.95   1       <NULL>  cann…
#> 11 ARM    AGE      stats_wilc… tol.root  tol.root   1e-04  1       <NULL>  cann…
#> 12 ARM    AGE      stats_wilc… digits.r… digits.ra… Inf    1       <NULL>  cann…
```
