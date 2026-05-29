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
#> {cards} data frame: 5 x 8
#>   variable   context stat_name stat_label   stat fmt_fun
#> 1      ARM stats_aov     sumsq  Sum of S… 71.386       1
#> 2      ARM stats_aov        df  Degrees …      2       1
#> 3      ARM stats_aov    meansq  Mean of … 35.693       1
#> 4      ARM stats_aov statistic  Statistic  0.523       1
#> 5      ARM stats_aov   p.value    p-value  0.593       1
#> ℹ 2 more variables: warning, error
```
