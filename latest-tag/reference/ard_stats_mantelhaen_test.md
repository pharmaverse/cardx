# ARD Cochran-Mantel-Haenszel Chi-Squared Test

Analysis results data for Cochran-Mantel-Haenszel Chi-Squared Test for
count data. Calculated with
`mantelhaen.test(x = data[[variables]], y = data[[by]], z = data[[strata]], ...)`.

## Usage

``` r
ard_stats_mantelhaen_test(data, by, variables, strata, ...)
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

- strata:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to stratify by.

- ...:

  additional arguments passed to `stats::mantelhaen.test(...)`

## Value

ARD data frame

## Examples

``` r
cards::ADSL |>
  ard_stats_mantelhaen_test(by = "ARM", variables = "AGEGR1", strata = "SEX")
#> {cards} data frame: 8 x 10
#>   group1 group2 variable   stat_name stat_label      stat
#> 1    ARM    SEX   AGEGR1   statistic  Generali…     6.455
#> 2    ARM    SEX   AGEGR1     p.value    p-value     0.168
#> 3    ARM    SEX   AGEGR1   parameter  Degrees …         4
#> 4    ARM    SEX   AGEGR1      method     method Cochran-…
#> 5    ARM    SEX   AGEGR1 alternative  alternat… two.sided
#> 6    ARM    SEX   AGEGR1     correct  Continui…      TRUE
#> 7    ARM    SEX   AGEGR1       exact  Exact Co…     FALSE
#> 8    ARM    SEX   AGEGR1  conf.level  CI Confi…      0.95
#> ℹ 4 more variables: context, fmt_fun, warning, error
```
