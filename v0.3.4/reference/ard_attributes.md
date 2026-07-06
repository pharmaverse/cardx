# ARD Attributes

Add variable attributes to an ARD data frame.

- The `label` attribute will be added for all columns, and when no label
  is specified and no label has been set for a column using the `label=`
  argument, the column name will be placed in the label statistic.

- The `class` attribute will also be returned for all columns.

- Any other attribute returned by
  [`attributes()`](https://rdrr.io/r/base/attributes.html) will also be
  added, e.g. factor levels.

## Usage

``` r
# S3 method for class 'survey.design'
ard_attributes(data, variables = everything(), label = NULL, ...)
```

## Arguments

- data:

  (`survey.design`)\
  a design object often created with
  [`survey::svydesign()`](https://rdrr.io/pkg/survey/man/svydesign.html).

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  variables to include

- label:

  (named `list`)\
  named list of variable labels, e.g. `list(cyl = "No. Cylinders")`.
  Default is `NULL`

- ...:

  These dots are for future extensions and must be empty.

## Value

an ARD data frame of class 'card'

## Examples

``` r
data(api, package = "survey")
dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)

ard_attributes(
  data = dclus1,
  variables = c(sname, dname),
  label = list(sname = "School Name", dname = "District Name")
)
#> {cards} data frame: 4 x 8
#>   variable   context stat_name stat_label      stat fmt_fun
#> 1    sname attribut…     label  Variable… School N…    <fn>
#> 2    sname attribut…     class  Variable… character    NULL
#> 3    dname attribut…     label  Variable… District…    <fn>
#> 4    dname attribut…     class  Variable… character    NULL
#> ℹ 2 more variables: warning, error
```
