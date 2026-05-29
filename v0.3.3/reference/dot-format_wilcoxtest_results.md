# Convert Wilcoxon test to ARD

Convert Wilcoxon test to ARD

## Usage

``` r
.format_wilcoxtest_results(by = NULL, variable, lst_tidy, paired, ...)
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

  a logical indicating whether you want a paired test.

- ...:

  passed to `stats::wilcox.test(...)`

## Value

ARD data frame

## Examples

``` r
# Pre-processing ADSL to have grouping factor (ARM here) with 2 levels
ADSL <- cards::ADSL |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  ard_stats_wilcox_test(by = "ARM", variables = "AGE")

cardx:::.format_wilcoxtest_results(
  by = "ARM",
  variable = "AGE",
  paired = FALSE,
  lst_tidy =
    cards::eval_capture_conditions(
      stats::wilcox.test(ADSL[["AGE"]] ~ ADSL[["ARM"]], paired = FALSE) |>
        broom::tidy()
    )
)
#> {cards} data frame: 12 x 9
#>    group1 variable   stat_name stat_label  stat     error
#> 1     ARM      AGE   statistic  X-square…       cannot u…
#> 2     ARM      AGE     p.value    p-value       cannot u…
#> 3     ARM      AGE      method     method       cannot u…
#> 4     ARM      AGE alternative  alternat…       cannot u…
#> 5     ARM      AGE          mu         mu     0 cannot u…
#> 6     ARM      AGE      paired  Paired t… FALSE cannot u…
#> 7     ARM      AGE       exact      exact       cannot u…
#> 8     ARM      AGE     correct    correct  TRUE cannot u…
#> 9     ARM      AGE    conf.int   conf.int FALSE cannot u…
#> 10    ARM      AGE  conf.level  CI Confi…  0.95 cannot u…
#> 11    ARM      AGE    tol.root   tol.root     0 cannot u…
#> 12    ARM      AGE digits.rank  digits.r…   Inf cannot u…
#> ℹ 3 more variables: context, fmt_fun, warning
```
