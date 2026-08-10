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
#> # An ARD data frame: 9 × 9
#>   group1 variable context        stat_name stat_label stat                      
#>   <chr>  <chr>    <chr>          <chr>     <chr>      <named list>              
#> 1 ARM    AGEGR1   stats_chisq_t… statistic X-squared… 6.852038                  
#> 2 ARM    AGEGR1   stats_chisq_t… p.value   p-value    0.143917                  
#> 3 ARM    AGEGR1   stats_chisq_t… parameter Degrees o… 4                         
#> 4 ARM    AGEGR1   stats_chisq_t… method    method     Pearson's Chi-squared test
#> 5 ARM    AGEGR1   stats_chisq_t… correct   correct    TRUE                      
#> 6 ARM    AGEGR1   stats_chisq_t… p         p          <language>                
#> 7 ARM    AGEGR1   stats_chisq_t… rescale.p rescale.p  FALSE                     
#> 8 ARM    AGEGR1   stats_chisq_t… simulate… simulate.… FALSE                     
#> 9 ARM    AGEGR1   stats_chisq_t… B         B          2000                      
#> # ℹ 3 more variables: fmt_fun <named list>, warning <named list>,
#> #   error <named list>
```
