#' ARD to Calculate Categorical Occurrence Rates by Maximum Level Per Unique ID
#'
#' Function calculates categorical variable level occurrences rates by maximum level per unique ID.
#' Each variable in `variables` is evaluated independently and then results for all variables are stacked.
#' Only the highest-ordered level will be counted for each unique ID.
#' Unordered, non-numeric variables will be converted to factor and the default level order used for ordering.
#'
#' @inheritParams cards::ard_tabulate
#' @inheritParams cards::ard_stack
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   The categorical variables for which occurrence rates per unique ID (by maximum level) will be calculated.
#' @param id ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   Argument used to subset `data` to identify rows in `data` to calculate categorical variable level occurrence rates.
#' @param denominator (`data.frame`, `integer`)\cr
#'   An optional argument to change the denominator used for `"N"` and `"p"` statistic calculations.
#'   Defaults to `NULL`, in which case `dplyr::distinct(data, dplyr::pick(all_of(c(id, by))))` is used for these
#'   calculations. See [cards::ard_tabulate()] for more details on specifying denominators.
#' @param quiet (scalar `logical`)\cr
#'   Logical indicating whether to suppress additional messaging. Default is `FALSE`.
#' @param fmt_fn `r lifecycle::badge("deprecated")`
#'
#' @return an ARD data frame of class 'card'
#' @name ard_tabulate_max
#'
#' @examples
#' # Occurrence Rates by Max Level (Highest Severity) --------------------------
#' ard_tabulate_max(
#'   cards::ADAE,
#'   variables = c(AESER, AESEV),
#'   id = USUBJID,
#'   by = TRTA,
#'   denominator = cards::ADSL
#' )
NULL

#' @rdname ard_tabulate_max
#' @export
ard_tabulate_max <- function(data,
                             variables,
                             id,
                             by = dplyr::group_vars(data),
                             statistic = everything() ~ c("n", "p", "N"),
                             denominator = NULL,
                             strata = NULL,
                             fmt_fun = NULL,
                             stat_label = everything() ~ cards::default_stat_labels(),
                             quiet = FALSE,
                             fmt_fn = deprecated(),
                             ...) {
  set_cli_abort_call()

  # deprecated args ------------------------------------------------------------
  if (lifecycle::is_present(fmt_fn)) {
    lifecycle::deprecate_soft(
      when = "0.2.5",
      what = "ard_tabulate_max(fmt_fn)",
      with = "ard_tabulate_max(fmt_fun)"
    )
    fmt_fun <- fmt_fn
  }

  # check inputs ---------------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_not_missing(id)
  cards::process_selectors(data,
    variables = {{ variables }}, id = {{ id }},
    by = {{ by }}, strata = {{ strata }}
  )
  data <- dplyr::ungroup(data)

  # check the id argument is not empty
  if (is_empty(id)) {
    cli::cli_abort("Argument {.arg id} cannot be empty.", call = get_cli_abort_call())
  }

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  lst_results <- lapply(
    variables,
    function(x) {
      ard_categorical(
        data = data |>
          arrange_using_order(c(id, by, strata, x)) |>
          dplyr::slice_tail(n = 1L, by = all_of(c(id, by, strata))),
        variables = all_of(x),
        by = all_of(by),
        strata = all_of(strata),
        statistic = statistic,
        denominator = denominator,
        fmt_fun = fmt_fun,
        stat_label = stat_label
      )
    }
  )

  # print default order of variable levels -------------------------------------
  for (v in variables) {
    lvls <- .unique_and_sorted(data[[v]])
    vec <- cli::cli_vec(
      lvls,
      style = list("vec-sep" = " < ", "vec-sep2" = " < ", "vec-last" = " < ", "vec-trunc" = 3)
    )
    if (!quiet) cli::cli_inform("{.var {v}}: {.val {vec}}")
  }

  # combine results ------------------------------------------------------------
  result <- lst_results |>
    dplyr::bind_rows() |>
    dplyr::mutate(context = "categorical_max") |>
    cards::tidy_ard_column_order() |>
    cards::tidy_ard_row_order()

  # return final result --------------------------------------------------------
  result
}

# internal function copied from cards
# like `dplyr::arrange()`, but uses base R's `order()` to keep consistency in some edge cases
arrange_using_order <- function(data, columns) {
  inject(data[with(data, order(!!!syms(columns))), ])
}
