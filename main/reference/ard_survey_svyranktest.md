# ARD Survey rank test

Analysis results data for survey wilcox test using
[`survey::svyranktest()`](https://rdrr.io/pkg/survey/man/svyranktest.html).

## Usage

``` r
ard_survey_svyranktest(data, by, variables, test, ...)
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

- test:

  (`string`)\
  a string to denote which rank test to use: `"wilcoxon"`,
  `"vanderWaerden"`, `"median"`, `"KruskalWallis"`

- ...:

  arguments passed to
  [`survey::svyranktest()`](https://rdrr.io/pkg/survey/man/svyranktest.html)

## Value

ARD data frame

## Examples

``` r
data(api, package = "survey")
dclus2 <- survey::svydesign(id = ~ dnum + snum, fpc = ~ fpc1 + fpc2, data = apiclus2)

ard_survey_svyranktest(dclus2, variables = enroll, by = comp.imp, test = "wilcoxon")
#> {cards} data frame: 6 x 9
#>     group1 variable   context   stat_name stat_label      stat
#> 1 comp.imp   enroll survey_s…    estimate  Median o…    -0.106
#> 2 comp.imp   enroll survey_s…   statistic  Statistic    -1.719
#> 3 comp.imp   enroll survey_s…     p.value    p-value     0.094
#> 4 comp.imp   enroll survey_s…   parameter  Degrees …        36
#> 5 comp.imp   enroll survey_s…      method     method Design-b…
#> 6 comp.imp   enroll survey_s… alternative  Alternat… two.sided
#> ℹ 3 more variables: fmt_fun, warning, error
ard_survey_svyranktest(dclus2, variables = enroll, by = comp.imp, test = "vanderWaerden")
#> {cards} data frame: 6 x 9
#>     group1 variable   context   stat_name stat_label      stat
#> 1 comp.imp   enroll survey_s…    estimate  Median o…    -0.379
#> 2 comp.imp   enroll survey_s…   statistic  Statistic    -1.584
#> 3 comp.imp   enroll survey_s…     p.value    p-value     0.122
#> 4 comp.imp   enroll survey_s…   parameter  Degrees …        36
#> 5 comp.imp   enroll survey_s…      method     method Design-b…
#> 6 comp.imp   enroll survey_s… alternative  Alternat… two.sided
#> ℹ 3 more variables: fmt_fun, warning, error
ard_survey_svyranktest(dclus2, variables = enroll, by = comp.imp, test = "median")
#> {cards} data frame: 6 x 9
#>     group1 variable   context   stat_name stat_label      stat
#> 1 comp.imp   enroll survey_s…    estimate  Median o…    -0.124
#> 2 comp.imp   enroll survey_s…   statistic  Statistic    -0.914
#> 3 comp.imp   enroll survey_s…     p.value    p-value     0.367
#> 4 comp.imp   enroll survey_s…   parameter  Degrees …        36
#> 5 comp.imp   enroll survey_s…      method     method Design-b…
#> 6 comp.imp   enroll survey_s… alternative  Alternat… two.sided
#> ℹ 3 more variables: fmt_fun, warning, error
ard_survey_svyranktest(dclus2, variables = enroll, by = comp.imp, test = "KruskalWallis")
#> {cards} data frame: 6 x 9
#>     group1 variable   context   stat_name stat_label      stat
#> 1 comp.imp   enroll survey_s…    estimate  Median o…    -0.106
#> 2 comp.imp   enroll survey_s…   statistic  Statistic    -1.719
#> 3 comp.imp   enroll survey_s…     p.value    p-value     0.094
#> 4 comp.imp   enroll survey_s…   parameter  Degrees …        36
#> 5 comp.imp   enroll survey_s…      method     method Design-b…
#> 6 comp.imp   enroll survey_s… alternative  Alternat… two.sided
#> ℹ 3 more variables: fmt_fun, warning, error
```
