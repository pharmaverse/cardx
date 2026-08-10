# ARD Incidence Rate

Function takes a time at risk variable (`time`) and event count variable
(`count`) and calculates the incidence rate in person-years.

Incidence rate is calculated as: Total number of events that occurred /
Total person-time at risk

## Usage

``` r
ard_incidence_rate(
  data,
  time,
  count = NULL,
  id = NULL,
  by = NULL,
  strata = NULL,
  n_person_time = 100,
  unit_label = "time",
  conf.level = 0.95,
  conf.type = c("normal", "normal-log", "exact", "byar")
)
```

## Arguments

- data:

  (`data.frame`)\
  a data frame.

- time:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name of time at risk variable.

- count:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name of variable indicating count of events that occurred. If
  `NULL`, each row in `data` is assumed to correspond to a single event
  occurrence.

- id:

  ([`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html))\
  column name used to identify unique subjects in `data`. If `NULL`,
  each row in `data` is assumed to correspond to a unique subject.

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

- n_person_time:

  (`numeric`)\
  amount of person-time to estimate incidence rate for. Defaults to 100.

- unit_label:

  (`string`)\
  label for the unit of values in `time` and estimated person-time
  output (e.g. `"years"` for person-years, `"days"` for person-days,
  etc.). If the desired person-time estimate unit does not match the
  current `time` unit, values of `time` should be converted to the
  correct unit during pre-processing. Defaults to `"time"`
  (person-time).

- conf.level:

  (`numeric`)\
  confidence level for the estimated incidence rate.

- conf.type:

  (`string`)\
  confidence interval type for the estimated incidence rate.

  One of: `normal` (default), `normal-log`, `exact`, or `byar`.

## Value

an ARD data frame of class 'card'

## Details

The formulas used to calculate the confidence interval for each CI type
are as follows, where \\x_i\\ and \\t_i\\ represent the number of events
and follow-up time for subject \\i\\, respectively.

- `byar`: Byar's approximation of a Poisson CI. A continuity correction
  of 0.5 is included in the calculation.

  \$\$CI = (\sum{x_i} + 0.5) (1 - 1 / (9 \times (\sum{x_i} + 0.5)) \pm
  Z\_{1 - \alpha / 2} / (3 \sqrt{\sum{x_i} + 0.5}))^3 / \sum{t_i}\$\$

- `normal`: Normal CI.

  \$\$CI = \sum{x_i} / \sum{t_i} \pm Z\_{1 - \alpha / 2}
  \sqrt{\sum{x_i}} / \sum{t_i}\$\$

- `normal-log`: Normal-Log CI.

  \$\$CI = \exp(\log(\sum{x_i} / \sum{t_i}) \pm Z\_{1 - \alpha / 2} /
  \sqrt{\sum{x_i}})\$\$

- `exact`: Exact CI for a Poisson mean.

  \$\$CI\_{lower} = \chi^2\_{\alpha / 2, 2\sum{x_i} + 2} / {2
  \sum{t_i}}\$\$ \$\$CI\_{upper} = \chi^2\_{1 - \alpha / 2, 2\sum{x_i} +
  2} / {2 \sum{t_i}}\$\$

## Examples

``` r
set.seed(1)
data <- data.frame(
  USUBJID = 1:100,
  TRTA = sample(LETTERS[1:3], 100, replace = TRUE),
  AETTE1 = abs(rnorm(100, mean = 0.5)),
  AETOT1 = sample(0:20, 100, replace = TRUE)
)

data |>
  ard_incidence_rate(time = AETTE1, count = AETOT1, id = USUBJID, by = TRTA, unit_label = "years")
#> # An ARD data frame: 27 × 10
#>    group1 group1_level variable context   stat_name stat_label stat      fmt_fun
#>    <chr>  <list>       <chr>    <chr>     <chr>     <chr>      <list>    <list> 
#>  1 TRTA   A            AETTE1   incidenc… estimate  Incidence… 976.3053  1      
#>  2 TRTA   A            AETTE1   incidenc… std.error Standard … 0.5783134 1      
#>  3 TRTA   A            AETTE1   incidenc… conf.low  CI Lower … 862.958   1      
#>  4 TRTA   A            AETTE1   incidenc… conf.high CI Upper … 1089.653  1      
#>  5 TRTA   A            AETTE1   incidenc… conf.type CI Type    normal    <fn>   
#>  6 TRTA   A            AETTE1   incidenc… conf.lev… CI Confid… 0.95      1      
#>  7 TRTA   A            AETTE1   incidenc… tot_pers… Person-Ye… 29.19169  1      
#>  8 TRTA   A            AETTE1   incidenc… n_events  Number of… 285       0      
#>  9 TRTA   A            AETTE1   incidenc… N         Number of… 33        0      
#> 10 TRTA   B            AETTE1   incidenc… estimate  Incidence… 1373.986  1      
#> # ℹ 17 more rows
#> # ℹ 2 more variables: warning <list>, error <list>
```
