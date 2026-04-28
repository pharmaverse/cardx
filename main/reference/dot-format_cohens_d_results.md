# Convert Cohen's D Test to ARD

Convert Cohen's D Test to ARD

## Usage

``` r
.format_cohens_d_results(by, variable, lst_tidy, paired, ...)
```

## Arguments

- by:

  (`string`)\
  by column name

- variable:

  (`string`)\
  variable column name

- lst_tidy:

  (named `list`)\
  list of tidied results constructed with
  [`eval_capture_conditions()`](https://insightsengineering.github.io/cards/latest-tag/reference/eval_capture_conditions.html),
  e.g.
  `eval_capture_conditions(t.test(mtcars$mpg ~ mtcars$am) |> broom::tidy())`.

- paired:

  If `TRUE`, the values of `x` and `y` are considered as paired. This
  produces an effect size that is equivalent to the one-sample effect
  size on `x - y`. See also
  [`repeated_measures_d()`](https://easystats.github.io/effectsize/reference/repeated_measures_d.html)
  for more options.

- ...:

  passed to `cohens_d(...)`

## Value

ARD data frame

## Examples

``` r
cardx:::.format_cohens_d_results(
  by = "ARM",
  variable = "AGE",
  paired = FALSE,
  lst_tidy =
    cards::eval_capture_conditions(
      effectsize::hedges_g(data[[variable]] ~ data[[by]], paired = FALSE) |>
        parameters::standardize_names(style = "broom")
    )
)
#> {cards} data frame: 8 x 9
#>   group1 variable   stat_name stat_label      stat     error
#> 1    ARM      AGE    estimate  Effect S…           object '…
#> 2    ARM      AGE  conf.level  CI Confi…           object '…
#> 3    ARM      AGE    conf.low  CI Lower…           object '…
#> 4    ARM      AGE   conf.high  CI Upper…           object '…
#> 5    ARM      AGE          mu    H0 Mean         0 object '…
#> 6    ARM      AGE      paired  Paired t…     FALSE object '…
#> 7    ARM      AGE   pooled_sd  Pooled S…      TRUE object '…
#> 8    ARM      AGE alternative  Alternat… two.sided object '…
#> ℹ 3 more variables: context, fmt_fun, warning
```
