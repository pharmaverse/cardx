#' ARD Cohen's D Test
#'
#' @description
#' Analysis results data for paired and non-paired Cohen's D Effect Size Test
#' using [`effectsize::cohens_d()`].
#'
#' @param data (`data.frame`)\cr
#'   a data frame. See below for details.
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name to compare by. Must be a categorical variable with exactly two levels.
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column names to be compared. Must be a continuous variables.
#'   Independent tests will be run for each variable.
#' @param id ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name of the subject or participant ID
#' @param conf.level (scalar `numeric`)\cr
#'   confidence level for confidence interval. Default is `0.95`.
#' @param ... arguments passed to `effectsize::cohens_d(...)`
#'
#' @return ARD data frame
#' @name ard_effectsize_cohens_d
#'
#' @details
#' For the `ard_effectsize_cohens_d()` function, the data is expected to be one row per subject.
#' The data is passed as `effectsize::cohens_d(data[[variable]]~data[[by]], data, paired = FALSE, ...)`.
#'
#' For the `ard_effectsize_paired_cohens_d()` function, the data is expected to be one row
#' per subject per by level. Before the effect size is calculated, the data are
#' reshaped to a wide format to be one row per subject.
#' The data are then passed as
#' `effectsize::cohens_d(x = data_wide[[<by level 1>]], y = data_wide[[<by level 2>]], paired = TRUE, ...)`.
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("effectsize", "parameters")))
#' cards::ADSL |>
#'   dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
#'   ard_effectsize_cohens_d(by = ARM, variables = AGE)
#'
#' # constructing a paired data set,
#' # where patients receive both treatments
#' cards::ADSL[c("ARM", "AGE")] |>
#'   dplyr::filter(ARM %in% c("Placebo", "Xanomeline High Dose")) |>
#'   dplyr::mutate(.by = ARM, USUBJID = dplyr::row_number()) |>
#'   dplyr::arrange(USUBJID, ARM) |>
#'   dplyr::group_by(USUBJID) |>
#'   dplyr::filter(dplyr::n() > 1) |>
#'   ard_effectsize_paired_cohens_d(by = ARM, variables = AGE, id = USUBJID)
NULL

#' @rdname ard_effectsize_cohens_d
#' @export
ard_effectsize_cohens_d <- function(data, by, variables, conf.level = 0.95, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(c("effectsize", "parameters"))

  # check/process inputs -------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_not_missing(by)
  check_data_frame(data)
  data <- dplyr::ungroup(data)
  cards::process_selectors(data, by = {{ by }}, variables = {{ variables }})
  check_scalar(by)
  check_range(conf.level, range = c(0, 1))

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # build ARD ------------------------------------------------------------------
  lapply(
    variables,
    function(variable) {
      .format_cohens_d_results(
        by = by,
        variable = variable,
        lst_tidy =
          cards::eval_capture_conditions(
            effectsize::cohens_d(
              reformulate2(by, response = variable),
              data = data |> tidyr::drop_na(all_of(c(by, variable))),
              paired = FALSE,
              ci = conf.level,
              ...
            ) |>
              parameters::standardize_names(style = "broom") |>
              dplyr::mutate(method = "Cohen's D")
          ),
        paired = FALSE,
        ...
      )
    }
  ) |>
    dplyr::bind_rows()
}


#' @rdname ard_effectsize_cohens_d
#' @export
ard_effectsize_paired_cohens_d <- function(data, by, variables, id, conf.level = 0.95, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(c("effectsize", "parameters"))

  # check/process inputs -------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_not_missing(by)
  check_not_missing(id)
  check_data_frame(data)
  data <- dplyr::ungroup(data)
  cards::process_selectors(data, by = {{ by }}, variables = {{ variables }}, id = {{ id }})
  check_scalar(by)
  check_scalar(id)
  check_range(conf.level, range = c(0, 1))

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # build ARD ------------------------------------------------------------------
  lapply(
    variables,
    function(variable) {
      .format_cohens_d_results(
        by = by,
        variable = variable,
        lst_tidy =
          cards::eval_capture_conditions({
            # adding this reshape inside the eval, so if there is an error it's captured in the ARD object
            data_wide <-
              data |>
              tidyr::drop_na(all_of(c(id, by, variable))) |>
              .paired_data_pivot_wider(by = by, variable = variable, id = id) |>
              tidyr::drop_na(any_of(c("by1", "by2")))
            # perform paired cohen's d test
            effectsize::cohens_d(x = data_wide[["by1"]], y = data_wide[["by2"]], paired = TRUE, ci = conf.level, ...) |>
              parameters::standardize_names(style = "broom") |>
              dplyr::mutate(method = "Paired Cohen's D")
          }),
        paired = TRUE,
        ...
      )
    }
  ) |>
    dplyr::bind_rows()
}

.df_effectsize_stat_labels <- function() {
  dplyr::tribble(
    ~stat_name, ~stat_label,
    "estimate", "Effect Size Estimate",
    "conf.low", "CI Lower Bound",
    "conf.high", "CI Upper Bound",
    "conf.level", "CI Confidence Level",
    "mu", "H0 Mean",
    "paired", "Paired test",
    "pooled_sd", "Pooled Standard Deviation",
    "alternative", "Alternative Hypothesis"
  )
}


#' Convert Cohen's D Test to ARD
#'
#' @inheritParams cards::tidy_as_ard
#' @inheritParams effectsize::cohens_d
#' @param by (`string`)\cr by column name
#' @param variable (`string`)\cr variable column name
#' @param ... passed to `cohens_d(...)`
#'
#' @return ARD data frame
#' @keywords internal
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("effectsize", "parameters")))
#' cardx:::.format_cohens_d_results(
#'   by = "ARM",
#'   variable = "AGE",
#'   paired = FALSE,
#'   lst_tidy =
#'     cards::eval_capture_conditions(
#'       effectsize::hedges_g(data[[variable]] ~ data[[by]], paired = FALSE) |>
#'         parameters::standardize_names(style = "broom")
#'     )
#' )
.format_cohens_d_results <- function(by, variable, lst_tidy, paired, ...) {
  # build ARD ------------------------------------------------------------------
  ret <-
    cards::tidy_as_ard(
      lst_tidy = lst_tidy,
      tidy_result_names = c(
        "estimate", "conf.level", "conf.low", "conf.high"
      ),
      fun_args_to_record = c("mu", "paired", "pooled_sd", "alternative"),
      formals = formals(asNamespace("effectsize")[["cohens_d"]]),
      passed_args = c(list(paired = paired), dots_list(...)),
      lst_ard_columns = list(group1 = by, variable = variable, context = "effectsize_cohens_d")
    )

  # add the stat label ---------------------------------------------------------
  ret |>
    dplyr::left_join(
      .df_effectsize_stat_labels(),
      by = "stat_name"
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name)) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}
