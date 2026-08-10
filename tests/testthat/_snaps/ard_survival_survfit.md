# ard_survival_survfit() works with times provided

    Code
      print(dplyr::mutate(ard_survival_survfit(survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE), times = c(60, 180)), stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))), n = Inf)
    Output
      # An ARD data frame: 32 x 11
         group1 group1_level         variable                 variable_level context  stat_name  stat_label                     stat   fmt_fun warning error 
         <chr>  <list>               <chr>                    <list>         <chr>    <chr>      <chr>                          <list> <list>  <list>  <list>
       1 TRTA   Placebo              time                     60             survival n.risk     Number of Subjects at Risk     59     1       <NULL>  <NULL>
       2 TRTA   Placebo              time                     60             survival estimate   Survival Probability           0.893  1       <NULL>  <NULL>
       3 TRTA   Placebo              time                     60             survival std.error  Standard Error (untransformed) 0.036  1       <NULL>  <NULL>
       4 TRTA   Placebo              time                     60             survival conf.high  CI Upper Bound                 0.966  1       <NULL>  <NULL>
       5 TRTA   Placebo              time                     60             survival conf.low   CI Lower Bound                 0.825  1       <NULL>  <NULL>
       6 TRTA   Placebo              time                     180            survival n.risk     Number of Subjects at Risk     35     1       <NULL>  <NULL>
       7 TRTA   Placebo              time                     180            survival estimate   Survival Probability           0.651  1       <NULL>  <NULL>
       8 TRTA   Placebo              time                     180            survival std.error  Standard Error (untransformed) 0.061  1       <NULL>  <NULL>
       9 TRTA   Placebo              time                     180            survival conf.high  CI Upper Bound                 0.783  1       <NULL>  <NULL>
      10 TRTA   Placebo              time                     180            survival conf.low   CI Lower Bound                 0.541  1       <NULL>  <NULL>
      11 TRTA   Xanomeline High Dose time                     60             survival n.risk     Number of Subjects at Risk     14     1       <NULL>  <NULL>
      12 TRTA   Xanomeline High Dose time                     60             survival estimate   Survival Probability           0.694  1       <NULL>  <NULL>
      13 TRTA   Xanomeline High Dose time                     60             survival std.error  Standard Error (untransformed) 0.071  1       <NULL>  <NULL>
      14 TRTA   Xanomeline High Dose time                     60             survival conf.high  CI Upper Bound                 0.849  1       <NULL>  <NULL>
      15 TRTA   Xanomeline High Dose time                     60             survival conf.low   CI Lower Bound                 0.568  1       <NULL>  <NULL>
      16 TRTA   Xanomeline High Dose time                     180            survival n.risk     Number of Subjects at Risk     3      1       <NULL>  <NULL>
      17 TRTA   Xanomeline High Dose time                     180            survival estimate   Survival Probability           0.262  1       <NULL>  <NULL>
      18 TRTA   Xanomeline High Dose time                     180            survival std.error  Standard Error (untransformed) 0.14   1       <NULL>  <NULL>
      19 TRTA   Xanomeline High Dose time                     180            survival conf.high  CI Upper Bound                 0.749  1       <NULL>  <NULL>
      20 TRTA   Xanomeline High Dose time                     180            survival conf.low   CI Lower Bound                 0.092  1       <NULL>  <NULL>
      21 TRTA   Xanomeline Low Dose  time                     60             survival n.risk     Number of Subjects at Risk     20     1       <NULL>  <NULL>
      22 TRTA   Xanomeline Low Dose  time                     60             survival estimate   Survival Probability           0.732  1       <NULL>  <NULL>
      23 TRTA   Xanomeline Low Dose  time                     60             survival std.error  Standard Error (untransformed) 0.068  1       <NULL>  <NULL>
      24 TRTA   Xanomeline Low Dose  time                     60             survival conf.high  CI Upper Bound                 0.878  1       <NULL>  <NULL>
      25 TRTA   Xanomeline Low Dose  time                     60             survival conf.low   CI Lower Bound                 0.61   1       <NULL>  <NULL>
      26 TRTA   Xanomeline Low Dose  time                     180            survival n.risk     Number of Subjects at Risk     5      1       <NULL>  <NULL>
      27 TRTA   Xanomeline Low Dose  time                     180            survival estimate   Survival Probability           0.381  1       <NULL>  <NULL>
      28 TRTA   Xanomeline Low Dose  time                     180            survival std.error  Standard Error (untransformed) 0.13   1       <NULL>  <NULL>
      29 TRTA   Xanomeline Low Dose  time                     180            survival conf.high  CI Upper Bound                 0.743  1       <NULL>  <NULL>
      30 TRTA   Xanomeline Low Dose  time                     180            survival conf.low   CI Lower Bound                 0.195  1       <NULL>  <NULL>
      31 <NA>   <NA>                 ..ard_survival_survfit.. <NULL>         survival conf.level CI Confidence Level            0.95   1       <NULL>  <NULL>
      32 <NA>   <NA>                 ..ard_survival_survfit.. <NULL>         survival conf.type  CI Type                        log    <NULL>  <NULL>  <NULL>

