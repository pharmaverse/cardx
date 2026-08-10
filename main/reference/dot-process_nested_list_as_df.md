# Convert Nested Lists to Column

Some arguments, such as `stat_label`, are passed as nested lists. This
function properly unnests these lists and adds them to the results data
frame.

## Usage

``` r
.process_nested_list_as_df(x, arg, new_column, unlist = FALSE)
```

## Arguments

- x:

  (`data.frame`)\
  result data frame

- arg:

  (`list`)\
  the nested list

- new_column:

  (`string`)\
  new column name

- unlist:

  (`logical`)\
  whether to fully unlist final results

## Value

a data frame

## Examples

``` r
ard <- ard_tabulate(cards::ADSL, by = "ARM", variables = "AGEGR1")

cardx:::.process_nested_list_as_df(ard, NULL, "new_col")
#> # An ARD data frame: 27 × 12
#>    group1 group1_level  variable variable_level context stat_name   stat new_col
#>    <chr>  <list>        <chr>    <list>         <chr>   <chr>     <list> <list> 
#>  1 ARM    Placebo       AGEGR1   65-80          tabula… n         42     <NULL> 
#>  2 ARM    Placebo       AGEGR1   65-80          tabula… N         86     <NULL> 
#>  3 ARM    Placebo       AGEGR1   65-80          tabula… p          0.488 <NULL> 
#>  4 ARM    Placebo       AGEGR1   <65            tabula… n         14     <NULL> 
#>  5 ARM    Placebo       AGEGR1   <65            tabula… N         86     <NULL> 
#>  6 ARM    Placebo       AGEGR1   <65            tabula… p          0.163 <NULL> 
#>  7 ARM    Placebo       AGEGR1   >80            tabula… n         30     <NULL> 
#>  8 ARM    Placebo       AGEGR1   >80            tabula… N         86     <NULL> 
#>  9 ARM    Placebo       AGEGR1   >80            tabula… p          0.349 <NULL> 
#> 10 ARM    Xanomeline H… AGEGR1   65-80          tabula… n         55     <NULL> 
#> # ℹ 17 more rows
#> # ℹ 4 more variables: stat_label <chr>, fmt_fun <list>, warning <list>,
#> #   error <list>
```
