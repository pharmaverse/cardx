# ARD Dichotomous Survey Statistics

Compute Analysis Results Data (ARD) for dichotomous summary statistics.

## Usage

``` r
# S3 method for class 'survey.design'
ard_tabulate_value(
  data,
  variables,
  by = NULL,
  value = cards::maximum_variable_value(data$variables[variables]),
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

- value:

  (named `list`)\
  named list of dichotomous values to tabulate. Default is
  `cards::maximum_variable_value(data$variables)`, which returns the
  largest/last value after a sort.

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
survey::svydesign(ids = ~1, data = mtcars, weights = ~1) |>
  ard_tabulate_value(by = vs, variables = c(cyl, am), value = list(cyl = 4))
#> {cards} data frame: 28 x 11
#>    group1 group1_level variable variable_level    stat_name stat_label  stat
#> 1      vs            0      cyl              4            n          n     1
#> 2      vs            0      cyl              4            N          N    18
#> 3      vs            0      cyl              4            p          % 0.056
#> 4      vs            0      cyl              4  p.std.error      SE(%) 0.055
#> 5      vs            0       am              1            n          n     6
#> 6      vs            0       am              1            N          N    18
#> 7      vs            0       am              1            p          % 0.333
#> 8      vs            0       am              1  p.std.error      SE(%) 0.113
#> 9      vs            0      cyl              4 n_unweighted  Unweight…     1
#> 10     vs            0      cyl              4 N_unweighted  Unweight…    18
#> ℹ 18 more rows
#> ℹ Use `print(n = ...)` to see more rows
#> ℹ 4 more variables: context, fmt_fun, warning, error
```
