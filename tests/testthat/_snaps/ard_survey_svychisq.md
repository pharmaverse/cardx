# ard_survey_svychisq() works for survey.design objects

    Code
      as.data.frame(dplyr::slice_head(dplyr::group_by(dplyr::select(
        ard_survey_svychisq(dclus2, variables = c(sch.wide, stype), by = comp.imp,
        statistic = "adjWald"), c(1:3, 5:6)), variable), n = 3))
    Output
          group1 variable         context                     stat_label     stat
      1 comp.imp sch.wide survey_svychisq   Nominator Degrees of Freedom        1
      2 comp.imp sch.wide survey_svychisq Denominator Degrees of Freedom       17
      3 comp.imp sch.wide survey_svychisq                      Statistic 7.795428
      4 comp.imp    stype survey_svychisq   Nominator Degrees of Freedom        2
      5 comp.imp    stype survey_svychisq Denominator Degrees of Freedom       16
      6 comp.imp    stype survey_svychisq                      Statistic 3.290016

# ard_survey_svychisq() works for svyrep.design objects

    Code
      as.data.frame(dplyr::slice_head(dplyr::group_by(dplyr::select(
        ard_survey_svychisq(rclus2, variables = c(sch.wide, stype), by = comp.imp,
        statistic = "adjWald"), c(1:3, 5:6)), variable), n = 3))
    Output
          group1 variable         context                     stat_label     stat
      1 comp.imp sch.wide survey_svychisq   Nominator Degrees of Freedom        1
      2 comp.imp sch.wide survey_svychisq Denominator Degrees of Freedom       17
      3 comp.imp sch.wide survey_svychisq                      Statistic 7.795428
      4 comp.imp    stype survey_svychisq   Nominator Degrees of Freedom        2
      5 comp.imp    stype survey_svychisq Denominator Degrees of Freedom       16
      6 comp.imp    stype survey_svychisq                      Statistic 3.293693

