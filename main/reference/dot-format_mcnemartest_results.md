# Convert McNemar's test to ARD

Convert McNemar's test to ARD

## Usage

``` r
.format_mcnemartest_results(by, variable, lst_tidy, ...)
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

  passed to `stats::mcnemar.test(...)`

## Value

ARD data frame

## Examples

``` r
cardx:::.format_mcnemartest_results(
  by = "ARM",
  variable = "AGE",
  lst_tidy =
    cards::eval_capture_conditions(
      stats::mcnemar.test(cards::ADSL[["SEX"]], cards::ADSL[["EFFFL"]]) |>
        broom::tidy()
    )
)
#> # An ARD data frame: 5 × 9
#>   group1 variable stat_name
#>   <chr>  <chr>    <chr>    
#> 1 ARM    AGE      statistic
#> 2 ARM    AGE      p.value  
#> 3 ARM    AGE      parameter
#> 4 ARM    AGE      method   
#> 5 ARM    AGE      correct  
#> # ℹ 6 more variables: context <chr>, stat_label <chr>, stat <named list>,
#> #   fmt_fun <named list>, warning <named list>, error <named list>
```