# ard_survival_survfit() works with different type

    Code
      print(dplyr::mutate(ard_survival_survfit(survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE), times = c(60, 180), type = "risk"), stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))), n = Inf)
    Output
      # An ARD data frame: 32 x 11
         group1 group1_level         variable                 variable_level context  stat_name  stat_label                     stat   fmt_fun warning error 
         <chr>  <list>               <chr>                    <list>         <chr>    <chr>      <chr>                          <list> <list>  <list>  <list>
       1 TRTA   Placebo              time                     60             risk     n.risk     Number of Subjects at Risk     59     1       <NULL>  <NULL>
       2 TRTA   Placebo              time                     60             risk     estimate   Survival Probability           0.107  1       <NULL>  <NULL>
       3 TRTA   Placebo              time                     60             risk     std.error  Standard Error (untransformed) 0.036  1       <NULL>  <NULL>
       4 TRTA   Placebo              time                     60             risk     conf.high  CI Upper Bound                 0.175  1       <NULL>  <NULL>
       5 TRTA   Placebo              time                     60             risk     conf.low   CI Lower Bound                 0.034  1       <NULL>  <NULL>
       6 TRTA   Placebo              time                     180            risk     n.risk     Number of Subjects at Risk     35     1       <NULL>  <NULL>
       7 TRTA   Placebo              time                     180            risk     estimate   Survival Probability           0.349  1       <NULL>  <NULL>
       8 TRTA   Placebo              time                     180            risk     std.error  Standard Error (untransformed) 0.061  1       <NULL>  <NULL>
       9 TRTA   Placebo              time                     180            risk     conf.high  CI Upper Bound                 0.459  1       <NULL>  <NULL>
      10 TRTA   Placebo              time                     180            risk     conf.low   CI Lower Bound                 0.217  1       <NULL>  <NULL>
      11 TRTA   Xanomeline High Dose time                     60             risk     n.risk     Number of Subjects at Risk     14     1       <NULL>  <NULL>
      12 TRTA   Xanomeline High Dose time                     60             risk     estimate   Survival Probability           0.306  1       <NULL>  <NULL>
      13 TRTA   Xanomeline High Dose time                     60             risk     std.error  Standard Error (untransformed) 0.071  1       <NULL>  <NULL>
      14 TRTA   Xanomeline High Dose time                     60             risk     conf.high  CI Upper Bound                 0.432  1       <NULL>  <NULL>
      15 TRTA   Xanomeline High Dose time                     60             risk     conf.low   CI Lower Bound                 0.151  1       <NULL>  <NULL>
      16 TRTA   Xanomeline High Dose time                     180            risk     n.risk     Number of Subjects at Risk     3      1       <NULL>  <NULL>
      17 TRTA   Xanomeline High Dose time                     180            risk     estimate   Survival Probability           0.738  1       <NULL>  <NULL>
      18 TRTA   Xanomeline High Dose time                     180            risk     std.error  Standard Error (untransformed) 0.14   1       <NULL>  <NULL>
      19 TRTA   Xanomeline High Dose time                     180            risk     conf.high  CI Upper Bound                 0.908  1       <NULL>  <NULL>
      20 TRTA   Xanomeline High Dose time                     180            risk     conf.low   CI Lower Bound                 0.251  1       <NULL>  <NULL>
      21 TRTA   Xanomeline Low Dose  time                     60             risk     n.risk     Number of Subjects at Risk     20     1       <NULL>  <NULL>
      22 TRTA   Xanomeline Low Dose  time                     60             risk     estimate   Survival Probability           0.268  1       <NULL>  <NULL>
      23 TRTA   Xanomeline Low Dose  time                     60             risk     std.error  Standard Error (untransformed) 0.068  1       <NULL>  <NULL>
      24 TRTA   Xanomeline Low Dose  time                     60             risk     conf.high  CI Upper Bound                 0.39   1       <NULL>  <NULL>
      25 TRTA   Xanomeline Low Dose  time                     60             risk     conf.low   CI Lower Bound                 0.122  1       <NULL>  <NULL>
      26 TRTA   Xanomeline Low Dose  time                     180            risk     n.risk     Number of Subjects at Risk     5      1       <NULL>  <NULL>
      27 TRTA   Xanomeline Low Dose  time                     180            risk     estimate   Survival Probability           0.619  1       <NULL>  <NULL>
      28 TRTA   Xanomeline Low Dose  time                     180            risk     std.error  Standard Error (untransformed) 0.13   1       <NULL>  <NULL>
      29 TRTA   Xanomeline Low Dose  time                     180            risk     conf.high  CI Upper Bound                 0.805  1       <NULL>  <NULL>
      30 TRTA   Xanomeline Low Dose  time                     180            risk     conf.low   CI Lower Bound                 0.257  1       <NULL>  <NULL>
      31 <NA>   <NA>                 ..ard_survival_survfit.. <NULL>         survival conf.level CI Confidence Level            0.95   1       <NULL>  <NULL>
      32 <NA>   <NA>                 ..ard_survival_survfit.. <NULL>         survival conf.type  CI Type                        log    <NULL>  <NULL>  <NULL>

