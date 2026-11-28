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
#> # An ARD data frame: 12 × 9
#>    group1 variable context          stat_name stat                              
#>    <chr>  <chr>    <chr>            <chr>     <named list>                      
#>  1 ARM    AGEGR1   stats_fisher_te… p.value   0.08918073                        
#>  2 ARM    AGEGR1   stats_fisher_te… method    Fisher's Exact Test for Count Data
#>  3 ARM    AGEGR1   stats_fisher_te… alternat… two.sided                         
#>  4 ARM    AGEGR1   stats_fisher_te… workspace 2e+05                             
#>  5 ARM    AGEGR1   stats_fisher_te… hybrid    FALSE                             
#>  6 ARM    AGEGR1   stats_fisher_te… hybridPa… <language>                        
#>  7 ARM    AGEGR1   stats_fisher_te… control   <language>                        
#>  8 ARM    AGEGR1   stats_fisher_te… or        1                                 
#>  9 ARM    AGEGR1   stats_fisher_te… conf.int  TRUE                              
#> 10 ARM    AGEGR1   stats_fisher_te… conf.lev… 0.95                              
#> 11 ARM    AGEGR1   stats_fisher_te… simulate… FALSE                             
#> 12 ARM    AGEGR1   stats_fisher_te… B         2000                              
#> # ℹ 4 more variables: stat_label <chr>, fmt_fun <named list>,
#> #   warning <named list>, error <named list>
```
