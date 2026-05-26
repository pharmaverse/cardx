#' ARD 2-sample proportion test
#'
#' @description
#' Analysis results data for a 2-sample test or proportions using [`stats::prop.test()`].
#'
#' @param data (`data.frame`)\cr
#'   a data frame.
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name to compare by
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column names to be compared. Must be a binary column coded as `TRUE`/`FALSE`
#'   or `1`/`0`. Independent tests will be computed for each variable.
#' @param conf.level (scalar `numeric`)\cr
#'   confidence level for confidence interval. Default is `0.95`.
#' @param ... arguments passed to `prop.test(...)`
#'
#' @return ARD data frame
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' mtcars |>
#'   ard_stats_prop_test(by = vs, variables = am)
ard_stats_prop_test <- function(data, by, variables, conf.level = 0.95, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(pkg = "broom")

  # check inputs ---------------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_not_missing(by)
  check_data_frame(data)
  check_scalar_range(conf.level, range = c(0, 1))

  # process inputs -------------------------------------------------------------
  cards::process_selectors(data, by = {{ by }}, variables = {{ variables }})
  check_scalar(by)
  data <- data[c(by, variables)] |> dplyr::ungroup() |> tidyr::drop_na() # styler: off

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # build ARD ------------------------------------------------------------------
  lapply(
    variables,
    function(variable) {
      .format_proptest_results(
        by = by,
        variable = variable,
        lst_tidy =
          cards::eval_capture_conditions({
            check_binary(data[[variable]], arg_name = "variable")

            data_counts <-
              dplyr::arrange(data, .data[[by]]) |>
              dplyr::summarise(
                .by = all_of(by),
                x = sum(.data[[variable]]),
                n = length(.data[[variable]])
              )

            if (nrow(data_counts) != 2) {
              cli::cli_abort(
                c(
                  "The {.arg by} column must have exactly 2 levels.",
                  "The levels are {.val {data_counts[[by]]}}"
                ),
                call = get_cli_abort_call()
              )
            }

            stats::prop.test(
              x = data_counts[["x"]],
              n = data_counts[["n"]],
              conf.level = conf.level,
              ...
            ) |>
              broom::tidy() |>
              # add central estimate for difference
              dplyr::mutate(estimate = .data$estimate1 - .data$estimate2, .before = 1L)
          }),
        ...
      )
    }
  ) |>
    dplyr::bind_rows()
}


#' Convert prop.test to ARD
#'
#' @inheritParams cards::tidy_as_ard
#' @param by (`string`)\cr by column name
#' @param variable (`string`)\cr variable column name
#' @param ... passed to `prop.test(...)`
#'
#' @return ARD data frame
#' @examples
#' NULL
#'
#' @keywords internal
.format_proptest_results <- function(by, variable, lst_tidy, ...) {
  # build ARD ------------------------------------------------------------------
  ret <-
    cards::tidy_as_ard(
      lst_tidy = lst_tidy,
      tidy_result_names = c(
        "estimate", "estimate1", "estimate2", "statistic",
        "p.value", "parameter", "conf.low", "conf.high",
        "method", "alternative"
      ),
      fun_args_to_record = c("p", "conf.level", "correct"),
      formals = formals(stats::prop.test),
      passed_args = dots_list(...),
      lst_ard_columns = list(group1 = by, variable = variable, context = "stats_prop_test")
    )

  # add the stat label ---------------------------------------------------------
  ret |>
    dplyr::left_join(
      .df_proptest_stat_labels(),
      by = "stat_name"
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name)) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}

.df_proptest_stat_labels <- function() {
  dplyr::tribble(
    ~stat_name, ~stat_label,
    "estimate1", "Group 1 Rate",
    "estimate2", "Group 2 Rate",
    "estimate", "Rate Difference",
    "p.value", "p-value",
    "statistic", "X-squared Statistic",
    "parameter", "Degrees of Freedom",
    "conf.low", "CI Lower Bound",
    "conf.high", "CI Upper Bound",
    "conf.level", "CI Confidence Level",
    "correct", "Yates' continuity correction",
  )
}
