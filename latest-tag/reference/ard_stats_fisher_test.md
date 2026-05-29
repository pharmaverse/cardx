# ARD Fisher's Exact Test

Analysis results data for Fisher's Exact Test. Calculated with
`fisher.test(x = data[[variable]], y = data[[by]], ...)`

## Usage

``` r
ard_stats_fisher_test(data, by, variables, conf.level = 0.95, ...)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to compare by

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent tests will be computed for
  each variable.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  additional arguments passed to `fisher.test(...)`

## Value

ARD data frame

## Examples

``` r
cards::ADSL[1:30, ] |>
  ard_stats_fisher_test(by = "ARM", variables = "AGEGR1")
#> {cards} data frame: 12 x 9
#>    group1 variable   context        stat_name stat_label        stat
#> 1     ARM   AGEGR1 stats_fi…          p.value    p-value       0.089
#> 2     ARM   AGEGR1 stats_fi…           method     method   Fisher's…
#> 3     ARM   AGEGR1 stats_fi…      alternative  alternat…   two.sided
#> 4     ARM   AGEGR1 stats_fi…        workspace  workspace       2e+05
#> 5     ARM   AGEGR1 stats_fi…           hybrid     hybrid       FALSE
#> 6     ARM   AGEGR1 stats_fi…       hybridPars  hybridPa… c, 5, 80, 1
#> 7     ARM   AGEGR1 stats_fi…          control    control        list
#> 8     ARM   AGEGR1 stats_fi…               or         or           1
#> 9     ARM   AGEGR1 stats_fi…         conf.int   conf.int        TRUE
#> 10    ARM   AGEGR1 stats_fi…       conf.level  conf.lev…        0.95
#> 11    ARM   AGEGR1 stats_fi… simulate.p.value  simulate…       FALSE
#> 12    ARM   AGEGR1 stats_fi…                B          B        2000
#> ℹ 3 more variables: fmt_fun, warning, error
```
