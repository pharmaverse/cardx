# ARDs for LS Mean Difference and LS Means

The `ard_emmeans_contrast()` function calculates least-squares mean
differences using the 'emmeans' package using the following

    emmeans::emmeans(object = <regression model>, specs = ~ <primary covariate>) |>
      emmeans::contrast(method = "pairwise") |>
      summary(infer = TRUE, level = <confidence level>)

The `ard_emmeans_emmeans()` function calculates least-squares means
using the 'emmeans' package using the following

    emmeans::emmeans(object = <regression model>, specs = ~ <primary covariate>) |>
      summary(emmeans, calc = c(n = ".wgt."))

The arguments `data`, `formula`, `method`, `method.args`, `package` are
used to construct the regression model via
[`cardx::construct_model()`](https://pharmaverse.github.io/cardx/reference/construction_helpers.md).

## Usage

``` r
ard_emmeans_contrast(
  data,
  formula,
  method,
  method.args = list(),
  package = "base",
  response_type = c("continuous", "dichotomous"),
  conf.level = 0.95,
  primary_covariate = getElement(attr(stats::terms(formula), "term.labels"), 1L)
)

ard_emmeans_emmeans(
  data,
  formula,
  method,
  method.args = list(),
  package = "base",
  response_type = c("continuous", "dichotomous"),
  conf.level = 0.95,
  primary_covariate = getElement(attr(stats::terms(formula), "term.labels"), 1L)
)
```

## Arguments

- data:

  (`data.frame`/`survey.design`)\
  a data frame or survey design object

- formula:

  (`formula`)\
  a formula

- method:

  (`string`)\
  string of function naming the function to be called, e.g. `"glm"`. If
  function belongs to a library that is not attached, the package name
  must be specified in the `package` argument.

- method.args:

  (named `list`)\
  named list of arguments that will be passed to `method`.

  Note that this list may contain non-standard evaluation components. If
  you are wrapping this function in other functions, the argument must
  be passed in a way that does not evaluate the list, e.g. using rlang's
  embrace operator `{{ . }}`.

- package:

  (`string`)\
  a package name that will be temporarily loaded when function specified
  in `method` is executed.

- response_type:

  (`string`) string indicating whether the model outcome is
  `'continuous'` or `'dichotomous'`. When `'dichotomous'`, the call to
  [`emmeans::emmeans()`](https://rvlenth.github.io/emmeans/reference/emmeans.html)
  is supplemented with argument `regrid="response"`.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- primary_covariate:

  (`string`)\
  string indicating the primary covariate (typically the dichotomous
  treatment variable). Default is the first covariate listed in the
  formula.

## Value

ARD data frame

## Examples

``` r
# LS Mean Difference
ard_emmeans_contrast(
  data = mtcars,
  formula = mpg ~ am + cyl,
  method = "lm"
)
#> # An ARD data frame: 8 × 10
#>   group1 variable variable_level stat_name 
#>   <chr>  <chr>    <list>         <chr>     
#> 1 am     contrast am0 - am1      estimate  
#> 2 am     contrast am0 - am1      std.error 
#> 3 am     contrast am0 - am1      df        
#> 4 am     contrast am0 - am1      conf.low  
#> 5 am     contrast am0 - am1      conf.high 
#> 6 am     contrast am0 - am1      p.value   
#> 7 am     contrast am0 - am1      conf.level
#> 8 am     contrast am0 - am1      method    
#> # ℹ 6 more variables: context <chr>, stat_label <chr>, stat <list>,
#> #   fmt_fun <list>, warning <list>, error <list>

ard_emmeans_contrast(
  data = mtcars,
  formula = vs ~ am + mpg,
  method = "glm",
  method.args = list(family = binomial),
  response_type = "dichotomous"
)
#> # An ARD data frame: 8 × 10
#>   group1 variable variable_level stat_name 
#>   <chr>  <chr>    <list>         <chr>     
#> 1 am     contrast am0 - am1      estimate  
#> 2 am     contrast am0 - am1      std.error 
#> 3 am     contrast am0 - am1      df        
#> 4 am     contrast am0 - am1      conf.low  
#> 5 am     contrast am0 - am1      conf.high 
#> 6 am     contrast am0 - am1      p.value   
#> 7 am     contrast am0 - am1      conf.level
#> 8 am     contrast am0 - am1      method    
#> # ℹ 6 more variables: context <chr>, stat_label <chr>, stat <list>,
#> #   fmt_fun <list>, warning <list>, error <list>
# LS Means
ard_emmeans_emmeans(
  data = mtcars,
  formula = mpg ~ am + cyl,
  method = "lm"
)
#> # An ARD data frame: 16 × 10
#>    group1 variable variable_level context         stat_name  stat               
#>    <chr>  <chr>    <list>         <chr>           <chr>      <list>             
#>  1 am     contrast 0              emmeans_emmeans estimate   19.04777           
#>  2 am     contrast 0              emmeans_emmeans std.error  0.7534361          
#>  3 am     contrast 0              emmeans_emmeans df         29                 
#>  4 am     contrast 0              emmeans_emmeans n          19                 
#>  5 am     contrast 0              emmeans_emmeans conf.low   17.50682           
#>  6 am     contrast 0              emmeans_emmeans conf.high  20.58872           
#>  7 am     contrast 0              emmeans_emmeans conf.level 0.95               
#>  8 am     contrast 0              emmeans_emmeans method     Least-squares means
#>  9 am     contrast 1              emmeans_emmeans estimate   21.6148            
#> 10 am     contrast 1              emmeans_emmeans std.error  0.9382835          
#> 11 am     contrast 1              emmeans_emmeans df         29                 
#> 12 am     contrast 1              emmeans_emmeans n          13                 
#> 13 am     contrast 1              emmeans_emmeans conf.low   19.6958            
#> 14 am     contrast 1              emmeans_emmeans conf.high  23.53381           
#> 15 am     contrast 1              emmeans_emmeans conf.level 0.95               
#> 16 am     contrast 1              emmeans_emmeans method     Least-squares means
#> # ℹ 4 more variables: stat_label <chr>, fmt_fun <list>, warning <list>,
#> #   error <list>

ard_emmeans_emmeans(
  data = mtcars,
  formula = vs ~ am + mpg,
  method = "glm",
  method.args = list(family = binomial),
  response_type = "dichotomous"
)
#> # An ARD data frame: 16 × 10
#>    group1 variable variable_level context         stat_name  stat               
#>    <chr>  <chr>    <list>         <chr>           <chr>      <list>             
#>  1 am     contrast 0              emmeans_emmeans estimate   0.7261156          
#>  2 am     contrast 0              emmeans_emmeans std.error  0.1651809          
#>  3 am     contrast 0              emmeans_emmeans df         Inf                
#>  4 am     contrast 0              emmeans_emmeans n          19                 
#>  5 am     contrast 0              emmeans_emmeans conf.low   0.402367           
#>  6 am     contrast 0              emmeans_emmeans conf.high  1.049864           
#>  7 am     contrast 0              emmeans_emmeans conf.level 0.95               
#>  8 am     contrast 0              emmeans_emmeans method     Least-squares means
#>  9 am     contrast 1              emmeans_emmeans estimate   0.1158561          
#> 10 am     contrast 1              emmeans_emmeans std.error  0.1171975          
#> 11 am     contrast 1              emmeans_emmeans df         Inf                
#> 12 am     contrast 1              emmeans_emmeans n          13                 
#> 13 am     contrast 1              emmeans_emmeans conf.low   -0.1138467         
#> 14 am     contrast 1              emmeans_emmeans conf.high  0.345559           
#> 15 am     contrast 1              emmeans_emmeans conf.level 0.95               
#> 16 am     contrast 1              emmeans_emmeans method     Least-squares means
#> # ℹ 4 more variables: stat_label <chr>, fmt_fun <list>, warning <list>,
#> #   error <list>
```
