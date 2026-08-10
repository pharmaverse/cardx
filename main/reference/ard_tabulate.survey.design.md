# ARD Categorical Survey Statistics

Compute tabulations on survey-weighted data.

The counts and proportion (`"N"`, `"n"`, `"p"`) are calculated using
[`survey::svytable()`](https://rdrr.io/pkg/survey/man/svychisq.html),
and the standard errors and design effect (`"p.std.error"`, `"deff"`)
are calculated using
[`survey::svymean()`](https://rdrr.io/pkg/survey/man/surveysummary.html).

The design effect (`"deff"`) is calculated only when requested in the
`statistic` argument.

The unweighted statistics are calculated with
[`cards::ard_tabulate.data.frame()`](https://insightsengineering.github.io/cards/latest-tag/reference/ard_tabulate.html).

## Usage

``` r
# S3 method for class 'survey.design'
ard_tabulate(
  data,
  variables,
  by = NULL,
  statistic = everything() ~ c("n", "N", "p", "p.std.error", "n_unweighted",
    "N_unweighted", "p_unweighted"),
  denominator = c("column", "row", "cell"),
  fmt_fun = NULL,
  stat_label = everything() ~ list(p = "%", p.std.error = "SE(%)", deff =
    "Design Effect", n_unweighted = "Unweighted n", N_unweighted = "Unweighted N",
    p_unweighted = "Unweighted %"),
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

- denominator:

  (`string`)\
  a string indicating the type proportions to calculate. Must be one of
  `"column"` (the default), `"row"`, and `"cell"`.

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

ard_tabulate(svy_titanic, variables = c(Class, Age), by = Survived)
#> # An ARD data frame: 84 × 11
#>    group1   group1_level variable variable_level context     stat_name      stat
#>    <chr>    <list>       <chr>    <list>         <chr>       <chr>        <list>
#>  1 Survived No           Class    1st            categorical n           1.22e+2
#>  2 Survived No           Class    1st            categorical N           1.49e+3
#>  3 Survived No           Class    1st            categorical p           8.19e-2
#>  4 Survived No           Class    1st            categorical p.std.error 8.62e-2
#>  5 Survived No           Class    2nd            categorical n           1.67e+2
#>  6 Survived No           Class    2nd            categorical N           1.49e+3
#>  7 Survived No           Class    2nd            categorical p           1.12e-1
#>  8 Survived No           Class    2nd            categorical p.std.error 1.11e-1
#>  9 Survived No           Class    3rd            categorical n           5.28e+2
#> 10 Survived No           Class    3rd            categorical N           1.49e+3
#> # ℹ 74 more rows
#> # ℹ 4 more variables: stat_label <chr>, fmt_fun <list>, warning <list>,
#> #   error <list>
```
