# ARD ANOVA

Prepare ANOVA results from the
[`stats::anova()`](https://rdrr.io/r/stats/anova.html) function. Users
may pass a pre-calculated
[`stats::anova()`](https://rdrr.io/r/stats/anova.html) object or a list
of formulas. In the latter case, the models will be constructed using
the information passed and models will be passed to
[`stats::anova()`](https://rdrr.io/r/stats/anova.html).

## Usage

``` r
ard_stats_anova(x, ...)

# S3 method for class 'anova'
ard_stats_anova(x, method_text = "ANOVA results from `stats::anova()`", ...)

# S3 method for class 'data.frame'
ard_stats_anova(
  x,
  formulas,
  method,
  method.args = list(),
  package = "base",
  method_text = "ANOVA results from `stats::anova()`",
  ...
)
```

## Arguments

- x:

  (`anova` or `data.frame`)\
  an object of class `'anova'` created with
  [`stats::anova()`](https://rdrr.io/r/stats/anova.html) or a data frame

- ...:

  These dots are for future extensions and must be empty.

- method_text:

  (`string`)\
  string of the method used. Default is
  `"ANOVA results from `stats::anova()`"`. We provide the option to
  change this as [`stats::anova()`](https://rdrr.io/r/stats/anova.html)
  can produce results from many types of models that may warrant a more
  precise description.

- formulas:

  (`list`)\
  a list of formulas

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

ARD data frame

## Details

When a list of formulas is supplied to `ard_stats_anova()`, these
formulas along with information from other arguments, are used to
construct models and pass those models to
[`stats::anova()`](https://rdrr.io/r/stats/anova.html).

The models are constructed using
[`rlang::exec()`](https://rlang.r-lib.org/reference/exec.html), which is
similar to [`do.call()`](https://rdrr.io/r/base/do.call.html).

    rlang::exec(.fn = method, formula = formula, data = data, !!!method.args)

The above function is executed in `withr::with_namespace(package)`,
which allows for the use of `ard_stats_anova(method)` from packages,
e.g. `package = 'lme4'` must be specified when `method = 'glmer'`. See
example below.

## Examples

``` r
anova(
  lm(mpg ~ am, mtcars),
  lm(mpg ~ am + hp, mtcars)
) |>
  ard_stats_anova()
#> {cards} data frame: 11 x 8
#>    variable   context   stat_name stat_label      stat fmt_fun
#> 1   model_1 stats_an…        term       term  mpg ~ am    NULL
#> 2   model_1 stats_an… df.residual  df for r…        30       1
#> 3   model_1 stats_an…         rss  Residual…   720.897       1
#> 4   model_2 stats_an…        term       term mpg ~ am…    NULL
#> 5   model_2 stats_an… df.residual  df for r…        29       1
#> 6   model_2 stats_an…         rss  Residual…   245.439       1
#> 7   model_2 stats_an…          df  Degrees …         1       1
#> 8   model_2 stats_an…       sumsq  Sum of S…   475.457       1
#> 9   model_2 stats_an…   statistic  statistic    56.178       1
#> 10  model_2 stats_an…     p.value    p-value         0       1
#> 11  model_2 stats_an…      method     method ANOVA re…    NULL
#> ℹ 2 more variables: warning, error

ard_stats_anova(
  x = mtcars,
  formulas = list(am ~ mpg, am ~ mpg + hp),
  method = "glm",
  method.args = list(family = binomial)
)
#> {cards} data frame: 10 x 8
#>    variable   context         stat_name stat_label      stat fmt_fun
#> 1   model_1 stats_an…              term       term  am ~ mpg    NULL
#> 2   model_1 stats_an…       df.residual  df for r…        30       1
#> 3   model_1 stats_an… residual.deviance  residual…    29.675       1
#> 4   model_2 stats_an…              term       term am ~ mpg…    NULL
#> 5   model_2 stats_an…       df.residual  df for r…        29       1
#> 6   model_2 stats_an… residual.deviance  residual…    19.233       1
#> 7   model_2 stats_an…                df  Degrees …         1       1
#> 8   model_2 stats_an…          deviance   deviance    10.443       1
#> 9   model_2 stats_an…           p.value    p-value     0.001       1
#> 10  model_2 stats_an…            method     method ANOVA re…    NULL
#> ℹ 2 more variables: warning, error

ard_stats_anova(
  x = mtcars,
  formulas = list(am ~ 1 + (1 | vs), am ~ mpg + (1 | vs)),
  method = "glmer",
  method.args = list(family = binomial),
  package = "lme4"
)
#> {cards} data frame: 16 x 8
#>    variable   context  stat_name stat_label      stat   warning
#> 1   model_1 stats_an…       term       term    MODEL1 failed t…
#> 2   model_1 stats_an…       npar       npar         2 failed t…
#> 3   model_1 stats_an…        AIC        AIC     47.23 failed t…
#> 4   model_1 stats_an…        BIC        BIC    50.161 failed t…
#> 5   model_1 stats_an…     logLik     logLik   -21.615 failed t…
#> 6   model_1 stats_an… minus2logL  minus2lo…     43.23 failed t…
#> 7   model_2 stats_an…       term       term    MODEL2 failed t…
#> 8   model_2 stats_an…       npar       npar         3 failed t…
#> 9   model_2 stats_an…        AIC        AIC     35.25 failed t…
#> 10  model_2 stats_an…        BIC        BIC    39.647 failed t…
#> 11  model_2 stats_an…     logLik     logLik   -14.625 failed t…
#> 12  model_2 stats_an… minus2logL  minus2lo…     29.25 failed t…
#> 13  model_2 stats_an…  statistic  statistic    13.979 failed t…
#> 14  model_2 stats_an…         df  Degrees …         1 failed t…
#> 15  model_2 stats_an…    p.value    p-value         0 failed t…
#> 16  model_2 stats_an…     method     method ANOVA re… failed t…
#> ℹ 2 more variables: fmt_fun, error
```
