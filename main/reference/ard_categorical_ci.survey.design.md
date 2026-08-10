# ARD survey categorical CIs

Confidence intervals for categorical variables calculated via
[`survey::svyciprop()`](https://rdrr.io/pkg/survey/man/svyciprop.html).

## Usage

``` r
# S3 method for class 'survey.design'
ard_categorical_ci(
  data,
  variables,
  by = NULL,
  method = c("logit", "likelihood", "asin", "beta", "mean", "xlogit"),
  conf.level = 0.95,
  value = list(where(is_binary) ~ 1L, where(is.logical) ~ TRUE),
  df = survey::degf(data),
  ...
)
```

## Arguments

- data:

  (`survey.design`)\
  a design object often created with
  [`survey::svydesign()`](https://rdrr.io/pkg/survey/man/svydesign.html).

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  columns to include in summaries.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  results are calculated for **all combinations** of the columns
  specified, including unobserved combinations and unobserved factor
  levels.

- method:

  (`string`)\
  Method passed to `survey::svyciprop(method)`

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

- df:

  (`numeric`)\
  denominator degrees of freedom, passed to `survey::svyciprop(df)`.
  Default is `survey::degf(data)`.

- ...:

  arguments passed to
  [`survey::svyciprop()`](https://rdrr.io/pkg/survey/man/svyciprop.html)

## Value

ARD data frame

## Examples

``` r
data(api, package = "survey")
dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)

ard_categorical_ci(dclus1, variables = sch.wide)
#> # An ARD data frame: 10 × 9
#>    variable variable_level context       stat_name stat_label stat       fmt_fun
#>    <chr>    <list>         <chr>         <chr>     <chr>      <list>     <list> 
#>  1 sch.wide No             categorical_… estimate  estimate   0.1256831  2      
#>  2 sch.wide No             categorical_… conf.low  conf.low   0.08809992 2      
#>  3 sch.wide No             categorical_… conf.high conf.high  0.1762011  2      
#>  4 sch.wide No             categorical_… method    method     logit      <fn>   
#>  5 sch.wide No             categorical_… conf.lev… conf.level 0.95       2      
#>  6 sch.wide Yes            categorical_… estimate  estimate   0.8743169  2      
#>  7 sch.wide Yes            categorical_… conf.low  conf.low   0.8237989  2      
#>  8 sch.wide Yes            categorical_… conf.high conf.high  0.9119001  2      
#>  9 sch.wide Yes            categorical_… method    method     logit      <fn>   
#> 10 sch.wide Yes            categorical_… conf.lev… conf.level 0.95       2      
#> # ℹ 2 more variables: warning <list>, error <list>
ard_categorical_ci(dclus1, variables = sch.wide, value = sch.wide ~ "Yes", method = "xlogit")
#> # An ARD data frame: 5 × 9
#>   variable variable_level context        stat_name  stat_label stat      fmt_fun
#>   <chr>    <list>         <chr>          <chr>      <chr>      <list>    <list> 
#> 1 sch.wide Yes            categorical_ci estimate   estimate   0.8743169 2      
#> 2 sch.wide Yes            categorical_ci conf.low   conf.low   0.8237989 2      
#> 3 sch.wide Yes            categorical_ci conf.high  conf.high  0.9119001 2      
#> 4 sch.wide Yes            categorical_ci method     method     xlogit    <fn>   
#> 5 sch.wide Yes            categorical_ci conf.level conf.level 0.95      2      
#> # ℹ 2 more variables: warning <list>, error <list>
```
