# ard_aod_wald_test() works

    Code
      glm_ard_aod_waldtest[, 1:6]
    Output
      # An ARD data frame: 6 x 6
        variable    context       stat_name stat_label             stat fmt_fun
        <chr>       <chr>         <chr>     <chr>                <list>  <list>
      1 (Intercept) aod_wald_test df        Degrees of Freedom    1           1
      2 (Intercept) aod_wald_test statistic Statistic          7127.          1
      3 (Intercept) aod_wald_test p.value   p-value               0           1
      4 ARM         aod_wald_test df        Degrees of Freedom    2           1
      5 ARM         aod_wald_test statistic Statistic             1.05        1
      6 ARM         aod_wald_test p.value   p-value               0.593       1

