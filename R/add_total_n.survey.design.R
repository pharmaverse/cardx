#' ARD Total N
#'
#' Returns the total N for a survey object.
#' The placeholder variable name returned in the object is `"..ard_total_n.."`
#'
#' @inheritParams ard_tabulate_value.survey.design
#' @inheritParams rlang::args_dots_empty
#'
#' @return an ARD data frame of class 'card'
#' @export
#'
#' @examplesIf cardx:::is_pkg_installed("survey")
#' svy_titanic <- survey::svydesign(~1, data = as.data.frame(Titanic), weights = ~Freq)
#'
#' ard_total_n(svy_titanic)
ard_total_n.survey.design <- function(data, ...) {
  # process inputs -------------------------------------------------------------
  set_cli_abort_call()
  check_dots_empty(call = get_cli_abort_call())

  # calculate total N ----------------------------------------------------------
  data <- stats::update(data, ..ard_total_n.. = TRUE)

  data |>
    ard_tabulate_value(
      variables = "..ard_total_n..",
      statistic = list(..ard_total_n.. = c("N", "N_unweighted"))
    ) |>
    dplyr::mutate(context = "total_n") |>
    dplyr::select(-cards::all_ard_variables("levels"))
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
  # claim the abort call before delegating, so errors are reported against this
  # method rather than the `survey.design` method it delegates to
  set_cli_abort_call()
  ard_total_n.survey.design(data = data, ...)
}
