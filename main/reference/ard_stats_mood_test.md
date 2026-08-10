# ARD Mood Test

Analysis results data for Mood two sample test of scale. Note this not
to be confused with the Brown-Mood test of medians.

## Usage

``` r
ard_stats_mood_test(data, by, variables, ...)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to compare by.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to be compared. Independent tests will be run for each
  variable.

- ...:

  arguments passed to `mood.test(...)`

## Value

ARD data frame

## Details

For the `ard_stats_mood_test()` function, the data is expected to be one
row per subject. The data is passed as
`mood.test(data[[variable]] ~ data[[by]], ...)`.

## Examples

``` r
cards::ADSL |>
  ard_stats_mood_test(by = "SEX", variables = "AGE")
#> # An ARD data frame: 4 × 9
#>   group1 variable context     stat_name stat_label stat                         
#>   <chr>  <chr>    <chr>       <chr>     <chr>      <named list>                 
#> 1 SEX    AGE      stats_mood… statistic Z-Statist… 0.1292194                    
#> 2 SEX    AGE      stats_mood… p.value   p-value    0.8971841                    
#> 3 SEX    AGE      stats_mood… method    method     Mood two-sample test of scale
#> 4 SEX    AGE      stats_mood… alternat… Alternati… two.sided                    
#> # ℹ 3 more variables: fmt_fun <named list>, warning <named list>,
#> #   error <named list>
```
