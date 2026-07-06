# Regression VIF ARD

Function takes a regression model object and returns the variance
inflation factor (VIF) using
[`car::vif()`](https://rdrr.io/pkg/car/man/vif.html) and converts it to
a ARD structure

## Usage

``` r
ard_car_vif(x, ...)
```

## Arguments

- x:

  regression model object See car::vif() for details

- ...:

  arguments passed to `car::vif(...)`

## Value

data frame

## Examples

``` r
lm(AGE ~ ARM + SEX, data = cards::ADSL) |>
  ard_car_vif()
#> {cards} data frame: 6 x 8
#>   variable context stat_name stat_label  stat fmt_fun
#> 1      ARM car_vif      GVIF       GVIF 1.016       1
#> 2      ARM car_vif        df         df     2       1
#> 3      ARM car_vif     aGVIF  Adjusted… 1.004       1
#> 4      SEX car_vif      GVIF       GVIF 1.016       1
#> 5      SEX car_vif        df         df     1       1
#> 6      SEX car_vif     aGVIF  Adjusted… 1.008       1
#> ℹ 2 more variables: warning, error
```
