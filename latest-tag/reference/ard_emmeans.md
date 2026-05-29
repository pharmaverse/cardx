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
[`cardx::construct_model()`](https://insightsengineering.github.io/cardx/reference/construction_helpers.md).

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
#> {cards} data frame: 8 x 10
#>   group1 variable variable_level  stat_name stat_label      stat
#> 1     am contrast      am0 - am1   estimate  Mean Dif…    -2.567
#> 2     am contrast      am0 - am1  std.error  Standard…     1.291
#> 3     am contrast      am0 - am1         df  Degrees …        29
#> 4     am contrast      am0 - am1   conf.low  CI Lower…    -5.208
#> 5     am contrast      am0 - am1  conf.high  CI Upper…     0.074
#> 6     am contrast      am0 - am1    p.value    p-value     0.056
#> 7     am contrast      am0 - am1 conf.level  CI Confi…      0.95
#> 8     am contrast      am0 - am1     method     method Least-sq…
#> ℹ 4 more variables: context, fmt_fun, warning, error

ard_emmeans_contrast(
  data = mtcars,
  formula = vs ~ am + mpg,
  method = "glm",
  method.args = list(family = binomial),
  response_type = "dichotomous"
)
#> {cards} data frame: 8 x 10
#>   group1 variable variable_level  stat_name stat_label      stat
#> 1     am contrast      am0 - am1   estimate  Mean Dif…      0.61
#> 2     am contrast      am0 - am1  std.error  Standard…     0.229
#> 3     am contrast      am0 - am1         df  Degrees …       Inf
#> 4     am contrast      am0 - am1   conf.low  CI Lower…     0.162
#> 5     am contrast      am0 - am1  conf.high  CI Upper…     1.059
#> 6     am contrast      am0 - am1    p.value    p-value     0.008
#> 7     am contrast      am0 - am1 conf.level  CI Confi…      0.95
#> 8     am contrast      am0 - am1     method     method Least-sq…
#> ℹ 4 more variables: context, fmt_fun, warning, error
# LS Means
ard_emmeans_emmeans(
  data = mtcars,
  formula = mpg ~ am + cyl,
  method = "lm"
)
#> {cards} data frame: 16 x 10
#>    group1 variable variable_level  stat_name stat_label      stat
#> 1      am contrast              0   estimate       Mean    19.048
#> 2      am contrast              0  std.error  Standard…     0.753
#> 3      am contrast              0         df  Degrees …        29
#> 4      am contrast              0          n          n        19
#> 5      am contrast              0   conf.low  CI Lower…    17.507
#> 6      am contrast              0  conf.high  CI Upper…    20.589
#> 7      am contrast              0 conf.level  CI Confi…      0.95
#> 8      am contrast              0     method     method Least-sq…
#> 9      am contrast              1   estimate       Mean    21.615
#> 10     am contrast              1  std.error  Standard…     0.938
#> 11     am contrast              1         df  Degrees …        29
#> 12     am contrast              1          n          n        13
#> 13     am contrast              1   conf.low  CI Lower…    19.696
#> 14     am contrast              1  conf.high  CI Upper…    23.534
#> 15     am contrast              1 conf.level  CI Confi…      0.95
#> 16     am contrast              1     method     method Least-sq…
#> ℹ 4 more variables: context, fmt_fun, warning, error

ard_emmeans_emmeans(
  data = mtcars,
  formula = vs ~ am + mpg,
  method = "glm",
  method.args = list(family = binomial),
  response_type = "dichotomous"
)
#> {cards} data frame: 16 x 10
#>    group1 variable variable_level  stat_name stat_label      stat
#> 1      am contrast              0   estimate       Mean     0.726
#> 2      am contrast              0  std.error  Standard…     0.165
#> 3      am contrast              0         df  Degrees …       Inf
#> 4      am contrast              0          n          n        19
#> 5      am contrast              0   conf.low  CI Lower…     0.402
#> 6      am contrast              0  conf.high  CI Upper…      1.05
#> 7      am contrast              0 conf.level  CI Confi…      0.95
#> 8      am contrast              0     method     method Least-sq…
#> 9      am contrast              1   estimate       Mean     0.116
#> 10     am contrast              1  std.error  Standard…     0.117
#> 11     am contrast              1         df  Degrees …       Inf
#> 12     am contrast              1          n          n        13
#> 13     am contrast              1   conf.low  CI Lower…    -0.114
#> 14     am contrast              1  conf.high  CI Upper…     0.346
#> 15     am contrast              1 conf.level  CI Confi…      0.95
#> 16     am contrast              1     method     method Least-sq…
#> ℹ 4 more variables: context, fmt_fun, warning, error
```
