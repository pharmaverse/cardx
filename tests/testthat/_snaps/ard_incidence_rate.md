# ard_incidence_rate() works

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 10 x 8
         variable context       stat_name stat_label stat       fmt_fun warning error 
         <chr>    <chr>         <chr>     <chr>      <list>     <list>  <list>  <list>
       1 AVAL     incidence_ra~ estimate  Incidence~ 0.6052335  1       <NULL>  <NULL>
       2 AVAL     incidence_ra~ std.error Standard ~ 0.05992705 1       <NULL>  <NULL>
       3 AVAL     incidence_ra~ conf.low  CI Lower ~ 0.4877786  1       <NULL>  <NULL>
       4 AVAL     incidence_ra~ conf.high CI Upper ~ 0.7226883  1       <NULL>  <NULL>
       5 AVAL     incidence_ra~ conf.type CI Type    normal     <fn>    <NULL>  <NULL>
       6 AVAL     incidence_ra~ conf.lev~ CI Confid~ 0.95       1       <NULL>  <NULL>
       7 AVAL     incidence_ra~ tot_pers~ Person-Ye~ 16853      1       <NULL>  <NULL>
       8 AVAL     incidence_ra~ n_events  Number of~ 102        1       <NULL>  <NULL>
       9 AVAL     incidence_ra~ n         Number of~ 102        0       <NULL>  <NULL>
      10 AVAL     incidence_ra~ N         Number of~ 254        0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 10 x 8
         variable context        stat_name stat_label stat      fmt_fun warning error 
         <chr>    <chr>          <chr>     <chr>      <list>    <list>  <list>  <list>
       1 TRTDUR   incidence_rate estimate  Incidence~ 4.039068  1       <NULL>  <NULL>
       2 TRTDUR   incidence_rate std.error Standard ~ 0.1170376 1       <NULL>  <NULL>
       3 TRTDUR   incidence_rate conf.low  CI Lower ~ 3.809679  1       <NULL>  <NULL>
       4 TRTDUR   incidence_rate conf.high CI Upper ~ 4.268457  1       <NULL>  <NULL>
       5 TRTDUR   incidence_rate conf.type CI Type    normal    <fn>    <NULL>  <NULL>
       6 TRTDUR   incidence_rate conf.lev~ CI Confid~ 0.95      1       <NULL>  <NULL>
       7 TRTDUR   incidence_rate tot_pers~ Person-Da~ 29487     1       <NULL>  <NULL>
       8 TRTDUR   incidence_rate n_events  Number of~ 1191      0       <NULL>  <NULL>
       9 TRTDUR   incidence_rate n         Number of~ 225       0       <NULL>  <NULL>
      10 TRTDUR   incidence_rate N         Number of~ 254       0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 10 x 8
         variable context       stat_name stat_label stat       fmt_fun warning error 
         <chr>    <chr>         <chr>     <chr>      <list>     <list>  <list>  <list>
       1 TRTDUR   incidence_ra~ estimate  Incidence~ 2.019534   1       <NULL>  <NULL>
       2 TRTDUR   incidence_ra~ std.error Standard ~ 0.05851878 1       <NULL>  <NULL>
       3 TRTDUR   incidence_ra~ conf.low  CI Lower ~ 1.904839   1       <NULL>  <NULL>
       4 TRTDUR   incidence_ra~ conf.high CI Upper ~ 2.134229   1       <NULL>  <NULL>
       5 TRTDUR   incidence_ra~ conf.type CI Type    normal     <fn>    <NULL>  <NULL>
       6 TRTDUR   incidence_ra~ conf.lev~ CI Confid~ 0.95       1       <NULL>  <NULL>
       7 TRTDUR   incidence_ra~ tot_pers~ Person-Da~ 29487      1       <NULL>  <NULL>
       8 TRTDUR   incidence_ra~ n_events  Number of~ 1191       0       <NULL>  <NULL>
       9 TRTDUR   incidence_ra~ n         Number of~ 225        0       <NULL>  <NULL>
      10 TRTDUR   incidence_ra~ N         Number of~ 254        0       <NULL>  <NULL>

