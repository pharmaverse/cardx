#' ARD continuous CIs
#'
#' One-sample confidence intervals for continuous variable means and medians.
#'
#' @inheritParams ard_stats_t_test
#' @param method (`string`)\cr
#'   a string indicating the method to use for the confidence interval
#'   calculation. Must be one of `"t.test"` or `"wilcox.test"`
#' @param ... arguments passed to `t.test()` or `wilcox.test()`
#'
#' @return ARD data frame
#' @name ard_continuous_ci
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' ard_continuous_ci(mtcars, variables = c(mpg, hp), method = "wilcox.test")
#' ard_continuous_ci(mtcars, variables = mpg, by = am, method = "t.test")
NULL

#' @rdname ard_continuous_ci
#' @export
ard_continuous_ci <- function(data, ...) {
  check_not_missing(data)
  UseMethod("ard_continuous_ci")
}

#' @rdname ard_continuous_ci
#' @export
ard_continuous_ci.data.frame <- function(data, variables, by = dplyr::group_vars(data), conf.level = 0.95, method = c("t.test", "wilcox.test"), ...) {
  set_cli_abort_call()

  # check inputs ---------------------------------------------------------------
  method <- arg_match(method)
  check_not_missing(variables)
  cards::process_selectors(data, by = {{ by }}, variables = {{ variables }})

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # calculate CIs --------------------------------------------------------------
  switch(method,
    "t.test" =
      ard_stats_t_test_onesample(
        data = data,
        variables = {{ variables }},
        by = {{ by }},
        conf.level = conf.level,
        ...
      ),
    "wilcox.test" =
      ard_stats_wilcox_test_onesample(
        data = data,
        variables = {{ variables }},
        by = {{ by }},
        conf.level = conf.level,
        conf.int = TRUE,
        ...
      )
  ) |>
    dplyr::mutate(context = "continuous_ci")
}