# ard_survival_survfit() works with probs provided

    Code
      print(dplyr::mutate(ard_survival_survfit(survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE), probs = c(0.25, 0.75)), stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))), n = Inf)
    Output
      # An ARD data frame: 20 x 11
         group1 group1_level         variable                 variable_level context          stat_name  stat_label           stat   fmt_fun warning error 
         <chr>  <list>               <chr>                    <list>         <chr>            <chr>      <chr>                <list> <list>  <list>  <list>
       1 TRTA   Placebo              prob                     0.25           survival_survfit estimate   Survival Probability 142    1       <NULL>  <NULL>
       2 TRTA   Placebo              prob                     0.25           survival_survfit conf.high  CI Upper Bound       181    1       <NULL>  <NULL>
       3 TRTA   Placebo              prob                     0.25           survival_survfit conf.low   CI Lower Bound       70     1       <NULL>  <NULL>
       4 TRTA   Placebo              prob                     0.75           survival_survfit estimate   Survival Probability 184    1       <NULL>  <NULL>
       5 TRTA   Placebo              prob                     0.75           survival_survfit conf.high  CI Upper Bound       191    1       <NULL>  <NULL>
       6 TRTA   Placebo              prob                     0.75           survival_survfit conf.low   CI Lower Bound       183    1       <NULL>  <NULL>
       7 TRTA   Xanomeline High Dose prob                     0.25           survival_survfit estimate   Survival Probability 44     1       <NULL>  <NULL>
       8 TRTA   Xanomeline High Dose prob                     0.25           survival_survfit conf.high  CI Upper Bound       180    1       <NULL>  <NULL>
       9 TRTA   Xanomeline High Dose prob                     0.25           survival_survfit conf.low   CI Lower Bound       22     1       <NULL>  <NULL>
      10 TRTA   Xanomeline High Dose prob                     0.75           survival_survfit estimate   Survival Probability 188    1       <NULL>  <NULL>
      11 TRTA   Xanomeline High Dose prob                     0.75           survival_survfit conf.high  CI Upper Bound       NA     1       <NULL>  <NULL>
      12 TRTA   Xanomeline High Dose prob                     0.75           survival_survfit conf.low   CI Lower Bound       167    1       <NULL>  <NULL>
      13 TRTA   Xanomeline Low Dose  prob                     0.25           survival_survfit estimate   Survival Probability 49     1       <NULL>  <NULL>
      14 TRTA   Xanomeline Low Dose  prob                     0.25           survival_survfit conf.high  CI Upper Bound       180    1       <NULL>  <NULL>
      15 TRTA   Xanomeline Low Dose  prob                     0.25           survival_survfit conf.low   CI Lower Bound       37     1       <NULL>  <NULL>
      16 TRTA   Xanomeline Low Dose  prob                     0.75           survival_survfit estimate   Survival Probability 184    1       <NULL>  <NULL>
      17 TRTA   Xanomeline Low Dose  prob                     0.75           survival_survfit conf.high  CI Upper Bound       NA     1       <NULL>  <NULL>
      18 TRTA   Xanomeline Low Dose  prob                     0.75           survival_survfit conf.low   CI Lower Bound       180    1       <NULL>  <NULL>
      19 <NA>   <NA>                 ..ard_survival_survfit.. <NULL>         survival         conf.level CI Confidence Level  0.95   1       <NULL>  <NULL>
      20 <NA>   <NA>                 ..ard_survival_survfit.. <NULL>         survival         conf.type  CI Type              log    <NULL>  <NULL>  <NULL>

