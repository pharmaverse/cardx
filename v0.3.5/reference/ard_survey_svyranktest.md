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
#> # An ARD data frame: 6 × 9
#>   group1   variable context stat_name stat_label stat                           
#>   <chr>    <chr>    <chr>   <chr>     <chr>      <named list>                   
#> 1 comp.imp enroll   survey… estimate  Median of… -0.1060602                     
#> 2 comp.imp enroll   survey… statistic Statistic  -1.718689                      
#> 3 comp.imp enroll   survey… p.value   p-value    0.09426084                     
#> 4 comp.imp enroll   survey… parameter Degrees o… 36                             
#> 5 comp.imp enroll   survey… method    method     Design-based KruskalWallis test
#> 6 comp.imp enroll   survey… alternat… Alternati… two.sided                      
#> # ℹ 3 more variables: fmt_fun <named list>, warning <named list>,
#> #   error <named list>
ard_survey_svyranktest(dclus2, variables = enroll, by = comp.imp, test = "vanderWaerden")
#> # An ARD data frame: 6 × 9
#>   group1   variable context stat_name stat_label stat                           
#>   <chr>    <chr>    <chr>   <chr>     <chr>      <named list>                   
#> 1 comp.imp enroll   survey… estimate  Median of… -0.3791163                     
#> 2 comp.imp enroll   survey… statistic Statistic  -1.583859                      
#> 3 comp.imp enroll   survey… p.value   p-value    0.1219723                      
#> 4 comp.imp enroll   survey… parameter Degrees o… 36                             
#> 5 comp.imp enroll   survey… method    method     Design-based vanderWaerden test
#> 6 comp.imp enroll   survey… alternat… Alternati… two.sided                      
#> # ℹ 3 more variables: fmt_fun <named list>, warning <named list>,
#> #   error <named list>
ard_survey_svyranktest(dclus2, variables = enroll, by = comp.imp, test = "median")
#> # An ARD data frame: 6 × 9
#>   group1  variable context stat_name stat_label stat                     fmt_fun
#>   <chr>   <chr>    <chr>   <chr>     <chr>      <named list>             <named>
#> 1 comp.i… enroll   survey… estimate  Median of… -0.1240709               1      
#> 2 comp.i… enroll   survey… statistic Statistic  -0.9139828               1      
#> 3 comp.i… enroll   survey… p.value   p-value    0.3668071                1      
#> 4 comp.i… enroll   survey… parameter Degrees o… 36                       1      
#> 5 comp.i… enroll   survey… method    method     Design-based median test <NULL> 
#> 6 comp.i… enroll   survey… alternat… Alternati… two.sided                <NULL> 
#> # ℹ 2 more variables: warning <named list>, error <named list>
ard_survey_svyranktest(dclus2, variables = enroll, by = comp.imp, test = "KruskalWallis")
#> # An ARD data frame: 6 × 9
#>   group1   variable context stat_name stat_label stat                           
#>   <chr>    <chr>    <chr>   <chr>     <chr>      <named list>                   
#> 1 comp.imp enroll   survey… estimate  Median of… -0.1060602                     
#> 2 comp.imp enroll   survey… statistic Statistic  -1.718689                      
#> 3 comp.imp enroll   survey… p.value   p-value    0.09426084                     
#> 4 comp.imp enroll   survey… parameter Degrees o… 36                             
#> 5 comp.imp enroll   survey… method    method     Design-based KruskalWallis test
#> 6 comp.imp enroll   survey… alternat… Alternati… two.sided                      
#> # ℹ 3 more variables: fmt_fun <named list>, warning <named list>,
#> #   error <named list>
```
