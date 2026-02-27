#' Regression ARD
#'
#' Function takes a regression model object and converts it to a ARD
#' structure using the `broom.helpers` package.
#'
#' @inheritParams construct_model
#' @param x (regression model/`data.frame`)\cr
#'   regression model object or a data frame
#' @param tidy_fun (`function`)\cr
#'   a tidier. Default is [`broom.helpers::tidy_with_broom_or_parameters`]
#' @param ... Arguments passed to [`broom.helpers::tidy_plus_plus()`]
#'
#' @return data frame
#' @name ard_regression
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom.helpers"))
#' lm(AGE ~ ARM, data = cards::ADSL) |>
#'   ard_regression(add_estimate_to_reference_rows = TRUE)
#'
#' ard_regression(
#'   x = cards::ADSL,
#'   formula = AGE ~ ARM,
#'   method = "lm"
#' )
NULL

#' @rdname ard_regression
#' @export
ard_regression <- function(x, ...) {
  UseMethod("ard_regression")
}

#' @rdname ard_regression
#' @export
ard_regression.default <- function(x, tidy_fun = broom.helpers::tidy_with_broom_or_parameters, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(pkg = "broom.helpers")

  # check inputs ---------------------------------------------------------------
  check_not_missing(x)

  # summarize model ------------------------------------------------------------
  lst_results <- cards::eval_capture_conditions(
    broom.helpers::tidy_plus_plus(
      model = x,
      tidy_fun = tidy_fun,
      ...
    )
  )

  # final tidying up of cards data frame ---------------------------------------
  .regression_final_ard_prep(lst_results)
}

#' @rdname ard_regression
#' @export
ard_regression.data.frame <- function(x, formula, method, method.args = list(), package = "base",
                                      tidy_fun = broom.helpers::tidy_with_broom_or_parameters, ...) {
  # check inputs ---------------------------------------------------------------
  set_cli_abort_call()
  check_not_missing(x)
  check_not_missing(formula)
  check_not_missing(method)
  check_class(formula, cls = "formula")

  # build model ----------------------------------------------------------------
  model <-
    construct_model(
      data = x,
      formula = formula,
      method = method,
      method.args = {{ method.args }},
      package = package
    )

  # summarize model ------------------------------------------------------------
  ard_regression(x = model, tidy_fun = tidy_fun, ...)
}

.regression_final_ard_prep <- function(lst_results) {
  # saving the results in data frame -------------------------------------------
  df_card <-
    if (!is.null(lst_results[["result"]])) {
      lst_results[["result"]] |>
        dplyr::mutate(
          variable_level = as.list(dplyr::if_else(.data$var_type %in% "continuous", NA_character_, .data$label)),
          dplyr::across(-c("variable", "variable_level"), .fns = as.list)
        ) |>
        tidyr::pivot_longer(
          cols = -c("variable", "variable_level"),
          names_to = "stat_name",
          values_to = "stat"
        ) |>
        dplyr::filter(map_lgl(.data$stat, Negate(is.na))) |>
        dplyr::select(-(cards::all_ard_variables("levels") & dplyr::where(\(x) all(is.na(x)))))
    } else { # if there was an error return a shell of an ARD data frame
      dplyr::tibble(
        variable = "model_1",
        stat_name = "estimate",
        stat = list(NULL)
      )
    }

  # final tidying up of ARD data frame ---------------------------------------
  df_card |>
    dplyr::mutate(
      warning = lst_results["warning"],
      error = lst_results["error"],
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
      context = "regression"
    ) |>
    dplyr::left_join(
      .df_regression_stat_labels(),
      by = "stat_name"
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name)) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}

.df_regression_stat_labels <- function() {
  dplyr::tribble(
    ~stat_name, ~stat_label,
    "var_label", "Label",
    "var_class", "Class",
    "var_type", "Type",
    "var_nlevels", "N Levels",
    "contrasts_type", "Contrast Type",
    "label", "Level Label",
    "n_obs", "N Obs.",
    "n_event", "N Events",
    "exposure", "Exposure Time",
    "estimate", "Coefficient",
    "std.error", "Standard Error",
    "p.value", "p-value",
    "conf.low", "CI Lower Bound",
    "conf.high", "CI Upper Bound",
  )
}
