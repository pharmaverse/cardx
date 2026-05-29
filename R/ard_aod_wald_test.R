#' ARD Wald Test
#'
#' @description
#' Function takes a regression model object and calculates Wald
#' statistical test using [`aod::wald.test()`].
#'
#' @param x regression model object
#' @param ... arguments passed to `aod::wald.test(...)`
#' @inheritParams ard_regression
#'
#' @return data frame
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("aod", "broom.helpers")))
#' lm(AGE ~ ARM, data = cards::ADSL) |>
#'   ard_aod_wald_test()
ard_aod_wald_test <- function(x, tidy_fun = broom.helpers::tidy_with_broom_or_parameters, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(c("aod", "broom.helpers"))

  # check inputs ---------------------------------------------------------------
  check_not_missing(x)

  # run regression() -----------------------------------------------------------
  reg_model <- cards::eval_capture_conditions(
    ard_regression_basic(x, tidy_fun = tidy_fun, intercept = TRUE, stats_to_remove = c(
      "var_type",
      "var_label",
      "var_class", "label",
      "contrasts_type", "contrasts", "var_nlevels", "std.error",
      "conf.low", "conf.high", "statistic", "p.value", "estimate"
    ))
  )

  if (!is.null(reg_model[["error"]])) {
    cli::cli_abort(
      c("Unable to identify underlying variable names in regression model.",
        i = "Is this model type supported by {.fun broom.helpers::tidy_plus_plus}, which is the function used to identify variable names?"
      ),
      call = get_cli_abort_call()
    )
  }
  aod <-
    reg_model[["result"]] %>%
    dplyr::select(c(
      variable = "variable",
      model_terms = "stat"
    )) %>%
    dplyr::mutate(term_id = dplyr::row_number()) %>%
    tidyr::nest(data = -"variable") %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      model_terms = unlist(.data$data[["model_terms"]]) %>% list(),
      model_terms_id = rlang::set_names(.data$data[["term_id"]]) %>% list()
    )
  # run wald.test() -----------------------------------------------------------
  wald_test <-
    cards::eval_capture_conditions(lapply(seq_len(length(aod$model_terms_id)), function(terms_id) {
      aod::wald.test(
        Sigma = stats::vcov(x),
        b = stats::coef(x), Terms = aod$model_terms_id[[terms_id]]
      )
    }))


  df_list <- do.call(rbind, lapply(wald_test$result, .extract_wald_results))

  cbind(aod$variable, df_list) %>%
    tidyr::pivot_longer(
      cols = !"aod$variable",
      names_to = "stat_name",
      values_to = "stat"
    ) %>%
    dplyr::rename(
      "variable" = "aod$variable"
    ) |>
    dplyr::mutate(
      stat = as.list(.data$stat),
      stat_label =
        dplyr::case_when(
          .data$stat_name %in% "statistic" ~ "Statistic",
          .data$stat_name %in% "df" ~ "Degrees of Freedom",
          .data$stat_name %in% "p.value" ~ "p-value",
          TRUE ~ .data$stat_name
        ),
      fmt_fun =
        map(
          .data$stat,
          function(.x) {
            # styler: off
            if (is.integer(.x)) return(0L)
            if (is.numeric(.x)) return(1L)
            # styler: on
            NULL
          }
        ),
      context = "aod_wald_test",
      warning = wald_test["warning"],
      error = wald_test["error"]
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}

#' Extract data from wald.test object
#'
#' @param wald_test (`data.frame`)\cr wald test object object from `aod::wald.test()`
#'
#' @return a data frame containing the wald test results.
#' @examples
#' NULL
#'
#' @keywords internal
.extract_wald_results <- function(wald_test) {
  df <- wald_test$result$chi2[("df")]
  statistic <- wald_test$result$chi2[("chi2")]
  p.value <- wald_test$result$chi2[("P")]
  data.frame(df, statistic, p.value)
}
