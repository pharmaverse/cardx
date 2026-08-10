# ARD Standardized Mean Difference

Standardized mean difference calculated via
[`smd::smd()`](https://bsaul.github.io/smd/reference/smd.html) with
`na.rm = TRUE`. Additionally, this function add a confidence interval to
the SMD when `std.error=TRUE`, which the original
[`smd::smd()`](https://bsaul.github.io/smd/reference/smd.html) does not
include.

## Usage

``` r
ard_smd_smd(data, by, variables, std.error = TRUE, conf.level = 0.95, ...)
```

## Arguments

- data:

  (`data.frame`/`survey.design`)\
  a data frame or object of class 'survey.design' (typically created
  with
  [`survey::svydesign()`](https://rdrr.io/pkg/survey/man/svydesign.html)).

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to compare by.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent tests will be computed for
  each variable.

- std.error:

  (scalar `logical`)\
  Logical indicator for computing standard errors using
  [`smd::compute_smd_var()`](https://bsaul.github.io/smd/reference/compute_smd_var.html).
  Default is `TRUE`.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to
  [`smd::smd()`](https://bsaul.github.io/smd/reference/smd.html)

## Value

ARD data frame

## Examples

``` r
ard_smd_smd(cards::ADSL, by = SEX, variables = AGE)
#> # An ARD data frame: 6 × 9
#>   group1 variable context stat_name stat_label      stat                        
#>   <chr>  <chr>    <chr>   <chr>     <chr>           <named list>                
#> 1 SEX    AGE      smd_smd estimate  Standardized M… 0.1571071                   
#> 2 SEX    AGE      smd_smd std.error Standard Error  0.126691                    
#> 3 SEX    AGE      smd_smd conf.low  conf.low        -0.09120262                 
#> 4 SEX    AGE      smd_smd conf.high conf.high       0.4054169                   
#> 5 SEX    AGE      smd_smd method    method          Standardized Mean Difference
#> 6 SEX    AGE      smd_smd gref      Integer Refere… 1                           
#> # ℹ 3 more variables: fmt_fun <named list>, warning <named list>,
#> #   error <named list>
ard_smd_smd(cards::ADSL, by = SEX, variables = AGEGR1)
#> # An ARD data frame: 6 × 9
#>   group1 variable context stat_name stat_label      stat                        
#>   <chr>  <chr>    <chr>   <chr>     <chr>           <named list>                
#> 1 SEX    AGEGR1   smd_smd estimate  Standardized M… 0.1029458                   
#> 2 SEX    AGEGR1   smd_smd std.error Standard Error  0.1265815                   
#> 3 SEX    AGEGR1   smd_smd conf.low  conf.low        -0.1451494                  
#> 4 SEX    AGEGR1   smd_smd conf.high conf.high       0.351041                    
#> 5 SEX    AGEGR1   smd_smd method    method          Standardized Mean Difference
#> 6 SEX    AGEGR1   smd_smd gref      Integer Refere… 1                           
#> # ℹ 3 more variables: fmt_fun <named list>, warning <named list>,
#> #   error <named list>
```
