# unstratified ard_summary.survey.design() works

    Code
      ard_uni_svy_cont
    Output
      # An ARD data frame: 10 x 8
         variable context    stat_name      stat_label     stat fmt_fun warning error 
         <chr>    <chr>      <chr>          <chr>        <list>  <list> <list>  <list>
       1 api00    continuous mean           Mean         6.44e2       1 <NULL>  <NULL>
       2 api00    continuous median         Median       6.52e2       1 <NULL>  <NULL>
       3 api00    continuous min            Minimum      4.11e2       1 <NULL>  <NULL>
       4 api00    continuous max            Maximum      9.05e2       1 <NULL>  <NULL>
       5 api00    continuous sum            Sum          3.99e6       1 <NULL>  <NULL>
       6 api00    continuous var            Variance     1.12e4       1 <NULL>  <NULL>
       7 api00    continuous sd             Standard De~ 1.06e2       1 <NULL>  <NULL>
       8 api00    continuous mean.std.error SE(Mean)     2.35e1       1 <NULL>  <NULL>
       9 api00    continuous deff           Design Effe~ 9.35e0       1 <NULL>  <NULL>
      10 api00    continuous p75            75% Percent~ 7.19e2       1 <NULL>  <NULL>

# ard_summary.survey.design(fmt_fun)

    Code
      as.data.frame(dplyr::select(ard_summary(dclus1, variables = c(api99, api00),
      statistic = ~ c("mean", "median", "min", "max"), fmt_fun = list(api00 = list(
        mean = 2, median = "xx.xx", min = as.character))), -warning, -error))
    Output
        variable    context stat_name stat_label     stat                    fmt_fun
      1    api99 continuous      mean       Mean 606.9781                          1
      2    api99 continuous    median     Median      615                          1
      3    api99 continuous       min    Minimum      365                          1
      4    api99 continuous       max    Maximum      890                          1
      5    api00 continuous      mean       Mean 644.1694                          2
      6    api00 continuous    median     Median      652                      xx.xx
      7    api00 continuous       min    Minimum      411 .Primitive("as.character")
      8    api00 continuous       max    Maximum      905                          1

# ard_summary.survey.design(stat_label)

    Code
      as.data.frame(ard_summary(dclus1, variables = c(api00, api99), statistic = ~ c(
        "mean", "median", "min", "max"), stat_label = list(api00 = list(mean = "MeAn",
        median = "MEDian", min = "MINimum"))))
    Output
        variable    context stat_name stat_label     stat fmt_fun warning error
      1    api00 continuous      mean       MeAn 644.1694       1    NULL  NULL
      2    api00 continuous    median     MEDian      652       1    NULL  NULL
      3    api00 continuous       min    MINimum      411       1    NULL  NULL
      4    api00 continuous       max    Maximum      905       1    NULL  NULL
      5    api99 continuous      mean       Mean 606.9781       1    NULL  NULL
      6    api99 continuous    median     Median      615       1    NULL  NULL
      7    api99 continuous       min    Minimum      365       1    NULL  NULL
      8    api99 continuous       max    Maximum      890       1    NULL  NULL

