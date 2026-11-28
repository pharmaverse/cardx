# ARD Survival Estimates

Analysis results data for survival quantiles and x-year survival
estimates, extracted from a
[`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)
model.

## Usage

``` r
ard_survival_survfit(x, ...)

# S3 method for class 'survfit'
ard_survival_survfit(x, times = NULL, probs = NULL, type = NULL, ...)

# S3 method for class 'data.frame'
ard_survival_survfit(
  x,
  y,
  variables = NULL,
  times = NULL,
  probs = NULL,
  type = NULL,
  method.args = list(conf.int = 0.95, conf.type = "log"),
  ...
)
```

## Arguments

- x:

  (`survfit` or `data.frame`)\
  an object of class `survfit` created with
  [`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)
  or a data frame. See below for details.

- ...:

  These dots are for future extensions and must be empty.

- times:

  (`numeric`)\
  a vector of times for which to return survival probabilities.

- probs:

  (`numeric`)\
  a vector of probabilities with values in (0,1) specifying the survival
  quantiles to return.

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

- y:

  (`Surv` or `string`)\
  an object of class `Surv` created using
  [`survival::Surv()`](https://rdrr.io/pkg/survival/man/Surv.html). This
  object will be passed as the left-hand side of the formula constructed
  and passed to
  [`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html).
  This object can also be passed as a string.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  stratification variables to be passed as the right-hand side of the
  formula constructed and passed to
  [`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html).
  Default is `NULL` for an unstratified model, e.g. `Surv() ~ 1`.

- method.args:

  (named `list`)\
  named list of arguments that will be passed to
  [`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html).

## Value

an ARD data frame of class 'card'

## Details

- Only one of either the `times` or `probs` parameters can be specified.

- Times should be provided using the same scale as the time variable
  used to fit the provided survival fit model.

## Formula Specification

When passing a
[`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)
object to `ard_survival_survfit()`, the
[`survfit()`](https://rdrr.io/pkg/survival/man/survfit.html) call must
use an evaluated formula and not a stored formula. Including a proper
formula in the call allows the function to accurately identify all
variables included in the estimation. See below for examples:

    library(cardx)
    library(survival)

    # include formula in `survfit()` call
    survfit(Surv(time, status) ~ sex, lung) |> ard_survival_survfit(time = 500)

    # you can also pass a data frame to `ard_survival_survfit()` as well.
    lung |>
      ard_survival_survfit(y = Surv(time, status), variables = "sex", time = 500)

You **cannot**, however, pass a stored formula, e.g.
`survfit(my_formula, lung)`, but you can use stored formulas with
`rlang::inject(survfit(!!my_formula, lung))`.

## Variable Classes

When the `survfit` method is called, the class of the stratifying
variables will be returned as a factor.

When the data frame method is called, the original classes are retained
in the resulting ARD.

## Examples

``` r
library(survival)
library(ggsurvfit)

survfit(Surv_CNSR(AVAL, CNSR) ~ TRTA, data = cards::ADTTE) |>
  ard_survival_survfit(times = c(60, 180))
#> # An ARD data frame: 32 × 11
#>    group1 group1_level variable variable_level context  stat_name    stat
#>    <chr>  <list>       <chr>            <list> <chr>    <chr>      <list>
#>  1 TRTA   Placebo      time                 60 survival n.risk    59     
#>  2 TRTA   Placebo      time                 60 survival estimate   0.768 
#>  3 TRTA   Placebo      time                 60 survival std.error  0.0467
#>  4 TRTA   Placebo      time                 60 survival conf.high  0.866 
#>  5 TRTA   Placebo      time                 60 survival conf.low   0.682 
#>  6 TRTA   Placebo      time                180 survival n.risk    35     
#>  7 TRTA   Placebo      time                180 survival estimate   0.626 
#>  8 TRTA   Placebo      time                180 survival std.error  0.0559
#>  9 TRTA   Placebo      time                180 survival conf.high  0.746 
#> 10 TRTA   Placebo      time                180 survival conf.low   0.526 
#> # ℹ 22 more rows
#> # ℹ 4 more variables: stat_label <chr>, fmt_fun <list>, warning <list>,
#> #   error <list>

survfit(Surv_CNSR(AVAL, CNSR) ~ TRTA, data = cards::ADTTE, conf.int = 0.90) |>
  ard_survival_survfit(probs = c(0.25, 0.5, 0.75))
#> # An ARD data frame: 29 × 11
#>    group1 group1_level         variable variable_level context   stat_name  stat
#>    <chr>  <list>               <chr>            <list> <chr>     <chr>     <lis>
#>  1 TRTA   Placebo              prob               0.25 survival… estimate     70
#>  2 TRTA   Placebo              prob               0.25 survival… conf.high   110
#>  3 TRTA   Placebo              prob               0.25 survival… conf.low     42
#>  4 TRTA   Placebo              prob               0.5  survival… estimate     NA
#>  5 TRTA   Placebo              prob               0.5  survival… conf.high    NA
#>  6 TRTA   Placebo              prob               0.5  survival… conf.low     NA
#>  7 TRTA   Placebo              prob               0.75 survival… estimate     NA
#>  8 TRTA   Placebo              prob               0.75 survival… conf.high    NA
#>  9 TRTA   Placebo              prob               0.75 survival… conf.low     NA
#> 10 TRTA   Xanomeline High Dose prob               0.25 survival… estimate     14
#> # ℹ 19 more rows
#> # ℹ 4 more variables: stat_label <chr>, fmt_fun <list>, warning <list>,
#> #   error <list>

cards::ADTTE |>
  ard_survival_survfit(y = Surv_CNSR(AVAL, CNSR), variables = c("TRTA", "SEX"), times = 90)
#> # An ARD data frame: 32 × 13
#>    group1 group1_level group2 group2_level variable variable_level stat_name
#>    <chr>  <list>       <chr>  <list>       <chr>            <list> <chr>    
#>  1 TRTA   Placebo      SEX    F            time                 90 n.risk   
#>  2 TRTA   Placebo      SEX    F            time                 90 estimate 
#>  3 TRTA   Placebo      SEX    F            time                 90 std.error
#>  4 TRTA   Placebo      SEX    F            time                 90 conf.high
#>  5 TRTA   Placebo      SEX    F            time                 90 conf.low 
#>  6 TRTA   Placebo      SEX    M            time                 90 n.risk   
#>  7 TRTA   Placebo      SEX    M            time                 90 estimate 
#>  8 TRTA   Placebo      SEX    M            time                 90 std.error
#>  9 TRTA   Placebo      SEX    M            time                 90 conf.high
#> 10 TRTA   Placebo      SEX    M            time                 90 conf.low 
#> # ℹ 22 more rows
#> # ℹ 6 more variables: context <chr>, stat_label <chr>, stat <list>,
#> #   fmt_fun <list>, warning <list>, error <list>

# Competing Risks Example ---------------------------
set.seed(1)
ADTTE_MS <- cards::ADTTE %>%
  dplyr::mutate(
    CNSR = dplyr::case_when(
      CNSR == 0 ~ "censor",
      runif(dplyr::n()) < 0.5 ~ "death from cancer",
      TRUE ~ "death other causes"
    ) %>% factor()
  )

survfit(Surv(AVAL, CNSR) ~ TRTA, data = ADTTE_MS) %>%
  ard_survival_survfit(times = c(60, 180))
#> Multi-state model detected. Showing probabilities into state 'death from
#> cancer'.
#> # An ARD data frame: 32 × 11
#>    group1 group1_level variable variable_level context  stat_name    stat
#>    <chr>  <list>       <chr>            <list> <chr>    <chr>      <list>
#>  1 TRTA   Placebo      time                 60 survival n.risk    59     
#>  2 TRTA   Placebo      time                 60 survival estimate   0.0538
#>  3 TRTA   Placebo      time                 60 survival std.error  0.0263
#>  4 TRTA   Placebo      time                 60 survival conf.high  0.140 
#>  5 TRTA   Placebo      time                 60 survival conf.low   0.0206
#>  6 TRTA   Placebo      time                180 survival n.risk    35     
#>  7 TRTA   Placebo      time                180 survival estimate   0.226 
#>  8 TRTA   Placebo      time                180 survival std.error  0.0540
#>  9 TRTA   Placebo      time                180 survival conf.high  0.361 
#> 10 TRTA   Placebo      time                180 survival conf.low   0.142 
#> # ℹ 22 more rows
#> # ℹ 4 more variables: stat_label <chr>, fmt_fun <list>, warning <list>,
#> #   error <list>
```
