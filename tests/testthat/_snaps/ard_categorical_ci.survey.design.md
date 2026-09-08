# ard_categorical_ci.survey.design(data)

    Code
      dplyr::select(ard_categorical_ci(dclus1, variables = c(both, awards)), -warning,
      -error, -fmt_fun, -context)
    Output
      # An ARD data frame: 20 x 5
         variable variable_level stat_name  stat_label stat     
         <chr>    <list>         <chr>      <chr>      <list>   
       1 both     No             estimate   estimate   0.26     
       2 both     No             conf.low   conf.low   0.1166025
       3 both     No             conf.high  conf.high  0.4832731
       4 both     No             method     method     logit    
       5 both     No             conf.level conf.level 0.95     
       6 both     Yes            estimate   estimate   0.74     
       7 both     Yes            conf.low   conf.low   0.5167269
       8 both     Yes            conf.high  conf.high  0.8833975
       9 both     Yes            method     method     logit    
      10 both     Yes            conf.level conf.level 0.95     
      11 awards   No             estimate   estimate   0.28     
      12 awards   No             conf.low   conf.low   0.1351153
      13 awards   No             conf.high  conf.high  0.4918869
      14 awards   No             method     method     logit    
      15 awards   No             conf.level conf.level 0.95     
      16 awards   Yes            estimate   estimate   0.72     
      17 awards   Yes            conf.low   conf.low   0.5081131
      18 awards   Yes            conf.high  conf.high  0.8648847
      19 awards   Yes            method     method     logit    
      20 awards   Yes            conf.level conf.level 0.95     

# ard_categorical_ci.svyrep.design(data)

    Code
      dplyr::select(ard_categorical_ci(rclus1, variables = c(both, awards)), -warning,
      -error, -fmt_fun, -context)
    Output
      # An ARD data frame: 20 x 5
         variable variable_level stat_name  stat_label stat     
         <chr>    <list>         <chr>      <chr>      <list>   
       1 both     No             estimate   estimate   0.26     
       2 both     No             conf.low   conf.low   0.1126733
       3 both     No             conf.high  conf.high  0.4929465
       4 both     No             method     method     logit    
       5 both     No             conf.level conf.level 0.95     
       6 both     Yes            estimate   estimate   0.74     
       7 both     Yes            conf.low   conf.low   0.5070535
       8 both     Yes            conf.high  conf.high  0.8873267
       9 both     Yes            method     method     logit    
      10 both     Yes            conf.level conf.level 0.95     
      11 awards   No             estimate   estimate   0.28     
      12 awards   No             conf.low   conf.low   0.1312269
      13 awards   No             conf.high  conf.high  0.5003077
      14 awards   No             method     method     logit    
      15 awards   No             conf.level conf.level 0.95     
      16 awards   Yes            estimate   estimate   0.72     
      17 awards   Yes            conf.low   conf.low   0.4996923
      18 awards   Yes            conf.high  conf.high  0.8687731
      19 awards   Yes            method     method     logit    
      20 awards   Yes            conf.level conf.level 0.95     

