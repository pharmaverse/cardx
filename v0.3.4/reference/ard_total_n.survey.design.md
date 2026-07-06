# ARD Total N

Returns the total N for a survey object. The placeholder variable name
returned in the object is `"..ard_total_n.."`

## Usage

``` r
# S3 method for class 'survey.design'
ard_total_n(data, ...)
```

## Arguments

- data:

  (`survey.design`)\
  a design object often created with
  [`survey::svydesign()`](https://rdrr.io/pkg/survey/man/svydesign.html).

- ...:

  These dots are for future extensions and must be empty.

## Value

an ARD data frame of class 'card'

## Examples

``` r
svy_titanic <- survey::svydesign(~1, data = as.data.frame(Titanic), weights = ~Freq)

ard_total_n(svy_titanic)
#> {cards} data frame: 2 x 8
#>          variable context    stat_name stat_label stat fmt_fun
#> 1 ..ard_total_n.. total_n            N          N 2201    <fn>
#> 2 ..ard_total_n.. total_n N_unweighted  Unweight…   32    <fn>
#> ℹ 2 more variables: warning, error
```
