# ARD McNemar's Test

Analysis results data for McNemar's statistical test. We have two
functions depending on the structure of the data.

- `ard_stats_mcnemar_test()` is the structure expected by
  [`stats::mcnemar.test()`](https://rdrr.io/r/stats/mcnemar.test.html)

- `ard_stats_mcnemar_test_long()` is one row per ID per group

## Usage

``` r
ard_stats_mcnemar_test(data, by, variables, ...)

ard_stats_mcnemar_test_long(data, by, variables, id, ...)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame. See below for details.

- by:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name to compare by.

- variables:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column names to be compared. Independent tests will be computed for
  each variable.

- ...:

  arguments passed to `stats::mcnemar.test(...)`

- id:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name of the subject or participant ID

## Value

ARD data frame

## Details

For the `ard_stats_mcnemar_test()` function, the data is expected to be
one row per subject. The data is passed as
`stats::mcnemar.test(x = data[[variable]], y = data[[by]], ...)`. Please
use `table(x = data[[variable]], y = data[[by]])` to check the
contingency table.

## Examples

``` r
cards::ADSL |>
  ard_stats_mcnemar_test(by = "SEX", variables = "EFFFL")
#> # An ARD data frame: 5 × 9
#>   group1 variable stat_name
#>   <chr>  <chr>    <chr>    
#> 1 SEX    EFFFL    statistic
#> 2 SEX    EFFFL    p.value  
#> 3 SEX    EFFFL    parameter
#> 4 SEX    EFFFL    method   
#> 5 SEX    EFFFL    correct  
#> # ℹ 6 more variables: context <chr>, stat_label <chr>, stat <named list>,
#> #   fmt_fun <named list>, warning <named list>, error <named list>

set.seed(1234)
cards::ADSL[c("USUBJID", "TRT01P")] |>
  dplyr::mutate(TYPE = "PLANNED") |>
  dplyr::rename(TRT01 = TRT01P) %>%
  dplyr::bind_rows(dplyr::mutate(., TYPE = "ACTUAL", TRT01 = sample(TRT01))) |>
  ard_stats_mcnemar_test_long(
    by = TYPE,
    variable = TRT01,
    id = USUBJID
  )
#> # An ARD data frame: 5 × 9
#>   group1 variable context        stat_name stat_label stat                      
#>   <chr>  <chr>    <chr>          <chr>     <chr>      <named list>              
#> 1 TYPE   TRT01    stats_mcnemar… statistic X-squared… 1.352521                  
#> 2 TYPE   TRT01    stats_mcnemar… p.value   p-value    0.7167007                 
#> 3 TYPE   TRT01    stats_mcnemar… parameter Degrees o… 3                         
#> 4 TYPE   TRT01    stats_mcnemar… method    method     McNemar's Chi-squared test
#> 5 TYPE   TRT01    stats_mcnemar… correct   correct    TRUE                      
#> # ℹ 3 more variables: fmt_fun <named list>, warning <named list>,
#> #   error <named list>
```
