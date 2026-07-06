# Functions for Calculating Proportion Confidence Intervals

Functions to calculate different proportion confidence intervals for use
in `ard_proportion()`.

## Usage

``` r
proportion_ci_wald(x, conf.level = 0.95, correct = FALSE)

proportion_ci_wilson(x, conf.level = 0.95, correct = FALSE)

proportion_ci_clopper_pearson(x, conf.level = 0.95)

proportion_ci_agresti_coull(x, conf.level = 0.95)

proportion_ci_jeffreys(x, conf.level = 0.95)

proportion_ci_strat_wilson(
  x,
  strata,
  weights = NULL,
  conf.level = 0.95,
  max.iterations = 10L,
  correct = FALSE
)

is_binary(x)
```

## Arguments

- x:

  (binary `numeric`/`logical`)\
  vector of a binary values, i.e. a logical vector, or numeric with
  values `c(0, 1)`

- conf.level:

  (scalar `numeric`)\
  a scalar in `(0,1)` indicating the confidence level. Default is `0.95`

- correct:

  (scalar `logical`)\
  include the continuity correction. For further information, see for
  example
  [`stats::prop.test()`](https://rdrr.io/r/stats/prop.test.html).

- strata:

  (`factor`)\
  variable with one level per stratum and same length as `x`.

- weights:

  (`numeric`)\
  weights for each level of the strata. If `NULL`, they are estimated
  using the iterative algorithm that minimizes the weighted squared
  length of the confidence interval.

- max.iterations:

  (positive `integer`)\
  maximum number of iterations for the iterative procedure used to find
  estimates of optimal weights.

## Value

Confidence interval of a proportion.

## Functions

- `proportion_ci_wald()`: Calculates the Wald interval by following the
  usual textbook definition for a single proportion confidence interval
  using the normal approximation.

  \$\$\hat{p} \pm z\_{\alpha/2} \sqrt{\frac{\hat{p}(1 -
  \hat{p})}{n}}\$\$

- `proportion_ci_wilson()`: Calculates the Wilson interval by calling
  [`stats::prop.test()`](https://rdrr.io/r/stats/prop.test.html). Also
  referred to as Wilson score interval.

  \$\$\frac{\hat{p} + \frac{z^2\_{\alpha/2}}{2n} \pm z\_{\alpha/2}
  \sqrt{\frac{\hat{p}(1 - \hat{p})}{n} +
  \frac{z^2\_{\alpha/2}}{4n^2}}}{1 + \frac{z^2\_{\alpha/2}}{n}}\$\$

- `proportion_ci_clopper_pearson()`: Calculates the Clopper-Pearson
  interval by calling
  [`stats::binom.test()`](https://rdrr.io/r/stats/binom.test.html). Also
  referred to as the `exact` method.

  \$\$ \left( \frac{k}{n} \pm z\_{\alpha/2}
  \sqrt{\frac{\frac{k}{n}(1-\frac{k}{n})}{n} +
  \frac{z^2\_{\alpha/2}}{4n^2}} \right) / \left( 1 +
  \frac{z^2\_{\alpha/2}}{n} \right)\$\$

- `proportion_ci_agresti_coull()`: Calculates the `Agresti-Coull`
  interval (created by `Alan Agresti` and `Brent Coull`) by (for 95% CI)
  adding two successes and two failures to the data and then using the
  Wald formula to construct a CI.

  \$\$ \left( \frac{\tilde{p} + z^2\_{\alpha/2}/2}{n + z^2\_{\alpha/2}}
  \pm z\_{\alpha/2} \sqrt{\frac{\tilde{p}(1 - \tilde{p})}{n} +
  \frac{z^2\_{\alpha/2}}{4n^2}} \right)\$\$

- `proportion_ci_jeffreys()`: Calculates the Jeffreys interval, an
  equal-tailed interval based on the non-informative Jeffreys prior for
  a binomial proportion.

  \$\$\left( \text{Beta}\left(\frac{k}{2} + \frac{1}{2}, \frac{n -
  k}{2} + \frac{1}{2}\right)\_\alpha, \text{Beta}\left(\frac{k}{2} +
  \frac{1}{2}, \frac{n - k}{2} + \frac{1}{2}\right)\_{1-\alpha}
  \right)\$\$

- `proportion_ci_strat_wilson()`: Calculates the stratified Wilson
  confidence interval for unequal proportions as described in Xin YA, Su
  XG. Stratified Wilson and Newcombe confidence intervals for multiple
  binomial proportions. *Statistics in Biopharmaceutical Research*.
  2010;2(3).

  \$\$\frac{\hat{p}\_j + \frac{z^2\_{\alpha/2}}{2n_j} \pm z\_{\alpha/2}
  \sqrt{\frac{\hat{p}\_j(1 - \hat{p}\_j)}{n_j} +
  \frac{z^2\_{\alpha/2}}{4n_j^2}}}{1 + \frac{z^2\_{\alpha/2}}{n_j}}\$\$

- `is_binary()`: Helper to determine if vector is binary (logical or
  0/1)

## Examples

``` r
x <- c(
  TRUE, TRUE, TRUE, TRUE, TRUE,
  FALSE, FALSE, FALSE, FALSE, FALSE
)

proportion_ci_wald(x, conf.level = 0.9)
#> $N
#> [1] 10
#> 
#> $n
#> [1] 5
#> 
#> $estimate
#> [1] 0.5
#> 
#> $conf.low
#> [1] 0.2399258
#> 
#> $conf.high
#> [1] 0.7600742
#> 
#> $conf.level
#> [1] 0.9
#> 
#> $method
#> Wald Confidence Interval without continuity correction
#> 
proportion_ci_wilson(x, correct = TRUE)
#> $N
#> [1] 10
#> 
#> $n
#> [1] 5
#> 
#> $conf.level
#> [1] 0.95
#> 
#> $estimate
#>   p 
#> 0.5 
#> 
#> $statistic
#> X-squared 
#>         0 
#> 
#> $p.value
#> [1] 1
#> 
#> $parameter
#> df 
#>  1 
#> 
#> $conf.low
#> [1] 0.2365931
#> 
#> $conf.high
#> [1] 0.7634069
#> 
#> $method
#> Wilson Confidence Interval with continuity correction
#> 
#> $alternative
#> [1] "two.sided"
#> 
proportion_ci_clopper_pearson(x)
#> $N
#> [1] 10
#> 
#> $n
#> [1] 5
#> 
#> $conf.level
#> [1] 0.95
#> 
#> $estimate
#> probability of success 
#>                    0.5 
#> 
#> $statistic
#> number of successes 
#>                   5 
#> 
#> $p.value
#> [1] 1
#> 
#> $parameter
#> number of trials 
#>               10 
#> 
#> $conf.low
#> [1] 0.187086
#> 
#> $conf.high
#> [1] 0.812914
#> 
#> $method
#> [1] "Clopper-Pearson Confidence Interval"
#> 
#> $alternative
#> [1] "two.sided"
#> 
proportion_ci_agresti_coull(x)
#> $N
#> [1] 10
#> 
#> $n
#> [1] 5
#> 
#> $estimate
#> [1] 0.5
#> 
#> $conf.low
#> [1] 0.2365931
#> 
#> $conf.high
#> [1] 0.7634069
#> 
#> $conf.level
#> [1] 0.95
#> 
#> $method
#> [1] "Agresti-Coull Confidence Interval"
#> 
proportion_ci_jeffreys(x)
#> $N
#> [1] 10
#> 
#> $n
#> [1] 5
#> 
#> $estimate
#> [1] 0.5
#> 
#> $conf.low
#> [1] 0.2235287
#> 
#> $conf.high
#> [1] 0.7764713
#> 
#> $conf.level
#> [1] 0.95
#> 
#> $method
#> Jeffreys Interval
#> 
# Stratified Wilson confidence interval with unequal probabilities

set.seed(1)
rsp <- sample(c(TRUE, FALSE), 100, TRUE)
strata_data <- data.frame(
  "f1" = sample(c("a", "b"), 100, TRUE),
  "f2" = sample(c("x", "y", "z"), 100, TRUE),
  stringsAsFactors = TRUE
)
strata <- interaction(strata_data)
n_strata <- ncol(table(rsp, strata)) # Number of strata

proportion_ci_strat_wilson(
  x = rsp, strata = strata,
  conf.level = 0.90
)
#> $N
#> [1] 100
#> 
#> $n
#> [1] 49
#> 
#> $estimate
#> [1] 0.49
#> 
#> $conf.low
#> [1] 0.4072891
#> 
#> $conf.high
#> [1] 0.5647887
#> 
#> $conf.level
#> [1] 0.9
#> 
#> $weights
#>       a.x       b.x       a.y       b.y       a.z       b.z 
#> 0.2074199 0.1776464 0.1915610 0.1604678 0.1351096 0.1277952 
#> 
#> $method
#> Stratified Wilson Confidence Interval without continuity correction
#> 

# Not automatic setting of weights
proportion_ci_strat_wilson(
  x = rsp, strata = strata,
  weights = rep(1 / n_strata, n_strata),
  conf.level = 0.90
)
#> $N
#> [1] 100
#> 
#> $n
#> [1] 49
#> 
#> $estimate
#> [1] 0.49
#> 
#> $conf.low
#> [1] 0.4190436
#> 
#> $conf.high
#> [1] 0.5789733
#> 
#> $conf.level
#> [1] 0.9
#> 
#> $method
#> Stratified Wilson Confidence Interval without continuity correction
#> 
```
