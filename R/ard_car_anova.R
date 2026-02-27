#' ARD ANOVA from car Package
#'
#' Function takes a regression model object and calculated ANOVA using [`car::Anova()`].
#'
#' @param x regression model object
#' @param ... arguments passed to `car::Anova(...)`
#'
#' @return data frame
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("broom.helpers", "car", "parameters")))
#' lm(AGE ~ ARM, data = cards::ADSL) |>
#'   ard_car_anova()
#'
#' glm(vs ~ factor(cyl) + factor(am), data = mtcars, family = binomial) |>
#'   ard_car_anova(test.statistic = "Wald")
ard_car_anova <- function(x, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(pkg = c("broom.helpers", "car", "parameters"))

  # check inputs ---------------------------------------------------------------
  check_not_missing(x)

  # run car::Anova() -----------------------------------------------------------
  car_anova <- cards::eval_capture_conditions(car::Anova(x, ...))

  if (!is.null(car_anova[["error"]])) {
    cli::cli_abort(
      c(
        "There was an error running {.fun car::Anova}. See error message below.",
        x = car_anova[["error"]]
      ),
      call = get_cli_abort_call()
    )
  }

  car_anova[["result"]] |>
    broom.helpers::tidy_parameters(conf.int = FALSE) |> # using broom.helpers, because it handle non-syntactic names for us
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
      context = "car_anova",
      warning = car_anova["warning"],
      error = car_anova["error"]
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}
