
# cardx <a href="https://pharmaverse.github.io/cardx/"><img src="man/figures/logo.png" align="right" height="120" alt="cardx website" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/pharmaverse/cardx/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pharmaverse/cardx/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/insightsengineering/cardx/branch/main/graph/badge.svg)](https://app.codecov.io/gh/pharmaverse/cardx?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/cardx)](https://CRAN.R-project.org/package=cardx)
[![Downloads](https://cranlogs.r-pkg.org/badges/cardx)](https://cran.r-project.org/package=cardx)
<!-- badges: end -->

The **{cardx}** package is an extension of the {cards} package,
providing additional functions to create Analysis Results Data Objects
(ARDs) using the **R** programming language. The {cardx} package exports
ARD functions that uses utility functions from {cards} and statistical
functions from additional packages (such as, {stats}, {mmrm}, {emmeans},
{car}, {survey}, etc.) to construct summary objects.

Summary objects can be used to:

- **Generate Tables and visualizations for Regulatory Submission**
  easily in **R**. Perfect for presenting descriptive statistics,
  statistical analyses, regressions, etc. and more.

- **Conduct Quality Control checks on existing Tables** in R. Storing
  both the results and test parameters supports the re-use and
  verification of data analyses.

## Installation

Install cards from CRAN with:

``` r
install.packages("cardx")
```

You can install the development version of cards from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("pharmaverse/cardx")
```

## Examples

### Example ARD Creation

Example t-test:

``` r
library(cardx)

cards::ADSL |>
  # keep two treatment arms for the t-test calculation
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  cardx::ard_stats_t_test(by = ARM, variable = AGE)
```

    ## # An ARD data frame: 14 × 9
    ##    group1 variable context  stat_name stat_label stat                    fmt_fun
    ##    <chr>  <chr>    <chr>    <chr>     <chr>      <named list>            <named>
    ##  1 ARM    AGE      stats_t… estimate  Mean Diff… 0.8283499               1      
    ##  2 ARM    AGE      stats_t… estimate1 Group 1 M… 75.2093                 1      
    ##  3 ARM    AGE      stats_t… estimate2 Group 2 M… 74.38095                1      
    ##  4 ARM    AGE      stats_t… statistic t Statist… 0.6551964               1      
    ##  5 ARM    AGE      stats_t… p.value   p-value    0.5132409               1      
    ##  6 ARM    AGE      stats_t… parameter Degrees o… 167.3625                1      
    ##  7 ARM    AGE      stats_t… conf.low  CI Lower … -1.667637               1      
    ##  8 ARM    AGE      stats_t… conf.high CI Upper … 3.324337                1      
    ##  9 ARM    AGE      stats_t… method    method     Welch Two Sample t-test <NULL> 
    ## 10 ARM    AGE      stats_t… alternat… alternati… two.sided               <NULL> 
    ## 11 ARM    AGE      stats_t… mu        H0 Mean    0                       1      
    ## 12 ARM    AGE      stats_t… paired    Paired t-… FALSE                   <NULL> 
    ## 13 ARM    AGE      stats_t… var.equal Equal Var… FALSE                   <NULL> 
    ## 14 ARM    AGE      stats_t… conf.lev… CI Confid… 0.95                    1      
    ## # ℹ 2 more variables: warning <named list>, error <named list>

Note that the returned ARD contains the analysis results in addition to
the function parameters used to calculate the results allowing for
reproducible future analyses and further customization.

### Model Input

Some {cardx} functions accept regression model objects as input:

``` r
lm(AGE ~ ARM, data = cards::ADSL) |>
  ard_aod_wald_test()
```

Note that the [Analysis Results
Standard](https://www.cdisc.org/standards/foundational/analysis-results-standard)
should begin with a data set rather than a model object. To accomplish
this we include model construction helpers.

``` r
construct_model(
  data = cards::ADSL,
  formula = reformulate2("ARM", response = "AGE"),
  method = "lm"
) |>
  ard_aod_wald_test()
```

    ## # An ARD data frame: 6 × 8
    ##   variable    context       stat_name stat_label     stat fmt_fun warning error 
    ##   <chr>       <chr>         <chr>     <chr>        <list>  <list> <named> <name>
    ## 1 (Intercept) aod_wald_test df        Degrees of… 1   e+0       1 <NULL>  <NULL>
    ## 2 (Intercept) aod_wald_test statistic Statistic   7.13e+3       1 <NULL>  <NULL>
    ## 3 (Intercept) aod_wald_test p.value   p-value     0             1 <NULL>  <NULL>
    ## 4 ARM         aod_wald_test df        Degrees of… 2   e+0       1 <NULL>  <NULL>
    ## 5 ARM         aod_wald_test statistic Statistic   1.05e+0       1 <NULL>  <NULL>
    ## 6 ARM         aod_wald_test p.value   p-value     5.93e-1       1 <NULL>  <NULL>

## Additional Resources

- The best resources are the help documents accompanying each {cardx}
  function.
- Supporting documentation for both companion packages
  [{cards}](https://pharmaverse.github.io/cards/) and
  {[gtsummary](https://www.danieldsjoberg.com/gtsummary/index.html)}
  will be useful for understanding the ARD workflow and capabilities.

## {cardx} + {renv}

The {cardx} package exports functions to create ARDs based on various
statistical methods; methods that are primarily implemented in other
packages. {cardx} does not take a hard dependency on these packages,
meaning that these packages are not typically installed when {cardx} is
installed from CRAN. As a result, {renv} will not record these packages
in its `lock.file` unless there is a direct reference to the underlying
statistical package in your code. For example, if you pass a regression
model to `ard_emmeans_contrast()`, there is no direct reference to the
{emmeans} package in your script and {renv} will not record the package.

One can circumvent this issue by including some kind of reference to the
package in your code. Below are are couple of common ways to do so.

``` r
library(emmeans)
```

Attaching a package with `library()` is great for its simplicity, but
you may not want to attach a package if it’s not necessary.

``` r
invisible(emmeans::emmeans)
```

You can invisibly print a function from the package. Printing a function
does not have an effect on your environment (which is great), but it is
somewhat more difficult to read. (*This is my preferred method.*)
