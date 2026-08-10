# ard_stats_mantelhaen_test() works

    Code
      print(ard_mantelhaentest, columns = "all")
    Output
      # An ARD data frame: 8 x 10
        group1 group2 variable context               stat_name   stat_label                                    stat                         fmt_fun warning error 
        <chr>  <chr>  <chr>    <chr>                 <chr>       <chr>                                         <list>                       <list>  <list>  <list>
      1 ARM    SEX    AGEGR1   stats_mantelhaen_test statistic   Generalized Cochran-Mantel-Haenszel Statistic 6.455033                     1       <NULL>  <NULL>
      2 ARM    SEX    AGEGR1   stats_mantelhaen_test p.value     p-value                                       0.1676458                    1       <NULL>  <NULL>
      3 ARM    SEX    AGEGR1   stats_mantelhaen_test parameter   Degrees of Freedom                            4                            1       <NULL>  <NULL>
      4 ARM    SEX    AGEGR1   stats_mantelhaen_test method      method                                        Cochran-Mantel-Haenszel test <fn>    <NULL>  <NULL>
      5 ARM    SEX    AGEGR1   stats_mantelhaen_test alternative alternative                                   two.sided                    <fn>    <NULL>  <NULL>
      6 ARM    SEX    AGEGR1   stats_mantelhaen_test correct     Continuity Correction                         TRUE                         <fn>    <NULL>  <NULL>
      7 ARM    SEX    AGEGR1   stats_mantelhaen_test exact       Exact Conditional Test                        FALSE                        <fn>    <NULL>  <NULL>
      8 ARM    SEX    AGEGR1   stats_mantelhaen_test conf.level  CI Confidence Level                           0.95                         1       <NULL>  <NULL>

---

    Code
      print(ard_mantelhaentest, columns = "all")
    Output
      # An ARD data frame: 8 x 10
        group1 group2 variable context               stat_name   stat_label                          stat                         fmt_fun warning error 
        <chr>  <chr>  <chr>    <chr>                 <chr>       <chr>                               <list>                       <list>  <list>  <list>
      1 ARM    SEX    AGEGR1   stats_mantelhaen_test statistic   Mantel-Haenszel X-squared Statistic 6.455033                     1       <NULL>  <NULL>
      2 ARM    SEX    AGEGR1   stats_mantelhaen_test p.value     p-value                             0.1676458                    1       <NULL>  <NULL>
      3 ARM    SEX    AGEGR1   stats_mantelhaen_test parameter   Degrees of Freedom                  4                            1       <NULL>  <NULL>
      4 ARM    SEX    AGEGR1   stats_mantelhaen_test method      method                              Cochran-Mantel-Haenszel test <fn>    <NULL>  <NULL>
      5 ARM    SEX    AGEGR1   stats_mantelhaen_test alternative alternative                         less                         <fn>    <NULL>  <NULL>
      6 ARM    SEX    AGEGR1   stats_mantelhaen_test correct     Continuity Correction               FALSE                        <fn>    <NULL>  <NULL>
      7 ARM    SEX    AGEGR1   stats_mantelhaen_test exact       Exact Conditional Test              TRUE                         <fn>    <NULL>  <NULL>
      8 ARM    SEX    AGEGR1   stats_mantelhaen_test conf.level  CI Confidence Level                 0.9                          1       <NULL>  <NULL>

