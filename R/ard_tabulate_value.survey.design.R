#' ARD Dichotomous Survey Statistics
#'
#' Compute Analysis Results Data (ARD) for dichotomous summary statistics.
#'
#' @inheritParams ard_tabulate.survey.design
#' @param value (named `list`)\cr
#'   named list of dichotomous values to tabulate.
#'   Default is `cards::maximum_variable_value(data$variables)`,
#'   which returns the largest/last value after a sort.
#'
#' @return an ARD data frame of class 'card'
#' @export
#'
#' @examplesIf cardx:::is_pkg_installed("survey")
#' survey::svydesign(ids = ~1, data = mtcars, weights = ~1) |>
#'   ard_tabulate_value(by = vs, variables = c(cyl, am), value = list(cyl = 4))
ard_tabulate_value.survey.design <- function(data,
                                             variables,
                                             by = NULL,
                                             value = cards::maximum_variable_value(data$variables[variables]),
                                             statistic = everything() ~ c("n", "N", "p", "p.std.error", "n_unweighted", "N_unweighted", "p_unweighted"),
                                             denominator = c("column", "row", "cell"),
                                             fmt_fun = NULL,
                                             stat_label = everything() ~ list(
                                               p = "%",
                                               p.std.error = "SE(%)",
                                               deff = "Design Effect",
                                               "n_unweighted" = "Unweighted n",
                                               "N_unweighted" = "Unweighted N",
                                               "p_unweighted" = "Unweighted %"
                                             ),
                                             fmt_fn = deprecated(),
                                             ...) {
  set_cli_abort_call()
  check_dots_empty()
  check_pkg_installed(pkg = "survey")

  # deprecated args ------------------------------------------------------------
  if (lifecycle::is_present(fmt_fn)) {
    lifecycle::deprecate_soft(
      when = "0.2.5",
      what = "ard_tabulate_value(fmt_fn)",
      with = "ard_tabulate_value(fmt_fun)"
    )
    fmt_fun <- fmt_fn
  }

  # check inputs ---------------------------------------------------------------
  check_not_missing(variables)

  # process inputs -------------------------------------------------------------
  cards::process_selectors(data$variables, variables = {{ variables }})
  cards::process_formula_selectors(data$variables[variables], value = value)
  cards::fill_formula_selectors(
    data$variables[variables],
    value = formals(asNamespace("cardx")[["ard_tabulate_value.survey.design"]])[["value"]] |> eval()
  )
  .check_dichotomous_value(data$variables, value)

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # calculate summary statistics -----------------------------------------------
  ard_tabulate(
    data = data,
    variables = all_of(variables),
    by = {{ by }},
    statistic = statistic,
    denominator = denominator,
    fmt_fun = fmt_fun,
    stat_label = stat_label
  ) |>
    dplyr::filter(
      pmap(
        list(.data$variable, .data$variable_level),
        function(variable, variable_level) {
          variable_level %in% .env$value[[variable]]
        }
      ) |>
        unlist()
    ) |>
    dplyr::mutate(context = "dichotomous")
}

#' Perform Value Checks
#'
#' Check the validity of the values passed in `ard_tabulate_value(value)`.
#'
#' @param data (`data.frame`)\cr
#'   a data frame
#' @param value (named `list`)\cr
#'   a named list
#'
#' @return returns invisible if check is successful, throws an error message if not.
#' @keywords internal
#'
#' @examples
#' cardx:::.check_dichotomous_value(mtcars, list(cyl = 4))
.check_dichotomous_value <- function(data, value) {
  imap(
    value,
    function(value, column) {
      accepted_values <- .unique_and_sorted(data[[column]])
      if (length(value) != 1L || !value %in% accepted_values) {
        message <- "Error in argument {.arg value} for variable {.val {column}}."
        message <-
          case_switch(
            length(value) != 1L ~ c(message, "i" = "The value must be one of {.val {accepted_values}}."),
            .default = c(message, "i" = "A value of {.val {value}} was passed, but must be one of {.val {accepted_values}}.")
          )
        if (length(value) == 1L) {
          message <-
            case_switch(
              inherits(data[[column]], "factor") ~
                c(message, i = "To summarize this value, use {.fun forcats::fct_expand} to add {.val {value}} as a level."),
              .default = c(message, i = "To summarize this value, make the column a factor and include {.val {value}} as a level.")
            )
        }


        cli::cli_abort(
          message = message,
          call = get_cli_abort_call()
        )
      }
    }
  ) |>
    invisible()
}

#' ARD-flavor of unique()
#'
#' Essentially a wrapper for `unique(x) |> sort()` with `NA` levels removed.
#' For factors, all levels are returned even if they are unobserved.
#' Similarly, logical vectors always return `c(TRUE, FALSE)`, even if
#' both levels are not observed.
#'
#' @param x (`any`)\cr
#'   a vector
#'
#' @return a vector
#' @keywords internal
#'
#' @examples
#' cards:::.unique_and_sorted(factor(letters[c(5, 5:1)], levels = letters))
#'
#' cards:::.unique_and_sorted(c(FALSE, TRUE, TRUE, FALSE))
#'
#' cards:::.unique_and_sorted(c(5, 5:1))
.unique_and_sorted <- function(x, useNA = c("no", "always")) {
  # styler: off
  useNA <- match.arg(useNA)
  # if a factor return a factor that includes the same levels (including unobserved levels)
  if (inherits(x, "factor")) {
    return(
      factor(
        if (useNA == "no") levels(x)
        else c(levels(x), NA_character_),
        levels = levels(x)
      )
    )
  }
  if (inherits(x, "logical")) {
    if (useNA == "no") return(c(TRUE, FALSE))
    else return(c(TRUE, FALSE, NA))
  }

  # otherwise, return a simple unique and sort of the vector
  if (useNA == "no") return(unique(x) |> sort())
  else return(unique(x) |> sort() |> c(NA))
  # styler: on
}
