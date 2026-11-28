# ARD ANOVA

Analysis results data for Analysis of Variance. Calculated with
[`stats::aov()`](https://rdrr.io/r/stats/aov.html)

## Usage

``` r
ard_stats_aov(formula, data, ...)
```

## Arguments

- formula:

  A formula specifying the model.

- data:

  A data frame in which the variables specified in the formula will be
  found. If missing, the variables are searched for in the standard way.

- ...:

  arguments passed to `stats::aov(...)`

## Value

ARD data frame

## Examples

``` r
ard_stats_aov(AGE ~ ARM, data = cards::ADSL)
#> # An ARD data frame: 5 × 8
#>   variable context   stat_name stat_label            stat fmt_fun warning error 
#>   <chr>    <chr>     <chr>     <chr>               <list>  <list> <named> <name>
#> 1 ARM      stats_aov sumsq     Sum of Squares      71.4         1 <NULL>  <NULL>
#> 2 ARM      stats_aov df        Degrees of Freedom   2           1 <NULL>  <NULL>
#> 3 ARM      stats_aov meansq    Mean of Sum of Squ… 35.7         1 <NULL>  <NULL>
#> 4 ARM      stats_aov statistic Statistic            0.523       1 <NULL>  <NULL>
#> 5 ARM      stats_aov p.value   p-value              0.593       1 <NULL>  <NULL>
```
