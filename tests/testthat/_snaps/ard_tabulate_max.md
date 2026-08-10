# ard_tabulate_max() works with default settings

    Code
      print(res, n = 20, columns = "all")
    Output
      # An ARD data frame: 27 x 11
         group1 group1_level         variable variable_level context         stat_name stat_label   stat fmt_fun warning error 
         <chr>  <list>               <chr>    <list>         <chr>           <chr>     <chr>      <list> <list>  <list>  <list>
       1 TRTA   Placebo              AESEV    MILD           categorical_max n         n          36     0       <NULL>  <NULL>
       2 TRTA   Placebo              AESEV    MILD           categorical_max N         N          69     0       <NULL>  <NULL>
       3 TRTA   Placebo              AESEV    MILD           categorical_max p         %           0.522 <fn>    <NULL>  <NULL>
       4 TRTA   Placebo              AESEV    MODERATE       categorical_max n         n          26     0       <NULL>  <NULL>
       5 TRTA   Placebo              AESEV    MODERATE       categorical_max N         N          69     0       <NULL>  <NULL>
       6 TRTA   Placebo              AESEV    MODERATE       categorical_max p         %           0.377 <fn>    <NULL>  <NULL>
       7 TRTA   Placebo              AESEV    SEVERE         categorical_max n         n           7     0       <NULL>  <NULL>
       8 TRTA   Placebo              AESEV    SEVERE         categorical_max N         N          69     0       <NULL>  <NULL>
       9 TRTA   Placebo              AESEV    SEVERE         categorical_max p         %           0.101 <fn>    <NULL>  <NULL>
      10 TRTA   Xanomeline High Dose AESEV    MILD           categorical_max n         n          22     0       <NULL>  <NULL>
      11 TRTA   Xanomeline High Dose AESEV    MILD           categorical_max N         N          79     0       <NULL>  <NULL>
      12 TRTA   Xanomeline High Dose AESEV    MILD           categorical_max p         %           0.278 <fn>    <NULL>  <NULL>
      13 TRTA   Xanomeline High Dose AESEV    MODERATE       categorical_max n         n          49     0       <NULL>  <NULL>
      14 TRTA   Xanomeline High Dose AESEV    MODERATE       categorical_max N         N          79     0       <NULL>  <NULL>
      15 TRTA   Xanomeline High Dose AESEV    MODERATE       categorical_max p         %           0.620 <fn>    <NULL>  <NULL>
      16 TRTA   Xanomeline High Dose AESEV    SEVERE         categorical_max n         n           8     0       <NULL>  <NULL>
      17 TRTA   Xanomeline High Dose AESEV    SEVERE         categorical_max N         N          79     0       <NULL>  <NULL>
      18 TRTA   Xanomeline High Dose AESEV    SEVERE         categorical_max p         %           0.101 <fn>    <NULL>  <NULL>
      19 TRTA   Xanomeline Low Dose  AESEV    MILD           categorical_max n         n          19     0       <NULL>  <NULL>
      20 TRTA   Xanomeline Low Dose  AESEV    MILD           categorical_max N         N          77     0       <NULL>  <NULL>
      # i 7 more rows

