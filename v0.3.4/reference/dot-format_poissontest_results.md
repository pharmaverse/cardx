# Convert Poisson test to ARD

Convert Poisson test to ARD

## Usage

``` r
.format_poissontest_results(by = NULL, variables, lst_tidy, ...)
```

## Arguments

- by:

  (`string`)\
  by column name

- variables:

  (`character`)\
  names of the event and time variables

- lst_tidy:

  (named `list`)\
  list of tidied results constructed with
  [`eval_capture_conditions()`](https://insightsengineering.github.io/cards/latest-tag/reference/eval_capture_conditions.html),
  e.g.
  `eval_capture_conditions(t.test(mtcars$mpg ~ mtcars$am) |> broom::tidy())`.

- ...:

  passed to
  [`poisson.test()`](https://rdrr.io/r/stats/poisson.test.html)

## Value

ARD data frame

## Examples

``` r
cardx:::.format_poissontest_results(
  by = "ARM",
  variables = c("CNSR", "AVAL"),
  lst_tidy =
    cards::eval_capture_conditions(
      stats::poisson.test(sum(cards::ADTTE[["CNSR"]]), sum(cards::ADTTE[["AVAL"]])) |>
        broom::tidy()
    )
)
#> {cards} data frame: 10 x 9
#>    group1 variable   context   stat_name stat_label      stat
#> 1     ARM     AVAL stats_po…    estimate  Estimate…     0.006
#> 2     ARM     AVAL stats_po…   statistic  Number o…       102
#> 3     ARM     AVAL stats_po…     p.value    p-value         0
#> 4     ARM     AVAL stats_po…   parameter  Expected…     16853
#> 5     ARM     AVAL stats_po…    conf.low  CI Lower…     0.005
#> 6     ARM     AVAL stats_po…   conf.high  CI Upper…     0.007
#> 7     ARM     AVAL stats_po…      method     method Exact Po…
#> 8     ARM     AVAL stats_po… alternative  alternat… two.sided
#> 9     ARM     AVAL stats_po…  conf.level  CI Confi…      0.95
#> 10    ARM     AVAL stats_po…          mu    H0 Mean         1
#> ℹ 3 more variables: fmt_fun, warning, error
```
