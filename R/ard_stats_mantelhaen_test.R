#' ARD Cochran-Mantel-Haenszel Chi-Squared Test
#'
#' @description
#' Analysis results data for Cochran-Mantel-Haenszel Chi-Squared Test for count data.
#' Calculated with `mantelhaen.test(x = data[[variables]], y = data[[by]], z = data[[strata]], ...)`.
#'
#' @param data (`data.frame`)\cr
#'   a data frame.
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name to compare by.
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column names to be compared. Independent tests will be computed for each variable.
#' @param strata ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name to stratify by.
#' @param ... additional arguments passed to `stats::mantelhaen.test(...)`
#'
#' @return ARD data frame
#' @name ard_stats_mantelhaen_test
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' cards::ADSL |>
#'   ard_stats_mantelhaen_test(by = "ARM", variables = "AGEGR1", strata = "SEX")
ard_stats_mantelhaen_test <- function(data, by, variables, strata, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed("broom")

  # check/process inputs -------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_not_missing(by)
  check_not_missing(strata)
  cards::process_selectors(data, by = {{ by }}, variables = {{ variables }}, strata = {{ strata }})
  check_class(variables, "character")
  check_scalar(by)
  check_scalar(strata)
  check_class(data[[variables]], c("character", "factor"))
  check_class(data[[by]], c("character", "factor"))
  check_class(data[[strata]], c("character", "factor"))

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  dots <- dots_list(...)
  formals_cmh <- formals(asNamespace("stats")[["mantelhaen.test"]])[-c(1:3)]
  if (!"alternative" %in% names(dots)) formals_cmh$alternative <- "two.sided"
  mantelhaen.args <- c(dots, formals_cmh[setdiff(names(formals_cmh), names(dots))])

  # build ARD ------------------------------------------------------------------
  cards::ard_mvsummary(
    data = data,
    variables = all_of(variables),
    statistic = all_of(variables) ~ list(
      stats_mantelhaen_test = .calc_mantelhaen_test(data, by, variables, strata, mantelhaen.args)
    )
  ) |>
    dplyr::select(-"stat_label") |>
    dplyr::left_join(
      .df_mantelhaentest_stat_labels(exact = mantelhaen.args$exact),
      by = "stat_name"
    ) |>
    dplyr::mutate(
      group1 = by,
      group2 = strata,
      stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name),
      context = "stats_mantelhaen_test",
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order() |>
    cards::tidy_ard_row_order()
}

.calc_mantelhaen_test <- function(data, by, variables, strata, mantelhaen.args) {
  cards::as_cards_fn(
    \(x, data, variables, ...) {
      stats::mantelhaen.test(
        x = x,
        y = data[[by]],
        z = data[[strata]],
        mantelhaen.args
      ) |>
        broom::tidy() |>
        dplyr::bind_cols(mantelhaen.args)
    },
    stat_names = c(
      "estimate", "statistic", "p.value", "parameter", "correct", "exact", "conf.level", "conf.low", "conf.high"
    )
  )
}

.df_mantelhaentest_stat_labels <- function(exact = FALSE) {
  dplyr::tribble(
    ~stat_name, ~stat_label,
    "estimate", ifelse(exact, "Mantel-Haenszel Odds Ratio Estimate", "Conditional Maximum Likelihood Odds Ratio Estimate"),
    "statistic", ifelse(exact, "Mantel-Haenszel X-squared Statistic", "Generalized Cochran-Mantel-Haenszel Statistic"),
    "p.value", "p-value",
    "parameter", "Degrees of Freedom",
    "correct", "Continuity Correction",
    "exact", "Exact Conditional Test",
    "conf.level", "CI Confidence Level",
    "conf.low", "CI Lower Bound",
    "conf.high", "CI Upper Bound"
  )
}
