# ARD one-sample Wilcox Rank-sum

Analysis results data for one-sample Wilcox Rank-sum. Result may be
stratified by including the `by` argument.

## Usage

``` r
ard_stats_wilcox_test_onesample(
  data,
  variables,
  by = dplyr::group_vars(data),
  conf.level = 0.95,
  ...
)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be analyzed. Independent Wilcox Rank-sum tests will be
  computed for each variable.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  optional column name to stratify results by.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to `wilcox.test(...)`

## Value

ARD data frame

## Examples

``` r
cards::ADSL |>
  ard_stats_wilcox_test_onesample(by = ARM, variables = AGE)
#> # An ARD data frame: 27 × 10
#>    group1 group1_level         variable stat_name  
#>    <chr>  <list>               <chr>    <chr>      
#>  1 ARM    Placebo              AGE      statistic  
#>  2 ARM    Placebo              AGE      p.value    
#>  3 ARM    Placebo              AGE      method     
#>  4 ARM    Placebo              AGE      alternative
#>  5 ARM    Placebo              AGE      mu         
#>  6 ARM    Placebo              AGE      conf.int   
#>  7 ARM    Placebo              AGE      tol.root   
#>  8 ARM    Placebo              AGE      digits.rank
#>  9 ARM    Placebo              AGE      conf.level 
#> 10 ARM    Xanomeline High Dose AGE      statistic  
#> # ℹ 17 more rows
#> # ℹ 6 more variables: context <chr>, stat_label <chr>, stat <list>,
#> #   fmt_fun <list>, warning <list>, error <list>
```
