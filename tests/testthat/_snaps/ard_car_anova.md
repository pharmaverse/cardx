# ard_car_anova() works

    Code
      glm_ard_car_anova
    Output
      # An ARD data frame: 6 x 8
        variable    context   stat_name stat_label         stat fmt_fun warning error 
        <chr>       <chr>     <chr>     <chr>            <list>  <list> <named> <name>
      1 factor(cyl) car_anova statistic Statistic      9.59 e-6       1 <NULL>  <NULL>
      2 factor(cyl) car_anova df        Degrees of Fr~ 2    e+0       1 <NULL>  <NULL>
      3 factor(cyl) car_anova p.value   p-value        1.000e+0       1 <NULL>  <NULL>
      4 factor(am)  car_anova statistic Statistic      5.65 e-6       1 <NULL>  <NULL>
      5 factor(am)  car_anova df        Degrees of Fr~ 1    e+0       1 <NULL>  <NULL>
      6 factor(am)  car_anova p.value   p-value        9.98 e-1       1 <NULL>  <NULL>

# ard_car_anova() messaging

    Code
      ard_car_anova(mtcars)
    Condition
      Error in `ard_car_anova()`:
      ! There was an error running `car::Anova()`. See error message below.
      x no applicable method for 'vcov' applied to an object of class "data.frame"

