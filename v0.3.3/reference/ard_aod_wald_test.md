# ARD Wald Test

Function takes a regression model object and calculates Wald statistical
test using
[`aod::wald.test()`](https://rdrr.io/pkg/aod/man/wald.test.html).

## Usage

``` r
ard_aod_wald_test(
  x,
  tidy_fun = broom.helpers::tidy_with_broom_or_parameters,
  ...
)
```

## Arguments

- x:

  regression model object

- tidy_fun:

  (`function`)\
  a tidier. Default is
  [`broom.helpers::tidy_with_broom_or_parameters`](https://larmarange.github.io/broom.helpers/reference/tidy_with_broom_or_parameters.html)

- ...:

  arguments passed to `aod::wald.test(...)`

## Value

data frame

## Examples

``` r
lm(AGE ~ ARM, data = cards::ADSL) |>
  ard_aod_wald_test()
#> {cards} data frame: 6 x 8
#>      variable   context stat_name stat_label     stat fmt_fun
#> 1 (Intercept) aod_wald…        df  Degrees …        1       1
#> 2 (Intercept) aod_wald… statistic  Statistic 7126.713       1
#> 3 (Intercept) aod_wald…   p.value    p-value        0       1
#> 4         ARM aod_wald…        df  Degrees …        2       1
#> 5         ARM aod_wald… statistic  Statistic    1.046       1
#> 6         ARM aod_wald…   p.value    p-value    0.593       1
#> ℹ 2 more variables: warning, error
```
