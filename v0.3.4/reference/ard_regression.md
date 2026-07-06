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
#> {cards} data frame: 43 x 9
#>    variable variable_level   context      stat_name stat_label      stat
#> 1       ARM        Placebo regressi…           term       term ARMPlace…
#> 2       ARM        Placebo regressi…      var_label      Label Descript…
#> 3       ARM        Placebo regressi…      var_class      Class character
#> 4       ARM        Placebo regressi…       var_type       Type categori…
#> 5       ARM        Placebo regressi…    var_nlevels   N Levels         3
#> 6       ARM        Placebo regressi…      contrasts  contrasts contr.tr…
#> 7       ARM        Placebo regressi… contrasts_type  Contrast… treatment
#> 8       ARM        Placebo regressi…  reference_row  referenc…      TRUE
#> 9       ARM        Placebo regressi…          label  Level La…   Placebo
#> 10      ARM        Placebo regressi…          n_obs     N Obs.        86
#> ℹ 33 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 3 more variables: fmt_fun, warning, error

ard_regression(
  x = cards::ADSL,
  formula = AGE ~ ARM,
  method = "lm"
)
#> {cards} data frame: 43 x 9
#>    variable variable_level   context      stat_name stat_label      stat
#> 1       ARM        Placebo regressi…           term       term ARMPlace…
#> 2       ARM        Placebo regressi…      var_label      Label Descript…
#> 3       ARM        Placebo regressi…      var_class      Class character
#> 4       ARM        Placebo regressi…       var_type       Type categori…
#> 5       ARM        Placebo regressi…    var_nlevels   N Levels         3
#> 6       ARM        Placebo regressi…      contrasts  contrasts contr.tr…
#> 7       ARM        Placebo regressi… contrasts_type  Contrast… treatment
#> 8       ARM        Placebo regressi…  reference_row  referenc…      TRUE
#> 9       ARM        Placebo regressi…          label  Level La…   Placebo
#> 10      ARM        Placebo regressi…          n_obs     N Obs.        86
#> ℹ 33 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 3 more variables: fmt_fun, warning, error
```
