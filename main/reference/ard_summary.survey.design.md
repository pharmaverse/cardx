# ARD Continuous Survey Statistics

Returns an ARD of weighted statistics using the `{survey}` package.

## Usage

``` r
# S3 method for class 'survey.design'
ard_summary(
  data,
  variables,
  by = NULL,
  statistic = everything() ~ c("median", "p25", "p75"),
  fmt_fun = NULL,
  stat_label = NULL,
  fmt_fn = deprecated(),
  ...
)
```

## Arguments

- data:

  (`survey.design`)\
  a design object often created with
  [`survey::svydesign()`](https://rdrr.io/pkg/survey/man/svydesign.html).

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  columns to include in summaries.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  results are calculated for **all combinations** of the columns
  specified, including unobserved combinations and unobserved factor
  levels.

- statistic:

  ([`formula-list-selector`](https://insightsengineering.github.io/cards/latest-tag/reference/syntax.html))\
  a named list, a list of formulas, or a single formula where the list
  element is a character vector of statistic names to include. See below
  for options.

- fmt_fun:

  ([`formula-list-selector`](https://insightsengineering.github.io/cards/latest-tag/reference/syntax.html))\
  a named list, a list of formulas, or a single formula where the list
  element is a named list of functions (or the RHS of a formula), e.g.
  `list(mpg = list(mean = \(x) round(x, digits = 2) |> as.character))`.

- stat_label:

  ([`formula-list-selector`](https://insightsengineering.github.io/cards/latest-tag/reference/syntax.html))\
  a named list, a list of formulas, or a single formula where the list
  element is either a named list or a list of formulas defining the
  statistic labels, e.g. `everything() ~ list(mean = "Mean", sd = "SD")`
  or `everything() ~ list(mean ~ "Mean", sd ~ "SD")`.

- fmt_fn:

  **\[deprecated\]**

- ...:

  These dots are for future extensions and must be empty.

## Value

an ARD data frame of class 'card'

## statistic argument

The following statistics are available: 'mean', 'median', 'min', 'max',
'sum', 'var', 'sd', 'mean.std.error', 'deff', 'p##', where 'p##' is are
the percentiles and `##` is an integer between 0 and 100.

The design effect (`"deff"`) is calculated only when requested in the
`statistic` argument.

## Examples

``` r
data(api, package = "survey")
dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)

ard_summary(
  data = dclus1,
  variables = api00,
  by = stype
)
#> # An ARD data frame: 9 × 10
#>   group1 group1_level variable context    stat_name stat_label      stat fmt_fun
#>   <chr>  <list>       <chr>    <chr>      <chr>     <chr>          <lis>  <list>
#> 1 stype  E            api00    continuous median    Median           652       1
#> 2 stype  H            api00    continuous median    Median           608       1
#> 3 stype  M            api00    continuous median    Median           642       1
#> 4 stype  E            api00    continuous p25       25% Percentile   553       1
#> 5 stype  H            api00    continuous p25       25% Percentile   529       1
#> 6 stype  M            api00    continuous p25       25% Percentile   547       1
#> 7 stype  E            api00    continuous p75       75% Percentile   729       1
#> 8 stype  H            api00    continuous p75       75% Percentile   703       1
#> 9 stype  M            api00    continuous p75       75% Percentile   699       1
#> # ℹ 2 more variables: warning <list>, error <list>
```
