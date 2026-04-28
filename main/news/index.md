# Changelog

## cardx 0.3.2.9003

- Added fix to ensure `as_card` does not error after update to `cards`

- Bug fix in
  [`ard_car_vif()`](https://insightsengineering.github.io/cardx/reference/ard_car_vif.md)
  where non-syntactic variable names (e.g. those containing spaces) were
  returned with backticks in the `variable` column. Since
  [`gtsummary::tbl_regression()`](https://www.danieldsjoberg.com/gtsummary/reference/tbl_regression.html)
  stores variable names without backticks, this mismatch resulted in
  empty VIF columns in
  [`gtsummary::add_vif()`](https://www.danieldsjoberg.com/gtsummary/reference/add_vif.html).
  ([\#335](https://github.com/insightsengineering/cardx/issues/335),
  [@NourEdinDarwish](https://github.com/NourEdinDarwish))

## cardx 0.3.2

CRAN release: 2026-02-05

- Swapped internal use of
  [`dplyr::case_when()`](https://dplyr.tidyverse.org/reference/case-and-replace-when.html)
  for
  [`dplyr::recode_values()`](https://dplyr.tidyverse.org/reference/recode-and-replace-values.html)
  as the former is now deprecated.
  ([\#327](https://github.com/insightsengineering/cardx/issues/327))

## cardx 0.3.1

CRAN release: 2025-12-04

- Added the
  [`ard_emmeans_emmeans()`](https://insightsengineering.github.io/cardx/reference/ard_emmeans.md)
  function.
  ([\#317](https://github.com/insightsengineering/cardx/issues/317))

- Renamed
  [`ard_emmeans_mean_difference()`](https://insightsengineering.github.io/cardx/reference/deprecated.md)
  to
  [`ard_emmeans_contrast()`](https://insightsengineering.github.io/cardx/reference/ard_emmeans.md)
  to align with function naming conventions.

- The `ard_complex()` function has been renamed to `ard_mvsummary()`.

## cardx 0.3.0

CRAN release: 2025-08-27

### New Features and Updates

- Added function
  [`ard_tabulate_abnormal()`](https://insightsengineering.github.io/cardx/reference/ard_tabulate_abnormal.md)
  to calculate ARDs for abnormality analyses.
  ([\#310](https://github.com/insightsengineering/cardx/issues/310))

- Adding `strata` argument to
  [`ard_tabulate_max()`](https://insightsengineering.github.io/cardx/reference/ard_tabulate_max.md).
  ([\#445](https://github.com/insightsengineering/cardx/issues/445),
  [@jtalboys](https://github.com/jtalboys))

- Added function
  [`ard_incidence_rate()`](https://insightsengineering.github.io/cardx/reference/ard_incidence_rate.md)
  to calculate ARDs for incidence rate estimation.
  ([\#234](https://github.com/insightsengineering/cardx/issues/234))

### Lifecycle Changes

- The following functions have been renamed.

  - [`ard_continuous()`](https://insightsengineering.github.io/cards/latest-tag/reference/deprecated.html)
    to
    [`ard_summary()`](https://insightsengineering.github.io/cards/latest-tag/reference/ard_summary.html)
  - [`ard_categorical()`](https://insightsengineering.github.io/cards/latest-tag/reference/deprecated.html)
    to
    [`ard_tabulate()`](https://insightsengineering.github.io/cards/latest-tag/reference/ard_tabulate.html)
  - [`ard_dichotomous()`](https://insightsengineering.github.io/cards/latest-tag/reference/deprecated.html)
    to
    [`ard_tabulate_value()`](https://insightsengineering.github.io/cards/latest-tag/reference/ard_tabulate_value.html)
  - [`ard_categorical_max()`](https://insightsengineering.github.io/cardx/reference/deprecated.md)
    to
    [`ard_tabulate_max()`](https://insightsengineering.github.io/cardx/reference/ard_tabulate_max.md)

- Updating any `fmt_fn` references to `fmt_fun` for consistency.

  - Any function with an argument `cardx::foo(fmt_fn)` has been updated
    to `cardx::foo(fmt_fun)`. The old syntax will continue to function,
    but with a deprecation warning to users.

  - Importantly, the ARD column named `"fmt_fn"` has been updated to
    `"fmt_fun"`. This change cannot be formally deprecated. For users
    who were accessing the ARD object directly to modify this column
    instead of using functions like
    [`cards::update_ard_fmt_fun()`](https://insightsengineering.github.io/cards/latest-tag/reference/update_ard.html),
    this will be a breaking change.

### Bug Fixes

- Fix in
  [`ard_survival_survfit.data.frame()`](https://insightsengineering.github.io/cardx/reference/ard_survival_survfit.md)
  method where the stratifying variable was not correctly converted back
  to its original type.

- Fix in
  [`ard_total_n.survey.design()`](https://insightsengineering.github.io/cardx/reference/ard_total_n.survey.design.md)
  to use [`update()`](https://rdrr.io/r/stats/update.html) instead of
  [`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html),
  which sometimes caused a downstream issue.

## cardx 0.2.4

CRAN release: 2025-04-12

### New Features and Updates

- Added function
  [`ard_stats_mantelhaen_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_mantelhaen_test.md)
  to calculate ARDs for Cochran-Mantel-Haenszel test results using
  [`stats::mantelhaen.test()`](https://rdrr.io/r/stats/mantelhaen.test.html).
  ([\#238](https://github.com/insightsengineering/cardx/issues/238))

- Added a
  [`ard_regression.data.frame()`](https://insightsengineering.github.io/cardx/reference/ard_regression.md)
  S3 method. Also converted
  [`ard_regression_basic()`](https://insightsengineering.github.io/cardx/reference/ard_regression_basic.md)
  to an S3 generic and added a
  [`ard_regression_basic.data.frame()`](https://insightsengineering.github.io/cardx/reference/ard_regression_basic.md)
  method
  ([\#287](https://github.com/insightsengineering/cardx/issues/287))

- Specifying `ard_survfit_survfit.data.frame(variables=NULL)` now
  creates an unstratified
  [`survfit()`](https://rdrr.io/pkg/survival/man/survfit.html) model,
  where previously `variables` argument could not be empty.
  ([\#277](https://github.com/insightsengineering/cardx/issues/277))

- The `ard_survfit_survfit.data.frame(variables)` now accepts tidyselect
  input.
  ([\#278](https://github.com/insightsengineering/cardx/issues/278))

- Added `conf.level` and `conf.type` to
  [`ard_survival_survfit()`](https://insightsengineering.github.io/cardx/reference/ard_survival_survfit.md)
  results.
  ([\#218](https://github.com/insightsengineering/cardx/issues/218))

- Added `cards::as_cards_fun()` to
  [`ard_emmeans_mean_difference()`](https://insightsengineering.github.io/cardx/reference/deprecated.md)
  so when an error occurs the user gets an ARD with the expected ARD
  structure.
  ([\#132](https://github.com/insightsengineering/cardx/issues/132))

## cardx 0.2.3

CRAN release: 2025-02-18

### New Features and Updates

- Added function
  [`ard_categorical_max()`](https://insightsengineering.github.io/cardx/reference/deprecated.md)
  to calculate categorical occurrence rates by maximum level per unique
  ID. ([\#240](https://github.com/insightsengineering/cardx/issues/240))

### Other Updates

- Little `n` is now returned with the results of the `proportion_ci_*()`
  functions, which then flows into the results of `ard_proportion_ci()`.
  ([\#256](https://github.com/insightsengineering/cardx/issues/256))

- Added `as_cards_fun()` to
  [`ard_categorical_ci()`](https://insightsengineering.github.io/cardx/reference/ard_categorical_ci.md)
  so when there is an error, the user gets an ARD with the expected ARD
  structure.
  ([\#262](https://github.com/insightsengineering/cardx/issues/262))

- Update in
  [`ard_categorical.survey.design()`](https://insightsengineering.github.io/cardx/reference/deprecated.md)
  for factor variables that are all missing. These variables can now be
  tabulated, where previously this resulted in an error.

- Update in
  [`ard_missing.survey.design()`](https://insightsengineering.github.io/cardx/reference/ard_missing.survey.design.md)
  where we can now tabulate the missing rate of design variables, such
  as the weights.

### Bug Fixes

- Fixed a bug in
  [`ard_survival_survfit()`](https://insightsengineering.github.io/cardx/reference/ard_survival_survfit.md)
  causing an error when “=” character is present in stratification
  variable level labels.
  ([\#252](https://github.com/insightsengineering/cardx/issues/252))

- Bug fix in `ard_categorical_ci(denominator='cell')` when missing
  values were present in the `by` variable.

## cardx 0.2.2

CRAN release: 2024-11-27

- Added a `data.frame` method to
  [`ard_survival_survfit()`](https://insightsengineering.github.io/cardx/reference/ard_survival_survfit.md).

- Added a warning for incorrect formula type to
  [`ard_survival_survfit()`](https://insightsengineering.github.io/cardx/reference/ard_survival_survfit.md).
  ([\#223](https://github.com/insightsengineering/cardx/issues/223))

- Implemented `summary(extend=TRUE)` in
  [`ard_survival_survfit()`](https://insightsengineering.github.io/cardx/reference/ard_survival_survfit.md)
  to return results for time points out of bounds.
  ([\#224](https://github.com/insightsengineering/cardx/issues/224))

- Methods in the {survey} and {survival} packages do not retain inputs
  variables types in their outputs. We now are able retain these
  variable types in ARDs returned by
  [`ard_continuous.survey.design()`](https://insightsengineering.github.io/cardx/reference/deprecated.md),
  [`ard_categorical.survey.design()`](https://insightsengineering.github.io/cardx/reference/deprecated.md),
  [`ard_continuous_ci.survey.design()`](https://insightsengineering.github.io/cardx/reference/ard_continuous_ci.survey.design.md),
  [`ard_categorical_ci.survey.design()`](https://insightsengineering.github.io/cardx/reference/ard_categorical_ci.survey.design.md),
  and
  [`ard_survival_survfit.data.frame()`](https://insightsengineering.github.io/cardx/reference/ard_survival_survfit.md)
  (and notably, *not* in
  [`ard_survival_survfit.survfit()`](https://insightsengineering.github.io/cardx/reference/ard_survival_survfit.md)).

- Added function
  [`ard_stats_mantelhaen_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_mantelhaen_test.md)
  for calculating ARDs for Cochran-Mantel-Haenszel test results using
  [`stats::mantelhaen.test()`](https://rdrr.io/r/stats/mantelhaen.test.html).
  ([\#238](https://github.com/insightsengineering/cardx/issues/238))

## cardx 0.2.1

CRAN release: 2024-09-03

### New Features and Updates

- Added S3 method
  [`ard_total_n.survey.design()`](https://insightsengineering.github.io/cardx/reference/ard_total_n.survey.design.md)
  which returns an ARD with both the survey-weighted and unweighted
  total sample size.

- Added `warning` and `error` columns to
  [`ard_regression()`](https://insightsengineering.github.io/cardx/reference/ard_regression.md)
  output.
  ([\#148](https://github.com/insightsengineering/cardx/issues/148))

- Implemented
  [`cards::as_card()`](https://insightsengineering.github.io/cards/latest-tag/reference/as_card.html)
  where needed in the package to convert data frames to class ‘card’.
  ([\#200](https://github.com/insightsengineering/cardx/issues/200))

### Bug Fixes

- Bug fix in
  [`ard_categorical.survey.design()`](https://insightsengineering.github.io/cardx/reference/deprecated.md)
  where all unweighted statistics were returned, even in the case where
  they were explicitly not requested.

### Lifecycle Changes

- The `bt(pattern)`, `reformulate2(pattern_term)`,
  `reformulate2(pattern_response)` arguments have been deprecated and
  are now ignored. We now use
  [`make.names()`](https://rdrr.io/r/base/make.names.html) to determine
  whether a column name needs to be wrapped in backticks.
  ([\#192](https://github.com/insightsengineering/cardx/issues/192))

## cardx 0.2.0

CRAN release: 2024-07-20

#### Breaking Changes

- Updated function names to follow the pattern
  `ard_<pkgname>_<fnname>()`. This change is immediate: previous
  functions names have *not* been deprecated.
  ([\#106](https://github.com/insightsengineering/cardx/issues/106))

``` r

ard_ttest()             -> ard_stats_t_test()
ard_paired_ttest()      -> ard_stats_paired_t_test()
ard_wilcoxtest()        -> ard_stats_wilcox_test()
ard_paired_wilcoxtest() -> ard_stats_paired_wilcox_test()
ard_chisqtest()         -> ard_stats_chisq_test()
ard_fishertest()        -> ard_stats_fisher_test()
ard_kruskaltest()       -> ard_stats_kruskal_test()
ard_mcnemartest()       -> ard_stats_mcnemar_test()
ard_moodtest()          -> ard_stats_mood_test()
```

#### New Features

- The `ard_categorical_ci(value)` argument has been added. Previously,
  only binary variables (0/1 or TRUE/FALSE) could be summarized. When a
  value is not supplied, each level of the variable is summarized
  independently. By default, binary variables will have the `1`/`TRUE`
  level summarized.

- Added the following functions for calculating Analysis Results
  Datasets (ARDs).

  - [`ard_stats_aov()`](https://insightsengineering.github.io/cardx/reference/ard_stats_aov.md)
    for calculating ANOVA results using
    [`stats::aov()`](https://rdrr.io/r/stats/aov.html).
    ([\#3](https://github.com/insightsengineering/cardx/issues/3))
  - [`ard_stats_anova()`](https://insightsengineering.github.io/cardx/reference/ard_stats_anova.md)
    for calculating ANOVA results using
    [`stats::anova()`](https://rdrr.io/r/stats/anova.html).
    ([\#12](https://github.com/insightsengineering/cardx/issues/12))
  - [`ard_stats_mcnemar_test_long()`](https://insightsengineering.github.io/cardx/reference/ard_stats_mcnemar_test.md)
    for McNemar’s test from long data using
    [`stats::mcnemar.test()`](https://rdrr.io/r/stats/mcnemar.test.html).
  - [`ard_stats_prop_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_prop_test.md)
    for tests of proportions using
    [`stats::prop.test()`](https://rdrr.io/r/stats/prop.test.html).
    ([\#64](https://github.com/insightsengineering/cardx/issues/64))
  - [`ard_stats_t_test_onesample()`](https://insightsengineering.github.io/cardx/reference/ard_stats_t_test_onesample.md)
    for calculating one-sample results.
  - [`ard_stats_wilcox_test_onesample()`](https://insightsengineering.github.io/cardx/reference/ard_stats_wilcox_test_onesample.md)
    for calculating one-sample results.
  - [`ard_stats_oneway_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_oneway_test.md)
    for calculating ANOVA results using
    [`stats::oneway.test()`](https://rdrr.io/r/stats/oneway.test.html).
    ([\#3](https://github.com/insightsengineering/cardx/issues/3))
  - [`ard_aod_wald_test()`](https://insightsengineering.github.io/cardx/reference/ard_aod_wald_test.md)
    for calculating Wald Tests for regression models using
    [`aod::wald.test()`](https://rdrr.io/pkg/aod/man/wald.test.html).
    ([\#84](https://github.com/insightsengineering/cardx/issues/84))
  - [`ard_car_anova()`](https://insightsengineering.github.io/cardx/reference/ard_car_anova.md)
    for calculating ANOVA results using
    [`car::Anova()`](https://rdrr.io/pkg/car/man/Anova.html).
    ([\#3](https://github.com/insightsengineering/cardx/issues/3))
  - [`ard_car_vif()`](https://insightsengineering.github.io/cardx/reference/ard_car_vif.md)
    for calculating the variance inflation factor using
    [`car::vif()`](https://rdrr.io/pkg/car/man/vif.html).
    ([\#10](https://github.com/insightsengineering/cardx/issues/10))
  - [`ard_effectsize_cohens_d()`](https://insightsengineering.github.io/cardx/reference/ard_effectsize_cohens_d.md),
    [`ard_effectsize_paired_cohens_d()`](https://insightsengineering.github.io/cardx/reference/ard_effectsize_cohens_d.md),
    [`ard_effectsize_hedges_g()`](https://insightsengineering.github.io/cardx/reference/ard_effectsize_hedges_g.md),
    and
    [`ard_effectsize_paired_hedges_g()`](https://insightsengineering.github.io/cardx/reference/ard_effectsize_hedges_g.md)
    for standardized differences using
    [`effectsize::cohens_d()`](https://easystats.github.io/effectsize/reference/cohens_d.html)
    and
    [`effectsize::hedges_g()`](https://easystats.github.io/effectsize/reference/cohens_d.html).
    ([\#50](https://github.com/insightsengineering/cardx/issues/50))
  - [`ard_emmeans_mean_difference()`](https://insightsengineering.github.io/cardx/reference/deprecated.md)
    for calculating the least-squares mean differences using the
    {emmeans} package.
    ([\#34](https://github.com/insightsengineering/cardx/issues/34))
  - [`ard_smd_smd()`](https://insightsengineering.github.io/cardx/reference/ard_smd_smd.md)
    for calculating standardized mean differences using
    [`smd::smd()`](https://bsaul.github.io/smd/reference/smd.html).
    ([\#4](https://github.com/insightsengineering/cardx/issues/4))
  - [`ard_survival_survfit()`](https://insightsengineering.github.io/cardx/reference/ard_survival_survfit.md)
    for survival analyses using
    [`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html).
    ([\#43](https://github.com/insightsengineering/cardx/issues/43))
  - [`ard_continuous.survey.design()`](https://insightsengineering.github.io/cardx/reference/deprecated.md)
    for calculating univariate summary statistics from weighted/survey
    data using many functions from the {survey} package.
    ([\#68](https://github.com/insightsengineering/cardx/issues/68))
  - [`ard_categorical.survey.design()`](https://insightsengineering.github.io/cardx/reference/deprecated.md)
    for tabulating summary statistics from weighted/survey data using
    many functions from the {survey} package.
    ([\#140](https://github.com/insightsengineering/cardx/issues/140))
  - [`ard_dichotomous.survey.design()`](https://insightsengineering.github.io/cardx/reference/deprecated.md)
    for tabulating dichotomous summary statistics from weighted/survey
    data using many functions from the {survey} package.
    ([\#2](https://github.com/insightsengineering/cardx/issues/2))
  - [`ard_missing.survey.design()`](https://insightsengineering.github.io/cardx/reference/ard_missing.survey.design.md)
    for tabulating missing summary statistics from weighted/survey data
    using many functions from the {survey} package.
    ([\#2](https://github.com/insightsengineering/cardx/issues/2))
  - [`ard_attributes.survey.design()`](https://insightsengineering.github.io/cardx/reference/ard_attributes.md)
    for summarizing labels and attributes from weighted/survey data
    using many functions from the {survey} package.
  - [`ard_survey_svychisq()`](https://insightsengineering.github.io/cardx/reference/ard_survey_svychisq.md)
    for weighted/survey chi-squared test using
    [`survey::svychisq()`](https://rdrr.io/pkg/survey/man/svychisq.html).
    ([\#72](https://github.com/insightsengineering/cardx/issues/72))
  - [`ard_survey_svyttest()`](https://insightsengineering.github.io/cardx/reference/ard_survey_svyttest.md)
    for weighted/survey t-tests using
    [`survey::svyttest()`](https://rdrr.io/pkg/survey/man/svyttest.html).
    ([\#70](https://github.com/insightsengineering/cardx/issues/70))
  - [`ard_survey_svyranktest()`](https://insightsengineering.github.io/cardx/reference/ard_survey_svyranktest.md)
    for weighted/survey rank tests using
    [`survey::svyranktest()`](https://rdrr.io/pkg/survey/man/svyranktest.html).
    ([\#71](https://github.com/insightsengineering/cardx/issues/71))
  - [`ard_survival_survdiff()`](https://insightsengineering.github.io/cardx/reference/ard_survival_survdiff.md)
    for creating results from
    [`survival::survdiff()`](https://rdrr.io/pkg/survival/man/survdiff.html).
    ([\#113](https://github.com/insightsengineering/cardx/issues/113))
  - [`ard_regression_basic()`](https://insightsengineering.github.io/cardx/reference/ard_regression_basic.md)
    for basic regression models. The function focuses on matching model
    terms to underlying variables names.
    ([\#46](https://github.com/insightsengineering/cardx/issues/46))

- Updated functions
  [`ard_stats_t_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_t_test.md),
  [`ard_stats_paired_t_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_t_test.md),
  [`ard_stats_wilcox_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_wilcox_test.md),
  [`ard_stats_paired_wilcox_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_wilcox_test.md),
  [`ard_stats_chisq_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_chisq_test.md),
  [`ard_stats_fisher_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_fisher_test.md),
  [`ard_stats_kruskal_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_kruskal_test.md),
  [`ard_stats_mcnemar_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_mcnemar_test.md),
  and
  [`ard_stats_mood_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_mood_test.md)
  to accept multiple variables at once. Independent tests are calculated
  for each variable. The `variable` argument is renamed to `variables`.
  ([\#77](https://github.com/insightsengineering/cardx/issues/77))

- Updated
  [`ard_stats_t_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_t_test.md)
  and
  [`ard_stats_wilcox_test()`](https://insightsengineering.github.io/cardx/reference/ard_stats_wilcox_test.md)
  to no longer require the `by` argument, which yields central estimates
  with their confidence intervals.
  ([\#82](https://github.com/insightsengineering/cardx/issues/82))

- Added model construction helpers,
  [`construct_model()`](https://insightsengineering.github.io/cardx/reference/construction_helpers.md),
  [`reformulate2()`](https://insightsengineering.github.io/cardx/reference/construction_helpers.md),
  [`bt()`](https://insightsengineering.github.io/cardx/reference/construction_helpers.md),
  and
  [`bt_strip()`](https://insightsengineering.github.io/cardx/reference/construction_helpers.md).

- Imported cli call environment functions from
  `https://github.com/ddsjoberg/standalone/blob/main/R/standalone-cli_call_env.R`
  and implemented `set_cli_abort_call` in user-facing functions.
  ([\#111](https://github.com/insightsengineering/cardx/issues/111))

## cardx 0.1.0

CRAN release: 2024-03-18

- Initial release.