---

    Code
      print(ard_tabulate_max(dplyr::group_by(cards::ADAE, TRTA), variables = AESEV, id = USUBJID, denominator = cards::ADSL), n = 20, columns = "all")
    Message
      `AESEV`: "MILD" < "MODERATE" < "SEVERE"
    Output
      # An ARD data frame: 27 x 11
         group1 group1_level         variable variable_level context         stat_name stat_label    stat fmt_fun warning error 
         <chr>  <list>               <chr>    <list>         <chr>           <chr>     <chr>       <list> <list>  <list>  <list>
       1 TRTA   Placebo              AESEV    MILD           categorical_max n         n          36      0       <NULL>  <NULL>
       2 TRTA   Placebo              AESEV    MILD           categorical_max N         N          86      0       <NULL>  <NULL>
       3 TRTA   Placebo              AESEV    MILD           categorical_max p         %           0.419  <fn>    <NULL>  <NULL>
       4 TRTA   Placebo              AESEV    MODERATE       categorical_max n         n          26      0       <NULL>  <NULL>
       5 TRTA   Placebo              AESEV    MODERATE       categorical_max N         N          86      0       <NULL>  <NULL>
       6 TRTA   Placebo              AESEV    MODERATE       categorical_max p         %           0.302  <fn>    <NULL>  <NULL>
       7 TRTA   Placebo              AESEV    SEVERE         categorical_max n         n           7      0       <NULL>  <NULL>
       8 TRTA   Placebo              AESEV    SEVERE         categorical_max N         N          86      0       <NULL>  <NULL>
       9 TRTA   Placebo              AESEV    SEVERE         categorical_max p         %           0.0814 <fn>    <NULL>  <NULL>
      10 TRTA   Xanomeline High Dose AESEV    MILD           categorical_max n         n          22      0       <NULL>  <NULL>
      11 TRTA   Xanomeline High Dose AESEV    MILD           categorical_max N         N          84      0       <NULL>  <NULL>
      12 TRTA   Xanomeline High Dose AESEV    MILD           categorical_max p         %           0.262  <fn>    <NULL>  <NULL>
      13 TRTA   Xanomeline High Dose AESEV    MODERATE       categorical_max n         n          49      0       <NULL>  <NULL>
      14 TRTA   Xanomeline High Dose AESEV    MODERATE       categorical_max N         N          84      0       <NULL>  <NULL>
      15 TRTA   Xanomeline High Dose AESEV    MODERATE       categorical_max p         %           0.583  <fn>    <NULL>  <NULL>
      16 TRTA   Xanomeline High Dose AESEV    SEVERE         categorical_max n         n           8      0       <NULL>  <NULL>
      17 TRTA   Xanomeline High Dose AESEV    SEVERE         categorical_max N         N          84      0       <NULL>  <NULL>
      18 TRTA   Xanomeline High Dose AESEV    SEVERE         categorical_max p         %           0.0952 <fn>    <NULL>  <NULL>
      19 TRTA   Xanomeline Low Dose  AESEV    MILD           categorical_max n         n          19      0       <NULL>  <NULL>
      20 TRTA   Xanomeline Low Dose  AESEV    MILD           categorical_max N         N          84      0       <NULL>  <NULL>
      # i 7 more rows

# ard_tabulate_max(statistic) works

    Code
      ard_tabulate_max(cards::ADAE, variables = AESEV, id = USUBJID, by = TRTA, denominator = cards::ADSL, statistic = ~"n")
    Message
      `AESEV`: "MILD" < "MODERATE" < "SEVERE"
    Output
      # An ARD data frame: 9 x 11
        group1 group1_level         variable variable_level context         stat_name stat_label   stat fmt_fun warning error 
        <chr>  <list>               <chr>    <list>         <chr>           <chr>     <chr>      <list>  <list> <list>  <list>
      1 TRTA   Placebo              AESEV    MILD           categorical_max n         n              36       0 <NULL>  <NULL>
      2 TRTA   Placebo              AESEV    MODERATE       categorical_max n         n              26       0 <NULL>  <NULL>
      3 TRTA   Placebo              AESEV    SEVERE         categorical_max n         n               7       0 <NULL>  <NULL>
      4 TRTA   Xanomeline High Dose AESEV    MILD           categorical_max n         n              22       0 <NULL>  <NULL>
      5 TRTA   Xanomeline High Dose AESEV    MODERATE       categorical_max n         n              49       0 <NULL>  <NULL>
      6 TRTA   Xanomeline High Dose AESEV    SEVERE         categorical_max n         n               8       0 <NULL>  <NULL>
      7 TRTA   Xanomeline Low Dose  AESEV    MILD           categorical_max n         n              19       0 <NULL>  <NULL>
      8 TRTA   Xanomeline Low Dose  AESEV    MODERATE       categorical_max n         n              42       0 <NULL>  <NULL>
      9 TRTA   Xanomeline Low Dose  AESEV    SEVERE         categorical_max n         n              16       0 <NULL>  <NULL>

