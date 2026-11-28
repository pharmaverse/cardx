# ARD 2-sample proportion test

Analysis results data for a 2-sample test or proportions using
[`stats::prop.test()`](https://rdrr.io/r/stats/prop.test.html).

## Usage

``` r
ard_stats_prop_test(data, by, variables, conf.level = 0.95, ...)
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
  column names to be compared. Must be a binary column coded as
  `TRUE`/`FALSE` or `1`/`0`. Independent tests will be computed for each
  variable.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to `prop.test(...)`

## Value

ARD data frame

## Examples

``` r
mtcars |>
  ard_stats_prop_test(by = vs, variables = am)
#> # An ARD data frame: 13 × 9
#>    group1 variable stat_name  
#>    <chr>  <chr>    <chr>      
#>  1 vs     am       estimate   
#>  2 vs     am       estimate1  
#>  3 vs     am       estimate2  
#>  4 vs     am       statistic  
#>  5 vs     am       p.value    
#>  6 vs     am       parameter  
#>  7 vs     am       conf.low   
#>  8 vs     am       conf.high  
#>  9 vs     am       method     
#> 10 vs     am       alternative
#> 11 vs     am       p          
#> 12 vs     am       conf.level 
#> 13 vs     am       correct    
#> # ℹ 6 more variables: context <chr>, stat_label <chr>, stat <named list>,
#> #   fmt_fun <named list>, warning <named list>, error <named list>
```
