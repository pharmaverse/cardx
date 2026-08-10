# ard_emmeans_emmeans() works

    Code
      print(ard_emmeans_emmeans, columns = "all")
    Output
      # An ARD data frame: 16 x 10
         group1 variable variable_level context         stat_name  stat_label          stat                fmt_fun warning error 
         <chr>  <chr>    <list>         <chr>           <chr>      <chr>               <list>              <list>  <list>  <list>
       1 am     contrast 0              emmeans_emmeans estimate   Mean                0.7261156           <fn>    <NULL>  <NULL>
       2 am     contrast 0              emmeans_emmeans std.error  Standard Error      0.1651809           <fn>    <NULL>  <NULL>
       3 am     contrast 0              emmeans_emmeans df         Degrees of Freedom  Inf                 <fn>    <NULL>  <NULL>
       4 am     contrast 0              emmeans_emmeans n          n                   19                  <fn>    <NULL>  <NULL>
       5 am     contrast 0              emmeans_emmeans conf.low   CI Lower Bound      0.402367            <fn>    <NULL>  <NULL>
       6 am     contrast 0              emmeans_emmeans conf.high  CI Upper Bound      1.049864            <fn>    <NULL>  <NULL>
       7 am     contrast 0              emmeans_emmeans conf.level CI Confidence Level 0.95                <fn>    <NULL>  <NULL>
       8 am     contrast 0              emmeans_emmeans method     method              Least-squares means <fn>    <NULL>  <NULL>
       9 am     contrast 1              emmeans_emmeans estimate   Mean                0.1158561           <fn>    <NULL>  <NULL>
      10 am     contrast 1              emmeans_emmeans std.error  Standard Error      0.1171975           <fn>    <NULL>  <NULL>
      11 am     contrast 1              emmeans_emmeans df         Degrees of Freedom  Inf                 <fn>    <NULL>  <NULL>
      12 am     contrast 1              emmeans_emmeans n          n                   13                  <fn>    <NULL>  <NULL>
      13 am     contrast 1              emmeans_emmeans conf.low   CI Lower Bound      -0.1138467          <fn>    <NULL>  <NULL>
      14 am     contrast 1              emmeans_emmeans conf.high  CI Upper Bound      0.345559            <fn>    <NULL>  <NULL>
      15 am     contrast 1              emmeans_emmeans conf.level CI Confidence Level 0.95                <fn>    <NULL>  <NULL>
      16 am     contrast 1              emmeans_emmeans method     method              Least-squares means <fn>    <NULL>  <NULL>

# ard_emmeans_emmeans() errors are returned correctly

    Code
      print(ard, columns = "all")
    Output
      # An ARD data frame: 9 x 10
        group1 variable variable_level context         stat_name  stat_label          stat   fmt_fun warning error                                                                                                                                              
        <chr>  <chr>    <list>         <chr>           <chr>      <chr>               <list> <list>  <list>  <list>                                                                                                                                             
      1 am     contrast <NULL>         emmeans_emmeans estimate   Mean                <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not foun~
      2 am     contrast <NULL>         emmeans_emmeans std.error  Standard Error      <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not foun~
      3 am     contrast <NULL>         emmeans_emmeans df         Degrees of Freedom  <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not foun~
      4 am     contrast <NULL>         emmeans_emmeans conf.low   CI Lower Bound      <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not foun~
      5 am     contrast <NULL>         emmeans_emmeans conf.high  CI Upper Bound      <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not foun~
      6 am     contrast <NULL>         emmeans_emmeans p.value    p-value             <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not foun~
      7 am     contrast <NULL>         emmeans_emmeans conf.level CI Confidence Level <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not foun~
      8 am     contrast <NULL>         emmeans_emmeans method     method              <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not foun~
      9 am     contrast <NULL>         emmeans_emmeans n          n                   <NULL> <fn>    <NULL>  "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not foun~

---

    "There was an error evaluating the model `glm(formula = vs ~ am + mpg, data = ., family = nothing)`\nCaused by error:\n! object 'nothing' not found"

