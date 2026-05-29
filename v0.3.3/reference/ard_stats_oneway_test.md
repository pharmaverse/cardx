# ARD One-way Test

Analysis results data for Testing Equal Means in a One-Way Layout.
calculated with
[`oneway.test()`](https://rdrr.io/r/stats/oneway.test.html)

## Usage

``` r
ard_stats_oneway_test(formula, data, ...)
```

## Arguments

- formula:

  a formula of the form `lhs ~ rhs` where `lhs` gives the sample values
  and `rhs` the corresponding groups.

- data:

  an optional matrix or data frame (or similar: see
  [`model.frame`](https://rdrr.io/r/stats/model.frame.html)) containing
  the variables in the formula `formula`. By default the variables are
  taken from `environment(formula)`.

- ...:

  additional arguments passed to `oneway.test(...)`

## Value

ARD data frame

## Examples

``` r
ard_stats_oneway_test(AGE ~ ARM, data = cards::ADSL)
#> {cards} data frame: 6 x 9
#>   group1 variable   context stat_name stat_label      stat
#> 1    ARM      AGE stats_on…    num.df  Degrees …         2
#> 2    ARM      AGE stats_on…    den.df  Denomina…   167.237
#> 3    ARM      AGE stats_on… statistic  F Statis…     0.547
#> 4    ARM      AGE stats_on…   p.value    p-value      0.58
#> 5    ARM      AGE stats_on…    method     Method One-way …
#> 6    ARM      AGE stats_on… var.equal  var.equal     FALSE
#> ℹ 3 more variables: fmt_fun, warning, error
```
