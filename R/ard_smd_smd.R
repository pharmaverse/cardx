#' ARD Standardized Mean Difference
#'
#' @description
#' Standardized mean difference calculated via [`smd::smd()`] with `na.rm = TRUE`.
#' Additionally, this function add a confidence interval to the SMD when
#' `std.error=TRUE`, which the original `smd::smd()` does not include.
#'
#' @param data (`data.frame`/`survey.design`)\cr
#'   a data frame or object of class 'survey.design'
#'   (typically created with [`survey::svydesign()`]).
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name to compare by.
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column names to be compared. Independent tests will be computed for
#'   each variable.
#' @param conf.level (scalar `numeric`)\cr
#'   confidence level for confidence interval. Default is `0.95`.
#' @param std.error (scalar `logical`)\cr
#'   Logical indicator for computing standard errors using `smd::compute_smd_var()`.
#'   Default is `TRUE`.
#' @param ... arguments passed to `smd::smd()`
#'
#' @return ARD data frame
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "smd"))
#' ard_smd_smd(cards::ADSL, by = SEX, variables = AGE)
#' ard_smd_smd(cards::ADSL, by = SEX, variables = AGEGR1)
ard_smd_smd <- function(data, by, variables, std.error = TRUE, conf.level = 0.95, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed("smd")

  # check/process inputs -------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_not_missing(by)

  # grab design object if from `survey` ----------------------------------------
  is_survey <- inherits(data, "survey.design")
  if (is_survey) {
    design <- data
    data <- design$variables
  }

  # continue check/process inputs ----------------------------------------------
  check_data_frame(data)
  data <- dplyr::ungroup(data)
  cards::process_selectors(data, by = {{ by }}, variables = {{ variables }})
  check_scalar(by)
  # This check can be relaxed, but would require some changes to handle multi-row outputs
  check_n_levels(data[[by]], 2L, message = "The {.arg by} column must have {.val {length}} levels.")

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # build ARD ------------------------------------------------------------------
  lapply(
    variables,
    function(variable) {
      .format_smd_results(
        by = by,
        variable = variable,
        lst_tidy =
          cards::eval_capture_conditions(
            switch(as.character(is_survey),
              "TRUE" = smd::smd(x = data[[variable]], g = data[[by]], w = stats::weights(design), na.rm = TRUE, std.error = std.error, ...),
              "FALSE" = smd::smd(x = data[[variable]], g = data[[by]], na.rm = TRUE, std.error = std.error, ...)
            ) |>
              dplyr::select(-any_of("term")) %>%
              # styler: off
              {if (isTRUE(std.error))
                dplyr::mutate(
                  .,
                  conf.low = .data$estimate + stats::qnorm((1 - .env$conf.level) / 2) * .data$std.error,
                  conf.high = .data$estimate - stats::qnorm((1 - .env$conf.level) / 2) * .data$std.error,
                  method = "Standardized Mean Difference"
                )
               else
                 dplyr::mutate(
                   .,
                   method = "Standardized Mean Difference"
                 )}
            # styler: on
          ),
        ...
      )
    }
  ) |>
    dplyr::bind_rows()
}


.format_smd_results <- function(by, variable, lst_tidy, ...) {
  # build ARD ------------------------------------------------------------------
  ret <-
    cards::tidy_as_ard(
      lst_tidy = lst_tidy,
      tidy_result_names = c("estimate", "std.error"),
      fun_args_to_record = c("gref"),
      formals = formals(smd::smd)[c("gref")],
      # removing the `std.error` ARGUMENT (not the result)
      passed_args = dots_list(...) |> utils::modifyList(list(std.error = NULL)),
      lst_ard_columns = list(group1 = by, variable = variable, context = "smd_smd")
    )

  # add the stat label ---------------------------------------------------------
  ret |>
    dplyr::left_join(
      dplyr::tribble(
        ~stat_name, ~stat_label,
        "estimate", "Standardized Mean Difference",
        "std.error", "Standard Error",
        "gref", "Integer Reference Group Level"
      ),
      by = "stat_name"
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name)) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}
