# Convert long paired data to wide

Convert long paired data to wide

## Usage

``` r
.paired_data_pivot_wider(data, by, variable, id)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame that is one line per subject per group

- by:

  (`string`)\
  by column name

- variable:

  (`string`)\
  variable column name

- id:

  (`string`)\
  subject id column name

## Value

a wide data frame

## Examples

``` r
cards::ADSL[c("ARM", "AGE")] |>
  dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
  dplyr::mutate(.by = ARM, USUBJID = dplyr::row_number()) |>
  dplyr::arrange(USUBJID, ARM) |>
  cardx:::.paired_data_pivot_wider(by = "ARM", variable = "AGE", id = "USUBJID")
#> # A tibble: 86 × 3
#>    USUBJID   by1   by2
#>      <int> <dbl> <dbl>
#>  1       1    63    71
#>  2       2    64    77
#>  3       3    85    81
#>  4       4    52    75
#>  5       5    84    57
#>  6       6    79    56
#>  7       7    81    79
#>  8       8    69    56
#>  9       9    63    61
#> 10      10    81    56
#> # ℹ 76 more rows
```
