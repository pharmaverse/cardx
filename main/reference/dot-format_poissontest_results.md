# Convert Poisson test to ARD

Convert Poisson test to ARD

## Usage

``` r
.format_poissontest_results(by = NULL, variables, lst_tidy, ...)
```

## Arguments

- by:

  (`string`)\
  by column name

- variables:

  (`character`)\
  names of the event and time variables

- lst_tidy:

  (named `list`)\
  list of tidied results constructed with
  [`eval_capture_conditions()`](https://insightsengineering.github.io/cards/latest-tag/reference/eval_capture_conditions.html),
  e.g.
  `eval_capture_conditions(t.test(mtcars$mpg ~ mtcars$am) |> broom::tidy())`.

- ...:

  passed to
  [`poisson.test()`](https://rdrr.io/r/stats/poisson.test.html)

## Value

ARD data frame

## Examples

``` r
cardx:::.format_poissontest_results(
  by = "ARM",
  variables = c("CNSR", "AVAL"),
  lst_tidy =
    cards::eval_capture_conditions(
      stats::poisson.test(sum(cards::ADTTE[["CNSR"]]), sum(cards::ADTTE[["AVAL"]])) |>
        broom::tidy()
    )
)
#> # An ARD data frame: 10 × 9
#>    group1 variable context       stat_name stat_label stat               fmt_fun
#>    <chr>  <chr>    <chr>         <chr>     <chr>      <named list>       <named>
#>  1 ARM    AVAL     stats_poisso… estimate  Estimated… 0.006052335        1      
#>  2 ARM    AVAL     stats_poisso… statistic Number of… 102                1      
#>  3 ARM    AVAL     stats_poisso… p.value   p-value    9.881313e-324      1      
#>  4 ARM    AVAL     stats_poisso… parameter Expected … 16853              1      
#>  5 ARM    AVAL     stats_poisso… conf.low  CI Lower … 0.004934956        1      
#>  6 ARM    AVAL     stats_poisso… conf.high CI Upper … 0.007347122        1      
#>  7 ARM    AVAL     stats_poisso… method    method     Exact Poisson test <NULL> 
#>  8 ARM    AVAL     stats_poisso… alternat… alternati… two.sided          <NULL> 
#>  9 ARM    AVAL     stats_poisso… conf.lev… CI Confid… 0.95               1      
#> 10 ARM    AVAL     stats_poisso… mu        H0 Mean    1                  1      
#> # ℹ 2 more variables: warning <named list>, error <named list>
```
