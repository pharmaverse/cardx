# ARD t-test

Analysis results data for paired and non-paired t-tests.

## Usage

``` r
ard_stats_t_test(data, variables, by = NULL, conf.level = 0.95, ...)

ard_stats_paired_t_test(data, by, variables, id, conf.level = 0.95, ...)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent t-tests will be computed for
  each variable.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  optional column name to compare by.

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to [`t.test()`](https://rdrr.io/r/stats/t.test.html)

- id:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name of the subject or participant ID

## Value

ARD data frame

## Details

For the `ard_stats_t_test()` function, the data is expected to be one
row per subject. The data is passed as
`t.test(data[[variable]] ~ data[[by]], paired = FALSE, ...)`.

For the `ard_stats_paired_t_test()` function, the data is expected to be
one row per subject per by level. Before the t-test is calculated, the
data are reshaped to a wide format to be one row per subject. The data
are then passed as
`t.test(x = data_wide[[<by level 1>]], y = data_wide[[<by level 2>]], paired = TRUE, ...)`.

## Examples

``` r
cards::ADSL |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  ard_stats_t_test(by = ARM, variables = c(AGE, BMIBL))
#> # An ARD data frame: 28 × 9
#>    group1 variable context  stat_name stat_label stat                    fmt_fun
#>    <chr>  <chr>    <chr>    <chr>     <chr>      <named list>            <named>
#>  1 ARM    AGE      stats_t… estimate  Mean Diff… 0.8283499               1      
#>  2 ARM    AGE      stats_t… estimate1 Group 1 M… 75.2093                 1      
#>  3 ARM    AGE      stats_t… estimate2 Group 2 M… 74.38095                1      
#>  4 ARM    AGE      stats_t… statistic t Statist… 0.6551964               1      
#>  5 ARM    AGE      stats_t… p.value   p-value    0.5132409               1      
#>  6 ARM    AGE      stats_t… parameter Degrees o… 167.3625                1      
#>  7 ARM    AGE      stats_t… conf.low  CI Lower … -1.667637               1      
#>  8 ARM    AGE      stats_t… conf.high CI Upper … 3.324337                1      
#>  9 ARM    AGE      stats_t… method    method     Welch Two Sample t-test <NULL> 
#> 10 ARM    AGE      stats_t… alternat… alternati… two.sided               <NULL> 
#> # ℹ 18 more rows
#> # ℹ 2 more variables: warning <named list>, error <named list>

# constructing a paired data set,
# where patients receive both treatments
cards::ADSL[c("ARM", "AGE")] |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  dplyr::mutate(.by = ARM, USUBJID = dplyr::row_number()) |>
  dplyr::arrange(USUBJID, ARM) |>
  ard_stats_paired_t_test(by = ARM, variables = AGE, id = USUBJID)
#> # An ARD data frame: 12 × 9
#>    group1 variable context      stat_name   stat_label     stat          fmt_fun
#>    <chr>  <chr>    <chr>        <chr>       <chr>          <named list>  <named>
#>  1 ARM    AGE      stats_t_test estimate    Mean Differen… 0.797619      1      
#>  2 ARM    AGE      stats_t_test statistic   t Statistic    0.628482      1      
#>  3 ARM    AGE      stats_t_test p.value     p-value        0.5314139     1      
#>  4 ARM    AGE      stats_t_test parameter   Degrees of Fr… 83            1      
#>  5 ARM    AGE      stats_t_test conf.low    CI Lower Bound -1.726609     1      
#>  6 ARM    AGE      stats_t_test conf.high   CI Upper Bound 3.321848      1      
#>  7 ARM    AGE      stats_t_test method      method         Paired t-test <NULL> 
#>  8 ARM    AGE      stats_t_test alternative alternative    two.sided     <NULL> 
#>  9 ARM    AGE      stats_t_test mu          H0 Mean        0             1      
#> 10 ARM    AGE      stats_t_test paired      Paired t-test  TRUE          <NULL> 
#> 11 ARM    AGE      stats_t_test var.equal   Equal Varianc… FALSE         <NULL> 
#> 12 ARM    AGE      stats_t_test conf.level  CI Confidence… 0.95          1      
#> # ℹ 2 more variables: warning <named list>, error <named list>
```
