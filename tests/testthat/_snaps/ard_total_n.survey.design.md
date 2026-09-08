# ard_total_n.survey.design() works

    Code
      ard_total_n(survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq))
    Output
      # An ARD data frame: 2 x 8
        variable        context stat_name    stat_label    stat fmt_fun warning error 
        <chr>           <chr>   <chr>        <chr>        <lis> <list>  <list>  <list>
      1 ..ard_total_n.. total_n N            N             1490 <fn>    <NULL>  <NULL>
      2 ..ard_total_n.. total_n N_unweighted Unweighted N    16 <fn>    <NULL>  <NULL>

# ard_total_n.svyrep.design() works

    Code
      ard_total_n(rsvy_titanic)
    Output
      # An ARD data frame: 2 x 8
        variable        context stat_name    stat_label    stat fmt_fun warning error 
        <chr>           <chr>   <chr>        <chr>        <lis> <list>  <list>  <list>
      1 ..ard_total_n.. total_n N            N             1490 <fn>    <NULL>  <NULL>
      2 ..ard_total_n.. total_n N_unweighted Unweighted N    16 <fn>    <NULL>  <NULL>

