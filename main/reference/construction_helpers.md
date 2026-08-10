# Construction Helpers

These functions help construct calls to various types of models.

## Usage

``` r
construct_model(data, ...)

# S3 method for class 'data.frame'
construct_model(
  data,
  formula,
  method,
  method.args = list(),
  package = "base",
  env = caller_env(),
  ...
)

# S3 method for class 'survey.design'
construct_model(
  data,
  formula,
  method,
  method.args = list(),
  package = "survey",
  env = caller_env(),
  ...
)

reformulate2(
  termlabels,
  response = NULL,
  intercept = TRUE,
  env = parent.frame(),
  pattern_term = NULL,
  pattern_response = NULL
)

bt(x, pattern = NULL)

bt_strip(x)
```

## Arguments

- data:

  - `construct_model.data.frame()` (`data.frame`) a data frame

  - `construct_model.survey.design()` (`survey.design`) a survey design
    object

- ...:

  These dots are for future extensions and must be empty.

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

- env:

  The environment in which to evaluate `expr`. This environment is not
  applicable for quosures because they have their own environments.

- termlabels:

  character vector giving the right-hand side of a model formula. May be
  zero-length.

- response:

  a character string, symbol or call giving the left-hand side of a
  model formula, or `NULL`.

- intercept:

  logical: should the formula have an intercept?

- x:

  (`character`)\
  character vector, typically of variable names

- pattern, pattern_term, pattern_response:

  DEPRECATED

## Value

depends on the calling function

## Details

- `construct_model()`: Builds models of the form
  `method(data = data, formula = formula, method.args!!!)`. If the
  `package` argument is specified, that package is temporarily attached
  when the model is evaluated.

- `reformulate2()`: This is a copy of
  [`reformulate()`](https://rdrr.io/r/stats/delete.response.html) except
  that variable names that contain a space are wrapped in backticks.

- `bt()`: Adds backticks to a character vector.

- `bt_strip()`: Removes backticks from a string if it begins and ends
  with a backtick.

## Examples

``` r
construct_model(
  data = mtcars,
  formula = am ~ mpg + (1 | vs),
  method = "glmer",
  method.args = list(family = binomial),
  package = "lme4"
) |>
  broom.mixed::tidy()
#> # A tibble: 3 × 7
#>   effect   group term            estimate std.error statistic p.value
#>   <chr>    <chr> <chr>              <dbl>     <dbl>     <dbl>   <dbl>
#> 1 fixed    NA    (Intercept)       -8.70      4.12      -2.11  0.0347
#> 2 fixed    NA    mpg                0.409     0.199      2.05  0.0403
#> 3 ran_pars vs    sd__(Intercept)    0.790    NA         NA    NA     

construct_model(
  data = mtcars |> dplyr::rename(`M P G` = mpg),
  formula = reformulate2(c("M P G", "cyl"), response = "hp"),
  method = "lm"
) |>
  ard_regression() |>
  dplyr::filter(stat_name %in% c("term", "estimate", "p.value"))
#> # An ARD data frame: 6 × 8
#>   variable context    stat_name stat_label  stat         fmt_fun  warning error 
#>   <chr>    <chr>      <chr>     <chr>       <named list> <named > <named> <name>
#> 1 M P G    regression term      term        `M P G`      <NULL>   <NULL>  <NULL>
#> 2 M P G    regression estimate  Coefficient -2.774769    1        <NULL>  <NULL>
#> 3 M P G    regression p.value   p-value     0.2125285    1        <NULL>  <NULL>
#> 4 cyl      regression term      term        cyl          <NULL>   <NULL>  <NULL>
#> 5 cyl      regression estimate  Coefficient 23.97863     1        <NULL>  <NULL>
#> 6 cyl      regression p.value   p-value     0.002814958  1        <NULL>  <NULL>
```