# ard_survival_survfit() works with unstratified model

    Code
      print(dplyr::mutate(ard_survival_survfit(survival::survfit(survival::Surv(time, status) ~ 1, data = survival::lung), times = c(60, 180)), stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))), n = Inf)
    Output
      # An ARD data frame: 12 x 9
         variable                 variable_level context  stat_name  stat_label                     stat   fmt_fun warning error 
         <chr>                    <list>         <chr>    <chr>      <chr>                          <list> <list>  <list>  <list>
       1 time                     60             survival n.risk     Number of Subjects at Risk     213    1       <NULL>  <NULL>
       2 time                     60             survival estimate   Survival Probability           0.925  1       <NULL>  <NULL>
       3 time                     60             survival std.error  Standard Error (untransformed) 0.017  1       <NULL>  <NULL>
       4 time                     60             survival conf.high  CI Upper Bound                 0.96   1       <NULL>  <NULL>
       5 time                     60             survival conf.low   CI Lower Bound                 0.892  1       <NULL>  <NULL>
       6 time                     180            survival n.risk     Number of Subjects at Risk     160    1       <NULL>  <NULL>
       7 time                     180            survival estimate   Survival Probability           0.722  1       <NULL>  <NULL>
       8 time                     180            survival std.error  Standard Error (untransformed) 0.03   1       <NULL>  <NULL>
       9 time                     180            survival conf.high  CI Upper Bound                 0.783  1       <NULL>  <NULL>
      10 time                     180            survival conf.low   CI Lower Bound                 0.666  1       <NULL>  <NULL>
      11 ..ard_survival_survfit.. <NULL>         survival conf.level CI Confidence Level            0.95   1       <NULL>  <NULL>
      12 ..ard_survival_survfit.. <NULL>         survival conf.type  CI Type                        log    <NULL>  <NULL>  <NULL>

---

    Code
      print(dplyr::mutate(ard_survival_survfit(survival::survfit(survival::Surv(time, status) ~ 1, data = survival::lung), probs = c(0.5, 0.75)), stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))), n = Inf)
    Output
      # An ARD data frame: 8 x 9
        variable                 variable_level context          stat_name  stat_label           stat   fmt_fun warning error 
        <chr>                    <list>         <chr>            <chr>      <chr>                <list> <list>  <list>  <list>
      1 prob                     0.5            survival_survfit estimate   Survival Probability 310    1       <NULL>  <NULL>
      2 prob                     0.5            survival_survfit conf.high  CI Upper Bound       363    1       <NULL>  <NULL>
      3 prob                     0.5            survival_survfit conf.low   CI Lower Bound       285    1       <NULL>  <NULL>
      4 prob                     0.75           survival_survfit estimate   Survival Probability 550    1       <NULL>  <NULL>
      5 prob                     0.75           survival_survfit conf.high  CI Upper Bound       654    1       <NULL>  <NULL>
      6 prob                     0.75           survival_survfit conf.low   CI Lower Bound       460    1       <NULL>  <NULL>
      7 ..ard_survival_survfit.. <NULL>         survival         conf.level CI Confidence Level  0.95   1       <NULL>  <NULL>
      8 ..ard_survival_survfit.. <NULL>         survival         conf.type  CI Type              log    <NULL>  <NULL>  <NULL>

# ard_survival_survfit() works with multiple stratification variables

    Code
      print(head(dplyr::select(dplyr::mutate(ard_survival_survfit(survival::survfit(survival::Surv(time, status) ~ sex + ph.ecog, data = survival::lung), times = c(60, 180)), stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))),
      "group1", "group1_level", "group2", "group2_level"), 20), n = Inf)
    Output
      # An ARD data frame: 20 x 4
         group1 group1_level group2  group2_level
         <chr>  <list>       <chr>   <list>      
       1 sex    1            ph.ecog 0           
       2 sex    1            ph.ecog 0           
       3 sex    1            ph.ecog 0           
       4 sex    1            ph.ecog 0           
       5 sex    1            ph.ecog 0           
       6 sex    1            ph.ecog 0           
       7 sex    1            ph.ecog 0           
       8 sex    1            ph.ecog 0           
       9 sex    1            ph.ecog 0           
      10 sex    1            ph.ecog 0           
      11 sex    1            ph.ecog 1           
      12 sex    1            ph.ecog 1           
      13 sex    1            ph.ecog 1           
      14 sex    1            ph.ecog 1           
      15 sex    1            ph.ecog 1           
      16 sex    1            ph.ecog 1           
      17 sex    1            ph.ecog 1           
      18 sex    1            ph.ecog 1           
      19 sex    1            ph.ecog 1           
      20 sex    1            ph.ecog 1           

---

    Code
      print(head(dplyr::select(dplyr::mutate(ard_survival_survfit(survival::survfit(survival::Surv(time, status) ~ sex + ph.ecog, data = survival::lung), probs = c(0.5, 0.75)), stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))),
      "group1", "group1_level", "group2", "group2_level"), 20), n = Inf)
    Output
      # An ARD data frame: 20 x 4
         group1 group1_level group2  group2_level
         <chr>  <list>       <chr>   <list>      
       1 sex    1            ph.ecog 0           
       2 sex    1            ph.ecog 0           
       3 sex    1            ph.ecog 0           
       4 sex    1            ph.ecog 0           
       5 sex    1            ph.ecog 0           
       6 sex    1            ph.ecog 0           
       7 sex    1            ph.ecog 1           
       8 sex    1            ph.ecog 1           
       9 sex    1            ph.ecog 1           
      10 sex    1            ph.ecog 1           
      11 sex    1            ph.ecog 1           
      12 sex    1            ph.ecog 1           
      13 sex    1            ph.ecog 2           
      14 sex    1            ph.ecog 2           
      15 sex    1            ph.ecog 2           
      16 sex    1            ph.ecog 2           
      17 sex    1            ph.ecog 2           
      18 sex    1            ph.ecog 2           
      19 sex    1            ph.ecog 3           
      20 sex    1            ph.ecog 3           

