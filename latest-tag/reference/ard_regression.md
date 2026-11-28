# Regression ARD

Function takes a regression model object and converts it to a ARD
structure using the `broom.helpers` package.

## Usage

``` r
ard_regression(x, ...)

# Default S3 method
ard_regression(x, tidy_fun = broom.helpers::tidy_with_broom_or_parameters, ...)

# S3 method for class 'data.frame'
ard_regression(
  x,
  formula,
  method,
  method.args = list(),
  package = "base",
  tidy_fun = broom.helpers::tidy_with_broom_or_parameters,
  ...
)
```

## Arguments

- x:

  (regression model/`data.frame`)\
  regression model object or a data frame

- ...:

  Arguments passed to
  [`broom.helpers::tidy_plus_plus()`](https://larmarange.github.io/broom.helpers/reference/tidy_plus_plus.html)

- tidy_fun:

  (`function`)\
  a tidier. Default is
  [`broom.helpers::tidy_with_broom_or_parameters`](https://larmarange.github.io/broom.helpers/reference/tidy_with_broom_or_parameters.html)

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

## Value

data frame

## Examples

``` r
lm(AGE ~ ARM, data = cards::ADSL) |>
  ard_regression(add_estimate_to_reference_rows = TRUE)
#> # An ARD data frame: 43 × 9
#>    variable variable_level context    stat_name      stat                      
#>    <chr>    <named list>   <chr>      <chr>          <named list>              
#>  1 ARM      Placebo        regression term           ARMPlacebo                
#>  2 ARM      Placebo        regression var_label      Description of Planned Arm
#>  3 ARM      Placebo        regression var_class      character                 
#>  4 ARM      Placebo        regression var_type       categorical               
#>  5 ARM      Placebo        regression var_nlevels    3                         
#>  6 ARM      Placebo        regression contrasts      contr.treatment           
#>  7 ARM      Placebo        regression contrasts_type treatment                 
#>  8 ARM      Placebo        regression reference_row  TRUE                      
#>  9 ARM      Placebo        regression label          Placebo                   
#> 10 ARM      Placebo        regression n_obs          86                        
#> # ℹ 33 more rows
#> # ℹ 4 more variables: stat_label <chr>, fmt_fun <named list>,
#> #   warning <named list>, error <named list>

ard_regression(
  x = cards::ADSL,
  formula = AGE ~ ARM,
  method = "lm"
)
#> # An ARD data frame: 43 × 9
#>    variable variable_level context    stat_name      stat                      
#>    <chr>    <named list>   <chr>      <chr>          <named list>              
#>  1 ARM      Placebo        regression term           ARMPlacebo                
#>  2 ARM      Placebo        regression var_label      Description of Planned Arm
#>  3 ARM      Placebo        regression var_class      character                 
#>  4 ARM      Placebo        regression var_type       categorical               
#>  5 ARM      Placebo        regression var_nlevels    3                         
#>  6 ARM      Placebo        regression contrasts      contr.treatment           
#>  7 ARM      Placebo        regression contrasts_type treatment                 
#>  8 ARM      Placebo        regression reference_row  TRUE                      
#>  9 ARM      Placebo        regression label          Placebo                   
#> 10 ARM      Placebo        regression n_obs          86                        
#> # ℹ 33 more rows
#> # ℹ 4 more variables: stat_label <chr>, fmt_fun <named list>,
#> #   warning <named list>, error <named list>
```