# ard_tabulate_max(denominator) works

    Code
      ard_tabulate_max(cards::ADAE, variables = AESEV, id = USUBJID, by = TRTA)
    Message
      `AESEV`: "MILD" < "MODERATE" < "SEVERE"
    Output
      # An ARD data frame: 27 x 11
         group1 group1_level         variable variable_level context         stat_name stat_label   stat fmt_fun warning error 
         <chr>  <list>               <chr>    <list>         <chr>           <chr>     <chr>      <list> <list>  <list>  <list>
       1 TRTA   Placebo              AESEV    MILD           categorical_max n         n          36     0       <NULL>  <NULL>
       2 TRTA   Placebo              AESEV    MILD           categorical_max N         N          69     0       <NULL>  <NULL>
       3 TRTA   Placebo              AESEV    MILD           categorical_max p         %           0.522 <fn>    <NULL>  <NULL>
       4 TRTA   Placebo              AESEV    MODERATE       categorical_max n         n          26     0       <NULL>  <NULL>
       5 TRTA   Placebo              AESEV    MODERATE       categorical_max N         N          69     0       <NULL>  <NULL>
       6 TRTA   Placebo              AESEV    MODERATE       categorical_max p         %           0.377 <fn>    <NULL>  <NULL>
       7 TRTA   Placebo              AESEV    SEVERE         categorical_max n         n           7     0       <NULL>  <NULL>
       8 TRTA   Placebo              AESEV    SEVERE         categorical_max N         N          69     0       <NULL>  <NULL>
       9 TRTA   Placebo              AESEV    SEVERE         categorical_max p         %           0.101 <fn>    <NULL>  <NULL>
      10 TRTA   Xanomeline High Dose AESEV    MILD           categorical_max n         n          22     0       <NULL>  <NULL>
      # i 17 more rows

---

    Code
      ard_tabulate_max(cards::ADAE, variables = AESEV, id = USUBJID, by = TRTA, denominator = 100)
    Message
      `AESEV`: "MILD" < "MODERATE" < "SEVERE"
    Output
      # An ARD data frame: 27 x 11
         group1 group1_level         variable variable_level context         stat_name stat_label   stat fmt_fun warning error 
         <chr>  <list>               <chr>    <list>         <chr>           <chr>     <chr>      <list> <list>  <list>  <list>
       1 TRTA   Placebo              AESEV    MILD           categorical_max n         n           36    0       <NULL>  <NULL>
       2 TRTA   Placebo              AESEV    MILD           categorical_max N         N          100    0       <NULL>  <NULL>
       3 TRTA   Placebo              AESEV    MILD           categorical_max p         %            0.36 <fn>    <NULL>  <NULL>
       4 TRTA   Placebo              AESEV    MODERATE       categorical_max n         n           26    0       <NULL>  <NULL>
       5 TRTA   Placebo              AESEV    MODERATE       categorical_max N         N          100    0       <NULL>  <NULL>
       6 TRTA   Placebo              AESEV    MODERATE       categorical_max p         %            0.26 <fn>    <NULL>  <NULL>
       7 TRTA   Placebo              AESEV    SEVERE         categorical_max n         n            7    0       <NULL>  <NULL>
       8 TRTA   Placebo              AESEV    SEVERE         categorical_max N         N          100    0       <NULL>  <NULL>
       9 TRTA   Placebo              AESEV    SEVERE         categorical_max p         %            0.07 <fn>    <NULL>  <NULL>
      10 TRTA   Xanomeline High Dose AESEV    MILD           categorical_max n         n           22    0       <NULL>  <NULL>
      # i 17 more rows

# ard_tabulate_max() works with pre-ordered factor variables

    Code
      print(res, n = 20, columns = "all")
    Output
      # An ARD data frame: 27 x 11
         group1 group1_level         variable variable_level context         stat_name stat_label    stat fmt_fun warning error 
         <chr>  <list>               <chr>    <list>         <chr>           <chr>     <chr>       <list> <list>  <list>  <list>
       1 TRTA   Placebo              AESEV    MILD           categorical_max n         n          36      0       <NULL>  <NULL>
       2 TRTA   Placebo              AESEV    MILD           categorical_max N         N          86      0       <NULL>  <NULL>
       3 TRTA   Placebo              AESEV    MILD           categorical_max p         %           0.419  <fn>    <NULL>  <NULL>
       4 TRTA   Placebo              AESEV    MODERATE       categorical_max n         n          26      0       <NULL>  <NULL>
       5 TRTA   Placebo              AESEV    MODERATE       categorical_max N         N          86      0       <NULL>  <NULL>
       6 TRTA   Placebo              AESEV    MODERATE       categorical_max p         %           0.302  <fn>    <NULL>  <NULL>
       7 TRTA   Placebo              AESEV    SEVERE         categorical_max n         n           7      0       <NULL>  <NULL>
       8 TRTA   Placebo              AESEV    SEVERE         categorical_max N         N          86      0       <NULL>  <NULL>
       9 TRTA   Placebo              AESEV    SEVERE         categorical_max p         %           0.0814 <fn>    <NULL>  <NULL>
      10 TRTA   Xanomeline High Dose AESEV    MILD           categorical_max n         n          22      0       <NULL>  <NULL>
      11 TRTA   Xanomeline High Dose AESEV    MILD           categorical_max N         N          84      0       <NULL>  <NULL>
      12 TRTA   Xanomeline High Dose AESEV    MILD           categorical_max p         %           0.262  <fn>    <NULL>  <NULL>
      13 TRTA   Xanomeline High Dose AESEV    MODERATE       categorical_max n         n          49      0       <NULL>  <NULL>
      14 TRTA   Xanomeline High Dose AESEV    MODERATE       categorical_max N         N          84      0       <NULL>  <NULL>
      15 TRTA   Xanomeline High Dose AESEV    MODERATE       categorical_max p         %           0.583  <fn>    <NULL>  <NULL>
      16 TRTA   Xanomeline High Dose AESEV    SEVERE         categorical_max n         n           8      0       <NULL>  <NULL>
      17 TRTA   Xanomeline High Dose AESEV    SEVERE         categorical_max N         N          84      0       <NULL>  <NULL>
      18 TRTA   Xanomeline High Dose AESEV    SEVERE         categorical_max p         %           0.0952 <fn>    <NULL>  <NULL>
      19 TRTA   Xanomeline Low Dose  AESEV    MILD           categorical_max n         n          19      0       <NULL>  <NULL>
      20 TRTA   Xanomeline Low Dose  AESEV    MILD           categorical_max N         N          84      0       <NULL>  <NULL>
      # i 7 more rows

