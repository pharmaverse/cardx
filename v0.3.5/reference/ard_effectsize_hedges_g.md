# ARD Hedge's G Test

Analysis results data for paired and non-paired Hedge's G Effect Size
Test using
[`effectsize::hedges_g()`](https://easystats.github.io/effectsize/reference/cohens_d.html).

## Usage

``` r
ard_effectsize_hedges_g(data, by, variables, conf.level = 0.95, ...)

ard_effectsize_paired_hedges_g(data, by, variables, id, conf.level = 0.95, ...)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to compare by. Must be a categorical variable with exactly
  two levels.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Must be a continuous variable.
  Independent tests will be run for each variable

- conf.level:

  (scalar `numeric`)\
  confidence level for confidence interval. Default is `0.95`.

- ...:

  arguments passed to `effectsize::hedges_g(...)`

- id:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name of the subject or participant ID

## Value

ARD data frame

## Details

For the `ard_effectsize_hedges_g()` function, the data is expected to be
one row per subject. The data is passed as
`effectsize::hedges_g(data[[variable]]~data[[by]], data, paired = FALSE, ...)`.

For the `ard_effectsize_paired_hedges_g()` function, the data is
expected to be one row per subject per by level. Before the effect size
is calculated, the data are reshaped to a wide format to be one row per
subject. The data are then passed as
`effectsize::hedges_g(x = data_wide[[<by level 1>]], y = data_wide[[<by level 2>]], paired = TRUE, ...)`.

## Examples

``` r
cards::ADSL |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  ard_effectsize_hedges_g(by = ARM, variables = AGE)
#> # An ARD data frame: 9 × 9
#>   group1 variable context stat_name stat_label stat       fmt_fun warning error 
#>   <chr>  <chr>    <chr>   <chr>     <chr>      <named li> <named> <named> <name>
#> 1 ARM    AGE      effect… estimate  Effect Si… 0.09995903 1       <NULL>  <NULL>
#> 2 ARM    AGE      effect… conf.lev… CI Confid… 0.95       1       <NULL>  <NULL>
#> 3 ARM    AGE      effect… conf.low  CI Lower … -0.1997009 1       <NULL>  <NULL>
#> 4 ARM    AGE      effect… conf.high CI Upper … 0.399322   1       <NULL>  <NULL>
#> 5 ARM    AGE      effect… method    method     Hedge's G  <NULL>  <NULL>  <NULL>
#> 6 ARM    AGE      effect… mu        H0 Mean    0          1       <NULL>  <NULL>
#> 7 ARM    AGE      effect… paired    Paired te… FALSE      <NULL>  <NULL>  <NULL>
#> 8 ARM    AGE      effect… pooled_sd Pooled St… TRUE       <NULL>  <NULL>  <NULL>
#> 9 ARM    AGE      effect… alternat… Alternati… two.sided  <NULL>  <NULL>  <NULL>

# constructing a paired data set,
# where patients receive both treatments
cards::ADSL[c("ARM", "AGE")] |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  dplyr::mutate(.by = ARM, USUBJID = dplyr::row_number()) |>
  dplyr::arrange(USUBJID, ARM) |>
  dplyr::group_by(USUBJID) |>
  dplyr::filter(dplyr::n() > 1) |>
  ard_effectsize_paired_hedges_g(by = ARM, variables = AGE, id = USUBJID)
#> # An ARD data frame: 9 × 9
#>   group1 variable context          stat_name stat_label stat             fmt_fun
#>   <chr>  <chr>    <chr>            <chr>     <chr>      <named list>     <named>
#> 1 ARM    AGE      effectsize_hedg… estimate  Effect Si… 0.06795119       1      
#> 2 ARM    AGE      effectsize_hedg… conf.lev… CI Confid… 0.95             1      
#> 3 ARM    AGE      effectsize_hedg… conf.low  CI Lower … -0.1444143       1      
#> 4 ARM    AGE      effectsize_hedg… conf.high CI Upper … 0.2799087        1      
#> 5 ARM    AGE      effectsize_hedg… method    method     Paired Hedge's G <NULL> 
#> 6 ARM    AGE      effectsize_hedg… mu        H0 Mean    0                1      
#> 7 ARM    AGE      effectsize_hedg… paired    Paired te… TRUE             <NULL> 
#> 8 ARM    AGE      effectsize_hedg… pooled_sd Pooled St… TRUE             <NULL> 
#> 9 ARM    AGE      effectsize_hedg… alternat… Alternati… two.sided        <NULL> 
#> # ℹ 2 more variables: warning <named list>, error <named list>
```
