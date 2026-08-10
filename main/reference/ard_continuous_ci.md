# ARD continuous CIs

One-sample confidence intervals for continuous variable means and
medians.

## Usage

``` r
ard_continuous_ci(data, ...)

# S3 method for class 'data.frame'
ard_continuous_ci(
  data,
  variables,
  by = dplyr::group_vars(data),
  conf.level = 0.95,
  method = c("t.test", "wilcox.test"),
  ...
)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- ...:

  arguments passed to [`t.test()`](https://rdrr.io/r/stats/t.test.html)
  or [`wilcox.test()`](https://rdrr.io/r/stats/wilcox.test.html)

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent t-tests will be computed for
  each variable.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  optional column name to compare by.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- method:

  (`string`)\
  a string indicating the method to use for the confidence interval
  calculation. Must be one of `"t.test"` or `"wilcox.test"`

## Value

ARD data frame

## Examples

``` r
ard_continuous_ci(mtcars, variables = c(mpg, hp), method = "wilcox.test")
#> # An ARD data frame: 24 × 8
#>    variable stat_name   stat                                                
#>    <chr>    <chr>       <list>                                              
#>  1 mpg      estimate    19.59998                                            
#>  2 mpg      statistic   528                                                 
#>  3 mpg      p.value     8.31077e-07                                         
#>  4 mpg      conf.low    17.50004                                            
#>  5 mpg      conf.high   22.10001                                            
#>  6 mpg      method      Wilcoxon signed rank test with continuity correction
#>  7 mpg      alternative two.sided                                           
#>  8 hp       estimate    142.5001                                            
#>  9 hp       statistic   528                                                 
#> 10 hp       p.value     8.269629e-07                                        
#> # ℹ 14 more rows
#> # ℹ 5 more variables: context <chr>, stat_label <chr>, fmt_fun <list>,
#> #   warning <list>, error <list>
ard_continuous_ci(mtcars, variables = mpg, by = am, method = "t.test")
#> # An ARD data frame: 20 × 10
#>    group1 group1_level variable context   stat_name stat_label stat             
#>    <chr>        <list> <chr>    <chr>     <chr>     <chr>      <list>           
#>  1 am                0 mpg      continuo… estimate  Mean       17.14737         
#>  2 am                0 mpg      continuo… statistic t Statist… 19.49512         
#>  3 am                0 mpg      continuo… p.value   p-value    1.496986e-13     
#>  4 am                0 mpg      continuo… parameter Degrees o… 18               
#>  5 am                0 mpg      continuo… conf.low  CI Lower … 15.29946         
#>  6 am                0 mpg      continuo… conf.high CI Upper … 18.99528         
#>  7 am                0 mpg      continuo… method    method     One Sample t-test
#>  8 am                0 mpg      continuo… alternat… alternati… two.sided        
#>  9 am                0 mpg      continuo… mu        H0 Mean    0                
#> 10 am                0 mpg      continuo… conf.lev… CI Confid… 0.95             
#> 11 am                1 mpg      continuo… estimate  Mean       24.39231         
#> 12 am                1 mpg      continuo… statistic t Statist… 14.26217         
#> 13 am                1 mpg      continuo… p.value   p-value    6.909456e-09     
#> 14 am                1 mpg      continuo… parameter Degrees o… 12               
#> 15 am                1 mpg      continuo… conf.low  CI Lower … 20.66593         
#> 16 am                1 mpg      continuo… conf.high CI Upper … 28.11869         
#> 17 am                1 mpg      continuo… method    method     One Sample t-test
#> 18 am                1 mpg      continuo… alternat… alternati… two.sided        
#> 19 am                1 mpg      continuo… mu        H0 Mean    0                
#> 20 am                1 mpg      continuo… conf.lev… CI Confid… 0.95             
#> # ℹ 3 more variables: fmt_fun <list>, warning <list>, error <list>
```
