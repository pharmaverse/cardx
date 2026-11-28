# Basic Regression ARD

A function that takes a regression model and provides basic statistics
in an ARD structure. The default output is simpler than
[`ard_regression()`](https://pharmaverse.github.io/cardx/reference/ard_regression.md).
The function primarily matches regression terms to underlying variable
names and levels. The default arguments used are

    broom.helpers::tidy_plus_plus(
      add_reference_rows = FALSE,
      add_estimate_to_reference_rows = FALSE,
      add_n = FALSE,
      intercept = FALSE
    )

## Usage

``` r
ard_regression_basic(x, ...)

# Default S3 method
ard_regression_basic(
  x,
  tidy_fun = broom.helpers::tidy_with_broom_or_parameters,
  stats_to_remove = c("term", "var_type", "var_label", "var_class", "label",
    "contrasts_type", "contrasts", "var_nlevels"),
  ...
)

# S3 method for class 'data.frame'
ard_regression_basic(
  x,
  formula,
  method,
  method.args = list(),
  package = "base",
  tidy_fun = broom.helpers::tidy_with_broom_or_parameters,
  stats_to_remove = c("term", "var_type", "var_label", "var_class", "label",
    "contrasts_type", "contrasts", "var_nlevels"),
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

- stats_to_remove:

  (`character`)\
  character vector of statistic names to remove. Default is
  `c("term", "var_type", "var_label", "var_class", "label", "contrasts_type", "contrasts", "var_nlevels")`.

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
  ard_regression_basic()
#> # An ARD data frame: 12 × 9
#>    variable variable_level       context    stat_name stat_label    stat fmt_fun
#>    <chr>    <named list>         <chr>      <chr>     <chr>       <name> <named>
#>  1 ARM      Xanomeline High Dose regression estimate  Coefficient -0.828       1
#>  2 ARM      Xanomeline High Dose regression std.error Standard E…  1.27        1
#>  3 ARM      Xanomeline High Dose regression statistic statistic   -0.654       1
#>  4 ARM      Xanomeline High Dose regression p.value   p-value      0.514       1
#>  5 ARM      Xanomeline High Dose regression conf.low  CI Lower B… -3.32        1
#>  6 ARM      Xanomeline High Dose regression conf.high CI Upper B…  1.67        1
#>  7 ARM      Xanomeline Low Dose  regression estimate  Coefficient  0.457       1
#>  8 ARM      Xanomeline Low Dose  regression std.error Standard E…  1.27        1
#>  9 ARM      Xanomeline Low Dose  regression statistic statistic    0.361       1
#> 10 ARM      Xanomeline Low Dose  regression p.value   p-value      0.719       1
#> 11 ARM      Xanomeline Low Dose  regression conf.low  CI Lower B… -2.04        1
#> 12 ARM      Xanomeline Low Dose  regression conf.high CI Upper B…  2.95        1
#> # ℹ 2 more variables: warning <named list>, error <named list>

ard_regression_basic(
  x = cards::ADSL,
  formula = AGE ~ ARM,
  method = "lm"
)
#> # An ARD data frame: 12 × 9
#>    variable variable_level       context    stat_name stat_label    stat fmt_fun
#>    <chr>    <named list>         <chr>      <chr>     <chr>       <name> <named>
#>  1 ARM      Xanomeline High Dose regression estimate  Coefficient -0.828       1
#>  2 ARM      Xanomeline High Dose regression std.error Standard E…  1.27        1
#>  3 ARM      Xanomeline High Dose regression statistic statistic   -0.654       1
#>  4 ARM      Xanomeline High Dose regression p.value   p-value      0.514       1
#>  5 ARM      Xanomeline High Dose regression conf.low  CI Lower B… -3.32        1
#>  6 ARM      Xanomeline High Dose regression conf.high CI Upper B…  1.67        1
#>  7 ARM      Xanomeline Low Dose  regression estimate  Coefficient  0.457       1
#>  8 ARM      Xanomeline Low Dose  regression std.error Standard E…  1.27        1
#>  9 ARM      Xanomeline Low Dose  regression statistic statistic    0.361       1
#> 10 ARM      Xanomeline Low Dose  regression p.value   p-value      0.719       1
#> 11 ARM      Xanomeline Low Dose  regression conf.low  CI Lower B… -2.04        1
#> 12 ARM      Xanomeline Low Dose  regression conf.high CI Upper B…  2.95        1
#> # ℹ 2 more variables: warning <named list>, error <named list>
```
