# Helper Function for the Estimation of Stratified Quantiles

This function wraps the estimation of stratified percentiles when we
assume the approximation for large numbers. This is necessary only in
the case proportions for each strata are unequal.

## Usage

``` r
.strata_normal_quantile(vars, weights, conf.level)
```

## Arguments

- weights:

  (`numeric`)\
  weights for each level of the strata. If `NULL`, they are estimated
  using the iterative algorithm that minimizes the weighted squared
  length of the confidence interval.

- conf.level:

  (scalar `numeric`)\
  a scalar in `(0,1)` indicating the confidence level. Default is `0.95`

## Value

Stratified quantile.

## See also

[`proportion_ci_strat_wilson()`](https://pharmaverse.github.io/cardx/reference/proportion_ci.md)

## Examples

``` r
strata_data <- table(data.frame(
  "f1" = sample(c(TRUE, FALSE), 100, TRUE),
  "f2" = sample(c("x", "y", "z"), 100, TRUE),
  stringsAsFactors = TRUE
))
ns <- colSums(strata_data)
ests <- strata_data["TRUE", ] / ns
vars <- ests * (1 - ests) / ns
weights <- rep(1 / length(ns), length(ns))

cardx:::.strata_normal_quantile(vars, weights, 0.95)
#> [1] 1.134977
```
