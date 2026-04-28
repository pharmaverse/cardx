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
#> {cards} data frame: 32 x 11
#>    group1 group1_level variable variable_level stat_name stat_label  stat
#> 1    TRTA      Placebo     time             60    n.risk  Number o…    59
#> 2    TRTA      Placebo     time             60  estimate  Survival… 0.768
#> 3    TRTA      Placebo     time             60 std.error  Standard… 0.047
#> 4    TRTA      Placebo     time             60 conf.high  CI Upper… 0.866
#> 5    TRTA      Placebo     time             60  conf.low  CI Lower… 0.682
#> 6    TRTA      Placebo     time            180    n.risk  Number o…    35
#> 7    TRTA      Placebo     time            180  estimate  Survival… 0.626
#> 8    TRTA      Placebo     time            180 std.error  Standard… 0.056
#> 9    TRTA      Placebo     time            180 conf.high  CI Upper… 0.746
#> 10   TRTA      Placebo     time            180  conf.low  CI Lower… 0.526
#> ℹ 22 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 4 more variables: context, fmt_fun, warning, error

survfit(Surv_CNSR(AVAL, CNSR) ~ TRTA, data = cards::ADTTE, conf.int = 0.90) |>
  ard_survival_survfit(probs = c(0.25, 0.5, 0.75))
#> {cards} data frame: 29 x 11
#>    group1 group1_level variable variable_level stat_name stat_label stat
#> 1    TRTA      Placebo     prob           0.25  estimate  Survival…   70
#> 2    TRTA      Placebo     prob           0.25 conf.high  CI Upper…  110
#> 3    TRTA      Placebo     prob           0.25  conf.low  CI Lower…   42
#> 4    TRTA      Placebo     prob            0.5  estimate  Survival…   NA
#> 5    TRTA      Placebo     prob            0.5 conf.high  CI Upper…   NA
#> 6    TRTA      Placebo     prob            0.5  conf.low  CI Lower…   NA
#> 7    TRTA      Placebo     prob           0.75  estimate  Survival…   NA
#> 8    TRTA      Placebo     prob           0.75 conf.high  CI Upper…   NA
#> 9    TRTA      Placebo     prob           0.75  conf.low  CI Lower…   NA
#> 10   TRTA    Xanomeli…     prob           0.25  estimate  Survival…   14
#> ℹ 19 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 4 more variables: context, fmt_fun, warning, error

cards::ADTTE |>
  ard_survival_survfit(y = Surv_CNSR(AVAL, CNSR), variables = c("TRTA", "SEX"), times = 90)
#> {cards} data frame: 32 x 13
#>    group1 group1_level group2 group2_level variable variable_level stat_name
#> 1    TRTA      Placebo    SEX            F     time             90    n.risk
#> 2    TRTA      Placebo    SEX            F     time             90  estimate
#> 3    TRTA      Placebo    SEX            F     time             90 std.error
#> 4    TRTA      Placebo    SEX            F     time             90 conf.high
#> 5    TRTA      Placebo    SEX            F     time             90  conf.low
#> 6    TRTA      Placebo    SEX            M     time             90    n.risk
#> 7    TRTA      Placebo    SEX            M     time             90  estimate
#> 8    TRTA      Placebo    SEX            M     time             90 std.error
#> 9    TRTA      Placebo    SEX            M     time             90 conf.high
#> 10   TRTA      Placebo    SEX            M     time             90  conf.low
#>    stat_label  stat
#> 1   Number o…    27
#> 2   Survival… 0.619
#> 3   Standard… 0.072
#> 4   CI Upper… 0.777
#> 5   CI Lower… 0.493
#> 6   Number o…    22
#> 7   Survival… 0.748
#> 8   Standard… 0.077
#> 9   CI Upper… 0.916
#> 10  CI Lower… 0.611
#> ℹ 22 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 4 more variables: context, fmt_fun, warning, error

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
#> {cards} data frame: 32 x 11
#>    group1 group1_level variable variable_level stat_name stat_label  stat
#> 1    TRTA      Placebo     time             60    n.risk  Number o…    59
#> 2    TRTA      Placebo     time             60  estimate  Survival… 0.054
#> 3    TRTA      Placebo     time             60 std.error  Standard… 0.026
#> 4    TRTA      Placebo     time             60 conf.high  CI Upper…  0.14
#> 5    TRTA      Placebo     time             60  conf.low  CI Lower… 0.021
#> 6    TRTA      Placebo     time            180    n.risk  Number o…    35
#> 7    TRTA      Placebo     time            180  estimate  Survival… 0.226
#> 8    TRTA      Placebo     time            180 std.error  Standard… 0.054
#> 9    TRTA      Placebo     time            180 conf.high  CI Upper… 0.361
#> 10   TRTA      Placebo     time            180  conf.low  CI Lower… 0.142
#> ℹ 22 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 4 more variables: context, fmt_fun, warning, error
```
