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
#> {cards} data frame: 32 x 11
#>    group1 group1_level variable variable_level       stat_name stat_label
#> 1    TRTA    Xanomeli…     time             25 reference_level  referenc…
#> 2    TRTA    Xanomeli…     time             25          method     method
#> 3    TRTA    Xanomeli…     time             25        estimate  Survival…
#> 4    TRTA    Xanomeli…     time             25       std.error  Survival…
#> 5    TRTA    Xanomeli…     time             25       statistic  z statis…
#> 6    TRTA    Xanomeli…     time             25        conf.low  CI Lower…
#> 7    TRTA    Xanomeli…     time             25       conf.high  CI Upper…
#> 8    TRTA    Xanomeli…     time             25         p.value    p-value
#> 9    TRTA    Xanomeli…     time             50 reference_level  referenc…
#> 10   TRTA    Xanomeli…     time             50          method     method
#>         stat
#> 1    Placebo
#> 2  Survival…
#> 3      0.293
#> 4      0.067
#> 5      4.392
#> 6      0.162
#> 7      0.424
#> 8          0
#> 9    Placebo
#> 10 Survival…
#> ℹ 22 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 4 more variables: context, fmt_fun, warning, error
```
