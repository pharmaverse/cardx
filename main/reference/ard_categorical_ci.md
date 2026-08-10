# ARD Proportion Confidence Intervals

Calculate confidence intervals for proportions.

## Usage

``` r
ard_categorical_ci(data, ...)

# S3 method for class 'data.frame'
ard_categorical_ci(
  data,
  variables,
  by = dplyr::group_vars(data),
  method = c("waldcc", "wald", "clopper-pearson", "wilson", "wilsoncc", "strat_wilson",
    "strat_wilsoncc", "agresti-coull", "jeffreys"),
  denominator = c("column", "row", "cell"),
  conf.level = 0.95,
  value = list(where(is_binary) ~ 1L, where(is.logical) ~ TRUE),
  strata = NULL,
  weights = NULL,
  max.iterations = 10,
  ...
)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame

- ...:

  Arguments passed to methods.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  columns to include in summaries. Columns must be class `<logical>` or
  `<numeric>` values coded as `c(0,1)`.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  columns to stratify calculations by.

- method:

  (`string`)\
  string indicating the type of confidence interval to calculate. Must
  be one of . See
  [`?proportion_ci`](https://pharmaverse.github.io/cardx/reference/proportion_ci.md)
  for details.

- denominator:

  (`string`)\
  Must be one of `'column'` (default), `'row'`, and `'cell'`, which
  specifies the direction of the calculation/denominator. Argument is
  similar to `cards::ard_tabulate(denominator)`.

- conf.level:

  (scalar `numeric`)\
  a scalar in `(0,1)` indicating the confidence level. Default is `0.95`

- value:

  ([`formula-list-selector`](https://insightsengineering.github.io/cards/latest-tag/reference/syntax.html))\
  function will calculate the CIs for all levels of the variables
  specified. Use this argument to instead request only a single level by
  summarized. Default is
  `list(where(is_binary) ~ 1L, where(is.logical) ~ TRUE)`, where columns
  coded as `0`/`1` and `TRUE`/`FALSE` will summarize the `1` and `TRUE`
  levels.

- strata, weights, max.iterations:

  arguments passed to
  [`proportion_ci_strat_wilson()`](https://pharmaverse.github.io/cardx/reference/proportion_ci.md),
  when `method='strat_wilson'`

## Value

an ARD data frame

## Examples

``` r
# compute CI for binary variables
ard_categorical_ci(mtcars, variables = c(vs, am), method = "wilson")
#> # An ARD data frame: 22 × 9
#>    variable variable_level stat_name 
#>    <chr>            <list> <chr>     
#>  1 vs                    1 N         
#>  2 vs                    1 n         
#>  3 vs                    1 conf.level
#>  4 vs                    1 estimate  
#>  5 vs                    1 statistic 
#>  6 vs                    1 p.value   
#>  7 vs                    1 parameter 
#>  8 vs                    1 conf.low  
#>  9 vs                    1 conf.high 
#> 10 vs                    1 method    
#> # ℹ 12 more rows
#> # ℹ 6 more variables: context <chr>, stat_label <chr>, stat <list>,
#> #   fmt_fun <list>, warning <list>, error <list>

# compute CIs for each level of a categorical variable
ard_categorical_ci(mtcars, variables = cyl, method = "jeffreys")
#> # An ARD data frame: 21 × 9
#>    variable variable_level context       stat_name  stat_label stat             
#>    <chr>            <list> <chr>         <chr>      <chr>      <list>           
#>  1 cyl                   4 proportion_ci N          N          32               
#>  2 cyl                   4 proportion_ci n          n          11               
#>  3 cyl                   4 proportion_ci estimate   estimate   0.34375          
#>  4 cyl                   4 proportion_ci conf.low   conf.low   0.1982694        
#>  5 cyl                   4 proportion_ci conf.high  conf.high  0.5160952        
#>  6 cyl                   4 proportion_ci conf.level conf.level 0.95             
#>  7 cyl                   4 proportion_ci method     method     Jeffreys Interval
#>  8 cyl                   6 proportion_ci N          N          32               
#>  9 cyl                   6 proportion_ci n          n          7                
#> 10 cyl                   6 proportion_ci estimate   estimate   0.21875          
#> # ℹ 11 more rows
#> # ℹ 3 more variables: fmt_fun <list>, warning <list>, error <list>
```
