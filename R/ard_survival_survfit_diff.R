#' ARD Survival Differences
#'
#' Calculate differences in the Kaplan-Meier estimator of survival using the
#' results from [`survival::survfit()`].
#'
#' @param x (`survift`)\cr
#'   object of class `'survfit'` typically created with [`survival::survfit()`]
#' @param conf.level (scalar `numeric`)\cr
#'   confidence level for confidence interval. Default is `0.95`.
#' @inheritParams ard_survival_survfit
#'
#' @return an ARD data frame of class 'card'
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("survival", "ggsurvfit")))
#' library(ggsurvfit)
#' library(survival)
#'
#' survfit(Surv_CNSR() ~ TRTA, data = cards::ADTTE) |>
#'   ard_survival_survfit_diff(times = c(25, 50))
ard_survival_survfit_diff <- function(x, times, conf.level = 0.95) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(c("survival", "broom"))
  check_not_missing(x)
  check_not_missing(times)
  check_class(x, "survfit")

  if (inherits(x, c("survfitms", "survfitcox"))) {
    cli::cli_abort(
      "Argument {.arg x} cannot be class {.cls {c('survfitms', 'survfitcox')}}.",
      call = get_cli_abort_call()
    )
  }
  check_scalar_range(conf.level, range = c(0, 1))
  check_length(
    as.list(x$call)[["formula"]] |> stats::as.formula() |> stats::terms() |> attr("term.labels"),
    length = 1L,
    message = "The {.cls survfit} object passed in argument {.arg x} must be stratified by a single variable."
  )
  if (length(x$strata) < 2) {
    cli::cli_abort(
      "The {.cls survfit} object's stratifying variable must have 2 or more levels.",
      call = get_cli_abort_call()
    )
  }

  # calculate the survival at the specified times
  ard_survival_survfit <-
    ard_survival_survfit(x = x, times = times) |>
    dplyr::filter(.data$stat_name %in% c("estimate", "std.error")) |>
    dplyr::select(-c("stat_label", "context", "fmt_fun"))

  # transform the survival ARD into a cards object with the survival difference
  card <-
    ard_survival_survfit %>%
    {dplyr::left_join( # styler: off
        # remove the first group from the data frame (this is our reference group)
        dplyr::filter(., .by = cards::all_ard_groups(), dplyr::cur_group_id() > 1L) |>
          dplyr::rename(stat1 = "stat"),
        # merge the reference group data
        dplyr::filter(., .by = cards::all_ard_groups(), dplyr::cur_group_id() == 1L) |>
          dplyr::select(stat0 = "stat", everything(), -c("group1_level", "error", "warning")),
        by = c("group1", "variable", "variable_level", "stat_name")
    )} |> # styler: off
    # reshape to put the stats that need to be combined on the same row
    tidyr::pivot_wider(
      id_cols = c("group1", "group1_level", "variable", "variable_level"),
      names_from = "stat_name",
      values_from = c("stat0", "stat1"),
      values_fn = unlist
    ) |>
    # calcualte the primary statistics to return
    dplyr::mutate(
      # reference level
      reference_level = ard_survival_survfit[["group1_level"]][1],
      # short description of method
      method = "Survival Difference (Z-test)",
      # survival difference
      estimate = .data$stat0_estimate - .data$stat1_estimate,
      # survival difference standard error
      std.error = sqrt(.data$stat0_std.error^2 + .data$stat1_std.error^2),
      # Z test statistic
      statistic = .data$estimate / .data$std.error,
      # confidence limits of the survival difference
      conf.low = .data$estimate - .data$std.error * stats::qnorm(1 - (1 - .env$conf.level) / 2),
      conf.high = .data$estimate + .data$std.error * stats::qnorm(1 - (1 - .env$conf.level) / 2),
      # p-value for test where H0: no difference
      p.value = 2 * (1 - stats::pnorm(abs(.data$statistic))),
      across(c("reference_level", "estimate", "std.error", "statistic", "conf.low", "conf.high", "p.value", "method"), as.list)
    ) |>
    # reshape into the cards structure
    dplyr::select(-starts_with("stat0_"), -starts_with("stat1_")) |>
    tidyr::pivot_longer(
      cols = -c(cards::all_ard_groups(), cards::all_ard_variables()),
      names_to = "stat_name",
      values_to = "stat"
    )

  # final prepping of the cards object -----------------------------------------
  card |>
    dplyr::mutate(
      warning = ard_survival_survfit[["warning"]][1],
      error = ard_survival_survfit[["error"]][1],
      fmt_fun = list(1L),
      stat_label =
        dplyr::case_when(
          .data$stat_name %in% "estimate" ~ "Survival Difference",
          .data$stat_name %in% "std.error" ~ "Survival Difference Standard Error",
          .data$stat_name %in% "conf.low" ~ "CI Lower Bound",
          .data$stat_name %in% "conf.high" ~ "CI Upper Bound",
          .data$stat_name %in% "statistic" ~ "z statistic",
          .data$stat_name %in% "p.value" ~ "p-value",
          .default = .data$stat_name
        ),
      context = "survival_survfit_diff",
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}
