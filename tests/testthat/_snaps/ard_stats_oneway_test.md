# ard_stats_oneway_test() works

    Code
      head(dplyr::select(ard_stats_oneway_test(AGEGR1 ~ ARM, data = cards::ADSL), c(
        "stat_name", "stat", "warning")), 3)
    Output
      # An ARD data frame: 3 x 3
        stat_name stat         warning     
        <chr>     <named list> <named list>
      1 num.df    2            <chr [6]>   
      2 den.df    NA           <chr [6]>   
      3 statistic NA           <chr [6]>   

