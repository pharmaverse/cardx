# ARD Abnormality Counts

Function counts participants with abnormal analysis range values.

For each abnormality specified via the `abnormal` parameter (e.g. Low or
High), statistic `n` is calculated as the number of patients with this
abnormality recorded, and statistic `N` is calculated as the total
number of patients with at least one post-baseline assessment. `p` is
calculated as `n / N`. If `excl_baseline_abn=TRUE` then participants
with abnormality at baseline are excluded from all statistic
calculations.

## Usage

``` r
ard_tabulate_abnormal(
  data,
  postbaseline,
  baseline,
  id = NULL,
  by = NULL,
  strata = NULL,
  abnormal = list(Low = "LOW", High = "HIGH"),
  excl_baseline_abn = TRUE,
  quiet = FALSE
)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame.

- postbaseline:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name of post-baseline reference range indicator variable.

- baseline:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name of baseline reference range indicator variable.

- id:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name used to identify unique participants in `data`. If `NULL`,
  each row in `data` is assumed to correspond to a unique participants.

- by, strata:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  columns to tabulate by/stratify by for summary statistic calculation.
  Arguments are similar, but with an important distinction:

  `by`: results are calculated for **all combinations** of the columns
  specified, including unobserved combinations and unobserved factor
  levels.

  `strata`: results are calculated for **all *observed* combinations**
  of the columns specified.

  Arguments may be used in conjunction with one another.

- abnormal:

  (`list`)\
  a named list of abnormalities to assess for. Each element should
  specify all levels of `postbaseline`/`baseline` that should be
  included when assessing for a given abnormality, with the name
  specifying the name of the abnormality. Any levels specified but not
  present in the data are ignored.

- excl_baseline_abn:

  (`logical`)\
  whether participants with baseline abnormality should be excluded from
  calculations. Defaults to `TRUE`.

- quiet:

  (scalar `logical`)\
  logical indicating whether to suppress additional messaging. Default
  is `FALSE`.

## Value

an ARD data frame of class 'card'

## Examples

``` r
# Load Data -------------------
set.seed(1)
adlb <- cards::ADLB
adlb$BNRIND <- ifelse(
  adlb$BNRIND != "N",
  sample(c("LOW", "LOW LOW", "HIGH", "HIGH HIGH"), nrow(adlb), replace = TRUE),
  "NORMAL"
)

# Example 1 -------------------
adlb |>
  ard_tabulate_abnormal(
    postbaseline = LBNRIND, baseline = BNRIND, id = USUBJID, by = TRTA,
    abnormal = list(Low = c("LOW", "LOW LOW"), High = c("HIGH", "HIGH HIGH"))
  )
#> Abnormality "Low" created by merging levels: "LOW", "LOW LOW"
#> Abnormality "High" created by merging levels: "HIGH", "HIGH HIGH"
#> {cards} data frame: 18 x 11
#>    group1 group1_level variable variable_level stat_name stat_label  stat
#> 1    TRTA      Placebo  LBNRIND            Low         n          n     2
#> 2    TRTA      Placebo  LBNRIND            Low         N          N     7
#> 3    TRTA      Placebo  LBNRIND            Low         p          % 0.286
#> 4    TRTA      Placebo  LBNRIND           High         n          n     3
#> 5    TRTA      Placebo  LBNRIND           High         N          N     7
#> 6    TRTA      Placebo  LBNRIND           High         p          % 0.429
#> 7    TRTA    Xanomeli…  LBNRIND            Low         n          n     4
#> 8    TRTA    Xanomeli…  LBNRIND            Low         N          N     7
#> 9    TRTA    Xanomeli…  LBNRIND            Low         p          % 0.571
#> 10   TRTA    Xanomeli…  LBNRIND           High         n          n     3
#> 11   TRTA    Xanomeli…  LBNRIND           High         N          N     7
#> 12   TRTA    Xanomeli…  LBNRIND           High         p          % 0.429
#> 13   TRTA    Xanomeli…  LBNRIND            Low         n          n     4
#> 14   TRTA    Xanomeli…  LBNRIND            Low         N          N     6
#> 15   TRTA    Xanomeli…  LBNRIND            Low         p          % 0.667
#> 16   TRTA    Xanomeli…  LBNRIND           High         n          n     3
#> 17   TRTA    Xanomeli…  LBNRIND           High         N          N     6
#> 18   TRTA    Xanomeli…  LBNRIND           High         p          %   0.5
#> ℹ 4 more variables: context, fmt_fun, warning, error
```
