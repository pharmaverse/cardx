# ARD to Calculate Categorical Occurrence Rates by Maximum Level Per Unique ID

Function calculates categorical variable level occurrences rates by
maximum level per unique ID. Each variable in `variables` is evaluated
independently and then results for all variables are stacked. Only the
highest-ordered level will be counted for each unique ID. Unordered,
non-numeric variables will be converted to factor and the default level
order used for ordering.

## Usage

``` r
ard_tabulate_max(
  data,
  variables,
  id,
  by = dplyr::group_vars(data),
  statistic = everything() ~ c("n", "p", "N"),
  denominator = NULL,
  strata = NULL,
  fmt_fun = NULL,
  stat_label = everything() ~ cards::default_stat_labels(),
  quiet = FALSE,
  fmt_fn = deprecated(),
  ...
)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  The categorical variables for which occurrence rates per unique ID (by
  maximum level) will be calculated.

- id:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  Argument used to subset `data` to identify rows in `data` to calculate
  categorical variable level occurrence rates.

- by, strata:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  columns to use for grouping or stratifying the table output. Arguments
  are similar, but with an important distinction:

  `by`: results are tabulated by **all combinations** of the columns
  specified, including unobserved combinations and unobserved factor
  levels.

  `strata`: results are tabulated by **all *observed* combinations** of
  the columns specified.

  Arguments may be used in conjunction with one another.

- statistic:

  ([`formula-list-selector`](https://insightsengineering.github.io/cards/latest-tag/reference/syntax.html))\
  a named list, a list of formulas, or a single formula where the list
  element one or more of `c("n", "N", "p", "n_cum", "p_cum")` (on the
  RHS of a formula).

- denominator:

  (`data.frame`, `integer`)\
  An optional argument to change the denominator used for `"N"` and
  `"p"` statistic calculations. Defaults to `NULL`, in which case
  `dplyr::distinct(data, dplyr::pick(all_of(c(id, by))))` is used for
  these calculations. See
  [`cards::ard_tabulate()`](https://insightsengineering.github.io/cards/latest-tag/reference/ard_tabulate.html)
  for more details on specifying denominators.

- fmt_fun:

  ([`formula-list-selector`](https://insightsengineering.github.io/cards/latest-tag/reference/syntax.html))\
  a named list, a list of formulas, or a single formula where the list
  element is a named list of functions (or the RHS of a formula), e.g.
  `list(mpg = list(mean = \(x) round(x, digits = 2) |> as.character()))`.

- stat_label:

  ([`formula-list-selector`](https://insightsengineering.github.io/cards/latest-tag/reference/syntax.html))\
  a named list, a list of formulas, or a single formula where the list
  element is either a named list or a list of formulas defining the
  statistic labels, e.g. `everything() ~ list(n = "n", p = "pct")` or
  `everything() ~ list(n ~ "n", p ~ "pct")`.

- quiet:

  (scalar `logical`)\
  Logical indicating whether to suppress additional messaging. Default
  is `FALSE`.

- fmt_fn:

  **\[deprecated\]**

- ...:

  Arguments passed to methods.

## Value

an ARD data frame of class 'card'

## Examples

``` r
# Occurrence Rates by Max Level (Highest Severity) --------------------------
ard_tabulate_max(
  cards::ADAE,
  variables = c(AESER, AESEV),
  id = USUBJID,
  by = TRTA,
  denominator = cards::ADSL
)
#> `AESER`: "N" < "Y"
#> `AESEV`: "MILD" < "MODERATE" < "SEVERE"
#> # An ARD data frame: 45 × 11
#>    group1 group1_level variable variable_level context         stat_name   stat
#>    <chr>  <list>       <chr>    <list>         <chr>           <chr>     <list>
#>  1 TRTA   Placebo      AESER    N              categorical_max n         69    
#>  2 TRTA   Placebo      AESER    N              categorical_max N         86    
#>  3 TRTA   Placebo      AESER    N              categorical_max p          0.802
#>  4 TRTA   Placebo      AESER    Y              categorical_max n          0    
#>  5 TRTA   Placebo      AESER    Y              categorical_max N         86    
#>  6 TRTA   Placebo      AESER    Y              categorical_max p          0    
#>  7 TRTA   Placebo      AESEV    MILD           categorical_max n         36    
#>  8 TRTA   Placebo      AESEV    MILD           categorical_max N         86    
#>  9 TRTA   Placebo      AESEV    MILD           categorical_max p          0.419
#> 10 TRTA   Placebo      AESEV    MODERATE       categorical_max n         26    
#> # ℹ 35 more rows
#> # ℹ 4 more variables: stat_label <chr>, fmt_fun <list>, warning <list>,
#> #   error <list>
```
