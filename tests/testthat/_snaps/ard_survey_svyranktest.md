# ard_survey_svyranktest() works for survey.design objects

    Code
      dplyr::select(as.data.frame(svyranktest[[1]]), stat_label, stat)
    Output
                      stat_label                            stat
      1 Median of the Difference                     -0.08860465
      2                Statistic                       -0.622721
      3                  p-value                       0.5434787
      4       Degrees of Freedom                              14
      5                   method Design-based KruskalWallis test
      6   Alternative Hypothesis                       two.sided

---

    Code
      dplyr::select(as.data.frame(svyranktest[[2]]), stat_label, stat)
    Output
                      stat_label                            stat
      1 Median of the Difference                      -0.4011505
      2                Statistic                      -0.8682035
      3                  p-value                       0.3999213
      4       Degrees of Freedom                              14
      5                   method Design-based vanderWaerden test
      6   Alternative Hypothesis                       two.sided

---

    Code
      dplyr::select(as.data.frame(svyranktest[[3]]), stat_label, stat)
    Output
                      stat_label                     stat
      1 Median of the Difference               -0.1488372
      2                Statistic               -0.6391119
      3                  p-value                0.5330681
      4       Degrees of Freedom                       14
      5                   method Design-based median test
      6   Alternative Hypothesis                two.sided

---

    Code
      dplyr::select(as.data.frame(svyranktest[[4]]), stat_label, stat)
    Output
                      stat_label                            stat
      1 Median of the Difference                     -0.08860465
      2                Statistic                       -0.622721
      3                  p-value                       0.5434787
      4       Degrees of Freedom                              14
      5                   method Design-based KruskalWallis test
      6   Alternative Hypothesis                       two.sided

# ard_survey_svyranktest() works for svyrep.design objects

    Code
      dplyr::select(as.data.frame(svyranktest[[1]]), stat_label, stat)
    Output
                      stat_label                            stat
      1 Median of the Difference                     -0.08860465
      2                Statistic                       -0.622852
      3                  p-value                       0.5433951
      4       Degrees of Freedom                              14
      5                   method Design-based KruskalWallis test
      6   Alternative Hypothesis                       two.sided

---

    Code
      dplyr::select(as.data.frame(svyranktest[[2]]), stat_label, stat)
    Output
                      stat_label                            stat
      1 Median of the Difference                      -0.4011505
      2                Statistic                      -0.8683994
      3                  p-value                       0.3998177
      4       Degrees of Freedom                              14
      5                   method Design-based vanderWaerden test
      6   Alternative Hypothesis                       two.sided

---

    Code
      dplyr::select(as.data.frame(svyranktest[[3]]), stat_label, stat)
    Output
                      stat_label                     stat
      1 Median of the Difference               -0.1488372
      2                Statistic               -0.6394122
      3                  p-value                0.5328785
      4       Degrees of Freedom                       14
      5                   method Design-based median test
      6   Alternative Hypothesis                two.sided

---

    Code
      dplyr::select(as.data.frame(svyranktest[[4]]), stat_label, stat)
    Output
                      stat_label                            stat
      1 Median of the Difference                     -0.08860465
      2                Statistic                       -0.622852
      3                  p-value                       0.5433951
      4       Degrees of Freedom                              14
      5                   method Design-based KruskalWallis test
      6   Alternative Hypothesis                       two.sided

