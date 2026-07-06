# Process Survival Fit For Time Estimates

Process Survival Fit For Time Estimates

## Usage

``` r
.process_survfit_time(x, times, type, start.time = NULL)
```

## Arguments

- x:

  (`survfit` or `data.frame`)\
  an object of class `survfit` created with
  [`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)
  or a data frame. See below for details.

- times:

  (`numeric`)\
  a vector of times for which to return survival probabilities.

- type:

  (`string` or `NULL`)\
  type of statistic to report. Available for Kaplan-Meier time estimates
  only, otherwise `type` is ignored. Default is `NULL`. Must be one of
  the following:

  |              |                |
  |--------------|----------------|
  | type         | transformation |
  | `"survival"` | `x`            |
  | `"risk"`     | `1 - x`        |
  | `"cumhaz"`   | `-log(x)`      |

- start.time:

  (`numeric`)\
  default starting time. See
  [`survival::survfit0()`](https://rdrr.io/pkg/survival/man/survfit0.html)
  for more details.

## Value

a `tibble`

## Examples

``` r
survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
  cardx:::.process_survfit_time(times = c(60, 180), type = "risk")
#>   time n.risk  estimate  std.error conf.high   conf.low conf.level conf.type
#> 1   60     59 0.1071694 0.03599237 0.1749982 0.03376387       0.95       log
#> 2   60     14 0.3060260 0.07123698 0.4324990 0.15136743       0.95       log
#> 3   60     20 0.2678584 0.06803896 0.3897725 0.12158756       0.95       log
#> 4  180     35 0.3490579 0.06147816 0.4590580 0.21668945       0.95       log
#> 5  180      3 0.7379399 0.14042839 0.9083203 0.25091938       0.95       log
#> 6  180      5 0.6191957 0.12993587 0.8048989 0.25673450       0.95       log
#>   context         group1_level group1
#> 1    risk              Placebo   TRTA
#> 2    risk Xanomeline High Dose   TRTA
#> 3    risk  Xanomeline Low Dose   TRTA
#> 4    risk              Placebo   TRTA
#> 5    risk Xanomeline High Dose   TRTA
#> 6    risk  Xanomeline Low Dose   TRTA
```
