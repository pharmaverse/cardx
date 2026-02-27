#' ARD ANOVA
#'
#' Prepare ANOVA results from the `stats::anova()` function.
#' Users may pass a pre-calculated `stats::anova()` object or a list of
#' formulas. In the latter case, the models will be constructed using the
#' information passed and models will be passed to `stats::anova()`.
#'
#' @param x (`anova` or `data.frame`)\cr
#'   an object of class `'anova'` created with `stats::anova()` or
#'   a data frame
#' @param formulas (`list`)\cr
#'   a list of formulas
#' @param method_text (`string`)\cr
#'   string of the method used. Default is `"ANOVA results from `stats::anova()`"`.
#'   We provide the option to change this as `stats::anova()` can produce
#'   results from many types of models that may warrant a more precise
#'   description.
#' @inheritParams rlang::args_dots_empty
#' @inheritParams construction_helpers
#'
#' @details
#' When a list of formulas is supplied to `ard_stats_anova()`, these formulas
#' along with information from other arguments, are used to construct models
#' and pass those models to `stats::anova()`.
#'
#' The models are constructed using `rlang::exec()`, which is similar to `do.call()`.
#'
#' ```r
#' rlang::exec(.fn = method, formula = formula, data = data, !!!method.args)
#' ```
#'
#' The above function is executed in `withr::with_namespace(package)`, which
#' allows for the use of `ard_stats_anova(method)` from packages,
#' e.g. `package = 'lme4'` must be specified when `method = 'glmer'`.
#' See example below.
#'
#' @return ARD data frame
#' @name ard_stats_anova
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("broom", "withr", "lme4")))
#' anova(
#'   lm(mpg ~ am, mtcars),
#'   lm(mpg ~ am + hp, mtcars)
#' ) |>
#'   ard_stats_anova()
#'
#' ard_stats_anova(
#'   x = mtcars,
#'   formulas = list(am ~ mpg, am ~ mpg + hp),
#'   method = "glm",
#'   method.args = list(family = binomial)
#' )
#'
#' ard_stats_anova(
#'   x = mtcars,
#'   formulas = list(am ~ 1 + (1 | vs), am ~ mpg + (1 | vs)),
#'   method = "glmer",
#'   method.args = list(family = binomial),
#'   package = "lme4"
#' )
NULL

#' @rdname ard_stats_anova
#' @export
ard_stats_anova <- function(x, ...) {
  UseMethod("ard_stats_anova")
}

#' @rdname ard_stats_anova
#' @export
ard_stats_anova.anova <- function(x, method_text = "ANOVA results from `stats::anova()`", ...) {
  set_cli_abort_call()

  # check inputs ---------------------------------------------------------------
  check_dots_empty()
  check_pkg_installed("broom")
  check_string(method_text)

  # return df in cards formats -------------------------------------------------
  lst_results <-
    cards::eval_capture_conditions(
      .anova_tidy_and_reshape(x, method_text = method_text)
    )

  # final tidying up of cards data frame ---------------------------------------
  .anova_final_ard_prep(lst_results, method_text = method_text)
}


#' @rdname ard_stats_anova
#' @export
ard_stats_anova.data.frame <- function(x,
                                       formulas,
                                       method,
                                       method.args = list(),
                                       package = "base",
                                       method_text = "ANOVA results from `stats::anova()`",
                                       ...) {
  set_cli_abort_call()

  # check inputs ---------------------------------------------------------------
  check_dots_empty()
  check_pkg_installed(c("broom", "withr", package))
  check_not_missing(formulas)
  check_class(formulas, cls = "list")
  walk(
    formulas,
    ~ check_class(
      .x,
      cls = "formula",
      arg_name = "formulas",
      message = "Each element of {.arg formulas} must be class {.cls formula}"
    )
  )

  # calculate results and return df in cards formats ---------------------------
  # create models
  lst_results <-
    cards::eval_capture_conditions({
      # first build the models
      models <-
        lapply(
          formulas,
          function(formula) {
            construct_model(data = x, formula = formula, method = method, method.args = {{ method.args }}, package = package)
          }
        )

      # now calculate `stats::anova()` and reshape results
      rlang::inject(stats::anova(!!!models)) |>
        .anova_tidy_and_reshape(method_text = method_text)
    })

  # final tidying up of cards data frame ---------------------------------------
  .anova_final_ard_prep(lst_results, method_text = method_text)
}

.anova_tidy_and_reshape <- function(x, method_text) {
  broom::tidy(x) |>
    dplyr::mutate(
      across(everything(), as.list),
      variable = paste0("model_", dplyr::row_number())
    ) |>
    tidyr::pivot_longer(
      cols = -"variable",
      names_to = "stat_name",
      values_to = "stat"
    ) |>
    dplyr::filter(!is.na(.data$stat)) %>%
    # add one more row with the method
    {
      dplyr::bind_rows(
        .,
        dplyr::filter(., dplyr::n() == dplyr::row_number()) |>
          dplyr::mutate(
            stat_name = "method",
            stat = list(.env$method_text)
          )
      )
    }
}

.anova_final_ard_prep <- function(lst_results, method_text) {
  # saving the results in data frame -------------------------------------------
  df_card <-
    if (!is.null(lst_results[["result"]])) {
      lst_results[["result"]]
    } else { # if there was an error return a shell of an ARD data frame
      dplyr::tibble(
        variable = "model_1",
        stat_name = c("p.value", "method"),
        stat = list(NULL, method_text)
      )
    }

  # final tidying up of cards data frame ---------------------------------------
  df_card |>
    dplyr::mutate(
      warning = lst_results["warning"],
      error = lst_results["error"],
      context = "stats_anova",
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
      stat_label =
        dplyr::case_when(
          .data$stat_name %in% "p.value" ~ "p-value",
          .data$stat_name %in% "sumsq" ~ "Sum of Squares",
          .data$stat_name %in% "rss" ~ "Residual Sum of Squares",
          .data$stat_name %in% "df" ~ "Degrees of Freedom",
          .data$stat_name %in% "df.residual" ~ "df for residuals",
          .default = .data$stat_name
        )
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}
