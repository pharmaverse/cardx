# ARD ANOVA from car Package

Function takes a regression model object and calculated ANOVA using
[`car::Anova()`](https://rdrr.io/pkg/car/man/Anova.html).

## Usage

``` r
ard_car_anova(x, ...)
```

## Arguments

- x:

  regression model object

- ...:

  arguments passed to `car::Anova(...)`

## Value

data frame

## Examples

``` r
lm(AGE ~ ARM, data = cards::ADSL) |>
  ard_car_anova()
#> # An ARD data frame: 5 × 8
#>   variable context   stat_name stat_label           stat fmt_fun warning  error 
#>   <chr>    <chr>     <chr>     <chr>              <list>  <list> <named > <name>
#> 1 ARM      car_anova sumsq     sumsq              71.4         1 <NULL>   <NULL>
#> 2 ARM      car_anova df        Degrees of Freedom  2           1 <NULL>   <NULL>
#> 3 ARM      car_anova meansq    meansq             35.7         1 <NULL>   <NULL>
#> 4 ARM      car_anova statistic Statistic           0.523       1 <NULL>   <NULL>
#> 5 ARM      car_anova p.value   p-value             0.593       1 <NULL>   <NULL>

glm(vs ~ factor(cyl) + factor(am), data = mtcars, family = binomial) |>
  ard_car_anova(test.statistic = "Wald")
#> # An ARD data frame: 6 × 8
#>   variable    context   stat_name stat_label         stat fmt_fun warning error 
#>   <chr>       <chr>     <chr>     <chr>            <list>  <list> <named> <name>
#> 1 factor(cyl) car_anova statistic Statistic      9.59 e-6       1 glm.fi… <NULL>
#> 2 factor(cyl) car_anova df        Degrees of Fr… 2    e+0       1 glm.fi… <NULL>
#> 3 factor(cyl) car_anova p.value   p-value        1.000e+0       1 glm.fi… <NULL>
#> 4 factor(am)  car_anova statistic Statistic      5.65 e-6       1 glm.fi… <NULL>
#> 5 factor(am)  car_anova df        Degrees of Fr… 1    e+0       1 glm.fi… <NULL>
#> 6 factor(am)  car_anova p.value   p-value        9.98 e-1       1 glm.fi… <NULL>
```
