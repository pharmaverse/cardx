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
#> # An ARD data frame: 9 × 9
#>   group1   variable context     stat_name stat_label stat                fmt_fun
#>   <chr>    <chr>    <chr>       <chr>     <chr>      <named list>        <named>
#> 1 comp.imp enroll   survey_svy… estimate  Mean       -225.7371           1      
#> 2 comp.imp enroll   survey_svy… statistic t Statist… -2.888237           1      
#> 3 comp.imp enroll   survey_svy… p.value   p-value    0.006518228         1      
#> 4 comp.imp enroll   survey_svy… parameter Degrees o… 36                  1      
#> 5 comp.imp enroll   survey_svy… method    method     Design-based t-test <NULL> 
#> 6 comp.imp enroll   survey_svy… alternat… alternati… two.sided           <NULL> 
#> 7 comp.imp enroll   survey_svy… conf.low  CI Lower … -357.69             1      
#> 8 comp.imp enroll   survey_svy… conf.high CI Upper … -93.78413           1      
#> 9 comp.imp enroll   survey_svy… conf.lev… CI Confid… 0.9                 1      
#> # ℹ 2 more variables: warning <named list>, error <named list>
```
