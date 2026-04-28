# ard_stats_mood_test() works

    Code
      as.data.frame(ard_stats_mood_test(cards::ADSL[1:10, ], by = SEX, variable = AGE))
    Output
        group1 variable         context   stat_name             stat_label                          stat fmt_fun warning error
      1    SEX      AGE stats_mood_test   statistic            Z-Statistic                     0.6741999       1    NULL  NULL
      2    SEX      AGE stats_mood_test     p.value                p-value                     0.5001843       1    NULL  NULL
      3    SEX      AGE stats_mood_test      method                 method Mood two-sample test of scale    NULL    NULL  NULL
      4    SEX      AGE stats_mood_test alternative Alternative Hypothesis                     two.sided    NULL    NULL  NULL

