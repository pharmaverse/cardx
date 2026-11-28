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
#> # An ARD data frame: 6 × 8
#>   variable context stat_name stat_label      stat fmt_fun warning      error    
#>   <chr>    <chr>   <chr>     <chr>         <list>  <list> <named list> <named l>
#> 1 ARM      car_vif GVIF      GVIF            1.02       1 <NULL>       <NULL>   
#> 2 ARM      car_vif df        df              2          1 <NULL>       <NULL>   
#> 3 ARM      car_vif aGVIF     Adjusted GVIF   1.00       1 <NULL>       <NULL>   
#> 4 SEX      car_vif GVIF      GVIF            1.02       1 <NULL>       <NULL>   
#> 5 SEX      car_vif df        df              1          1 <NULL>       <NULL>   
#> 6 SEX      car_vif aGVIF     Adjusted GVIF   1.01       1 <NULL>       <NULL>   
```
