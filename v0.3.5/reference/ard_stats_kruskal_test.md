# ARD Kruskal-Wallis Test

Analysis results data for Kruskal-Wallis Rank Sum Test.

Calculated with `kruskal.test(data[[variable]], data[[by]], ...)`

## Usage

``` r
ard_stats_kruskal_test(data, by, variables)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to compare by.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent tests will be computed for
  each variable.

## Value

ARD data frame

## Examples

``` r
cards::ADSL |>
  ard_stats_kruskal_test(by = "ARM", variables = "AGE")
#> # An ARD data frame: 4 × 9
#>   group1 variable context      stat_name stat_label stat                        
#>   <chr>  <chr>    <chr>        <chr>     <chr>      <named list>                
#> 1 ARM    AGE      stats_krusk… statistic Kruskal-W… 1.63473                     
#> 2 ARM    AGE      stats_krusk… p.value   p-value    0.4415937                   
#> 3 ARM    AGE      stats_krusk… parameter Degrees o… 2                           
#> 4 ARM    AGE      stats_krusk… method    method     Kruskal-Wallis rank sum test
#> # ℹ 3 more variables: fmt_fun <named list>, warning <named list>,
#> #   error <named list>
```
