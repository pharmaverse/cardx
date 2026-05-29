# ARD Cohen's D Test

Analysis results data for paired and non-paired Cohen's D Effect Size
Test using
[`effectsize::cohens_d()`](https://easystats.github.io/effectsize/reference/cohens_d.html).

## Usage

``` r
ard_effectsize_cohens_d(data, by, variables, conf.level = 0.95, ...)

ard_effectsize_paired_cohens_d(data, by, variables, id, conf.level = 0.95, ...)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to compare by. Must be a categorical variable with exactly
  two levels.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Must be a continuous variables.
  Independent tests will be run for each variable.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to `effectsize::cohens_d(...)`

- id:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name of the subject or participant ID

## Value

ARD data frame

## Details

For the `ard_effectsize_cohens_d()` function, the data is expected to be
one row per subject. The data is passed as
`effectsize::cohens_d(data[[variable]]~data[[by]], data, paired = FALSE, ...)`.

For the `ard_effectsize_paired_cohens_d()` function, the data is
expected to be one row per subject per by level. Before the effect size
is calculated, the data are reshaped to a wide format to be one row per
subject. The data are then passed as
`effectsize::cohens_d(x = data_wide[[<by level 1>]], y = data_wide[[<by level 2>]], paired = TRUE, ...)`.

## Examples

``` r
cards::ADSL |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  ard_effectsize_cohens_d(by = ARM, variables = AGE)
#> {cards} data frame: 9 x 9
#>   group1 variable   context   stat_name stat_label      stat
#> 1    ARM      AGE effectsi…    estimate  Effect S…       0.1
#> 2    ARM      AGE effectsi…  conf.level  CI Confi…      0.95
#> 3    ARM      AGE effectsi…    conf.low  CI Lower…    -0.201
#> 4    ARM      AGE effectsi…   conf.high  CI Upper…     0.401
#> 5    ARM      AGE effectsi…      method     method Cohen's D
#> 6    ARM      AGE effectsi…          mu    H0 Mean         0
#> 7    ARM      AGE effectsi…      paired  Paired t…     FALSE
#> 8    ARM      AGE effectsi…   pooled_sd  Pooled S…      TRUE
#> 9    ARM      AGE effectsi… alternative  Alternat… two.sided
#> ℹ 3 more variables: fmt_fun, warning, error

# constructing a paired data set,
# where patients receive both treatments
cards::ADSL[c("ARM", "AGE")] |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  dplyr::mutate(.by = ARM, USUBJID = dplyr::row_number()) |>
  dplyr::arrange(USUBJID, ARM) |>
  dplyr::group_by(USUBJID) |>
  dplyr::filter(dplyr::n() > 1) |>
  ard_effectsize_paired_cohens_d(by = ARM, variables = AGE, id = USUBJID)
#> {cards} data frame: 9 x 9
#>   group1 variable   context   stat_name stat_label      stat
#> 1    ARM      AGE effectsi…    estimate  Effect S…     0.069
#> 2    ARM      AGE effectsi…  conf.level  CI Confi…      0.95
#> 3    ARM      AGE effectsi…    conf.low  CI Lower…    -0.146
#> 4    ARM      AGE effectsi…   conf.high  CI Upper…     0.282
#> 5    ARM      AGE effectsi…      method     method Paired C…
#> 6    ARM      AGE effectsi…          mu    H0 Mean         0
#> 7    ARM      AGE effectsi…      paired  Paired t…      TRUE
#> 8    ARM      AGE effectsi…   pooled_sd  Pooled S…      TRUE
#> 9    ARM      AGE effectsi… alternative  Alternat… two.sided
#> ℹ 3 more variables: fmt_fun, warning, error
```
