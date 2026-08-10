# ard_incidence_rate() works

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 9 x 8
        variable context      stat_name stat_label stat         fmt_fun warning error 
        <chr>    <chr>        <chr>     <chr>      <list>       <list>  <list>  <list>
      1 AVAL     incidence_r~ estimate  Incidence~ 0.6052335    1       <NULL>  <NULL>
      2 AVAL     incidence_r~ std.error Standard ~ 0.0005992705 1       <NULL>  <NULL>
      3 AVAL     incidence_r~ conf.low  CI Lower ~ 0.4877786    1       <NULL>  <NULL>
      4 AVAL     incidence_r~ conf.high CI Upper ~ 0.7226883    1       <NULL>  <NULL>
      5 AVAL     incidence_r~ conf.type CI Type    normal       <fn>    <NULL>  <NULL>
      6 AVAL     incidence_r~ conf.lev~ CI Confid~ 0.95         1       <NULL>  <NULL>
      7 AVAL     incidence_r~ tot_pers~ Person-Ye~ 16853        1       <NULL>  <NULL>
      8 AVAL     incidence_r~ n_events  Number of~ 102          1       <NULL>  <NULL>
      9 AVAL     incidence_r~ N         Number of~ 254          0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 9 x 8
        variable context      stat_name stat_label stat         fmt_fun warning error 
        <chr>    <chr>        <chr>     <chr>      <list>       <list>  <list>  <list>
      1 time     incidence_r~ estimate  Incidence~ 2.187109     1       <NULL>  <NULL>
      2 time     incidence_r~ std.error Standard ~ 0.0006491909 1       <NULL>  <NULL>
      3 time     incidence_r~ conf.low  CI Lower ~ 2.05987      1       <NULL>  <NULL>
      4 time     incidence_r~ conf.high CI Upper ~ 2.314348     1       <NULL>  <NULL>
      5 time     incidence_r~ conf.type CI Type    normal       <fn>    <NULL>  <NULL>
      6 time     incidence_r~ conf.lev~ CI Confid~ 0.95         1       <NULL>  <NULL>
      7 time     incidence_r~ tot_pers~ Person-Da~ 51895        1       <NULL>  <NULL>
      8 time     incidence_r~ n_events  Number of~ 1135         0       <NULL>  <NULL>
      9 time     incidence_r~ N         Number of~ 217          0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 9 x 8
        variable context      stat_name stat_label stat         fmt_fun warning error 
        <chr>    <chr>        <chr>     <chr>      <list>       <list>  <list>  <list>
      1 time     incidence_r~ estimate  Incidence~ 2.154346     1       <NULL>  <NULL>
      2 time     incidence_r~ std.error Standard ~ 0.0006271544 1       <NULL>  <NULL>
      3 time     incidence_r~ conf.low  CI Lower ~ 2.031426     1       <NULL>  <NULL>
      4 time     incidence_r~ conf.high CI Upper ~ 2.277266     1       <NULL>  <NULL>
      5 time     incidence_r~ conf.type CI Type    normal       <fn>    <NULL>  <NULL>
      6 time     incidence_r~ conf.lev~ CI Confid~ 0.95         1       <NULL>  <NULL>
      7 time     incidence_r~ tot_pers~ Person-Da~ 54773        1       <NULL>  <NULL>
      8 time     incidence_r~ n_events  Number of~ 1180         0       <NULL>  <NULL>
      9 time     incidence_r~ N         Number of~ 1180         0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 9 x 8
        variable context      stat_name stat_label stat         fmt_fun warning error 
        <chr>    <chr>        <chr>     <chr>      <list>       <list>  <list>  <list>
      1 time     incidence_r~ estimate  Incidence~ 1.077173     1       <NULL>  <NULL>
      2 time     incidence_r~ std.error Standard ~ 0.0006271544 1       <NULL>  <NULL>
      3 time     incidence_r~ conf.low  CI Lower ~ 1.015713     1       <NULL>  <NULL>
      4 time     incidence_r~ conf.high CI Upper ~ 1.138633     1       <NULL>  <NULL>
      5 time     incidence_r~ conf.type CI Type    normal       <fn>    <NULL>  <NULL>
      6 time     incidence_r~ conf.lev~ CI Confid~ 0.95         1       <NULL>  <NULL>
      7 time     incidence_r~ tot_pers~ Person-Da~ 54773        1       <NULL>  <NULL>
      8 time     incidence_r~ n_events  Number of~ 1180         0       <NULL>  <NULL>
      9 time     incidence_r~ N         Number of~ 224          0       <NULL>  <NULL>

