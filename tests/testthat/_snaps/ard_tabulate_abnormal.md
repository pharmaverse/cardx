# ard_tabulate_abnormal() works

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 18 x 11
         group1 group1_level         variable variable_level context              stat_name stat_label   stat fmt_fun warning error 
         <chr>  <list>               <chr>    <list>         <chr>                <chr>     <chr>      <list> <list>  <list>  <list>
       1 TRTA   Placebo              LBNRIND  Low            categorical_abnormal n         n           2     0       <NULL>  <NULL>
       2 TRTA   Placebo              LBNRIND  Low            categorical_abnormal N         N           7     0       <NULL>  <NULL>
       3 TRTA   Placebo              LBNRIND  Low            categorical_abnormal p         %           0.286 <fn>    <NULL>  <NULL>
       4 TRTA   Placebo              LBNRIND  High           categorical_abnormal n         n           3     0       <NULL>  <NULL>
       5 TRTA   Placebo              LBNRIND  High           categorical_abnormal N         N           7     0       <NULL>  <NULL>
       6 TRTA   Placebo              LBNRIND  High           categorical_abnormal p         %           0.429 <fn>    <NULL>  <NULL>
       7 TRTA   Xanomeline High Dose LBNRIND  Low            categorical_abnormal n         n           4     0       <NULL>  <NULL>
       8 TRTA   Xanomeline High Dose LBNRIND  Low            categorical_abnormal N         N           7     0       <NULL>  <NULL>
       9 TRTA   Xanomeline High Dose LBNRIND  Low            categorical_abnormal p         %           0.571 <fn>    <NULL>  <NULL>
      10 TRTA   Xanomeline High Dose LBNRIND  High           categorical_abnormal n         n           3     0       <NULL>  <NULL>
      11 TRTA   Xanomeline High Dose LBNRIND  High           categorical_abnormal N         N           7     0       <NULL>  <NULL>
      12 TRTA   Xanomeline High Dose LBNRIND  High           categorical_abnormal p         %           0.429 <fn>    <NULL>  <NULL>
      13 TRTA   Xanomeline Low Dose  LBNRIND  Low            categorical_abnormal n         n           4     0       <NULL>  <NULL>
      14 TRTA   Xanomeline Low Dose  LBNRIND  Low            categorical_abnormal N         N           6     0       <NULL>  <NULL>
      15 TRTA   Xanomeline Low Dose  LBNRIND  Low            categorical_abnormal p         %           0.667 <fn>    <NULL>  <NULL>
      16 TRTA   Xanomeline Low Dose  LBNRIND  High           categorical_abnormal n         n           3     0       <NULL>  <NULL>
      17 TRTA   Xanomeline Low Dose  LBNRIND  High           categorical_abnormal N         N           6     0       <NULL>  <NULL>
      18 TRTA   Xanomeline Low Dose  LBNRIND  High           categorical_abnormal p         %           0.5   <fn>    <NULL>  <NULL>

---

    Code
      print(ard_tabulate_abnormal(adlb, postbaseline = LBNRIND, baseline = BNRIND, id = USUBJID, abnormal = list(low = c("LOW", "LOW LOW"), high = c("HIGH", "HIGH HIGH"), other = "OTHER")), columns = "all")
    Message
      Abnormality "low" created by merging levels: "LOW", "LOW LOW"
      Abnormality "high" created by merging levels: "HIGH", "HIGH HIGH"
      Abnormality "other" created from level: "OTHER"
    Output
      # An ARD data frame: 9 x 9
        variable variable_level context              stat_name stat_label   stat fmt_fun warning error 
        <chr>    <list>         <chr>                <chr>     <chr>      <list> <list>  <list>  <list>
      1 LBNRIND  low            categorical_abnormal n         n           10    0       <NULL>  <NULL>
      2 LBNRIND  low            categorical_abnormal N         N           20    0       <NULL>  <NULL>
      3 LBNRIND  low            categorical_abnormal p         %            0.5  <fn>    <NULL>  <NULL>
      4 LBNRIND  high           categorical_abnormal n         n            9    0       <NULL>  <NULL>
      5 LBNRIND  high           categorical_abnormal N         N           20    0       <NULL>  <NULL>
      6 LBNRIND  high           categorical_abnormal p         %            0.45 <fn>    <NULL>  <NULL>
      7 LBNRIND  other          categorical_abnormal n         n            0    0       <NULL>  <NULL>
      8 LBNRIND  other          categorical_abnormal N         N           20    0       <NULL>  <NULL>
      9 LBNRIND  other          categorical_abnormal p         %            0    <fn>    <NULL>  <NULL>

