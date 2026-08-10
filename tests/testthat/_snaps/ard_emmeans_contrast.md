# ard_emmeans_contrast() works

    Code
      print(ard_emmeans_contrast, columns = "all")
    Output
      # An ARD data frame: 8 x 10
        group1 variable variable_level context          stat_name  stat_label          stat                                   fmt_fun warning error 
        <chr>  <chr>    <list>         <chr>            <chr>      <chr>               <list>                                 <list>  <list>  <list>
      1 am     contrast am0 - am1      emmeans_contrast estimate   Mean Difference     0.6102595                              1       <NULL>  <NULL>
      2 am     contrast am0 - am1      emmeans_contrast std.error  Standard Error      0.2289453                              1       <NULL>  <NULL>
      3 am     contrast am0 - am1      emmeans_contrast df         Degrees of Freedom  Inf                                    1       <NULL>  <NULL>
      4 am     contrast am0 - am1      emmeans_contrast conf.low   CI Lower Bound      0.161535                               1       <NULL>  <NULL>
      5 am     contrast am0 - am1      emmeans_contrast conf.high  CI Upper Bound      1.058984                               1       <NULL>  <NULL>
      6 am     contrast am0 - am1      emmeans_contrast p.value    p-value             0.007686806                            1       <NULL>  <NULL>
      7 am     contrast am0 - am1      emmeans_contrast conf.level CI Confidence Level 0.95                                   1       <NULL>  <NULL>
      8 am     contrast am0 - am1      emmeans_contrast method     method              Least-squares adjusted mean difference <fn>    <NULL>  <NULL>

# ard_emmeans_contrast() errors are returned correctly

    Code
      print(ard, columns = "all")
    Output
      # An ARD data frame: 8 x 10
        group1 variable variable_level context          stat_name  stat_label          stat   fmt_fun warning error                                                                                                                                             
        <chr>  <chr>    <list>         <chr>            <chr>      <chr>               <list> <list>  <list>  <list>                                                                                                                                            
      1 am     contrast <NULL>         emmeans_contrast estimate   Mean Difference     <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not fou~
      2 am     contrast <NULL>         emmeans_contrast std.error  Standard Error      <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not fou~
      3 am     contrast <NULL>         emmeans_contrast df         Degrees of Freedom  <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not fou~
      4 am     contrast <NULL>         emmeans_contrast conf.low   CI Lower Bound      <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not fou~
      5 am     contrast <NULL>         emmeans_contrast conf.high  CI Upper Bound      <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not fou~
      6 am     contrast <NULL>         emmeans_contrast p.value    p-value             <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not fou~
      7 am     contrast <NULL>         emmeans_contrast conf.level CI Confidence Level <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not fou~
      8 am     contrast <NULL>         emmeans_contrast method     method              <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not fou~

---

    "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not found"

