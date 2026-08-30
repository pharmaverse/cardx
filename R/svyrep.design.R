# Replicate-weight survey designs (`svyrep.design`) are a sibling class of
# `survey.design`, not a subclass, so they do not inherit the methods defined
# for `survey.design`. The methods below delegate to their `survey.design`
# counterparts: the statistics are computed by `survey::svymean()`,
# `svytotal()`, `svyvar()`, `svyquantile()`, `svytable()` and `svyby()`, each
# of which already handles replicate designs, so no separate calculation is
# required. See #355.

#' @rdname ard_attributes
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

#' @rdname ard_missing.survey.design
#' @export
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "survey"))
#' # replicate-weight designs are also supported
#' data(api, package = "survey")
#' rclus1 <-
#'   survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc) |>
#'   survey::as.svrepdesign()
#'
#' ard_missing(rclus1, variables = api00, by = stype)
ard_missing.svyrep.design <- function(data, ...) {
  ard_missing.survey.design(data = data, ...)
}

#' @rdname ard_tabulate.survey.design
#' @export
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "survey"))
#' # replicate-weight designs are also supported: the standard errors are
#' # computed from the replicate weights rather than by linearization
#' data(api, package = "survey")
#' rclus1 <-
#'   survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc) |>
#'   survey::as.svrepdesign()
#'
#' ard_tabulate(rclus1, variables = stype, by = both)
ard_tabulate.svyrep.design <- function(data, ...) {
  ard_tabulate.survey.design(data = data, ...)
}

#' @rdname ard_tabulate_value.survey.design
#' @export
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "survey"))
#' # replicate-weight designs are also supported
#' data(api, package = "survey")
#' rclus1 <-
#'   survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc) |>
#'   survey::as.svrepdesign()
#'
#' ard_tabulate_value(rclus1, variables = stype, value = list(stype = "E"))
ard_tabulate_value.svyrep.design <- function(data, ...) {
  ard_tabulate_value.survey.design(data = data, ...)
}

#' @rdname ard_summary.survey.design
#' @export
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "survey"))
#' # replicate-weight designs are also supported
#' data(api, package = "survey")
#' rclus1 <-
#'   survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc) |>
#'   survey::as.svrepdesign()
#'
#' ard_summary(
#'   data = rclus1,
#'   variables = api00,
#'   by = stype
#' )
ard_summary.svyrep.design <- function(data, ...) {
  ard_summary.survey.design(data = data, ...)
}

#' @rdname ard_total_n.survey.design
#' @export
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "survey"))
#' # replicate-weight designs are also supported
#' data(api, package = "survey")
#' rclus1 <-
#'   survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc) |>
#'   survey::as.svrepdesign()
#'
#' ard_total_n(rclus1)
ard_total_n.svyrep.design <- function(data, ...) {
  ard_total_n.survey.design(data = data, ...)
}
