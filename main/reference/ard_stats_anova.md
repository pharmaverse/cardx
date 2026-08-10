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
#> # An ARD data frame: 11 × 8
#>    variable context     stat_name stat_label stat                               
#>    <chr>    <chr>       <chr>     <chr>      <list>                             
#>  1 model_1  stats_anova term      term       mpg ~ am                           
#>  2 model_1  stats_anova df.resid… df for re… 30                                 
#>  3 model_1  stats_anova rss       Residual … 720.8966                           
#>  4 model_2  stats_anova term      term       mpg ~ am + hp                      
#>  5 model_2  stats_anova df.resid… df for re… 29                                 
#>  6 model_2  stats_anova rss       Residual … 245.4393                           
#>  7 model_2  stats_anova df        Degrees o… 1                                  
#>  8 model_2  stats_anova sumsq     Sum of Sq… 475.4573                           
#>  9 model_2  stats_anova statistic statistic  56.17789                           
#> 10 model_2  stats_anova p.value   p-value    2.920375e-08                       
#> 11 model_2  stats_anova method    method     ANOVA results from `stats::anova()`
#> # ℹ 3 more variables: fmt_fun <list>, warning <named list>, error <named list>

ard_stats_anova(
  x = mtcars,
  formulas = list(am ~ mpg, am ~ mpg + hp),
  method = "glm",
  method.args = list(family = binomial)
)
#> # An ARD data frame: 10 × 8
#>    variable context     stat_name stat_label stat                               
#>    <chr>    <chr>       <chr>     <chr>      <list>                             
#>  1 model_1  stats_anova term      term       am ~ mpg                           
#>  2 model_1  stats_anova df.resid… df for re… 30                                 
#>  3 model_1  stats_anova residual… residual.… 29.67517                           
#>  4 model_2  stats_anova term      term       am ~ mpg + hp                      
#>  5 model_2  stats_anova df.resid… df for re… 29                                 
#>  6 model_2  stats_anova residual… residual.… 19.23255                           
#>  7 model_2  stats_anova df        Degrees o… 1                                  
#>  8 model_2  stats_anova deviance  deviance   10.44261                           
#>  9 model_2  stats_anova p.value   p-value    0.001231408                        
#> 10 model_2  stats_anova method    method     ANOVA results from `stats::anova()`
#> # ℹ 3 more variables: fmt_fun <list>, warning <named list>, error <named list>

ard_stats_anova(
  x = mtcars,
  formulas = list(am ~ 1 + (1 | vs), am ~ mpg + (1 | vs)),
  method = "glmer",
  method.args = list(family = binomial),
  package = "lme4"
)
#> # An ARD data frame: 16 × 8
#>    variable context     stat_name  stat                                warning  
#>    <chr>    <chr>       <chr>      <list>                              <named l>
#>  1 model_1  stats_anova term       MODEL1                              failed t…
#>  2 model_1  stats_anova npar       2                                   failed t…
#>  3 model_1  stats_anova AIC        47.22973                            failed t…
#>  4 model_1  stats_anova BIC        50.16121                            failed t…
#>  5 model_1  stats_anova logLik     -21.61487                           failed t…
#>  6 model_1  stats_anova minus2logL 43.22973                            failed t…
#>  7 model_2  stats_anova term       MODEL2                              failed t…
#>  8 model_2  stats_anova npar       3                                   failed t…
#>  9 model_2  stats_anova AIC        35.25029                            failed t…
#> 10 model_2  stats_anova BIC        39.6475                             failed t…
#> 11 model_2  stats_anova logLik     -14.62514                           failed t…
#> 12 model_2  stats_anova minus2logL 29.25029                            failed t…
#> 13 model_2  stats_anova statistic  13.97945                            failed t…
#> 14 model_2  stats_anova df         1                                   failed t…
#> 15 model_2  stats_anova p.value    0.0001848201                        failed t…
#> 16 model_2  stats_anova method     ANOVA results from `stats::anova()` failed t…
#> # ℹ 3 more variables: stat_label <chr>, fmt_fun <list>, error <named list>
```
