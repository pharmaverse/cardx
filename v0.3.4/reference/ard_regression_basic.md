# Basic Regression ARD

A function that takes a regression model and provides basic statistics
in an ARD structure. The default output is simpler than
[`ard_regression()`](https://insightsengineering.github.io/cardx/reference/ard_regression.md).
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
#> {cards} data frame: 12 x 9
#>    variable variable_level   context stat_name stat_label   stat
#> 1       ARM      Xanomeli… regressi…  estimate  Coeffici… -0.828
#> 2       ARM      Xanomeli… regressi… std.error  Standard…  1.267
#> 3       ARM      Xanomeli… regressi… statistic  statistic -0.654
#> 4       ARM      Xanomeli… regressi…   p.value    p-value  0.514
#> 5       ARM      Xanomeli… regressi…  conf.low  CI Lower… -3.324
#> 6       ARM      Xanomeli… regressi… conf.high  CI Upper…  1.668
#> 7       ARM      Xanomeli… regressi…  estimate  Coeffici…  0.457
#> 8       ARM      Xanomeli… regressi… std.error  Standard…  1.267
#> 9       ARM      Xanomeli… regressi… statistic  statistic  0.361
#> 10      ARM      Xanomeli… regressi…   p.value    p-value  0.719
#> 11      ARM      Xanomeli… regressi…  conf.low  CI Lower… -2.039
#> 12      ARM      Xanomeli… regressi… conf.high  CI Upper…  2.953
#> ℹ 3 more variables: fmt_fun, warning, error

ard_regression_basic(
  x = cards::ADSL,
  formula = AGE ~ ARM,
  method = "lm"
)
#> {cards} data frame: 12 x 9
#>    variable variable_level   context stat_name stat_label   stat
#> 1       ARM      Xanomeli… regressi…  estimate  Coeffici… -0.828
#> 2       ARM      Xanomeli… regressi… std.error  Standard…  1.267
#> 3       ARM      Xanomeli… regressi… statistic  statistic -0.654
#> 4       ARM      Xanomeli… regressi…   p.value    p-value  0.514
#> 5       ARM      Xanomeli… regressi…  conf.low  CI Lower… -3.324
#> 6       ARM      Xanomeli… regressi… conf.high  CI Upper…  1.668
#> 7       ARM      Xanomeli… regressi…  estimate  Coeffici…  0.457
#> 8       ARM      Xanomeli… regressi… std.error  Standard…  1.267
#> 9       ARM      Xanomeli… regressi… statistic  statistic  0.361
#> 10      ARM      Xanomeli… regressi…   p.value    p-value  0.719
#> 11      ARM      Xanomeli… regressi…  conf.low  CI Lower… -2.039
#> 12      ARM      Xanomeli… regressi… conf.high  CI Upper…  2.953
#> ℹ 3 more variables: fmt_fun, warning, error
```
