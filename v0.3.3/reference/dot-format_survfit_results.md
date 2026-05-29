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
#> {cards} data frame: 805 x 11
#>    variable variable_level stat_name stat_label stat fmt_fun
#> 1      time              1    n.risk  Number o…   86       1
#> 2      time              1  estimate  Survival…    1       1
#> 3      time              1 std.error  Standard…    0       1
#> 4      time              1 conf.high  CI Upper…    1       1
#> 5      time              1  conf.low  CI Lower…    1       1
#> 6      time              2    n.risk  Number o…   85       1
#> 7      time              2  estimate  Survival…    1       1
#> 8      time              2 std.error  Standard…    0       1
#> 9      time              2 conf.high  CI Upper…    1       1
#> 10     time              2  conf.low  CI Lower…    1       1
#> ℹ 795 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 5 more variables: warning, error, n.event, n.censor, strata
```