# ard_tabulate_max() errors with incomplete factor columns

    Code
      ard_tabulate_max(dplyr::mutate(cards::ADAE, AESOC = factor(AESOC, levels = character(
        0))), variables = AESOC, id = USUBJID, by = TRTA)
    Condition
      Error in `ard_tabulate_max()`:
      ! Factors with empty "levels" attribute are not allowed, which was identified in column "AESOC".

---

    Code
      ard_tabulate_max(dplyr::mutate(cards::ADAE, SEX = factor(SEX, levels = c("F",
        "M", NA), exclude = NULL)), variables = SEX, id = USUBJID, by = TRTA)
    Condition
      Error in `ard_tabulate_max()`:
      ! Factors with NA levels are not allowed, which are present in column "SEX".

# ard_tabulate_max() works without any variables

    Code
      ard_tabulate_max(data = cards::ADAE, variables = starts_with("xxxx"), id = USUBJID,
      by = c(TRTA, AESEV))
    Output
      # An ARD data frame: 0 x 0

# ard_tabulate_max() strata works

    Code
      res
    Output
      # An ARD data frame: 18 x 11
         group1 group1_level         variable variable_level context  stat_name   stat
         <chr>  <list>               <chr>    <list>         <chr>    <chr>     <list>
       1 TRTA   Xanomeline High Dose AESEV    MILD           categor~ n         22    
       2 TRTA   Xanomeline High Dose AESEV    MILD           categor~ N         79    
       3 TRTA   Xanomeline High Dose AESEV    MILD           categor~ p          0.278
       4 TRTA   Xanomeline High Dose AESEV    MODERATE       categor~ n         49    
       5 TRTA   Xanomeline High Dose AESEV    MODERATE       categor~ N         79    
       6 TRTA   Xanomeline High Dose AESEV    MODERATE       categor~ p          0.620
       7 TRTA   Xanomeline High Dose AESEV    SEVERE         categor~ n          8    
       8 TRTA   Xanomeline High Dose AESEV    SEVERE         categor~ N         79    
       9 TRTA   Xanomeline High Dose AESEV    SEVERE         categor~ p          0.101
      10 TRTA   Xanomeline Low Dose  AESEV    MILD           categor~ n         19    
      11 TRTA   Xanomeline Low Dose  AESEV    MILD           categor~ N         77    
      12 TRTA   Xanomeline Low Dose  AESEV    MILD           categor~ p          0.247
      13 TRTA   Xanomeline Low Dose  AESEV    MODERATE       categor~ n         42    
      14 TRTA   Xanomeline Low Dose  AESEV    MODERATE       categor~ N         77    
      15 TRTA   Xanomeline Low Dose  AESEV    MODERATE       categor~ p          0.545
      16 TRTA   Xanomeline Low Dose  AESEV    SEVERE         categor~ n         16    
      17 TRTA   Xanomeline Low Dose  AESEV    SEVERE         categor~ N         77    
      18 TRTA   Xanomeline Low Dose  AESEV    SEVERE         categor~ p          0.208
      # i 4 more variables: stat_label <chr>, fmt_fun <list>, warning <list>,
      #   error <list>

