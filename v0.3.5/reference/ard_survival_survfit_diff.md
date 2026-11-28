# ARD Survival Differences

Calculate differences in the Kaplan-Meier estimator of survival using
the results from
[`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html).

## Usage

``` r
ard_survival_survfit_diff(x, times, conf.level = 0.95)
```

## Arguments

- x:

  (`survift`)\
  object of class `'survfit'` typically created with
  [`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)

- times:

  (`numeric`)\
  a vector of times for which to return survival probabilities.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

## Value

an ARD data frame of class 'card'

## Examples

``` r
library(ggsurvfit)
library(survival)

survfit(Surv_CNSR() ~ TRTA, data = cards::ADTTE) |>
  ard_survival_survfit_diff(times = c(25, 50))
#> # An ARD data frame: 32 × 11
#>    group1 group1_level         variable variable_level stat_name      
#>    <chr>  <list>               <chr>            <list> <chr>          
#>  1 TRTA   Xanomeline High Dose time                 25 reference_level
#>  2 TRTA   Xanomeline High Dose time                 25 method         
#>  3 TRTA   Xanomeline High Dose time                 25 estimate       
#>  4 TRTA   Xanomeline High Dose time                 25 std.error      
#>  5 TRTA   Xanomeline High Dose time                 25 statistic      
#>  6 TRTA   Xanomeline High Dose time                 25 conf.low       
#>  7 TRTA   Xanomeline High Dose time                 25 conf.high      
#>  8 TRTA   Xanomeline High Dose time                 25 p.value        
#>  9 TRTA   Xanomeline High Dose time                 50 reference_level
#> 10 TRTA   Xanomeline High Dose time                 50 method         
#> # ℹ 22 more rows
#> # ℹ 6 more variables: context <chr>, stat_label <chr>, stat <list>,
#> #   fmt_fun <list>, warning <list>, error <list>
```
