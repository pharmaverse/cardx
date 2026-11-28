# Convert Tidied Survival Fit to ARD

Convert Tidied Survival Fit to ARD

## Usage

``` r
.format_survfit_results(tidy_survfit)
```

## Value

an ARD data frame of class 'card'

## Examples

``` r
cardx:::.format_survfit_results(
  broom::tidy(survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE))
)
#> # An ARD data frame: 805 × 11
#>    variable variable_level stat_name stat_label     stat n.event n.censor strata
#>    <chr>            <list> <chr>     <chr>         <lis>   <dbl>    <dbl> <chr> 
#>  1 time                  1 n.risk    Number of Su…    86       0        1 TRTA=…
#>  2 time                  1 estimate  Survival Pro…     1       0        1 TRTA=…
#>  3 time                  1 std.error Standard Err…     0       0        1 TRTA=…
#>  4 time                  1 conf.high CI Upper Bou…     1       0        1 TRTA=…
#>  5 time                  1 conf.low  CI Lower Bou…     1       0        1 TRTA=…
#>  6 time                  2 n.risk    Number of Su…    85       0        1 TRTA=…
#>  7 time                  2 estimate  Survival Pro…     1       0        1 TRTA=…
#>  8 time                  2 std.error Standard Err…     0       0        1 TRTA=…
#>  9 time                  2 conf.high CI Upper Bou…     1       0        1 TRTA=…
#> 10 time                  2 conf.low  CI Lower Bou…     1       0        1 TRTA=…
#> # ℹ 795 more rows
#> # ℹ 3 more variables: fmt_fun <list>, warning <list>, error <list>
```
