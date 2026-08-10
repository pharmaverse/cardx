# ARD for Difference in Survival

Analysis results data for comparison of survival using
[`survival::survdiff()`](https://rdrr.io/pkg/survival/man/survdiff.html).

## Usage

``` r
ard_survival_survdiff(formula, data, rho = 0, ...)
```

## Arguments

- formula:

  (`formula`)\
  a formula

- data:

  (`data.frame`)\
  a data frame

- rho:

  (`scalar numeric`)\
  numeric scalar passed to `survival::survdiff(rho)`. Default is
  `rho=0`.

- ...:

  additional arguments passed to
  [`survival::survdiff()`](https://rdrr.io/pkg/survival/man/survdiff.html)

## Value

an ARD data frame of class 'card'

## Examples

``` r
library(survival)
library(ggsurvfit)
#> Loading required package: ggplot2

ard_survival_survdiff(Surv_CNSR(AVAL, CNSR) ~ TRTA, data = cards::ADTTE)
#> # An ARD data frame: 4 × 8
#>   variable context     stat_name stat_label stat          fmt_fun warning error 
#>   <chr>    <chr>       <chr>     <chr>      <list>        <list>  <named> <name>
#> 1 TRTA     survival_s… statistic X^2 Stati… 60.26956      1       <NULL>  <NULL>
#> 2 TRTA     survival_s… df        Degrees o… 2             1       <NULL>  <NULL>
#> 3 TRTA     survival_s… p.value   p-value    8.182344e-14  1       <NULL>  <NULL>
#> 4 TRTA     survival_s… method    method     Log-rank test <NULL>  <NULL>  <NULL>
```
