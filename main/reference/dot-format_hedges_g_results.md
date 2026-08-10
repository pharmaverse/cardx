# Convert Hedge's G Test to ARD

Convert Hedge's G Test to ARD

## Usage

``` r
.format_hedges_g_results(by, variable, lst_tidy, paired, ...)
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

  passed to `hedges_g(...)`

## Value

ARD data frame

## Examples

``` r
cardx:::.format_hedges_g_results(
  by = "ARM",
  variable = "AGE",
  paired = FALSE,
  lst_tidy =
    cards::eval_capture_conditions(
      effectsize::hedges_g(data[[variable]] ~ data[[by]], paired = FALSE) |>
        parameters::standardize_names(style = "broom")
    )
)
#> # An ARD data frame: 8 × 9
#>   group1 variable context   stat_name stat_label stat      fmt_fun warning error
#>   <chr>  <chr>    <chr>     <chr>     <chr>      <named l> <named> <named> <nam>
#> 1 ARM    AGE      effectsi… estimate  Effect Si… <NULL>    <NULL>  <NULL>  obje…
#> 2 ARM    AGE      effectsi… conf.lev… CI Confid… <NULL>    <NULL>  <NULL>  obje…
#> 3 ARM    AGE      effectsi… conf.low  CI Lower … <NULL>    <NULL>  <NULL>  obje…
#> 4 ARM    AGE      effectsi… conf.high CI Upper … <NULL>    <NULL>  <NULL>  obje…
#> 5 ARM    AGE      effectsi… mu        H0 Mean    0         1       <NULL>  obje…
#> 6 ARM    AGE      effectsi… paired    Paired te… FALSE     <NULL>  <NULL>  obje…
#> 7 ARM    AGE      effectsi… pooled_sd Pooled St… TRUE      <NULL>  <NULL>  obje…
#> 8 ARM    AGE      effectsi… alternat… Alternati… two.sided <NULL>  <NULL>  obje…
```
