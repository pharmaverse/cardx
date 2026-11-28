# ARD Wilcoxon Rank-Sum Test

Analysis results data for paired and non-paired Wilcoxon Rank-Sum tests.

## Usage

``` r
ard_stats_wilcox_test(data, variables, by = NULL, conf.level = 0.95, ...)

ard_stats_paired_wilcox_test(data, by, variables, id, conf.level = 0.95, ...)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent tests will be computed for
  each variable.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  optional column name to compare by.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to `wilcox.test(...)`

- id:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name of the subject or participant ID.

## Value

ARD data frame

## Details

For the `ard_stats_wilcox_test()` function, the data is expected to be
one row per subject. The data is passed as
`wilcox.test(data[[variable]] ~ data[[by]], paired = FALSE, ...)`.

For the `ard_stats_paired_wilcox_test()` function, the data is expected
to be one row per subject per by level. Before the test is calculated,
the data are reshaped to a wide format to be one row per subject. The
data are then passed as
`wilcox.test(x = data_wide[[<by level 1>]], y = data_wide[[<by level 2>]], paired = TRUE, ...)`.

## Examples

``` r
cards::ADSL |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  ard_stats_wilcox_test(by = "ARM", variables = "AGE")
#> # An ARD data frame: 12 × 9
#>    group1 variable stat_name   stat                                             
#>    <chr>  <chr>    <chr>       <named list>                                     
#>  1 ARM    AGE      statistic   3862.5                                           
#>  2 ARM    AGE      p.value     0.4354637                                        
#>  3 ARM    AGE      method      Wilcoxon rank sum test with continuity correction
#>  4 ARM    AGE      alternative two.sided                                        
#>  5 ARM    AGE      mu          0                                                
#>  6 ARM    AGE      paired      FALSE                                            
#>  7 ARM    AGE      exact       <NULL>                                           
#>  8 ARM    AGE      correct     TRUE                                             
#>  9 ARM    AGE      conf.int    FALSE                                            
#> 10 ARM    AGE      conf.level  0.95                                             
#> 11 ARM    AGE      tol.root    1e-04                                            
#> 12 ARM    AGE      digits.rank Inf                                              
#> # ℹ 5 more variables: context <chr>, stat_label <chr>, fmt_fun <named list>,
#> #   warning <named list>, error <named list>

# constructing a paired data set,
# where patients receive both treatments
cards::ADSL[c("ARM", "AGE")] |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  dplyr::mutate(.by = ARM, USUBJID = dplyr::row_number()) |>
  dplyr::arrange(USUBJID, ARM) |>
  ard_stats_paired_wilcox_test(by = ARM, variables = AGE, id = USUBJID)
#> # An ARD data frame: 12 × 9
#>    group1 variable stat_name  
#>    <chr>  <chr>    <chr>      
#>  1 ARM    AGE      statistic  
#>  2 ARM    AGE      p.value    
#>  3 ARM    AGE      method     
#>  4 ARM    AGE      alternative
#>  5 ARM    AGE      mu         
#>  6 ARM    AGE      paired     
#>  7 ARM    AGE      exact      
#>  8 ARM    AGE      correct    
#>  9 ARM    AGE      conf.int   
#> 10 ARM    AGE      conf.level 
#> 11 ARM    AGE      tol.root   
#> 12 ARM    AGE      digits.rank
#> # ℹ 6 more variables: context <chr>, stat_label <chr>, stat <named list>,
#> #   fmt_fun <named list>, warning <named list>, error <named list>
```
