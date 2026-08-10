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
#> # An ARD data frame: 6 × 8
#>   variable    context       stat_name stat_label     stat fmt_fun warning error 
#>   <chr>       <chr>         <chr>     <chr>        <list>  <list> <named> <name>
#> 1 (Intercept) aod_wald_test df        Degrees of… 1   e+0       1 <NULL>  <NULL>
#> 2 (Intercept) aod_wald_test statistic Statistic   7.13e+3       1 <NULL>  <NULL>
#> 3 (Intercept) aod_wald_test p.value   p-value     0             1 <NULL>  <NULL>
#> 4 ARM         aod_wald_test df        Degrees of… 2   e+0       1 <NULL>  <NULL>
#> 5 ARM         aod_wald_test statistic Statistic   1.05e+0       1 <NULL>  <NULL>
#> 6 ARM         aod_wald_test p.value   p-value     5.93e-1       1 <NULL>  <NULL>
```