# ard_survival_survfit() works with competing risks

    Code
      print(dplyr::mutate(survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, data = ADTTE_MS) %>% ard_survival_survfit(times = c(60, 180)), stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))), n = Inf)
    Message
      Multi-state model detected. Showing probabilities into state 'death from cancer'.
    Output
      # An ARD data frame: 32 x 11
         group1 group1_level         variable                 variable_level context  stat_name  stat_label                     stat   fmt_fun warning error 
         <chr>  <list>               <chr>                    <list>         <chr>    <chr>      <chr>                          <list> <list>  <list>  <list>
       1 TRTA   Placebo              time                     60             survival n.risk     Number of Subjects at Risk     59     1       <NULL>  <NULL>
       2 TRTA   Placebo              time                     60             survival estimate   Survival Probability           0.054  1       <NULL>  <NULL>
       3 TRTA   Placebo              time                     60             survival std.error  Standard Error (untransformed) 0.026  1       <NULL>  <NULL>
       4 TRTA   Placebo              time                     60             survival conf.high  CI Upper Bound                 0.14   1       <NULL>  <NULL>
       5 TRTA   Placebo              time                     60             survival conf.low   CI Lower Bound                 0.021  1       <NULL>  <NULL>
       6 TRTA   Placebo              time                     180            survival n.risk     Number of Subjects at Risk     35     1       <NULL>  <NULL>
       7 TRTA   Placebo              time                     180            survival estimate   Survival Probability           0.226  1       <NULL>  <NULL>
       8 TRTA   Placebo              time                     180            survival std.error  Standard Error (untransformed) 0.054  1       <NULL>  <NULL>
       9 TRTA   Placebo              time                     180            survival conf.high  CI Upper Bound                 0.361  1       <NULL>  <NULL>
      10 TRTA   Placebo              time                     180            survival conf.low   CI Lower Bound                 0.142  1       <NULL>  <NULL>
      11 TRTA   Xanomeline High Dose time                     60             survival n.risk     Number of Subjects at Risk     14     1       <NULL>  <NULL>
      12 TRTA   Xanomeline High Dose time                     60             survival estimate   Survival Probability           0.137  1       <NULL>  <NULL>
      13 TRTA   Xanomeline High Dose time                     60             survival std.error  Standard Error (untransformed) 0.057  1       <NULL>  <NULL>
      14 TRTA   Xanomeline High Dose time                     60             survival conf.high  CI Upper Bound                 0.311  1       <NULL>  <NULL>
      15 TRTA   Xanomeline High Dose time                     60             survival conf.low   CI Lower Bound                 0.06   1       <NULL>  <NULL>
      16 TRTA   Xanomeline High Dose time                     180            survival n.risk     Number of Subjects at Risk     3      1       <NULL>  <NULL>
      17 TRTA   Xanomeline High Dose time                     180            survival estimate   Survival Probability           0.51   1       <NULL>  <NULL>
      18 TRTA   Xanomeline High Dose time                     180            survival std.error  Standard Error (untransformed) 0.145  1       <NULL>  <NULL>
      19 TRTA   Xanomeline High Dose time                     180            survival conf.high  CI Upper Bound                 0.892  1       <NULL>  <NULL>
      20 TRTA   Xanomeline High Dose time                     180            survival conf.low   CI Lower Bound                 0.292  1       <NULL>  <NULL>
      21 TRTA   Xanomeline Low Dose  time                     60             survival n.risk     Number of Subjects at Risk     20     1       <NULL>  <NULL>
      22 TRTA   Xanomeline Low Dose  time                     60             survival estimate   Survival Probability           0.162  1       <NULL>  <NULL>
      23 TRTA   Xanomeline Low Dose  time                     60             survival std.error  Standard Error (untransformed) 0.059  1       <NULL>  <NULL>
      24 TRTA   Xanomeline Low Dose  time                     60             survival conf.high  CI Upper Bound                 0.33   1       <NULL>  <NULL>
      25 TRTA   Xanomeline Low Dose  time                     60             survival conf.low   CI Lower Bound                 0.08   1       <NULL>  <NULL>
      26 TRTA   Xanomeline Low Dose  time                     180            survival n.risk     Number of Subjects at Risk     5      1       <NULL>  <NULL>
      27 TRTA   Xanomeline Low Dose  time                     180            survival estimate   Survival Probability           0.244  1       <NULL>  <NULL>
      28 TRTA   Xanomeline Low Dose  time                     180            survival std.error  Standard Error (untransformed) 0.093  1       <NULL>  <NULL>
      29 TRTA   Xanomeline Low Dose  time                     180            survival conf.high  CI Upper Bound                 0.516  1       <NULL>  <NULL>
      30 TRTA   Xanomeline Low Dose  time                     180            survival conf.low   CI Lower Bound                 0.115  1       <NULL>  <NULL>
      31 <NA>   <NA>                 ..ard_survival_survfit.. <NULL>         survival conf.level CI Confidence Level            0.95   1       <NULL>  <NULL>
      32 <NA>   <NA>                 ..ard_survival_survfit.. <NULL>         survival conf.type  CI Type                        log    <NULL>  <NULL>  <NULL>

