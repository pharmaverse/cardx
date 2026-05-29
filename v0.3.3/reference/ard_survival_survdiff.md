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
#> {cards} data frame: 4 x 8
#>   variable   context stat_name stat_label      stat fmt_fun
#> 1     TRTA survival… statistic  X^2 Stat…     60.27       1
#> 2     TRTA survival…        df  Degrees …         2       1
#> 3     TRTA survival…   p.value    p-value         0       1
#> 4     TRTA survival…    method     method Log-rank…    NULL
#> ℹ 2 more variables: warning, error
```
