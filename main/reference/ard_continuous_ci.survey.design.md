# ARD survey continuous CIs

One-sample confidence intervals for continuous variables' means and
medians. Confidence limits are calculated with
[`survey::svymean()`](https://rdrr.io/pkg/survey/man/surveysummary.html)
and
[`survey::svyquantile()`](https://rdrr.io/pkg/survey/man/svyquantile.html).

## Usage

``` r
# S3 method for class 'survey.design'
ard_continuous_ci(
  data,
  variables,
  by = NULL,
  method = c("svymean", "svymedian.mean", "svymedian.beta", "svymedian.xlogit",
    "svymedian.asin", "svymedian.score"),
  conf.level = 0.95,
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
  Method for confidence interval calculation. When `"svymean"`, the
  calculation is computed via
  [`survey::svymean()`](https://rdrr.io/pkg/survey/man/surveysummary.html).
  Otherwise, it is calculated
  via`survey::svyquantile(interval.type=method)`

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- df:

  (`numeric`)\
  denominator degrees of freedom, passed to `survey::confint(df)`.
  Default is `survey::degf(data)`.

- ...:

  arguments passed to `survey::confint()`

## Value

ARD data frame

## Examples

``` r
data(api, package = "survey")
dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)

ard_continuous_ci(dclus1, variables = api00)
#> {cards} data frame: 5 x 8
#>   variable   context  stat_name stat_label    stat fmt_fun
#> 1    api00 survey_c…   estimate   estimate 644.169       2
#> 2    api00 survey_c…  std.error  std.error  23.542       2
#> 3    api00 survey_c…   conf.low   conf.low 593.676       2
#> 4    api00 survey_c…  conf.high  conf.high 694.662       2
#> 5    api00 survey_c… conf.level  conf.lev…    0.95       2
#> ℹ 2 more variables: warning, error
ard_continuous_ci(dclus1, variables = api00, method = "svymedian.xlogit")
#> {cards} data frame: 5 x 8
#>   variable   context  stat_name stat_label   stat fmt_fun
#> 1    api00 survey_c…   estimate   estimate    652       2
#> 2    api00 survey_c…  std.error  std.error 34.969       2
#> 3    api00 survey_c…   conf.low   conf.low    564       2
#> 4    api00 survey_c…  conf.high  conf.high    714       2
#> 5    api00 survey_c… conf.level  conf.lev…   0.95       2
#> ℹ 2 more variables: warning, error
```