---

    Code
      survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, data = ADTTE_MS) %>% ard_survival_survfit(times = c(60, 180), type = "risk")
    Condition
      Error in `ard_survival_survfit()`:
      ! Cannot use `type` argument with `survfit` models with class <survfitms/survfitcoxms>.

# ard_survival_survfit() errors are properly handled

    Code
      ard_survival_survfit(x, times = 25)
    Condition
      Error in `ard_survival_survfit()`:
      ! The call in the survfit object `x` must be an evaluated formula. Please see `ard_survival_survfit()` (`?cardx::ard_survival_survfit()`) documentation for details on properly specifying formulas.

---

    Code
      ard_survival_survfit(times = 25)
    Condition
      Error in `ard_survival_survfit()`:
      ! The `x` argument cannot be missing.

---

    Code
      ard_survival_survfit("not_survfit")
    Condition
      Error in `UseMethod()`:
      ! no applicable method for 'ard_survival_survfit' applied to an object of class "character"

---

    Code
      ard_survival_survfit(survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA,
      cards::ADTTE), times = 100, type = "notatype")
    Condition
      Error in `ard_survival_survfit()`:
      ! `type` must be one of "survival", "risk", or "cumhaz", not "notatype".

---

    Code
      ard_survival_survfit(survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA,
      cards::ADTTE), probs = c(0.25, 0.75), type = "risk")
    Condition
      Error in `ard_survival_survfit()`:
      ! Cannot use `type` argument when `probs` argument specifed.

---

    Code
      ard_survival_survfit(survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA,
      cards::ADTTE), times = 100, probs = c(0.25, 0.75))
    Condition
      Error in `ard_survival_survfit()`:
      ! One and only one of `times` and `probs` must be specified.

---

    Code
      ard_survival_survfit(survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA,
      cards::ADTTE), times = 100, summary.args = list(extend = "notatype"))
    Condition
      Error in `ard_survival_survfit()`:
      ! The `summary.args$extend` argument must be a scalar with class <logical>, not a string.

---

    Code
      ard_survival_survfit(x = cards::ADTTE, formula = survival::Surv(ttdeath, death) ~
        trt, variables = "trt", probs = c(0.25, 0.5, 0.75))
    Condition
      Error in `ard_survival_survfit()`:
      ! The `y` argument cannot be missing.

---

    Code
      ard_survival_survfit(x = cards::ADTTE, y = survival::Surv(ttdeath, death) ~ tte,
      probs = c(0.25, 0.5, 0.75))
    Condition
      Error in `ard_survival_survfit()`:
      ! The `y` argument must be a string or expression that evaluates to an object of class <Surv> most often created with `survival::Surv()` or `ggsurvfit::Surv_CNSR()`.

# ard_survival_survfit() errors with stratified Cox model

    Code
      ard_survival_survfit(survfit(coxph(Surv(time, status) ~ age + strata(sex),
      survival::lung)))
    Condition
      Error in `ard_survival_survfit()`:
      ! Argument `x` cannot be class <survfitcox>.

# ard_survival_survfit() works with '=' in strata variable level labels

    Code
      ard_survival_survfit(survival::survfit(survival::Surv(time, status) ~ age_bin, data = lung2), times = 100)
    Output
      # An ARD data frame: 12 x 11
         group1  group1_level variable                 variable_level context  stat_name  stat_label                     stat       fmt_fun warning error 
         <chr>   <list>       <chr>                    <list>         <chr>    <chr>      <chr>                          <list>     <list>  <list>  <list>
       1 age_bin <60          time                     100            survival n.risk     Number of Subjects at Risk     77         1       <NULL>  <NULL>
       2 age_bin <60          time                     100            survival estimate   Survival Probability           0.9277108  1       <NULL>  <NULL>
       3 age_bin <60          time                     100            survival std.error  Standard Error (untransformed) 0.02842522 1       <NULL>  <NULL>
       4 age_bin <60          time                     100            survival conf.high  CI Upper Bound                 0.9851301  1       <NULL>  <NULL>
       5 age_bin <60          time                     100            survival conf.low   CI Lower Bound                 0.8736383  1       <NULL>  <NULL>
       6 age_bin >=60         time                     100            survival n.risk     Number of Subjects at Risk     119        1       <NULL>  <NULL>
       7 age_bin >=60         time                     100            survival estimate   Survival Probability           0.8274722  1       <NULL>  <NULL>
       8 age_bin >=60         time                     100            survival std.error  Standard Error (untransformed) 0.0313902  1       <NULL>  <NULL>
       9 age_bin >=60         time                     100            survival conf.high  CI Upper Bound                 0.8913408  1       <NULL>  <NULL>
      10 age_bin >=60         time                     100            survival conf.low   CI Lower Bound                 0.7681801  1       <NULL>  <NULL>
      11 <NA>    <NA>         ..ard_survival_survfit.. <NULL>         survival conf.level CI Confidence Level            0.95       1       <NULL>  <NULL>
      12 <NA>    <NA>         ..ard_survival_survfit.. <NULL>         survival conf.type  CI Type                        log        <NULL>  <NULL>  <NULL>

