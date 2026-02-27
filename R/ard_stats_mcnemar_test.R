#' ARD McNemar's Test
#'
#' @description
#' Analysis results data for McNemar's statistical test.
#' We have two functions depending on the structure of the data.
#' - `ard_stats_mcnemar_test()` is the structure expected by [`stats::mcnemar.test()`]
#' - `ard_stats_mcnemar_test_long()` is one row per ID per group
#'
#' @param data (`data.frame`)\cr
#'   a data frame. See below for details.
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name to compare by.
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column names to be compared. Independent tests will
#'   be computed for each variable.
#' @param ... arguments passed to `stats::mcnemar.test(...)`
#' @param id ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name of the subject or participant ID
#'
#' @return ARD data frame
#' @name ard_stats_mcnemar_test
#'
#' @details
#' For the `ard_stats_mcnemar_test()` function, the data is expected to be one row per subject.
#' The data is passed as `stats::mcnemar.test(x = data[[variable]], y = data[[by]], ...)`.
#' Please use `table(x = data[[variable]], y = data[[by]])` to check the contingency table.
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' cards::ADSL |>
#'   ard_stats_mcnemar_test(by = "SEX", variables = "EFFFL")
#'
#' set.seed(1234)
#' cards::ADSL[c("USUBJID", "TRT01P")] |>
#'   dplyr::mutate(TYPE = "PLANNED") |>
#'   dplyr::rename(TRT01 = TRT01P) %>%
#'   dplyr::bind_rows(dplyr::mutate(., TYPE = "ACTUAL", TRT01 = sample(TRT01))) |>
#'   ard_stats_mcnemar_test_long(
#'     by = TYPE,
#'     variable = TRT01,
#'     id = USUBJID
#'   )
NULL

#' @rdname ard_stats_mcnemar_test
#' @export
ard_stats_mcnemar_test <- function(data, by, variables, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed("broom")

  # check/process inputs -------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_not_missing(by)
  check_data_frame(data)
  data <- dplyr::ungroup(data)
  cards::process_selectors(data, by = {{ by }}, variables = {{ variables }})
  check_scalar(by)

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # build ARD ------------------------------------------------------------------
  lapply(
    variables,
    function(variable) {
      .format_mcnemartest_results(
        by = by,
        variable = variable,
        lst_tidy =
          cards::eval_capture_conditions(
            stats::mcnemar.test(x = data[[variable]], y = data[[by]], ...) |>
              broom::tidy()
          ),
        ...
      )
    }
  ) |>
    dplyr::bind_rows()
}

#' @rdname ard_stats_mcnemar_test
#' @export
ard_stats_mcnemar_test_long <- function(data, by, variables, id, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed("broom")

  # check/process inputs -------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_not_missing(by)
  check_not_missing(id)
  check_data_frame(data)
  data <- dplyr::ungroup(data)
  cards::process_selectors(data, by = {{ by }}, variables = {{ variables }}, id = {{ id }})
  check_scalar(by)
  check_scalar(id)

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # build ARD ------------------------------------------------------------------
  lapply(
    variables,
    function(variable) {
      .format_mcnemartest_results(
        by = by,
        variable = variable,
        lst_tidy =
          cards::eval_capture_conditions({
            # adding this reshape inside the eval, so if there is an error it's captured in the ARD object
            data_wide <- .paired_data_pivot_wider(data, by = by, variable = variable, id = id)
            # performing McNemars test
            stats::mcnemar.test(x = data_wide[["by1"]], y = data_wide[["by2"]], ...) |>
              broom::tidy()
          }),
        ...
      )
    }
  ) |>
    dplyr::bind_rows()
}

#' Convert McNemar's test to ARD
#'
#' @inheritParams cards::tidy_as_ard
#' @inheritParams stats::mcnemar.test
#' @param by (`string`)\cr by column name
#' @param variable (`string`)\cr variable column name
#' @param ... passed to `stats::mcnemar.test(...)`
#'
#' @return ARD data frame
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' cardx:::.format_mcnemartest_results(
#'   by = "ARM",
#'   variable = "AGE",
#'   lst_tidy =
#'     cards::eval_capture_conditions(
#'       stats::mcnemar.test(cards::ADSL[["SEX"]], cards::ADSL[["EFFFL"]]) |>
#'         broom::tidy()
#'     )
#' )
#'
#' @keywords internal
.format_mcnemartest_results <- function(by, variable, lst_tidy, ...) {
  # build ARD ------------------------------------------------------------------
  ret <-
    cards::tidy_as_ard(
      lst_tidy = lst_tidy,
      tidy_result_names = c("statistic", "p.value", "method"),
      fun_args_to_record = c("correct"),
      formals = formals(asNamespace("stats")[["mcnemar.test"]]),
      passed_args = dots_list(...),
      lst_ard_columns = list(group1 = by, variable = variable, context = "stats_mcnemar_test")
    )

  # add the stat label ---------------------------------------------------------
  ret |>
    dplyr::left_join(
      .df_mcnemar_stat_labels(),
      by = "stat_name"
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name)) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}

.df_mcnemar_stat_labels <- function() {
  dplyr::tribble(
    ~stat_name, ~stat_label,
    "statistic", "X-squared Statistic",
    "parameter", "Degrees of Freedom",
    "p.value", "p-value",
  )
}
