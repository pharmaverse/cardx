# ARD one-sample t-test

Analysis results data for one-sample t-tests. Result may be stratified
by including the `by` argument.

## Usage

``` r
ard_stats_t_test_onesample(
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
  column names to be analyzed. Independent t-tests will be computed for
  each variable.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  optional column name to stratify results by.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to [`t.test()`](https://rdrr.io/r/stats/t.test.html)

## Value

ARD data frame

## Examples

``` r
cards::ADSL |>
  ard_stats_t_test_onesample(by = ARM, variables = AGE)
#> # An ARD data frame: 30 × 10
#>    group1 group1_level variable context   stat_name stat_label stat             
#>    <chr>  <list>       <chr>    <chr>     <chr>     <chr>      <list>           
#>  1 ARM    Placebo      AGE      stats_t_… estimate  Mean       75.2093          
#>  2 ARM    Placebo      AGE      stats_t_… statistic t Statist… 81.19311         
#>  3 ARM    Placebo      AGE      stats_t_… p.value   p-value    2.473885e-82     
#>  4 ARM    Placebo      AGE      stats_t_… parameter Degrees o… 85               
#>  5 ARM    Placebo      AGE      stats_t_… conf.low  CI Lower … 73.36757         
#>  6 ARM    Placebo      AGE      stats_t_… conf.high CI Upper … 77.05104         
#>  7 ARM    Placebo      AGE      stats_t_… method    method     One Sample t-test
#>  8 ARM    Placebo      AGE      stats_t_… alternat… alternati… two.sided        
#>  9 ARM    Placebo      AGE      stats_t_… mu        H0 Mean    0                
#> 10 ARM    Placebo      AGE      stats_t_… conf.lev… CI Confid… 0.95             
#> # ℹ 20 more rows
#> # ℹ 3 more variables: fmt_fun <list>, warning <list>, error <list>
```
