#' ARD Survey t-test
#'
#' @description
#' Analysis results data for survey t-test using [`survey::svyttest()`].
#'
#' @param data (`survey.design`)\cr
#'   a survey design object often created with [`survey::svydesign()`]
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name to compare by
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column names to be compared. Independent tests will be run for each variable.
#' @param conf.level (`double`)\cr
#'   confidence level of the returned confidence interval. Must be between `c(0, 1)`.
#'   Default is `0.95`
#' @param ... arguments passed to [`survey::svyttest()`]
#'
#' @return ARD data frame
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("survey", "broom")))
#' data(api, package = "survey")
#' dclus2 <- survey::svydesign(id = ~ dnum + snum, fpc = ~ fpc1 + fpc2, data = apiclus2)
#'
#' ard_survey_svyttest(dclus2, variables = enroll, by = comp.imp, conf.level = 0.9)
ard_survey_svyttest <- function(data, by, variables, conf.level = 0.95, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(c("survey", "broom"))

  # check/process inputs -------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_not_missing(by)
  check_range(conf.level, range = c(0, 1))
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
      .format_svyttest_results(
        by = by,
        variable = variable,
        lst_tidy =
          cards::eval_capture_conditions(
            survey::svyttest(reformulate2(termlabels = by, response = variable), design = data, ...) %>%
              # a slightly enhanced tidier that allows us to specify the conf.level
              {
                dplyr::bind_cols(
                  broom::tidy(.) |> dplyr::select(-c("conf.low", "conf.high")),
                  dplyr::tibble(!!!stats::confint(., level = conf.level) |> set_names(c("conf.low", "conf.high"))) |>
                    dplyr::mutate(conf.level = conf.level)
                )
              }
          ),
        ...
      )
    }
  ) |>
    dplyr::bind_rows()
}

.format_svyttest_results <- function(by, variable, lst_tidy, ...) {
  # build ARD ------------------------------------------------------------------
  ret <-
    cards::tidy_as_ard(
      lst_tidy = lst_tidy,
      tidy_result_names = c(
        "estimate", "statistic",
        "p.value", "parameter",
        "conf.low", "conf.high",
        "conf.level", "method", "alternative"
      ),
      passed_args = dots_list(...),
      lst_ard_columns = list(group1 = by, variable = variable, context = "survey_svyttest")
    )

  # add the stat label ---------------------------------------------------------
  ret |>
    dplyr::left_join(
      .df_ttest_stat_labels(),
      by = "stat_name"
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name)) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}