# extract_strata() returns safely and warns on 0-row datasets

    Dataset `df_stat` is empty.

# ard_survival_survfit() extends to times outside range

    Code
      print(ard_survival_survfit(survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE), times = 200), n = Inf)
    Output
      # An ARD data frame: 17 x 11
         group1 group1_level         variable                 variable_level context  stat_name  stat_label                     stat   fmt_fun warning error 
         <chr>  <list>               <chr>                    <list>         <chr>    <chr>      <chr>                          <list> <list>  <list>  <list>
       1 TRTA   Placebo              time                     200            survival n.risk     Number of Subjects at Risk     0      1       <NULL>  <NULL>
       2 TRTA   Placebo              time                     200            survival estimate   Survival Probability           0      1       <NULL>  <NULL>
       3 TRTA   Placebo              time                     200            survival std.error  Standard Error (untransformed) NaN    1       <NULL>  <NULL>
       4 TRTA   Placebo              time                     200            survival conf.high  CI Upper Bound                 NA     1       <NULL>  <NULL>
       5 TRTA   Placebo              time                     200            survival conf.low   CI Lower Bound                 NA     1       <NULL>  <NULL>
       6 TRTA   Xanomeline High Dose time                     200            survival n.risk     Number of Subjects at Risk     0      1       <NULL>  <NULL>
       7 TRTA   Xanomeline High Dose time                     200            survival estimate   Survival Probability           0      1       <NULL>  <NULL>
       8 TRTA   Xanomeline High Dose time                     200            survival std.error  Standard Error (untransformed) NaN    1       <NULL>  <NULL>
       9 TRTA   Xanomeline High Dose time                     200            survival conf.high  CI Upper Bound                 NA     1       <NULL>  <NULL>
      10 TRTA   Xanomeline High Dose time                     200            survival conf.low   CI Lower Bound                 NA     1       <NULL>  <NULL>
      11 TRTA   Xanomeline Low Dose  time                     200            survival n.risk     Number of Subjects at Risk     0      1       <NULL>  <NULL>
      12 TRTA   Xanomeline Low Dose  time                     200            survival estimate   Survival Probability           0      1       <NULL>  <NULL>
      13 TRTA   Xanomeline Low Dose  time                     200            survival std.error  Standard Error (untransformed) NaN    1       <NULL>  <NULL>
      14 TRTA   Xanomeline Low Dose  time                     200            survival conf.high  CI Upper Bound                 NA     1       <NULL>  <NULL>
      15 TRTA   Xanomeline Low Dose  time                     200            survival conf.low   CI Lower Bound                 NA     1       <NULL>  <NULL>
      16 <NA>   <NA>                 ..ard_survival_survfit.. <NULL>         survival conf.level CI Confidence Level            0.95   1       <NULL>  <NULL>
      17 <NA>   <NA>                 ..ard_survival_survfit.. <NULL>         survival conf.type  CI Type                        log    <NULL>  <NULL>  <NULL>

---

    Code
      print(ard_survival_survfit(survival::survfit(survival::Surv(AVAL, 1 - CNSR) ~ TRTA, cards::ADTTE), times = 200), n = Inf)
    Message
      {cards} data frame: 17 x 11
    Output
         group1 group1_level                 variable variable_level  stat_name stat_label  stat
      1    TRTA      Placebo                     time            200     n.risk  Number o…     0
      2    TRTA      Placebo                     time            200   estimate  Survival… 0.626
      3    TRTA      Placebo                     time            200  std.error  Standard… 0.056
      4    TRTA      Placebo                     time            200  conf.high  CI Upper… 0.746
      5    TRTA      Placebo                     time            200   conf.low  CI Lower… 0.526
      6    TRTA    Xanomeli…                     time            200     n.risk  Number o…     0
      7    TRTA    Xanomeli…                     time            200   estimate  Survival… 0.092
      8    TRTA    Xanomeli…                     time            200  std.error  Standard… 0.041
      9    TRTA    Xanomeli…                     time            200  conf.high  CI Upper… 0.221
      10   TRTA    Xanomeli…                     time            200   conf.low  CI Lower… 0.038
      11   TRTA    Xanomeli…                     time            200     n.risk  Number o…     0
      12   TRTA    Xanomeli…                     time            200   estimate  Survival… 0.126
      13   TRTA    Xanomeli…                     time            200  std.error  Standard… 0.044
      14   TRTA    Xanomeli…                     time            200  conf.high  CI Upper… 0.249
      15   TRTA    Xanomeli…                     time            200   conf.low  CI Lower… 0.064
      16   <NA>           NA ..ard_survival_survfit..                conf.level  CI Confi…  0.95
      17   <NA>           NA ..ard_survival_survfit..                 conf.type    CI Type   log
    Message
      i 4 more variables: context, fmt_fun, warning, error

