#' ARD Poisson Test
#'
#' @description
#' Analysis results data for exact tests of a simple null hypothesis about the rate parameter
#' in Poisson distribution, or the comparison of two rate parameters.
#'
#' @param data (`data.frame`)\cr
#'   a data frame. See below for details.
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   names of the event and time variables (in that order) to be used in computations. Must be of length 2.
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   optional column name to compare by.
#' @param conf.level (scalar `numeric`)\cr
#'   confidence level for confidence interval. Default is `0.95`.
#' @param na.rm (scalar `logical`)\cr
#'   whether missing values should be removed before computations. Default is `TRUE`.
#' @param ... arguments passed to [poisson.test()].
#' @return an ARD data frame of class 'card'
#' @name ard_stats_poisson_test
#'
#' @details
#' * For the `ard_stats_poisson_test()` function, the data is expected to be one row per subject.
#' * If `by` is not specified, an exact Poisson test of the rate parameter will be performed. Otherwise, a
#'   Poisson comparison of two rate parameters will be performed on the levels of `by`. If `by` has more than 2
#'   levels, an error will occur.
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' # Exact test of rate parameter against null hypothesis
#' cards::ADTTE |>
#'   ard_stats_poisson_test(variables = c(CNSR, AVAL))
#'
#' # Comparison test of ratio of 2 rate parameters against null hypothesis
#' cards::ADTTE |>
#'   dplyr::filter(TRTA %in% c("Placebo", "Xanomeline High Dose")) |>
#'   ard_stats_poisson_test(by = TRTA, variables = c(CNSR, AVAL))
NULL

#' @rdname ard_stats_poisson_test
#' @export
ard_stats_poisson_test <- function(data, variables, na.rm = TRUE, by = NULL, conf.level = 0.95, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed("broom")

  # check/process inputs -------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_data_frame(data)
  data <- dplyr::ungroup(data)
  cards::process_selectors(data, by = {{ by }}, variables = {{ variables }})
  check_length(variables, 2)
  check_logical(na.rm)
  check_scalar(by, allow_empty = TRUE)
  check_range(conf.level, range = c(0, 1))

  # return empty ARD if no variables selected ----------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # check number of levels in `by`
  if (!is_empty(by) && dplyr::n_distinct(data[[by]], na.rm = TRUE) != 2L) {
    cli::cli_abort(
      "The {.arg by} argument must have a maximum of two levels.",
      call = get_cli_abort_call()
    )
  }

  # calculate numerator and denominator values
  if (!is_empty(by)) {
    num <- data |>
      dplyr::group_by(.data[[by]]) |>
      dplyr::summarise(sum = sum(.data[[variables[1]]], na.rm = na.rm)) |>
      dplyr::pull(sum)
    denom <- data |>
      dplyr::group_by(.data[[by]]) |>
      dplyr::summarise(sum = sum(.data[[variables[2]]], na.rm = na.rm)) |>
      dplyr::pull(sum)
  } else {
    num <- sum(data[[variables[1]]], na.rm = na.rm)
    denom <- sum(data[[variables[2]]], na.rm = na.rm)
  }

  # build ARD ------------------------------------------------------------------
  .format_poissontest_results(
    by = by,
    variables = variables,
    lst_tidy =
      cards::eval_capture_conditions(
        stats::poisson.test(x = num, T = denom, conf.level = conf.level, ...) |> broom::tidy()
      ),
    ...
  )
}

#' Convert Poisson test to ARD
#'
#' @inheritParams cards::tidy_as_ard
#' @inheritParams stats::poisson.test
#' @param by (`string`)\cr by column name
#' @param variables (`character`)\cr names of the event and time variables
#' @param ... passed to [poisson.test()]
#'
#' @return ARD data frame
#' @keywords internal
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' cardx:::.format_poissontest_results(
#'   by = "ARM",
#'   variables = c("CNSR", "AVAL"),
#'   lst_tidy =
#'     cards::eval_capture_conditions(
#'       stats::poisson.test(sum(cards::ADTTE[["CNSR"]]), sum(cards::ADTTE[["AVAL"]])) |>
#'         broom::tidy()
#'     )
#' )
.format_poissontest_results <- function(by = NULL, variables, lst_tidy, ...) {
  # build ARD ------------------------------------------------------------------
  ret <-
    cards::tidy_as_ard(
      lst_tidy = lst_tidy,
      tidy_result_names =
        c(
          "estimate", "statistic",
          "p.value", "parameter", "conf.low", "conf.high",
          "method", "alternative"
        ),
      fun_args_to_record = c("conf.level", "r"),
      formals = formals(asNamespace("stats")[["poisson.test"]]),
      passed_args = dots_list(...),
      lst_ard_columns = list(context = "stats_poisson_test", variable = variables[2])
    ) |>
    dplyr::distinct()

  # rename "r" statistic to "mu"
  ret$stat_name[ret$stat_name == "r"] <- "mu"

  if (!is_empty(by)) {
    ret <- ret |>
      dplyr::mutate(group1 = by)
  }

  # add the stat label ---------------------------------------------------------
  ret |>
    dplyr::left_join(
      .df_poissontest_stat_labels(by = by),
      by = "stat_name"
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name)) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}

.df_poissontest_stat_labels <- function(by = NULL) {
  dplyr::tribble(
    ~stat_name, ~stat_label,
    "estimate", ifelse(is_empty(by), "Estimated Rate", "Estimated Rate Ratio"),
    "statistic", ifelse(is_empty(by), "Number of Events", "Number of Events in First Sample"),
    "p.value", "p-value",
    "parameter", "Expected Count",
    "conf.low", "CI Lower Bound",
    "conf.high", "CI Upper Bound",
    "mu", "H0 Mean",
    "conf.level", "CI Confidence Level"
  )
}
