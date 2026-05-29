# Process Survival Fit For Quantile Estimates

Process Survival Fit For Quantile Estimates

## Usage

``` r
.process_survfit_probs(x, probs)
```

## Arguments

- x:

  (`survfit` or `data.frame`)\
  an object of class `survfit` created with
  [`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)
  or a data frame. See below for details.

- probs:

  (`numeric`)\
  a vector of probabilities with values in (0,1) specifying the survival
  quantiles to return.

## Value

a `tibble`

## Examples

``` r
survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
  cardx:::.process_survfit_probs(probs = c(0.25, 0.75))
#>   estimate conf.low conf.high conf.level conf.type prob          context
#> 1      142       70       181       0.95       log 0.25 survival_survfit
#> 2       44       22       180       0.95       log 0.25 survival_survfit
#> 3       49       37       180       0.95       log 0.25 survival_survfit
#> 4      184      183       191       0.95       log 0.75 survival_survfit
#> 5      188      167        NA       0.95       log 0.75 survival_survfit
#> 6      184      180        NA       0.95       log 0.75 survival_survfit
#>           group1_level group1
#> 1              Placebo   TRTA
#> 2 Xanomeline High Dose   TRTA
#> 3  Xanomeline Low Dose   TRTA
#> 4              Placebo   TRTA
#> 5 Xanomeline High Dose   TRTA
#> 6  Xanomeline Low Dose   TRTA
```
