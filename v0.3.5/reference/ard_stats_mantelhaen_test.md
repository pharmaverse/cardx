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
#> # An ARD data frame: 8 × 10
#>   group1 group2 variable context          stat_name stat                        
#>   <chr>  <chr>  <chr>    <chr>            <chr>     <list>                      
#> 1 ARM    SEX    AGEGR1   stats_mantelhae… statistic 6.455033                    
#> 2 ARM    SEX    AGEGR1   stats_mantelhae… p.value   0.1676458                   
#> 3 ARM    SEX    AGEGR1   stats_mantelhae… parameter 4                           
#> 4 ARM    SEX    AGEGR1   stats_mantelhae… method    Cochran-Mantel-Haenszel test
#> 5 ARM    SEX    AGEGR1   stats_mantelhae… alternat… two.sided                   
#> 6 ARM    SEX    AGEGR1   stats_mantelhae… correct   TRUE                        
#> 7 ARM    SEX    AGEGR1   stats_mantelhae… exact     FALSE                       
#> 8 ARM    SEX    AGEGR1   stats_mantelhae… conf.lev… 0.95                        
#> # ℹ 4 more variables: stat_label <chr>, fmt_fun <list>, warning <list>,
#> #   error <list>
```
