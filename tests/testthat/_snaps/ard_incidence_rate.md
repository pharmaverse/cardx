# ard_incidence_rate() works

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 10 x 8
         variable context     stat_name stat_label stat         fmt_fun warning error 
         <chr>    <chr>       <chr>     <chr>      <list>       <list>  <list>  <list>
       1 AVAL     incidence_~ estimate  Incidence~ 0.9019166    1       <NULL>  <NULL>
       2 AVAL     incidence_~ std.error Standard ~ 0.0007315509 1       <NULL>  <NULL>
       3 AVAL     incidence_~ conf.low  CI Lower ~ 0.7585352    1       <NULL>  <NULL>
       4 AVAL     incidence_~ conf.high CI Upper ~ 1.045298     1       <NULL>  <NULL>
       5 AVAL     incidence_~ conf.type CI Type    normal       <fn>    <NULL>  <NULL>
       6 AVAL     incidence_~ conf.lev~ CI Confid~ 0.95         1       <NULL>  <NULL>
       7 AVAL     incidence_~ tot_pers~ Person-Ye~ 16853        1       <NULL>  <NULL>
       8 AVAL     incidence_~ n_events  Number of~ 152          1       <NULL>  <NULL>
       9 AVAL     incidence_~ n         Number of~ 152          0       <NULL>  <NULL>
      10 AVAL     incidence_~ N         Number of~ 254          0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 10 x 8
         variable context      stat_name stat_label stat        fmt_fun warning error 
         <chr>    <chr>        <chr>     <chr>      <list>      <list>  <list>  <list>
       1 TRTDUR   incidence_r~ estimate  Incidence~ 4.039068    1       <NULL>  <NULL>
       2 TRTDUR   incidence_r~ std.error Standard ~ 0.001170376 1       <NULL>  <NULL>
       3 TRTDUR   incidence_r~ conf.low  CI Lower ~ 3.809679    1       <NULL>  <NULL>
       4 TRTDUR   incidence_r~ conf.high CI Upper ~ 4.268457    1       <NULL>  <NULL>
       5 TRTDUR   incidence_r~ conf.type CI Type    normal      <fn>    <NULL>  <NULL>
       6 TRTDUR   incidence_r~ conf.lev~ CI Confid~ 0.95        1       <NULL>  <NULL>
       7 TRTDUR   incidence_r~ tot_pers~ Person-Da~ 29487       1       <NULL>  <NULL>
       8 TRTDUR   incidence_r~ n_events  Number of~ 1191        0       <NULL>  <NULL>
       9 TRTDUR   incidence_r~ n         Number of~ 225         0       <NULL>  <NULL>
      10 TRTDUR   incidence_r~ N         Number of~ 254         0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 10 x 8
         variable context      stat_name stat_label stat        fmt_fun warning error 
         <chr>    <chr>        <chr>     <chr>      <list>      <list>  <list>  <list>
       1 TRTDUR   incidence_r~ estimate  Incidence~ 2.019534    1       <NULL>  <NULL>
       2 TRTDUR   incidence_r~ std.error Standard ~ 0.001170376 1       <NULL>  <NULL>
       3 TRTDUR   incidence_r~ conf.low  CI Lower ~ 1.904839    1       <NULL>  <NULL>
       4 TRTDUR   incidence_r~ conf.high CI Upper ~ 2.134229    1       <NULL>  <NULL>
       5 TRTDUR   incidence_r~ conf.type CI Type    normal      <fn>    <NULL>  <NULL>
       6 TRTDUR   incidence_r~ conf.lev~ CI Confid~ 0.95        1       <NULL>  <NULL>
       7 TRTDUR   incidence_r~ tot_pers~ Person-Da~ 29487       1       <NULL>  <NULL>
       8 TRTDUR   incidence_r~ n_events  Number of~ 1191        0       <NULL>  <NULL>
       9 TRTDUR   incidence_r~ n         Number of~ 225         0       <NULL>  <NULL>
      10 TRTDUR   incidence_r~ N         Number of~ 254         0       <NULL>  <NULL>

