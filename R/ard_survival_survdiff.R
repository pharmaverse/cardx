#' ARD for Difference in Survival
#'
#' @description
#' Analysis results data for comparison of survival using [survival::survdiff()].
#'
#' @param formula (`formula`)\cr
#'   a formula
#' @param data (`data.frame`)\cr
#'  a data frame
#' @param rho (`scalar numeric`)\cr
#'   numeric scalar passed to `survival::survdiff(rho)`. Default is `rho=0`.
#' @param ... additional arguments passed to `survival::survdiff()`
#'
#' @return an ARD data frame of class 'card'
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("survival", "broom", "ggsurvfit")))
#' library(survival)
#' library(ggsurvfit)
#'
#' ard_survival_survdiff(Surv_CNSR(AVAL, CNSR) ~ TRTA, data = cards::ADTTE)
ard_survival_survdiff <- function(formula, data, rho = 0, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(c("survival", "broom"))

  # check/process inputs -------------------------------------------------------
  check_not_missing(formula)
  check_class(formula, cls = "formula")
  if (!missing(data)) check_class(data, cls = "data.frame")
  check_scalar(rho)
  check_class(rho, cls = "numeric")

  # assign method
  method <- dplyr::case_when(
    rho == 0 ~ "Log-rank test",
    rho == 1.5 ~ "Tarone-Ware test",
    rho == 1 ~ "Peto & Peto modification of Gehan-Wilcoxon test",
    .default = glue::glue("G-rho test (\U03C1 = {rho})")
  ) |>
    as.character()

  # calculate survdiff() results -----------------------------------------------
  lst_glance <-
    cards::eval_capture_conditions(
      survival::survdiff(formula = formula, data = data, rho = rho, ...) |>
        broom::glance() |>
        dplyr::mutate(method = .env$method)
    )

  # tidy results up in an ARD format -------------------------------------------
  # extract variable names from formula
  variables <- stats::terms(formula) |>
    attr("term.labels") |>
    .strip_backticks()

  # if there was an error, return results early
  if (is.null(lst_glance[["result"]])) {
    # if no variables in formula, then return an error
    # otherwise, if we do have variable names, then we can construct an empty ARD which will be done below
    if (is_empty(variables)) {
      cli::cli_abort(
        message =
          c("There was an error in {.fun survival::survdiff}. See below:",
            "x" = lst_glance[["error"]]
          ),
        call = get_cli_abort_call()
      )
    }
  }

  .variables_to_survdiff_ard(
    variables = variables,
    method = method,
    # styler: off
    stat_names =
      if (!is.null(lst_glance[["result"]])) names(lst_glance[["result"]])
      else c("statistic", "df", "p.value", "method"),
    stats =
      if (!is.null(lst_glance[["result"]])) unname(as.list(lst_glance[["result"]]))
      else rep_along(c("statistic", "df", "p.value"), list(NULL)) |> c(list(method = method))
    # styler: on
  ) |>
    .add_survdiff_stat_labels() |>
    dplyr::mutate(
      context = "survival_survdiff",
      warning = lst_glance["warning"],
      error = lst_glance["error"],
      fmt_fun = map(
        .data$stat,
        function(x) {
          if (is.numeric(x)) return(1L) # styler: off
          NULL
        }
      )
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}

.variables_to_survdiff_ard <- function(variables,
                                       method,
                                       stat_names,
                                       stats) {
  len <- length(variables)

  df_vars <- dplyr::tibble(!!!rev(variables)) |>
    set_names(
      ifelse(
        len > 1L,
        c(paste0("group_", rev(seq_len(len - 1L))), "variable"),
        "variable"
      )
    )

  dplyr::bind_cols(
    df_vars,
    dplyr::tibble(
      stat_name = .env$stat_names,
      stat = .env$stats
    )
  )
}

.add_survdiff_stat_labels <- function(x) {
  x |>
    dplyr::left_join(
      dplyr::tribble(
        ~stat_name, ~stat_label,
        "statistic", "X^2 Statistic",
        "df", "Degrees of Freedom",
        "p.value", "p-value"
      ),
      by = "stat_name"
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name))
}

.strip_backticks <- function(x) {
  ifelse(
    str_detect(x, "^`.*`$"),
    substr(x, 2, nchar(x) - 1),
    x
  )
}
