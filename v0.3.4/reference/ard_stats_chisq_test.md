# ARD Chi-squared Test

Analysis results data for Pearson's Chi-squared Test. Calculated with
`chisq.test(x = data[[variable]], y = data[[by]], ...)`

## Usage

``` r
ard_stats_chisq_test(data, by, variables, ...)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to compare by.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent tests will be computed for
  each variable.

- ...:

  additional arguments passed to `chisq.test(...)`

## Value

ARD data frame

## Examples

``` r
cards::ADSL |>
  ard_stats_chisq_test(by = "ARM", variables = "AGEGR1")
#> {cards} data frame: 9 x 9
#>   group1 variable   context        stat_name stat_label
#> 1    ARM   AGEGR1 stats_ch…        statistic  X-square…
#> 2    ARM   AGEGR1 stats_ch…          p.value    p-value
#> 3    ARM   AGEGR1 stats_ch…        parameter  Degrees …
#> 4    ARM   AGEGR1 stats_ch…           method     method
#> 5    ARM   AGEGR1 stats_ch…          correct    correct
#> 6    ARM   AGEGR1 stats_ch…                p          p
#> 7    ARM   AGEGR1 stats_ch…        rescale.p  rescale.p
#> 8    ARM   AGEGR1 stats_ch… simulate.p.value  simulate…
#> 9    ARM   AGEGR1 stats_ch…                B          B
#>                          stat
#> 1                       6.852
#> 2                       0.144
#> 3                           4
#> 4                   Pearson'…
#> 5                        TRUE
#> 6 rep, 1/length(x), length(x)
#> 7                       FALSE
#> 8                       FALSE
#> 9                        2000
#> ℹ 3 more variables: fmt_fun, warning, error
```
