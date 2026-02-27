#' ARD Kruskal-Wallis Test
#'
#' @description
#' Analysis results data for Kruskal-Wallis Rank Sum Test.
#'
#' Calculated with `kruskal.test(data[[variable]], data[[by]], ...)`
#'
#' @param data (`data.frame`)\cr
#'   a data frame.
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name to compare by.
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column names to be compared. Independent tests will
#'   be computed for each variable.
#'
#' @return ARD data frame
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' cards::ADSL |>
#'   ard_stats_kruskal_test(by = "ARM", variables = "AGE")
ard_stats_kruskal_test <- function(data, by, variables) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed("broom")

  # check/process inputs -------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_not_missing(by)
  check_data_frame(data)
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
      cards::tidy_as_ard(
        lst_tidy =
          cards::eval_capture_conditions(
            stats::kruskal.test(x = data[[variable]], g = data[[by]]) |>
              broom::tidy()
          ),
        tidy_result_names = c("statistic", "p.value", "parameter", "method"),
        lst_ard_columns = list(group1 = by, variable = variable, context = "stats_kruskal_test")
      ) |>
        dplyr::mutate(
          .after = "stat_name",
          stat_label =
            dplyr::case_when(
              .data$stat_name %in% "statistic" ~ "Kruskal-Wallis chi-squared Statistic",
              .data$stat_name %in% "p.value" ~ "p-value",
              .data$stat_name %in% "parameter" ~ "Degrees of Freedom",
              TRUE ~ .data$stat_name,
            )
        )
    }
  ) |>
    dplyr::bind_rows() |>
    cards::as_card(check = FALSE)
}
