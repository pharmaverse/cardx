# ARD Poisson Test

Analysis results data for exact tests of a simple null hypothesis about
the rate parameter in Poisson distribution, or the comparison of two
rate parameters.

## Usage

``` r
ard_stats_poisson_test(
  data,
  variables,
  na.rm = TRUE,
  by = NULL,
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
  names of the event and time variables (in that order) to be used in
  computations. Must be of length 2.

- na.rm:

  (scalar `logical`)\
  whether missing values should be removed before computations. Default
  is `TRUE`.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  optional column name to compare by.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to
  [`poisson.test()`](https://rdrr.io/r/stats/poisson.test.html).

## Value

an ARD data frame of class 'card'

## Details

- For the `ard_stats_poisson_test()` function, the data is expected to
  be one row per subject.

- If `by` is not specified, an exact Poisson test of the rate parameter
  will be performed. Otherwise, a Poisson comparison of two rate
  parameters will be performed on the levels of `by`. If `by` has more
  than 2 levels, an error will occur.

## Examples

``` r
# Exact test of rate parameter against null hypothesis
cards::ADTTE |>
  ard_stats_poisson_test(variables = c(CNSR, AVAL))
#> # An ARD data frame: 10 × 8
#>    variable context            stat_name   stat_label stat               fmt_fun
#>    <chr>    <chr>              <chr>       <chr>      <named list>       <named>
#>  1 AVAL     stats_poisson_test estimate    Estimated… 0.006052335        1      
#>  2 AVAL     stats_poisson_test statistic   Number of… 102                1      
#>  3 AVAL     stats_poisson_test p.value     p-value    9.881313e-324      1      
#>  4 AVAL     stats_poisson_test parameter   Expected … 16853              1      
#>  5 AVAL     stats_poisson_test conf.low    CI Lower … 0.004934956        1      
#>  6 AVAL     stats_poisson_test conf.high   CI Upper … 0.007347122        1      
#>  7 AVAL     stats_poisson_test method      method     Exact Poisson test <NULL> 
#>  8 AVAL     stats_poisson_test alternative alternati… two.sided          <NULL> 
#>  9 AVAL     stats_poisson_test conf.level  CI Confid… 0.95               1      
#> 10 AVAL     stats_poisson_test mu          H0 Mean    1                  1      
#> # ℹ 2 more variables: warning <named list>, error <named list>

# Comparison test of ratio of 2 rate parameters against null hypothesis
cards::ADTTE |>
  dplyr::filter(TRTA %in% c("Placebo", "Xanomeline High Dose")) |>
  ard_stats_poisson_test(by = TRTA, variables = c(CNSR, AVAL))
#> # An ARD data frame: 10 × 9
#>    group1 variable context      stat_name stat_label stat                       
#>    <chr>  <chr>    <chr>        <chr>     <chr>      <named list>               
#>  1 TRTA   AVAL     stats_poiss… estimate  Estimated… 0.7677454                  
#>  2 TRTA   AVAL     stats_poiss… statistic Number of… 57                         
#>  3 TRTA   AVAL     stats_poiss… p.value   p-value    0.2927159                  
#>  4 TRTA   AVAL     stats_poiss… parameter Expected … 61.0784                    
#>  5 TRTA   AVAL     stats_poiss… conf.low  CI Lower … 0.4655697                  
#>  6 TRTA   AVAL     stats_poiss… conf.high CI Upper … 1.305723                   
#>  7 TRTA   AVAL     stats_poiss… method    method     Comparison of Poisson rates
#>  8 TRTA   AVAL     stats_poiss… alternat… alternati… two.sided                  
#>  9 TRTA   AVAL     stats_poiss… conf.lev… CI Confid… 0.95                       
#> 10 TRTA   AVAL     stats_poiss… mu        H0 Mean    1                          
#> # ℹ 3 more variables: fmt_fun <named list>, warning <named list>,
#> #   error <named list>
```