---

    Code
      print(ard_survival_survfit(survival::survfit(survival::Surv(AVAL, 1 - CNSR) ~ TRTA, cards::ADTTE), times = 200, summary.args = list(extend = FALSE)), n = Inf)
    Message
      {cards} data frame: 17 x 11
    Output
         group1 group1_level                 variable variable_level  stat_name stat_label stat
      1    TRTA      Placebo                     time            200     n.risk  Number o…    0
      2    TRTA      Placebo                     time            200   estimate  Survival…   NA
      3    TRTA      Placebo                     time            200  std.error  Standard…   NA
      4    TRTA      Placebo                     time            200  conf.high  CI Upper…   NA
      5    TRTA      Placebo                     time            200   conf.low  CI Lower…   NA
      6    TRTA    Xanomeli…                     time            200     n.risk  Number o…    0
      7    TRTA    Xanomeli…                     time            200   estimate  Survival…   NA
      8    TRTA    Xanomeli…                     time            200  std.error  Standard…   NA
      9    TRTA    Xanomeli…                     time            200  conf.high  CI Upper…   NA
      10   TRTA    Xanomeli…                     time            200   conf.low  CI Lower…   NA
      11   TRTA    Xanomeli…                     time            200     n.risk  Number o…    0
      12   TRTA    Xanomeli…                     time            200   estimate  Survival…   NA
      13   TRTA    Xanomeli…                     time            200  std.error  Standard…   NA
      14   TRTA    Xanomeli…                     time            200  conf.high  CI Upper…   NA
      15   TRTA    Xanomeli…                     time            200   conf.low  CI Lower…   NA
      16   <NA>           NA ..ard_survival_survfit..                conf.level  CI Confi… 0.95
      17   <NA>           NA ..ard_survival_survfit..                 conf.type    CI Type  log
    Message
      i 4 more variables: context, fmt_fun, warning, error

# ard_survival_survfit.data.frame() works as expected

    Code
      res_quo <- print(dplyr::mutate(ard_survival_survfit(x = mtcars, y = "survival::Surv(mpg, am)", variables = "vs", times = 20, method.args = list(start.time = 0, id = cyl)), stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))),
      n = Inf)
    Output
      # An ARD data frame: 12 x 11
         group1 group1_level variable                 variable_level context  stat_name  stat_label                     stat   fmt_fun warning error 
         <chr>  <list>       <chr>                    <list>         <chr>    <chr>      <chr>                          <list> <list>  <list>  <list>
       1 vs     0            time                     20             survival n.risk     Number of Subjects at Risk     3      1       <NULL>  <NULL>
       2 vs     0            time                     20             survival estimate   Survival Probability           0.615  1       <NULL>  <NULL>
       3 vs     0            time                     20             survival std.error  Standard Error (untransformed) 0.082  1       <NULL>  <NULL>
       4 vs     0            time                     20             survival conf.high  CI Upper Bound                 0.8    1       <NULL>  <NULL>
       5 vs     0            time                     20             survival conf.low   CI Lower Bound                 0.474  1       <NULL>  <NULL>
       6 vs     1            time                     20             survival n.risk     Number of Subjects at Risk     11     1       <NULL>  <NULL>
       7 vs     1            time                     20             survival estimate   Survival Probability           1      1       <NULL>  <NULL>
       8 vs     1            time                     20             survival std.error  Standard Error (untransformed) 0      1       <NULL>  <NULL>
       9 vs     1            time                     20             survival conf.high  CI Upper Bound                 1      1       <NULL>  <NULL>
      10 vs     1            time                     20             survival conf.low   CI Lower Bound                 1      1       <NULL>  <NULL>
      11 <NA>   NA           ..ard_survival_survfit.. <NULL>         survival conf.level CI Confidence Level            0.95   1       <NULL>  <NULL>
      12 <NA>   NA           ..ard_survival_survfit.. <NULL>         survival conf.type  CI Type                        log    <NULL>  <NULL>  <NULL>

