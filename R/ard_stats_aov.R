#' ARD ANOVA
#'
#' @description
#' Analysis results data for Analysis of Variance.
#' Calculated with `stats::aov()`
#'
#' @inheritParams stats::aov
#' @param ... arguments passed to `stats::aov(...)`
#'
#' @return ARD data frame
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("broom.helpers", "parameters")))
#' ard_stats_aov(AGE ~ ARM, data = cards::ADSL)
ard_stats_aov <- function(formula, data, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(c("broom.helpers", "parameters"))

  # check/process inputs -------------------------------------------------------
  check_not_missing(formula)
  check_not_missing(data)
  check_data_frame(data)
  check_class(formula, cls = "formula")

  # build ARD ------------------------------------------------------------------
  aov <-
    cards::eval_capture_conditions(
      stats::aov(formula, data, ...)
    )
  aov[["result"]] |>
    broom.helpers::tidy_parameters() |> # using broom.helpers, because it handle non-syntactic names
    dplyr::filter(!(dplyr::row_number() == dplyr::n() & .data$term %in% "Residuals")) |> # removing Residual rows
    dplyr::rename(variable = "term") |>
    tidyr::pivot_longer(
      cols = -"variable",
      names_to = "stat_name",
      values_to = "stat"
    ) |>
    dplyr::mutate(
      stat = as.list(.data$stat),
      stat_label =
        dplyr::case_when(
          .data$stat_name %in% "statistic" ~ "Statistic",
          .data$stat_name %in% "df" ~ "Degrees of Freedom",
          .data$stat_name %in% "p.value" ~ "p-value",
          .data$stat_name %in% "sumsq" ~ "Sum of Squares",
          .data$stat_name %in% "meansq" ~ "Mean of Sum of Squares",
          TRUE ~ .data$stat_name
        ),
      context = "stats_aov",
      fmt_fun = lapply(
        .data$stat,
        function(x) {
          switch(is.integer(x),
            0L
          ) %||% switch(is.numeric(x),
            1L
          )
        }
      ),
      warning = aov["warning"],
      error = aov["error"]
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}