# ard_incidence_rate(conf.type) works

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 10 x 8
         variable context       stat_name stat_label stat       fmt_fun warning error 
         <chr>    <chr>         <chr>     <chr>      <list>     <list>  <list>  <list>
       1 AVAL     incidence_ra~ estimate  Incidence~ 0.6052335  1       <NULL>  <NULL>
       2 AVAL     incidence_ra~ std.error Standard ~ 0.05992705 1       <NULL>  <NULL>
       3 AVAL     incidence_ra~ conf.low  CI Lower ~ 0.4984728  1       <NULL>  <NULL>
       4 AVAL     incidence_ra~ conf.high CI Upper ~ 0.7348598  1       <NULL>  <NULL>
       5 AVAL     incidence_ra~ conf.type CI Type    normal-log <fn>    <NULL>  <NULL>
       6 AVAL     incidence_ra~ conf.lev~ CI Confid~ 0.95       1       <NULL>  <NULL>
       7 AVAL     incidence_ra~ tot_pers~ Person-Ye~ 16853      1       <NULL>  <NULL>
       8 AVAL     incidence_ra~ n_events  Number of~ 102        1       <NULL>  <NULL>
       9 AVAL     incidence_ra~ n         Number of~ 102        0       <NULL>  <NULL>
      10 AVAL     incidence_ra~ N         Number of~ 254        0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 10 x 8
         variable context       stat_name stat_label stat       fmt_fun warning error 
         <chr>    <chr>         <chr>     <chr>      <list>     <list>  <list>  <list>
       1 AVAL     incidence_ra~ estimate  Incidence~ 0.6052335  1       <NULL>  <NULL>
       2 AVAL     incidence_ra~ std.error Standard ~ 0.05992705 1       <NULL>  <NULL>
       3 AVAL     incidence_ra~ conf.low  CI Lower ~ 0.4934956  1       <NULL>  <NULL>
       4 AVAL     incidence_ra~ conf.high CI Upper ~ 0.7347122  1       <NULL>  <NULL>
       5 AVAL     incidence_ra~ conf.type CI Type    exact      <fn>    <NULL>  <NULL>
       6 AVAL     incidence_ra~ conf.lev~ CI Confid~ 0.95       1       <NULL>  <NULL>
       7 AVAL     incidence_ra~ tot_pers~ Person-Ye~ 16853      1       <NULL>  <NULL>
       8 AVAL     incidence_ra~ n_events  Number of~ 102        1       <NULL>  <NULL>
       9 AVAL     incidence_ra~ n         Number of~ 102        0       <NULL>  <NULL>
      10 AVAL     incidence_ra~ N         Number of~ 254        0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 10 x 8
         variable context       stat_name stat_label stat       fmt_fun warning error 
         <chr>    <chr>         <chr>     <chr>      <list>     <list>  <list>  <list>
       1 AVAL     incidence_ra~ estimate  Incidence~ 0.6052335  1       <NULL>  <NULL>
       2 AVAL     incidence_ra~ std.error Standard ~ 0.05992705 1       <NULL>  <NULL>
       3 AVAL     incidence_ra~ conf.low  CI Lower ~ 0.4961636  1       <NULL>  <NULL>
       4 AVAL     incidence_ra~ conf.high CI Upper ~ 0.731465   1       <NULL>  <NULL>
       5 AVAL     incidence_ra~ conf.type CI Type    byar       <fn>    <NULL>  <NULL>
       6 AVAL     incidence_ra~ conf.lev~ CI Confid~ 0.95       1       <NULL>  <NULL>
       7 AVAL     incidence_ra~ tot_pers~ Person-Ye~ 16853      1       <NULL>  <NULL>
       8 AVAL     incidence_ra~ n_events  Number of~ 102        1       <NULL>  <NULL>
       9 AVAL     incidence_ra~ n         Number of~ 102        0       <NULL>  <NULL>
      10 AVAL     incidence_ra~ N         Number of~ 254        0       <NULL>  <NULL>

# ard_incidence_rate() errors are handled correctly

    Code
      res <- ard_incidence_rate(adtte, time = SEX, count = CNSR, id = USUBJID)
    Condition
      Error in `ard_incidence_rate()`:
      ! The `time` variable must be of type <numeric/integer> but `SEX` is a character vector.

---

    Code
      res <- ard_incidence_rate(adtte, time = AVAL, count = CNSR, id = USUBJID,
        unit_label = 10)
    Condition
      Error in `ard_incidence_rate()`:
      ! The `unit_label` argument must be a string, not a number.

---

    Code
      res <- ard_incidence_rate(adtte, time = AVAL, count = CNSR, id = USUBJID,
        unit_label = "years", conf.type = "standard")
    Condition
      Error in `ard_incidence_rate()`:
      ! `conf.type` must be one of "normal", "normal-log", "exact", or "byar", not "standard".

