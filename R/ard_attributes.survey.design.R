#' ARD Attributes
#'
#' @description
#' Add variable attributes to an ARD data frame.
#' - The `label` attribute will be added for all columns, and when no label
#'   is specified and no label has been set for a column using the `label=` argument,
#'   the column name will be placed in the label statistic.
#' - The `class` attribute will also be returned for all columns.
#' - Any other attribute returned by `attributes()` will also be added, e.g. factor levels.
#'
#' @rdname ard_attributes
#' @param data (`survey.design`) or (`svyrep.design`)\cr
#'   a survey design object or survey replicate object often created with
#'   [`survey::svydesign()`], [`survey::as.svrepdesign()`], or 
#'   [`survey::svrepdesign()`]
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   variables to include
#' @param label (named `list`)\cr
#'   named list of variable labels, e.g. `list(cyl = "No. Cylinders")`.
#'   Default is `NULL`
#' @inheritParams rlang::args_dots_empty
#'
#' @return an ARD data frame of class 'card'
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "survey"))
#' data(api, package = "survey")
#' dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
#'
#' ard_attributes(
#'   data = dclus1,
#'   variables = c(sname, dname),
#'   label = list(sname = "School Name", dname = "District Name")
#' )
ard_attributes.survey.design <- function(data, variables = everything(), label = NULL, ...) {
  set_cli_abort_call()

  cards::ard_attributes(data = data[["variables"]], variables = {{ variables }}, label = label, ...)
}

#' @rdname ard_attributes
#' @inheritParams ard_attributes.survey.design
#' @export
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "survey"))
#' # replicate-weight designs are also supported
#' data(api, package = "survey")
#' rclus1 <-
#'   survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc) |>
#'   survey::as.svrepdesign()
#'
#' ard_attributes(
#'   data = rclus1,
#'   variables = c(sname, dname),
#'   label = list(sname = "School Name", dname = "District Name")
#' )
ard_attributes.svyrep.design <- function(data, ...) {
  ard_attributes.survey.design(data = data, ...)
}