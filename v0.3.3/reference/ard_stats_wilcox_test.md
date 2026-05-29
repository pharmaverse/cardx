# ARD Wilcoxon Rank-Sum Test

Analysis results data for paired and non-paired Wilcoxon Rank-Sum tests.

## Usage

``` r
ard_stats_wilcox_test(data, variables, by = NULL, conf.level = 0.95, ...)

ard_stats_paired_wilcox_test(data, by, variables, id, conf.level = 0.95, ...)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent tests will be computed for
  each variable.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  optional column name to compare by.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to `wilcox.test(...)`

- id:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name of the subject or participant ID.

## Value

ARD data frame

## Details

For the `ard_stats_wilcox_test()` function, the data is expected to be
one row per subject. The data is passed as
`wilcox.test(data[[variable]] ~ data[[by]], paired = FALSE, ...)`.

For the `ard_stats_paired_wilcox_test()` function, the data is expected
to be one row per subject per by level. Before the test is calculated,
the data are reshaped to a wide format to be one row per subject. The
data are then passed as
`wilcox.test(x = data_wide[[<by level 1>]], y = data_wide[[<by level 2>]], paired = TRUE, ...)`.

## Examples

``` r
cards::ADSL |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  ard_stats_wilcox_test(by = "ARM", variables = "AGE")
#> {cards} data frame: 12 x 9
#>    group1 variable   context   stat_name stat_label      stat
#> 1     ARM      AGE stats_wi…   statistic  X-square…    3862.5
#> 2     ARM      AGE stats_wi…     p.value    p-value     0.435
#> 3     ARM      AGE stats_wi…      method     method Wilcoxon…
#> 4     ARM      AGE stats_wi… alternative  alternat… two.sided
#> 5     ARM      AGE stats_wi…          mu         mu         0
#> 6     ARM      AGE stats_wi…      paired  Paired t…     FALSE
#> 7     ARM      AGE stats_wi…       exact      exact          
#> 8     ARM      AGE stats_wi…     correct    correct      TRUE
#> 9     ARM      AGE stats_wi…    conf.int   conf.int     FALSE
#> 10    ARM      AGE stats_wi…  conf.level  CI Confi…      0.95
#> 11    ARM      AGE stats_wi…    tol.root   tol.root         0
#> 12    ARM      AGE stats_wi… digits.rank  digits.r…       Inf
#> ℹ 3 more variables: fmt_fun, warning, error

# constructing a paired data set,
# where patients receive both treatments
cards::ADSL[c("ARM", "AGE")] |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  dplyr::mutate(.by = ARM, USUBJID = dplyr::row_number()) |>
  dplyr::arrange(USUBJID, ARM) |>
  ard_stats_paired_wilcox_test(by = ARM, variables = AGE, id = USUBJID)
#> {cards} data frame: 12 x 9
#>    group1 variable   context   stat_name stat_label      stat
#> 1     ARM      AGE stats_wi…   statistic  X-square…      1754
#> 2     ARM      AGE stats_wi…     p.value    p-value     0.522
#> 3     ARM      AGE stats_wi…      method     method Wilcoxon…
#> 4     ARM      AGE stats_wi… alternative  alternat… two.sided
#> 5     ARM      AGE stats_wi…          mu         mu         0
#> 6     ARM      AGE stats_wi…      paired  Paired t…      TRUE
#> 7     ARM      AGE stats_wi…       exact      exact          
#> 8     ARM      AGE stats_wi…     correct    correct      TRUE
#> 9     ARM      AGE stats_wi…    conf.int   conf.int     FALSE
#> 10    ARM      AGE stats_wi…  conf.level  CI Confi…      0.95
#> 11    ARM      AGE stats_wi…    tol.root   tol.root         0
#> 12    ARM      AGE stats_wi… digits.rank  digits.r…       Inf
#> ℹ 3 more variables: fmt_fun, warning, error
```
