# ARD Mood Test

Analysis results data for Mood two sample test of scale. Note this not
to be confused with the Brown-Mood test of medians.

## Usage

``` r
ard_stats_mood_test(data, by, variables, ...)
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
  column name to be compared. Independent tests will be run for each
  variable.

- ...:

  arguments passed to `mood.test(...)`

## Value

ARD data frame

## Details

For the `ard_stats_mood_test()` function, the data is expected to be one
row per subject. The data is passed as
`mood.test(data[[variable]] ~ data[[by]], ...)`.

## Examples

``` r
cards::ADSL |>
  ard_stats_mood_test(by = "SEX", variables = "AGE")
#> {cards} data frame: 4 x 9
#>   group1 variable   context   stat_name stat_label      stat
#> 1    SEX      AGE stats_mo…   statistic  Z-Statis…     0.129
#> 2    SEX      AGE stats_mo…     p.value    p-value     0.897
#> 3    SEX      AGE stats_mo…      method     method Mood two…
#> 4    SEX      AGE stats_mo… alternative  Alternat… two.sided
#> ℹ 3 more variables: fmt_fun, warning, error
```
