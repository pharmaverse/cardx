# ARD Missing Survey Statistics

Compute Analysis Results Data (ARD) for statistics related to data
missingness for survey objects

## Usage

``` r
# S3 method for class 'survey.design'
ard_missing(
  data,
  variables,
  by = NULL,
  statistic = everything() ~ c("N_obs", "N_miss", "N_nonmiss", "p_miss", "p_nonmiss",
    "N_obs_unweighted", "N_miss_unweighted", "N_nonmiss_unweighted", "p_miss_unweighted",
    "p_nonmiss_unweighted"),
  fmt_fun = NULL,
  stat_label = everything() ~ list(N_obs = "Total N", N_miss = "N Missing", N_nonmiss =
    "N not Missing", p_miss = "% Missing", p_nonmiss = "% not Missing",
    N_obs_unweighted = "Total N (unweighted)", N_miss_unweighted =
    "N Missing (unweighted)", N_nonmiss_unweighted = "N not Missing (unweighted)",
    p_miss_unweighted = "% Missing (unweighted)", p_nonmiss_unweighted =
    "% not Missing (unweighted)"),
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
  results are calculated for **all combinations** of the column
  specified and the variables. A single column may be specified.

- statistic:

  ([`formula-list-selector`](https://insightsengineering.github.io/cards/latest-tag/reference/syntax.html))\
  a named list, a list of formulas, or a single formula where the list
  element is a character vector of statistic names to include. See
  default value for options.

- fmt_fun:

  ([`formula-list-selector`](https://insightsengineering.github.io/cards/latest-tag/reference/syntax.html))\
  a named list, a list of formulas, or a single formula where the list
  element is a named list of functions (or the RHS of a formula), e.g.
  `list(mpg = list(mean = \(x) round(x, digits = 2) |> as.character()))`.

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

## Examples

``` r
svy_titanic <- survey::svydesign(~1, data = as.data.frame(Titanic), weights = ~Freq)

ard_missing(svy_titanic, variables = c(Class, Age), by = Survived)
#> # An ARD data frame: 40 × 10
#>    group1   group1_level variable context stat_name stat_label      stat fmt_fun
#>    <chr>    <list>       <chr>    <chr>   <chr>     <chr>         <list> <list> 
#>  1 Survived No           Class    missing N_nonmiss N not Missing   1490 <fn>   
#>  2 Survived No           Class    missing N_obs     Total N         1490 <fn>   
#>  3 Survived No           Class    missing p_nonmiss % not Missing      1 <fn>   
#>  4 Survived No           Class    missing N_miss    N Missing          0 <fn>   
#>  5 Survived No           Class    missing p_miss    % Missing          0 <fn>   
#>  6 Survived No           Age      missing N_nonmiss N not Missing   1490 <fn>   
#>  7 Survived No           Age      missing N_obs     Total N         1490 <fn>   
#>  8 Survived No           Age      missing p_nonmiss % not Missing      1 <fn>   
#>  9 Survived No           Age      missing N_miss    N Missing          0 <fn>   
#> 10 Survived No           Age      missing p_miss    % Missing          0 <fn>   
#> # ℹ 30 more rows
#> # ℹ 2 more variables: warning <list>, error <list>
```
