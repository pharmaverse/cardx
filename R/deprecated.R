#' Deprecated functions
#'
#' @description
#' `r lifecycle::badge('deprecated')`\cr
#' Some functions have been deprecated and are no longer being actively
#' supported.
#'
#' @name deprecated
#' @keywords internal
#' @examples
#' NULL
#' @returns See each individual function help page.
#'
NULL

# v0.3.0 -----------------------------------------------------------------------
#' @importFrom cards ard_continuous
#' @export
cards::ard_continuous

#' @importFrom cards ard_categorical
#' @export
cards::ard_categorical

#' @importFrom cards ard_dichotomous
#' @export
cards::ard_dichotomous

#' @rdname deprecated
#' @export
ard_continuous.survey.design <- function(data, ...) {
  lifecycle::deprecate_soft(
    when = "0.3.0",
    what = "cardx::ard_continuous()",
    with = "cardx::ard_summary()"
  )

  ard_summary(data = data, ...) |>
    dplyr::mutate(context = "continuous")
}

#' @rdname deprecated
#' @export
ard_categorical.survey.design <- function(data, ...) {
  lifecycle::deprecate_soft(
    when = "0.3.0",
    what = "cardx::ard_categorical()",
    with = "cardx::ard_tabulate()"
  )

  ard_tabulate(data = data, ...) |>
    dplyr::mutate(context = "categorical")
}

#' @rdname deprecated
#' @export
ard_dichotomous.survey.design <- function(data, ...) {
  lifecycle::deprecate_soft(
    when = "0.3.0",
    what = "cardx::ard_dichotomous()",
    with = "cardx::ard_tabulate_value()",
    details = "The `value` argument no longer has a default value and must be specified."
  )

  ard_tabulate_value(data = data, ...) |>
    dplyr::mutate(context = "dichotomous")
}

#' @rdname deprecated
#' @export
ard_categorical_max <- function(...) {
  lifecycle::deprecate_soft(
    when = "0.3.0",
    what = "cardx::ard_categorical_max()",
    with = "cardx::ard_tabulate_max()"
  )

  ard_tabulate_max(...)
}

#' @rdname deprecated
#' @export
ard_emmeans_mean_difference <- function(...) {
  lifecycle::deprecate_soft(
    when = "0.3.1",
    what = "cardx::ard_emmeans_mean_difference()",
    with = "cardx::ard_emmeans_contrast()"
  )

  ard_emmeans_contrast(...)
}
