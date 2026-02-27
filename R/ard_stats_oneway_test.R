#' ARD One-way Test
#'
#' @description
#' Analysis results data for Testing Equal Means in a One-Way Layout.
#' calculated with `oneway.test()`
#'
#' @inheritParams stats::oneway.test
#' @param ... additional arguments passed to `oneway.test(...)`
#'
#' @return ARD data frame
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' ard_stats_oneway_test(AGE ~ ARM, data = cards::ADSL)
ard_stats_oneway_test <- function(formula, data, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(c("broom"))

  # check/process inputs -------------------------------------------------------
  check_not_missing(formula)
  check_not_missing(data)
  check_data_frame(data)
  check_class(formula, cls = "formula")

  # build ARD ------------------------------------------------------------------
  df_results <-
    cards::tidy_as_ard(
      lst_tidy =
        cards::eval_capture_conditions(
          stats::oneway.test(formula, data = data, ...) |>
            broom::tidy()
        ),
      tidy_result_names = c("num.df", "den.df", "statistic", "p.value", "method"),
      fun_args_to_record =
        c("var.equal"),
      formals = formals(stats::oneway.test),
      passed_args = dots_list(...),
      lst_ard_columns = list(context = "stats_oneway_test")
    ) |>
    dplyr::mutate(
      .after = "stat_name",
      stat_label =
        dplyr::case_when(
          .data$stat_name %in% "num.df" ~ "Degrees of Freedom",
          .data$stat_name %in% "den.df" ~ "Denominator Degrees of Freedom",
          .data$stat_name %in% "statistic" ~ "F Statistic",
          .data$stat_name %in% "p.value" ~ "p-value",
          .data$stat_name %in% "method" ~ "Method",
          TRUE ~ .data$stat_name,
        )
    )

  # add variable/groups to results and return result
  df_results |>
    dplyr::bind_cols(
      dplyr::tibble(!!!map(as.list(attr(stats::terms(formula), "variables"))[-1], as_label)) %>%
        set_names(., c("variable", paste0("group", seq_len(length(.) - 1L))))
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}
