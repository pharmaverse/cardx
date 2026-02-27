# cardx 0.3.2.9000

* Added fix to ensure `as_card` does not error after update to `cards`

# cardx 0.3.2

* Swapped internal use of `dplyr::case_when()` for `dplyr::recode_values()` as the former is now deprecated. (#327)

# cardx 0.3.1

* Added the `ard_emmeans_emmeans()` function. (#317)

* Renamed `ard_emmeans_mean_difference()` to `ard_emmeans_contrast()` to align with function naming conventions.

* The `ard_complex()` function has been renamed to `ard_mvsummary()`.

# cardx 0.3.0

## New Features and Updates

* Added function `ard_tabulate_abnormal()` to calculate ARDs for abnormality analyses. (#310)

* Adding `strata` argument to `ard_tabulate_max()`. (#445, @jtalboys)

* Added function `ard_incidence_rate()` to calculate ARDs for incidence rate estimation. (#234)

## Lifecycle Changes

* The following functions have been renamed.
    - `ard_continuous()` to `ard_summary()`
    - `ard_categorical()` to `ard_tabulate()`
    - `ard_dichotomous()` to `ard_tabulate_value()`
    - `ard_categorical_max()` to `ard_tabulate_max()`
   
* Updating any `fmt_fn` references to `fmt_fun` for consistency. 

    * Any function with an argument `cardx::foo(fmt_fn)` has been updated to `cardx::foo(fmt_fun)`. The old syntax will continue to function, but with a deprecation warning to users.

    * Importantly, the ARD column named `"fmt_fn"` has been updated to `"fmt_fun"`. This change cannot be formally deprecated. For users who were accessing the ARD object directly to modify this column instead of using functions like `cards::update_ard_fmt_fun()`, this will be a breaking change.
 
## Bug Fixes

* Fix in `ard_survival_survfit.data.frame()` method where the stratifying variable was not correctly converted back to its original type.

* Fix in `ard_total_n.survey.design()` to use `update()` instead of `dplyr::mutate()`, which sometimes caused a downstream issue.

# cardx 0.2.4

## New Features and Updates

* Added function `ard_stats_mantelhaen_test()` to calculate ARDs for Cochran-Mantel-Haenszel test results using `stats::mantelhaen.test()`. (#238)

* Added a `ard_regression.data.frame()` S3 method. Also converted `ard_regression_basic()` to an S3 generic and added a `ard_regression_basic.data.frame()` method (#287)

* Specifying `ard_survfit_survfit.data.frame(variables=NULL)` now creates an unstratified `survfit()` model, where previously `variables` argument could not be empty. (#277)

* The `ard_survfit_survfit.data.frame(variables)` now accepts tidyselect input. (#278)

* Added `conf.level` and `conf.type` to `ard_survival_survfit()` results. (#218)

* Added `cards::as_cards_fun()` to `ard_emmeans_mean_difference()` so when an error occurs the user gets an ARD with the expected ARD structure. (#132)

# cardx 0.2.3

## New Features and Updates

* Added function `ard_categorical_max()` to calculate categorical occurrence rates by maximum level per unique ID. (#240)

## Other Updates

* Little `n` is now returned with the results of the `proportion_ci_*()` functions, which then flows into the results of `ard_proportion_ci()`. (#256)

* Added `as_cards_fun()` to `ard_categorical_ci()` so when there is an error, the user gets an ARD with the expected ARD structure. (#262)

* Update in `ard_categorical.survey.design()` for factor variables that are all missing. These variables can now be tabulated, where previously this resulted in an error. 

* Update in `ard_missing.survey.design()` where we can now tabulate the missing rate of design variables, such as the weights.

## Bug Fixes

* Fixed a bug in `ard_survival_survfit()` causing an error when "=" character is present in stratification variable level labels. (#252)

* Bug fix in `ard_categorical_ci(denominator='cell')` when missing values were present in the `by` variable.

# cardx 0.2.2

* Added a `data.frame` method to `ard_survival_survfit()`.

* Added a warning for incorrect formula type to `ard_survival_survfit()`. (#223)

* Implemented `summary(extend=TRUE)` in `ard_survival_survfit()` to return results for time points out of bounds. (#224)

* Methods in the {survey} and {survival} packages do not retain inputs variables types in their outputs. We now are able retain these variable types in ARDs returned by `ard_continuous.survey.design()`, `ard_categorical.survey.design()`, `ard_continuous_ci.survey.design()`, `ard_categorical_ci.survey.design()`, and `ard_survival_survfit.data.frame()` (and notably, _not_ in `ard_survival_survfit.survfit()`).

* Added function `ard_stats_mantelhaen_test()` for calculating ARDs for Cochran-Mantel-Haenszel test results using `stats::mantelhaen.test()`. (#238)

# cardx 0.2.1

## New Features and Updates

* Added S3 method `ard_total_n.survey.design()` which returns an ARD with both the survey-weighted and unweighted total sample size.

* Added `warning` and `error` columns to `ard_regression()` output. (#148)

* Implemented `cards::as_card()` where needed in the package to convert data frames to class 'card'. (#200)

## Bug Fixes

* Bug fix in `ard_categorical.survey.design()` where all unweighted statistics were returned, even in the case where they were explicitly not requested.

## Lifecycle Changes

* The `bt(pattern)`, `reformulate2(pattern_term)`, `reformulate2(pattern_response)` arguments have been deprecated and are now ignored. We now use `make.names()` to determine whether a column name needs to be wrapped in backticks. (#192)

# cardx 0.2.0

### Breaking Changes

* Updated function names to follow the pattern `ard_<pkgname>_<fnname>()`. This change is immediate: previous functions names have _not_ been deprecated. (#106)

```r
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

### New Features

* The `ard_categorical_ci(value)` argument has been added. Previously, only binary variables (0/1 or TRUE/FALSE) could be summarized. When a value is not supplied, each level of the variable is summarized independently. By default, binary variables will have the `1`/`TRUE` level summarized.

* Added the following functions for calculating Analysis Results Datasets (ARDs).
  - `ard_stats_aov()` for calculating ANOVA results using `stats::aov()`. (#3)
  - `ard_stats_anova()` for calculating ANOVA results using `stats::anova()`. (#12) 
  - `ard_stats_mcnemar_test_long()` for McNemar's test from long data using `stats::mcnemar.test()`. 
  - `ard_stats_prop_test()` for tests of proportions using `stats::prop.test()`. (#64)
  - `ard_stats_t_test_onesample()` for calculating one-sample results.
  - `ard_stats_wilcox_test_onesample()` for calculating one-sample results.
  - `ard_stats_oneway_test()` for calculating ANOVA results using `stats::oneway.test()`. (#3)
  - `ard_aod_wald_test()` for calculating Wald Tests for regression models using `aod::wald.test()`. (#84)
  - `ard_car_anova()` for calculating ANOVA results using `car::Anova()`. (#3)
  - `ard_car_vif()` for calculating the variance inflation factor using `car::vif()`. (#10)
  - `ard_effectsize_cohens_d()`, `ard_effectsize_paired_cohens_d()`, `ard_effectsize_hedges_g()`, and `ard_effectsize_paired_hedges_g()` for standardized differences using `effectsize::cohens_d()` and `effectsize::hedges_g()`. (#50)
  - `ard_emmeans_mean_difference()` for calculating the least-squares mean differences using the {emmeans} package. (#34)
  - `ard_smd_smd()` for calculating standardized mean differences using `smd::smd()`. (#4)
  - `ard_survival_survfit()` for survival analyses using `survival::survfit()`. (#43)
  - `ard_continuous.survey.design()` for calculating univariate summary statistics from weighted/survey data using many functions from the {survey} package. (#68)
  - `ard_categorical.survey.design()` for tabulating summary statistics from weighted/survey data using many functions from the {survey} package. (#140)
  - `ard_dichotomous.survey.design()` for tabulating dichotomous summary statistics from weighted/survey data using many functions from the {survey} package. (#2)
  - `ard_missing.survey.design()` for tabulating missing summary statistics from weighted/survey data using many functions from the {survey} package. (#2)
  - `ard_attributes.survey.design()` for summarizing labels and attributes from weighted/survey data using many functions from the {survey} package.
  - `ard_survey_svychisq()` for weighted/survey chi-squared test using `survey::svychisq()`. (#72)
  - `ard_survey_svyttest()` for weighted/survey t-tests using `survey::svyttest()`. (#70)
  - `ard_survey_svyranktest()` for weighted/survey rank tests using `survey::svyranktest()`. (#71)
  - `ard_survival_survdiff()` for creating results from `survival::survdiff()`. (#113)
  - `ard_regression_basic()` for basic regression models. The function focuses on matching model terms to underlying variables names. (#46)

* Updated functions `ard_stats_t_test()`, `ard_stats_paired_t_test()`, `ard_stats_wilcox_test()`, `ard_stats_paired_wilcox_test()`, `ard_stats_chisq_test()`, `ard_stats_fisher_test()`, `ard_stats_kruskal_test()`, `ard_stats_mcnemar_test()`, and `ard_stats_mood_test()` to accept multiple variables at once. Independent tests are calculated for each variable. The `variable` argument is renamed to `variables`. (#77)

* Updated `ard_stats_t_test()` and `ard_stats_wilcox_test()` to no longer require the `by` argument, which yields central estimates with their confidence intervals. (#82)

* Added model construction helpers, `construct_model()`, `reformulate2()`, `bt()`, and `bt_strip()`.

* Imported cli call environment functions from `https://github.com/ddsjoberg/standalone/blob/main/R/standalone-cli_call_env.R` and implemented `set_cli_abort_call` in user-facing functions. (#111)

# cardx 0.1.0

* Initial release.
