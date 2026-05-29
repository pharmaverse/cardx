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
#> {cards} data frame: 5 x 8
#>   variable   context stat_name stat_label   stat fmt_fun
#> 1      ARM car_anova     sumsq      sumsq 71.386       1
#> 2      ARM car_anova        df  Degrees …      2       1
#> 3      ARM car_anova    meansq     meansq 35.693       1
#> 4      ARM car_anova statistic  Statistic  0.523       1
#> 5      ARM car_anova   p.value    p-value  0.593       1
#> ℹ 2 more variables: warning, error

glm(vs ~ factor(cyl) + factor(am), data = mtcars, family = binomial) |>
  ard_car_anova(test.statistic = "Wald")
#> {cards} data frame: 6 x 8
#>      variable   context stat_name stat_label  stat   warning
#> 1 factor(cyl) car_anova statistic  Statistic     0 glm.fit:…
#> 2 factor(cyl) car_anova        df  Degrees …     2 glm.fit:…
#> 3 factor(cyl) car_anova   p.value    p-value     1 glm.fit:…
#> 4  factor(am) car_anova statistic  Statistic     0 glm.fit:…
#> 5  factor(am) car_anova        df  Degrees …     1 glm.fit:…
#> 6  factor(am) car_anova   p.value    p-value 0.998 glm.fit:…
#> ℹ 2 more variables: fmt_fun, error
```
