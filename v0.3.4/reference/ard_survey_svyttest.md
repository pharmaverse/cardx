# ARD Survey t-test

Analysis results data for survey t-test using
[`survey::svyttest()`](https://rdrr.io/pkg/survey/man/svyttest.html).

## Usage

``` r
ard_survey_svyttest(data, by, variables, conf.level = 0.95, ...)
```

## Arguments

- data:

  (`survey.design`)\
  a survey design object often created with
  [`survey::svydesign()`](https://rdrr.io/pkg/survey/man/svydesign.html)

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to compare by

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent tests will be run for each
  variable.

- conf.level:

  (`double`)\
  confidence level of the returned confidence interval. Must be between
  `c(0, 1)`. Default is `0.95`

- ...:

  arguments passed to
  [`survey::svyttest()`](https://rdrr.io/pkg/survey/man/svyttest.html)

## Value

ARD data frame

## Examples

``` r
data(api, package = "survey")
dclus2 <- survey::svydesign(id = ~ dnum + snum, fpc = ~ fpc1 + fpc2, data = apiclus2)

ard_survey_svyttest(dclus2, variables = enroll, by = comp.imp, conf.level = 0.9)
#> {cards} data frame: 9 x 9
#>     group1 variable   context   stat_name stat_label      stat
#> 1 comp.imp   enroll survey_s…    estimate       Mean  -225.737
#> 2 comp.imp   enroll survey_s…   statistic  t Statis…    -2.888
#> 3 comp.imp   enroll survey_s…     p.value    p-value     0.007
#> 4 comp.imp   enroll survey_s…   parameter  Degrees …        36
#> 5 comp.imp   enroll survey_s…      method     method Design-b…
#> 6 comp.imp   enroll survey_s… alternative  alternat… two.sided
#> 7 comp.imp   enroll survey_s…    conf.low  CI Lower…   -357.69
#> 8 comp.imp   enroll survey_s…   conf.high  CI Upper…   -93.784
#> 9 comp.imp   enroll survey_s…  conf.level  CI Confi…       0.9
#> ℹ 3 more variables: fmt_fun, warning, error
```
