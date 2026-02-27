#' ARD Survey rank test
#'
#' @description
#' Analysis results data for survey wilcox test using [`survey::svyranktest()`].
#'
#' @param data (`survey.design`)\cr
#'   a survey design object often created with [`survey::svydesign()`]
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name to compare by
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column names to be compared. Independent tests will be run for each variable.
#' @param test (`string`)\cr
#'   a string to denote which rank test to use:
#'   `"wilcoxon"`, `"vanderWaerden"`, `"median"`, `"KruskalWallis"`
#' @param ... arguments passed to [`survey::svyranktest()`]
#'
#' @return ARD data frame
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("survey", "broom")))
#' data(api, package = "survey")
#' dclus2 <- survey::svydesign(id = ~ dnum + snum, fpc = ~ fpc1 + fpc2, data = apiclus2)
#'
#' ard_survey_svyranktest(dclus2, variables = enroll, by = comp.imp, test = "wilcoxon")
#' ard_survey_svyranktest(dclus2, variables = enroll, by = comp.imp, test = "vanderWaerden")
#' ard_survey_svyranktest(dclus2, variables = enroll, by = comp.imp, test = "median")
#' ard_survey_svyranktest(dclus2, variables = enroll, by = comp.imp, test = "KruskalWallis")
ard_survey_svyranktest <- function(data, by, variables, test, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(c("survey", "broom"))

  # check/process inputs -------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_not_missing(by)
  check_class(data, cls = "survey.design")
  cards::process_selectors(data[["variables"]], by = {{ by }}, variables = {{ variables }})
  check_scalar(by)

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # build ARD ------------------------------------------------------------------
  lapply(
    variables,
    function(variable) {
      .format_svyranktest_results(
        by = by,
        variable = variable,
        lst_tidy =
          cards::eval_capture_conditions(
            survey::svyranktest(reformulate2(termlabels = by, response = variable), design = data, test = test, ...) |>
              broom::tidy()
          )
      )
    }
  ) |>
    dplyr::bind_rows()
}

.format_svyranktest_results <- function(by, variable, lst_tidy, ...) {
  # build ARD ------------------------------------------------------------------
  ret <-
    cards::tidy_as_ard(
      lst_tidy = lst_tidy,
      tidy_result_names = c(
        "estimate", "statistic",
        "p.value", "parameter",
        "method", "alternative"
      ),
      passed_args = dots_list(...),
      lst_ard_columns = list(group1 = by, variable = variable, context = "survey_svyranktest")
    )

  # add the stat label ---------------------------------------------------------
  ret |>
    dplyr::left_join(
      .df_surveyrank_stat_labels(),
      by = "stat_name"
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name)) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}


.df_surveyrank_stat_labels <- function() {
  dplyr::tribble(
    ~stat_name, ~stat_label,
    "statistic", "Statistic",
    "parameter", "Degrees of Freedom",
    "estimate", "Median of the Difference",
    "null.value", "Null Value",
    "alternative", "Alternative Hypothesis",
    "data.name", "Data Name",
    "p.value", "p-value"
  )
}
