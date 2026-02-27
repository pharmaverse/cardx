#' ARD t-test
#'
#' @description
#' Analysis results data for paired and non-paired t-tests.
#'
#' @param data (`data.frame`)\cr
#'   a data frame. See below for details.
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   optional column name to compare by.
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column names to be compared. Independent t-tests will be computed for
#'   each variable.
#' @param id ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name of the subject or participant ID
#' @param conf.level (scalar `numeric`)\cr
#'   confidence level for confidence interval. Default is `0.95`.
#' @param ... arguments passed to `t.test()`
#'
#' @return ARD data frame
#' @name ard_stats_t_test
#'
#' @details
#' For the `ard_stats_t_test()` function, the data is expected to be one row per subject.
#' The data is passed as `t.test(data[[variable]] ~ data[[by]], paired = FALSE, ...)`.
#'
#' For the `ard_stats_paired_t_test()` function, the data is expected to be one row
#' per subject per by level. Before the t-test is calculated, the data are
#' reshaped to a wide format to be one row per subject.
#' The data are then passed as
#' `t.test(x = data_wide[[<by level 1>]], y = data_wide[[<by level 2>]], paired = TRUE, ...)`.
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' cards::ADSL |>
#'   dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
#'   ard_stats_t_test(by = ARM, variables = c(AGE, BMIBL))
#'
#' # constructing a paired data set,
#' # where patients receive both treatments
#' cards::ADSL[c("ARM", "AGE")] |>
#'   dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
#'   dplyr::mutate(.by = ARM, USUBJID = dplyr::row_number()) |>
#'   dplyr::arrange(USUBJID, ARM) |>
#'   ard_stats_paired_t_test(by = ARM, variables = AGE, id = USUBJID)
NULL

#' @rdname ard_stats_t_test
#' @export
ard_stats_t_test <- function(data, variables, by = NULL, conf.level = 0.95, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed("broom")

  # check/process inputs -------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_data_frame(data)
  data <- dplyr::ungroup(data)
  cards::process_selectors(data, by = {{ by }}, variables = {{ variables }})
  check_scalar(by, allow_empty = TRUE)
  check_range(conf.level, range = c(0, 1))

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # build ARD ------------------------------------------------------------------
  lapply(
    variables,
    function(variable) {
      .format_ttest_results(
        by = by,
        variable = variable,
        lst_tidy =
          # styler: off
          cards::eval_capture_conditions(
            if (!is_empty(by)) stats::t.test(data[[variable]] ~ data[[by]], conf.level = conf.level, ...) |> broom::tidy()
            else stats::t.test(data[[variable]], ...) |> broom::tidy()
          ),
        # styler: on
        paired = FALSE,
        ...
      )
    }
  ) |>
    dplyr::bind_rows()
}

#' @rdname ard_stats_t_test
#' @export
ard_stats_paired_t_test <- function(data, by, variables, id, conf.level = 0.95, ...) {
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
      .format_ttest_results(
        by = by,
        variable = variable,
        lst_tidy =
          cards::eval_capture_conditions({
            # adding this reshape inside the eval, so if there is an error it's captured in the ARD object
            data_wide <- .paired_data_pivot_wider(data, by = by, variable = variable, id = id)
            # perform paired t-test
            stats::t.test(x = data_wide[["by1"]], y = data_wide[["by2"]], paired = TRUE, conf.level = conf.level, ...) |>
              broom::tidy()
          }),
        paired = TRUE,
        ...
      )
    }
  ) |>
    dplyr::bind_rows()
}

#' Convert t-test to ARD
#'
#' @inheritParams cards::tidy_as_ard
#' @inheritParams stats::t.test
#' @param by (`string`)\cr by column name
#' @param variable (`string`)\cr variable column name
#' @param ... passed to `t.test(...)`
#'
#' @return ARD data frame
#' @keywords internal
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' cardx:::.format_ttest_results(
#'   by = "ARM",
#'   variable = "AGE",
#'   paired = FALSE,
#'   lst_tidy =
#'     cards::eval_capture_conditions(
#'       stats::t.test(ADSL[["AGE"]] ~ ADSL[["ARM"]], paired = FALSE) |>
#'         broom::tidy()
#'     )
#' )
.format_ttest_results <- function(by = NULL, variable, lst_tidy, paired, ...) {
  # build ARD ------------------------------------------------------------------
  ret <-
    cards::tidy_as_ard(
      lst_tidy = lst_tidy,
      tidy_result_names =
        c(
          "estimate", "statistic",
          "p.value", "parameter", "conf.low", "conf.high",
          "method", "alternative"
        ) |>
          # add estimate1 and estimate2 if there is a by variable
        append(values = switch(!is_empty(by), c("estimate1", "estimate2")), after = 1L), # styler: off
      fun_args_to_record = c("mu", "paired", "var.equal", "conf.level"),
      formals = formals(asNamespace("stats")[["t.test.default"]]),
      passed_args = c(list(paired = paired), dots_list(...)),
      lst_ard_columns = list(variable = variable, context = "stats_t_test")
    )

  if (!is_empty(by)) {
    ret <- ret |>
      dplyr::mutate(group1 = by)
  }

  # add the stat label ---------------------------------------------------------
  ret |>
    dplyr::left_join(
      .df_ttest_stat_labels(by = by),
      by = "stat_name"
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name)) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}


#' Convert long paired data to wide
#'
#'
#' @param data (`data.frame`)\cr a data frame that is one line per subject per group
#' @param by (`string`)\cr by column name
#' @param variable (`string`)\cr variable column name
#' @param id (`string`)\cr subject id column name
#'
#' @return a wide data frame
#' @keywords internal
#' @examples
#' cards::ADSL[c("ARM", "AGE")] |>
#'   dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
#'   dplyr::mutate(.by = ARM, USUBJID = dplyr::row_number()) |>
#'   dplyr::arrange(USUBJID, ARM) |>
#'   cardx:::.paired_data_pivot_wider(by = "ARM", variable = "AGE", id = "USUBJID")
.paired_data_pivot_wider <- function(data, by, variable, id) {
  # check the number of levels before pivoting data to wider format
  if (dplyr::n_distinct(data[[by]], na.rm = TRUE) != 2L) {
    cli::cli_abort("The {.arg by} argument must have two and only two levels.",
      call = get_cli_abort_call()
    )
  }

  data |>
    # arrange data so the first group always appears first
    dplyr::arrange(.data[[by]]) |>
    tidyr::pivot_wider(
      id_cols = all_of(id),
      names_from = all_of(by),
      values_from = all_of(variable)
    ) |>
    stats::setNames(c(id, "by1", "by2"))
}

.df_ttest_stat_labels <- function(by = NULL) {
  dplyr::tribble(
    ~stat_name, ~stat_label,
    "estimate1", "Group 1 Mean",
    "estimate2", "Group 2 Mean",
    "estimate", ifelse(is_empty(by), "Mean", "Mean Difference"),
    "p.value", "p-value",
    "statistic", "t Statistic",
    "parameter", "Degrees of Freedom",
    "conf.low", "CI Lower Bound",
    "conf.high", "CI Upper Bound",
    "mu", "H0 Mean",
    "paired", "Paired t-test",
    "var.equal", "Equal Variances",
    "conf.level", "CI Confidence Level",
  )
}
