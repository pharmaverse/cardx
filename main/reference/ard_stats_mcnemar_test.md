# ARD McNemar's Test

Analysis results data for McNemar's statistical test. We have two
functions depending on the structure of the data.

- `ard_stats_mcnemar_test()` is the structure expected by
  [`stats::mcnemar.test()`](https://rdrr.io/r/stats/mcnemar.test.html)

- `ard_stats_mcnemar_test_long()` is one row per ID per group

## Usage

``` r
ard_stats_mcnemar_test(data, by, variables, ...)

ard_stats_mcnemar_test_long(data, by, variables, id, ...)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to compare by.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent tests will be computed for
  each variable.

- ...:

  arguments passed to `stats::mcnemar.test(...)`

- id:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name of the subject or participant ID

## Value

ARD data frame

## Details

For the `ard_stats_mcnemar_test()` function, the data is expected to be
one row per subject. The data is passed as
`stats::mcnemar.test(x = data[[variable]], y = data[[by]], ...)`. Please
use `table(x = data[[variable]], y = data[[by]])` to check the
contingency table.

## Examples

``` r
cards::ADSL |>
  ard_stats_mcnemar_test(by = "SEX", variables = "EFFFL")
#> {cards} data frame: 5 x 9
#>   group1 variable   context stat_name stat_label      stat
#> 1    SEX    EFFFL stats_mc… statistic  X-square…    111.91
#> 2    SEX    EFFFL stats_mc…   p.value    p-value         0
#> 3    SEX    EFFFL stats_mc… parameter  Degrees …         1
#> 4    SEX    EFFFL stats_mc…    method     method McNemar'…
#> 5    SEX    EFFFL stats_mc…   correct    correct      TRUE
#> ℹ 3 more variables: fmt_fun, warning, error

set.seed(1234)
cards::ADSL[c("USUBJID", "TRT01P")] |>
  dplyr::mutate(TYPE = "PLANNED") |>
  dplyr::rename(TRT01 = TRT01P) %>%
  dplyr::bind_rows(dplyr::mutate(., TYPE = "ACTUAL", TRT01 = sample(TRT01))) |>
  ard_stats_mcnemar_test_long(
    by = TYPE,
    variable = TRT01,
    id = USUBJID
  )
#> {cards} data frame: 5 x 9
#>   group1 variable   context stat_name stat_label      stat
#> 1   TYPE    TRT01 stats_mc… statistic  X-square…     1.353
#> 2   TYPE    TRT01 stats_mc…   p.value    p-value     0.717
#> 3   TYPE    TRT01 stats_mc… parameter  Degrees …         3
#> 4   TYPE    TRT01 stats_mc…    method     method McNemar'…
#> 5   TYPE    TRT01 stats_mc…   correct    correct      TRUE
#> ℹ 3 more variables: fmt_fun, warning, error
```