# ard_incidence_rate(conf.type) works

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 10 x 8
         variable context     stat_name stat_label stat         fmt_fun warning error 
         <chr>    <chr>       <chr>     <chr>      <list>       <list>  <list>  <list>
       1 AVAL     incidence_~ estimate  Incidence~ 0.9019166    1       <NULL>  <NULL>
       2 AVAL     incidence_~ std.error Standard ~ 0.0007315509 1       <NULL>  <NULL>
       3 AVAL     incidence_~ conf.low  CI Lower ~ 0.7693515    1       <NULL>  <NULL>
       4 AVAL     incidence_~ conf.high CI Upper ~ 1.057324     1       <NULL>  <NULL>
       5 AVAL     incidence_~ conf.type CI Type    normal-log   <fn>    <NULL>  <NULL>
       6 AVAL     incidence_~ conf.lev~ CI Confid~ 0.95         1       <NULL>  <NULL>
       7 AVAL     incidence_~ tot_pers~ Person-Ye~ 16853        1       <NULL>  <NULL>
       8 AVAL     incidence_~ n_events  Number of~ 152          1       <NULL>  <NULL>
       9 AVAL     incidence_~ n         Number of~ 152          0       <NULL>  <NULL>
      10 AVAL     incidence_~ N         Number of~ 254          0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 10 x 8
         variable context     stat_name stat_label stat         fmt_fun warning error 
         <chr>    <chr>       <chr>     <chr>      <list>       <list>  <list>  <list>
       1 AVAL     incidence_~ estimate  Incidence~ 0.9019166    1       <NULL>  <NULL>
       2 AVAL     incidence_~ std.error Standard ~ 0.0007315509 1       <NULL>  <NULL>
       3 AVAL     incidence_~ conf.low  CI Lower ~ 0.7642353    1       <NULL>  <NULL>
       4 AVAL     incidence_~ conf.high CI Upper ~ 1.057238     1       <NULL>  <NULL>
       5 AVAL     incidence_~ conf.type CI Type    exact        <fn>    <NULL>  <NULL>
       6 AVAL     incidence_~ conf.lev~ CI Confid~ 0.95         1       <NULL>  <NULL>
       7 AVAL     incidence_~ tot_pers~ Person-Ye~ 16853        1       <NULL>  <NULL>
       8 AVAL     incidence_~ n_events  Number of~ 152          1       <NULL>  <NULL>
       9 AVAL     incidence_~ n         Number of~ 152          0       <NULL>  <NULL>
      10 AVAL     incidence_~ N         Number of~ 254          0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 10 x 8
         variable context     stat_name stat_label stat         fmt_fun warning error 
         <chr>    <chr>       <chr>     <chr>      <list>       <list>  <list>  <list>
       1 AVAL     incidence_~ estimate  Incidence~ 0.9019166    1       <NULL>  <NULL>
       2 AVAL     incidence_~ std.error Standard ~ 0.0007315509 1       <NULL>  <NULL>
       3 AVAL     incidence_~ conf.low  CI Lower ~ 0.7669576    1       <NULL>  <NULL>
       4 AVAL     incidence_~ conf.high CI Upper ~ 1.054041     1       <NULL>  <NULL>
       5 AVAL     incidence_~ conf.type CI Type    byar         <fn>    <NULL>  <NULL>
       6 AVAL     incidence_~ conf.lev~ CI Confid~ 0.95         1       <NULL>  <NULL>
       7 AVAL     incidence_~ tot_pers~ Person-Ye~ 16853        1       <NULL>  <NULL>
       8 AVAL     incidence_~ n_events  Number of~ 152          1       <NULL>  <NULL>
       9 AVAL     incidence_~ n         Number of~ 152          0       <NULL>  <NULL>
      10 AVAL     incidence_~ N         Number of~ 254          0       <NULL>  <NULL>

# ard_incidence_rate() errors are handled correctly

    Code
      res <- ard_incidence_rate(adtte, time = SEX, count = EVENT, id = USUBJID)
    Condition
      Error in `ard_incidence_rate()`:
      ! The `time` variable must be of type <numeric/integer> but `SEX` is a character vector.

---

    Code
      res <- ard_incidence_rate(adtte, time = AVAL, count = EVENT, id = USUBJID,
        unit_label = 10)
    Condition
      Error in `ard_incidence_rate()`:
      ! The `unit_label` argument must be a string, not a number.

---

    Code
      res <- ard_incidence_rate(adtte, time = AVAL, count = EVENT, id = USUBJID,
        unit_label = "years", conf.type = "standard")
    Condition
      Error in `ard_incidence_rate()`:
      ! `conf.type` must be one of "normal", "normal-log", "exact", or "byar", not "standard".