# ard_incidence_rate(conf.type) works

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 9 x 8
        variable context      stat_name stat_label stat         fmt_fun warning error 
        <chr>    <chr>        <chr>     <chr>      <list>       <list>  <list>  <list>
      1 AVAL     incidence_r~ estimate  Incidence~ 0.6052335    1       <NULL>  <NULL>
      2 AVAL     incidence_r~ std.error Standard ~ 0.0005992705 1       <NULL>  <NULL>
      3 AVAL     incidence_r~ conf.low  CI Lower ~ 0.4984728    1       <NULL>  <NULL>
      4 AVAL     incidence_r~ conf.high CI Upper ~ 0.7348598    1       <NULL>  <NULL>
      5 AVAL     incidence_r~ conf.type CI Type    normal-log   <fn>    <NULL>  <NULL>
      6 AVAL     incidence_r~ conf.lev~ CI Confid~ 0.95         1       <NULL>  <NULL>
      7 AVAL     incidence_r~ tot_pers~ Person-Ye~ 16853        1       <NULL>  <NULL>
      8 AVAL     incidence_r~ n_events  Number of~ 102          1       <NULL>  <NULL>
      9 AVAL     incidence_r~ N         Number of~ 254          0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 9 x 8
        variable context      stat_name stat_label stat         fmt_fun warning error 
        <chr>    <chr>        <chr>     <chr>      <list>       <list>  <list>  <list>
      1 AVAL     incidence_r~ estimate  Incidence~ 0.6052335    1       <NULL>  <NULL>
      2 AVAL     incidence_r~ std.error Standard ~ 0.0005992705 1       <NULL>  <NULL>
      3 AVAL     incidence_r~ conf.low  CI Lower ~ 0.4934956    1       <NULL>  <NULL>
      4 AVAL     incidence_r~ conf.high CI Upper ~ 0.7347122    1       <NULL>  <NULL>
      5 AVAL     incidence_r~ conf.type CI Type    exact        <fn>    <NULL>  <NULL>
      6 AVAL     incidence_r~ conf.lev~ CI Confid~ 0.95         1       <NULL>  <NULL>
      7 AVAL     incidence_r~ tot_pers~ Person-Ye~ 16853        1       <NULL>  <NULL>
      8 AVAL     incidence_r~ n_events  Number of~ 102          1       <NULL>  <NULL>
      9 AVAL     incidence_r~ N         Number of~ 254          0       <NULL>  <NULL>

---

    Code
      print(res, columns = "all")
    Output
      # An ARD data frame: 9 x 8
        variable context      stat_name stat_label stat         fmt_fun warning error 
        <chr>    <chr>        <chr>     <chr>      <list>       <list>  <list>  <list>
      1 AVAL     incidence_r~ estimate  Incidence~ 0.6052335    1       <NULL>  <NULL>
      2 AVAL     incidence_r~ std.error Standard ~ 0.0005992705 1       <NULL>  <NULL>
      3 AVAL     incidence_r~ conf.low  CI Lower ~ 0.4961636    1       <NULL>  <NULL>
      4 AVAL     incidence_r~ conf.high CI Upper ~ 0.731465     1       <NULL>  <NULL>
      5 AVAL     incidence_r~ conf.type CI Type    byar         <fn>    <NULL>  <NULL>
      6 AVAL     incidence_r~ conf.lev~ CI Confid~ 0.95         1       <NULL>  <NULL>
      7 AVAL     incidence_r~ tot_pers~ Person-Ye~ 16853        1       <NULL>  <NULL>
      8 AVAL     incidence_r~ n_events  Number of~ 102          1       <NULL>  <NULL>
      9 AVAL     incidence_r~ N         Number of~ 254          0       <NULL>  <NULL>

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

