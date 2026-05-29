# ARD Kruskal-Wallis Test

Analysis results data for Kruskal-Wallis Rank Sum Test.

Calculated with `kruskal.test(data[[variable]], data[[by]], ...)`

## Usage

``` r
ard_stats_kruskal_test(data, by, variables)
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

## Value

ARD data frame

## Examples

``` r
cards::ADSL |>
  ard_stats_kruskal_test(by = "ARM", variables = "AGE")
#> {cards} data frame: 4 x 9
#>   group1 variable   context stat_name stat_label      stat
#> 1    ARM      AGE stats_kr… statistic  Kruskal-…     1.635
#> 2    ARM      AGE stats_kr…   p.value    p-value     0.442
#> 3    ARM      AGE stats_kr… parameter  Degrees …         2
#> 4    ARM      AGE stats_kr…    method     method Kruskal-…
#> ℹ 3 more variables: fmt_fun, warning, error
```
