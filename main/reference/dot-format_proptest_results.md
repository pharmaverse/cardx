# Convert prop.test to ARD

Convert prop.test to ARD

## Usage

``` r
.format_proptest_results(by, variable, lst_tidy, ...)
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

- ...:

  passed to `prop.test(...)`

## Value

ARD data frame

## Examples

``` r
NULL
#> NULL
```
