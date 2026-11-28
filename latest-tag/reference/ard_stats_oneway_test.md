# ARD One-way Test

Analysis results data for Testing Equal Means in a One-Way Layout.
calculated with
[`oneway.test()`](https://rdrr.io/r/stats/oneway.test.html)

## Usage

``` r
ard_stats_oneway_test(formula, data, ...)
```

## Arguments

- formula:

  a formula of the form `lhs ~ rhs` where `lhs` gives the sample values
  and `rhs` the corresponding groups.

- data:

  an optional matrix or data frame (or similar: see
  [`model.frame`](https://rdrr.io/r/stats/model.frame.html)) containing
  the variables in the formula `formula`. By default the variables are
  taken from `environment(formula)`.

- ...:

  additional arguments passed to `oneway.test(...)`

## Value

ARD data frame

## Examples

``` r
ard_stats_oneway_test(AGE ~ ARM, data = cards::ADSL)
#> # An ARD data frame: 6 × 9
#>   group1 variable stat_name
#>   <chr>  <chr>    <chr>    
#> 1 ARM    AGE      num.df   
#> 2 ARM    AGE      den.df   
#> 3 ARM    AGE      statistic
#> 4 ARM    AGE      p.value  
#> 5 ARM    AGE      method   
#> 6 ARM    AGE      var.equal
#> # ℹ 6 more variables: context <chr>, stat_label <chr>, stat <named list>,
#> #   fmt_fun <named list>, warning <named list>, error <named list>
```
