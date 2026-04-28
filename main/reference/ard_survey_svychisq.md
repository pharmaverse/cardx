# ARD Survey Chi-Square Test

Analysis results data for survey Chi-Square test using
[`survey::svychisq()`](https://rdrr.io/pkg/survey/man/svychisq.html).
Only two-way comparisons are supported.

## Usage

``` r
ard_survey_svychisq(data, by, variables, statistic = "F", ...)
```

## Arguments

- data:

  (`survey.design`)\
  a survey design object often created with the {survey} package

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to compare by.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent tests will be computed for
  each variable.

- statistic:

  (`character`)\
  statistic used to estimate Chisq p-value. Default is the Rao-Scott
  second-order correction ("F"). See
  [`survey::svychisq`](https://rdrr.io/pkg/survey/man/svychisq.html) for
  available statistics options.

- ...:

  arguments passed to
  [`survey::svychisq()`](https://rdrr.io/pkg/survey/man/svychisq.html).

## Value

ARD data frame

## Examples

``` r
data(api, package = "survey")
dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)

ard_survey_svychisq(dclus1, variables = sch.wide, by = comp.imp, statistic = "F")
#> {cards} data frame: 5 x 9
#>     group1 variable   context stat_name stat_label      stat
#> 1 comp.imp sch.wide survey_s…       ndf  Nominato…         1
#> 2 comp.imp sch.wide survey_s…       ddf  Denomina…        14
#> 3 comp.imp sch.wide survey_s… statistic  Statistic   236.895
#> 4 comp.imp sch.wide survey_s…   p.value    p-value         0
#> 5 comp.imp sch.wide survey_s…    method     method Pearson'…
#> ℹ 3 more variables: fmt_fun, warning, error
```
