# Helper Function for the Estimation of Weights for `proportion_ci_strat_wilson()`

This function wraps the iteration procedure that allows you to estimate
the weights for each proportional strata. This assumes to minimize the
weighted squared length of the confidence interval.

## Usage

``` r
.update_weights_strat_wilson(
  vars,
  strata_qnorm,
  initial_weights,
  n_per_strata,
  max.iterations = 50,
  conf.level = 0.95,
  tol = 0.001
)
```

## Arguments

- vars:

  (`numeric`)\
  normalized proportions for each strata.

- strata_qnorm:

  (`numeric`)\
  initial estimation with identical weights of the quantiles.

- initial_weights:

  (`numeric`)\
  initial weights used to calculate `strata_qnorm`. This can be
  optimized in the future if we need to estimate better initial weights.

- n_per_strata:

  (`numeric`)\
  number of elements in each strata.

- max.iterations:

  (`count`)\
  maximum number of iterations to be tried. Convergence is always
  checked.

- conf.level:

  (scalar `numeric`)\
  a scalar in `(0,1)` indicating the confidence level. Default is `0.95`

- tol:

  (`number`)\
  tolerance threshold for convergence.

## Value

A `list` of 3 elements: `n_it`, `weights`, and `diff_v`.

## See also

For references and details see
[`proportion_ci_strat_wilson()`](https://insightsengineering.github.io/cardx/reference/proportion_ci.md).

## Examples

``` r
vs <- c(0.011, 0.013, 0.012, 0.014, 0.017, 0.018)
sq <- 0.674
ws <- rep(1 / length(vs), length(vs))
ns <- c(22, 18, 17, 17, 14, 12)

cardx:::.update_weights_strat_wilson(vs, sq, ws, ns, 100, 0.95, 0.001)
#> $n_it
#> [1] 3
#> 
#> $weights
#> [1] 0.2067191 0.1757727 0.1896962 0.1636346 0.1357615 0.1284160
#> 
#> $diff_v
#> [1] 1.458717e-01 1.497223e-03 1.442189e-06
#> 
```
