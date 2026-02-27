#' ARD Fisher's Exact Test
#'
#' @description
#' Analysis results data for Fisher's Exact Test.
#' Calculated with `fisher.test(x = data[[variable]], y = data[[by]], ...)`
#'
#'
#' @param data (`data.frame`)\cr
#'   a data frame.
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name to compare by
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column names to be compared. Independent tests will be computed for
#'   each variable.
#' @param conf.level (scalar `numeric`)\cr
#'   confidence level for confidence interval. Default is `0.95`.
#' @param ... additional arguments passed to `fisher.test(...)`
#'
#' @return ARD data frame
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' cards::ADSL[1:30, ] |>
#'   ard_stats_fisher_test(by = "ARM", variables = "AGEGR1")
ard_stats_fisher_test <- function(data, by, variables, conf.level = 0.95, ...) {
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
  check_range(conf.level, range = c(0, 1))

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
            stats::fisher.test(x = data[[variable]], y = data[[by]], conf.level = conf.level, ...) |>
              broom::tidy()
          ),
        tidy_result_names =
          c("estimate", "p.value", "conf.low", "conf.high", "method", "alternative"),
        fun_args_to_record =
          c(
            "workspace", "hybrid", "hybridPars", "control", "or",
            "conf.int", "conf.level", "simulate.p.value", "B"
          ),
        formals = formals(stats::fisher.test),
        passed_args = dots_list(...),
        lst_ard_columns = list(group1 = by, variable = variable, context = "stats_fisher_test")
      ) |>
        dplyr::mutate(
          .after = "stat_name",
          stat_label =
            dplyr::case_when(
              .data$stat_name %in% "p.value" ~ "p-value",
              TRUE ~ .data$stat_name,
            )
        )
    }
  ) |>
    dplyr::bind_rows() |>
    cards::as_card(check = FALSE)
}
