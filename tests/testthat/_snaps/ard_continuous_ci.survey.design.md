# ard_continuous_ci(data)

    Code
      dplyr::select(as.data.frame(ard_continuous_ci(dclus1, variables = c(api00,
        api99))), -warning, -error)
    Output
         variable              context  stat_name stat_label     stat fmt_fun
      1     api00 survey_continuous_ci   estimate   estimate 644.1694       2
      2     api00 survey_continuous_ci  std.error  std.error 23.54224       2
      3     api00 survey_continuous_ci   conf.low   conf.low 593.6763       2
      4     api00 survey_continuous_ci  conf.high  conf.high 694.6625       2
      5     api00 survey_continuous_ci conf.level conf.level     0.95       2
      6     api99 survey_continuous_ci   estimate   estimate 606.9781       2
      7     api99 survey_continuous_ci  std.error  std.error 24.22504       2
      8     api99 survey_continuous_ci   conf.low   conf.low 555.0206       2
      9     api99 survey_continuous_ci  conf.high  conf.high 658.9357       2
      10    api99 survey_continuous_ci conf.level conf.level     0.95       2

# ard_continuous_ci() errors are captured

    Code
      ard_continuous_ci(dclus1, variables = c(api00, api99), df = letters)
    Output
      # An ARD data frame: 10 x 8
         variable context            stat_name stat_label stat   fmt_fun warning error
       * <chr>    <chr>              <chr>     <chr>      <list> <list>  <list>  <lis>
       1 api00    survey_continuous~ estimate  estimate   <NULL> <fn>    <NULL>  Non-~
       2 api00    survey_continuous~ std.error std.error  <NULL> <fn>    <NULL>  Non-~
       3 api00    survey_continuous~ conf.low  conf.low   <NULL> <fn>    <NULL>  Non-~
       4 api00    survey_continuous~ conf.high conf.high  <NULL> <fn>    <NULL>  Non-~
       5 api00    survey_continuous~ conf.lev~ conf.level 0.95   2       <NULL>  Non-~
       6 api99    survey_continuous~ estimate  estimate   <NULL> <fn>    <NULL>  Non-~
       7 api99    survey_continuous~ std.error std.error  <NULL> <fn>    <NULL>  Non-~
       8 api99    survey_continuous~ conf.low  conf.low   <NULL> <fn>    <NULL>  Non-~
       9 api99    survey_continuous~ conf.high conf.high  <NULL> <fn>    <NULL>  Non-~
      10 api99    survey_continuous~ conf.lev~ conf.level 0.95   2       <NULL>  Non-~

---

    Code
      ard_continuous_ci(dclus1, variables = sch.wide, method = "svymedian.beta")
    Message
      Column "sch.wide" is not <numeric> and results may be an unexpected format.
    Output
      # An ARD data frame: 5 x 8
        variable context             stat_name stat_label stat   fmt_fun warning error
      * <chr>    <chr>               <chr>     <chr>      <list> <list>  <list>  <lis>
      1 sch.wide survey_continuous_~ estimate  estimate   <NULL> <fn>    '<=' n~ erro~
      2 sch.wide survey_continuous_~ std.error std.error  <NULL> <fn>    '<=' n~ erro~
      3 sch.wide survey_continuous_~ conf.low  conf.low   <NULL> <fn>    '<=' n~ erro~
      4 sch.wide survey_continuous_~ conf.high conf.high  <NULL> <fn>    '<=' n~ erro~
      5 sch.wide survey_continuous_~ conf.lev~ conf.level 0.95   2       '<=' n~ erro~