---

    Code
      print(ard_tabulate_abnormal(adlb, postbaseline = LBNRIND, baseline = BNRIND, id = USUBJID, by = TRTA, excl_baseline_abn = FALSE), columns = "all")
    Message
      Abnormality "Low" created from level: "LOW"
      Abnormality "High" created from level: "HIGH"
    Output
      # An ARD data frame: 18 x 11
         group1 group1_level         variable variable_level context              stat_name stat_label   stat fmt_fun warning error 
         <chr>  <list>               <chr>    <list>         <chr>                <chr>     <chr>      <list> <list>  <list>  <list>
       1 TRTA   Placebo              LBNRIND  Low            categorical_abnormal n         n           2     0       <NULL>  <NULL>
       2 TRTA   Placebo              LBNRIND  Low            categorical_abnormal N         N           7     0       <NULL>  <NULL>
       3 TRTA   Placebo              LBNRIND  Low            categorical_abnormal p         %           0.286 <fn>    <NULL>  <NULL>
       4 TRTA   Placebo              LBNRIND  High           categorical_abnormal n         n           3     0       <NULL>  <NULL>
       5 TRTA   Placebo              LBNRIND  High           categorical_abnormal N         N           7     0       <NULL>  <NULL>
       6 TRTA   Placebo              LBNRIND  High           categorical_abnormal p         %           0.429 <fn>    <NULL>  <NULL>
       7 TRTA   Xanomeline High Dose LBNRIND  Low            categorical_abnormal n         n           4     0       <NULL>  <NULL>
       8 TRTA   Xanomeline High Dose LBNRIND  Low            categorical_abnormal N         N           7     0       <NULL>  <NULL>
       9 TRTA   Xanomeline High Dose LBNRIND  Low            categorical_abnormal p         %           0.571 <fn>    <NULL>  <NULL>
      10 TRTA   Xanomeline High Dose LBNRIND  High           categorical_abnormal n         n           3     0       <NULL>  <NULL>
      11 TRTA   Xanomeline High Dose LBNRIND  High           categorical_abnormal N         N           7     0       <NULL>  <NULL>
      12 TRTA   Xanomeline High Dose LBNRIND  High           categorical_abnormal p         %           0.429 <fn>    <NULL>  <NULL>
      13 TRTA   Xanomeline Low Dose  LBNRIND  Low            categorical_abnormal n         n           4     0       <NULL>  <NULL>
      14 TRTA   Xanomeline Low Dose  LBNRIND  Low            categorical_abnormal N         N           6     0       <NULL>  <NULL>
      15 TRTA   Xanomeline Low Dose  LBNRIND  Low            categorical_abnormal p         %           0.667 <fn>    <NULL>  <NULL>
      16 TRTA   Xanomeline Low Dose  LBNRIND  High           categorical_abnormal n         n           3     0       <NULL>  <NULL>
      17 TRTA   Xanomeline Low Dose  LBNRIND  High           categorical_abnormal N         N           6     0       <NULL>  <NULL>
      18 TRTA   Xanomeline Low Dose  LBNRIND  High           categorical_abnormal p         %           0.5   <fn>    <NULL>  <NULL>

# ard_tabulate_abnormal() errors are handled correctly

    Code
      res <- ard_tabulate_abnormal(adlb, postbaseline = LBNRIND, baseline = BNRIND,
        id = USUBJID, by = TRTA, abnormal = list("HIGH", "LOW"))
    Condition
      Error in `ard_tabulate_abnormal()`:
      ! `abnormal` must be a named list, where each name corresponds to a different abnormality/direction.

---

    Code
      res <- ard_tabulate_abnormal(adlb, postbaseline = LBNRIND, baseline = BNRIND,
        id = USUBJID, by = TRTA, abnormal = list(high = 1:5, low = 0))
    Condition
      Error in `ard_tabulate_abnormal()`:
      ! Each abnormal level of `LBNRIND` specified via `abnormal` must be a <string>.

