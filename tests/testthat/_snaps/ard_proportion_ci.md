# ard_categorical_ci(method='strat_wilson') works

    Code
      ard_categorical_ci_strat_wilson
    Output
      # An ARD data frame: 7 x 9
        variable variable_level context       stat_name  stat_label stat                                                                fmt_fun warning error 
        <chr>    <list>         <chr>         <chr>      <chr>      <list>                                                              <list>  <list>  <list>
      1 rsp      TRUE           proportion_ci N          N          80                                                                  0       <NULL>  <NULL>
      2 rsp      TRUE           proportion_ci n          n          50                                                                  0       <NULL>  <NULL>
      3 rsp      TRUE           proportion_ci estimate   estimate   0.625                                                               1       <NULL>  <NULL>
      4 rsp      TRUE           proportion_ci conf.low   conf.low   0.4867191                                                           1       <NULL>  <NULL>
      5 rsp      TRUE           proportion_ci conf.high  conf.high  0.7186381                                                           1       <NULL>  <NULL>
      6 rsp      TRUE           proportion_ci conf.level conf.level 0.95                                                                1       <NULL>  <NULL>
      7 rsp      TRUE           proportion_ci method     method     Stratified Wilson Confidence Interval without continuity correction <fn>    <NULL>  <NULL>

---

    Code
      ard_categorical_ci_strat_wilsoncc
    Output
      # An ARD data frame: 7 x 9
        variable variable_level context       stat_name  stat_label stat                                                             fmt_fun warning error 
        <chr>    <list>         <chr>         <chr>      <chr>      <list>                                                           <list>  <list>  <list>
      1 rsp      TRUE           proportion_ci N          N          80                                                               0       <NULL>  <NULL>
      2 rsp      TRUE           proportion_ci n          n          50                                                               0       <NULL>  <NULL>
      3 rsp      TRUE           proportion_ci estimate   estimate   0.625                                                            1       <NULL>  <NULL>
      4 rsp      TRUE           proportion_ci conf.low   conf.low   0.4482566                                                        1       <NULL>  <NULL>
      5 rsp      TRUE           proportion_ci conf.high  conf.high  0.7531474                                                        1       <NULL>  <NULL>
      6 rsp      TRUE           proportion_ci conf.level conf.level 0.95                                                             1       <NULL>  <NULL>
      7 rsp      TRUE           proportion_ci method     method     Stratified Wilson Confidence Interval with continuity correction <fn>    <NULL>  <NULL>

# ard_categorical_ci() messaging

    Code
      ard <- ard_categorical_ci(data = mtcars, variables = cyl, value = cyl ~ 10,
      method = "jeffreys")
    Condition
      Warning:
      A value of `value=10` for variable "cyl" was passed, but is not one of the observed levels: 4, 6, and 8.
      i This may be an error.
      i If value is a valid, convert variable to factor with all levels specified to avoid this message.

