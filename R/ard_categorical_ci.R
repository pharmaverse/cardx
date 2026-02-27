#' ARD Proportion Confidence Intervals
#'
#' Calculate confidence intervals for proportions.
#'
#' @inheritParams cards::ard_tabulate
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   columns to include in summaries. Columns must be class `<logical>`
#'   or `<numeric>` values coded as `c(0,1)`.
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   columns to stratify calculations by.
#' @param denominator (`string`)\cr
#'   Must be one of `'column'` (default), `'row'`, and `'cell'`, which specifies
#'   the direction of the calculation/denominator. Argument is similar to
#'   `cards::ard_tabulate(denominator)`.
#' @param conf.level (scalar `numeric`)\cr
#'   a scalar in `(0,1)` indicating the confidence level.
#'   Default is `0.95`
#' @param method (`string`)\cr
#'   string indicating the type of confidence interval to calculate.
#'   Must be one of `r formals(ard_categorical_ci)[["method"]] |> eval() |> shQuote("sh")`.
#'   See `?proportion_ci` for details.
#' @param strata,weights,max.iterations arguments passed to `proportion_ci_strat_wilson()`,
#'   when `method='strat_wilson'`
#' @param value ([`formula-list-selector`][cards::syntax])\cr
#'   function will calculate the CIs for all levels of the variables specified.
#'   Use this argument to instead request only a single level by summarized.
#'   Default is `list(where(is_binary) ~ 1L, where(is.logical) ~ TRUE)`, where
#'   columns coded as `0`/`1` and `TRUE`/`FALSE` will summarize the `1` and `TRUE` levels.
#'
#' @return an ARD data frame
#' @name ard_categorical_ci
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom"))
#' # compute CI for binary variables
#' ard_categorical_ci(mtcars, variables = c(vs, am), method = "wilson")
#'
#' # compute CIs for each level of a categorical variable
#' ard_categorical_ci(mtcars, variables = cyl, method = "jeffreys")
NULL

#' @rdname ard_categorical_ci
#' @export
ard_categorical_ci <- function(data, ...) {
  check_not_missing(data)
  UseMethod("ard_categorical_ci")
}

#' @rdname ard_categorical_ci
#' @export
ard_categorical_ci.data.frame <- function(data,
                                          variables,
                                          by = dplyr::group_vars(data),
                                          method = c(
                                            "waldcc", "wald", "clopper-pearson",
                                            "wilson", "wilsoncc",
                                            "strat_wilson", "strat_wilsoncc",
                                            "agresti-coull", "jeffreys"
                                          ),
                                          denominator = c("column", "row", "cell"),
                                          conf.level = 0.95,
                                          value = list(where(is_binary) ~ 1L, where(is.logical) ~ TRUE),
                                          strata = NULL,
                                          weights = NULL,
                                          max.iterations = 10,
                                          ...) {
  set_cli_abort_call()
  check_dots_empty()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(pkg = "broom")

  # process inputs -------------------------------------------------------------
  check_not_missing(variables)
  cards::process_selectors(data, variables = {{ variables }}, by = {{ by }})
  denominator <- arg_match(denominator, call = get_cli_abort_call())
  method <- arg_match(method)
  if (method %in% c("strat_wilson", "strat_wilsoncc")) {
    cards::process_selectors(data, strata = {{ strata }})
    check_scalar(strata)
  }

  # if the method is strat_wilson, `weights` and `strata` cannot contain NA values
  if (method %in% c("strat_wilson")) {
    if (any(is.na({{ weights }}))) {
      cli::cli_warn("{.field weights} cannot contain {.val NA} values.")
    }
  }
  cards::process_formula_selectors(
    data[variables],
    value = value
  )

  # if there is no by variable, then treat cell as column because it's the same.
  if (denominator == "cell" && is_empty(by)) {
    denominator <- "column"
  }

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # calculate confidence intervals ---------------------------------------------
  map(
    variables,
    function(variable) {
      switch(denominator,
        "column" =
          .calculate_ard_proportion_column(
            data = data,
            variable = variable,
            by = by,
            value = value,
            method = method,
            conf.level = conf.level,
            strata = strata,
            weights = weights,
            max.iterations = max.iterations
          ),
        "row" =
          .calculate_ard_proportion_row(
            data = data,
            variable = variable,
            by = by,
            value = value,
            method = method,
            conf.level = conf.level,
            strata = strata,
            weights = weights,
            max.iterations = max.iterations
          ),
        "cell" =
          .calculate_ard_proportion_cell(
            data = data,
            variable = variable,
            by = by,
            value = value,
            method = method,
            conf.level = conf.level,
            strata = strata,
            weights = weights,
            max.iterations = max.iterations
          )
      )
    }
  ) |>
    dplyr::bind_rows() |>
    dplyr::mutate(
      context = "proportion_ci"
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order() |>
    cards::tidy_ard_row_order()
}

.calculate_ard_proportion_column <- function(data, variable, varname, by, value, method, conf.level, strata, weights, max.iterations) {
  levels <- .unique_values_sort(data, variable = variable, value = value[[variable]])
  data <- .as_dummy_column(data, variable = variable, levels = levels, by = by, strata = strata)

  cards::ard_mvsummary(
    data = data,
    variables = c(everything(), -all_of(c(by, strata))),
    by = all_of(by),
    statistic =
      ~ list(
        prop_ci =
          .calculate_prop_ci_fun(
            data = data, method = method, conf.level = conf.level,
            strata = strata, weights = weights, max.iterations = max.iterations
          )
      )
  ) %>%
    # merge in the variable levels
    dplyr::left_join(
      dplyr::select(., "variable") |>
        dplyr::distinct() |>
        dplyr::mutate(variable_level = as.list(.env$levels)),
      by = "variable"
    ) |>
    # rename variable column
    dplyr::mutate(variable = .env$variable)
}

.calculate_prop_ci_fun <- function(data, method, conf.level, strata, weights, max.iterations) {
  switch(method,
    "waldcc" = \(x, ...) proportion_ci_wald(x, conf.level = conf.level, correct = TRUE),
    "wald" = \(x, ...) proportion_ci_wald(x, conf.level = conf.level, correct = FALSE),
    "wilsoncc" = \(x, ...) proportion_ci_wilson(x, conf.level = conf.level, correct = TRUE),
    "wilson" = \(x, ...) proportion_ci_wilson(x, conf.level = conf.level, correct = FALSE),
    "clopper-pearson" = \(x, ...) proportion_ci_clopper_pearson(x, conf.level = conf.level),
    "agresti-coull" = \(x, ...) proportion_ci_agresti_coull(x, conf.level = conf.level),
    "jeffreys" = \(x, ...) proportion_ci_jeffreys(x, conf.level = conf.level),
    "strat_wilsoncc" = \(x, data, ...) {
      proportion_ci_strat_wilson(x,
        strata = data[[strata]], weights = weights,
        max.iterations = max.iterations,
        conf.level = conf.level, correct = TRUE
      )
    },
    "strat_wilson" = \(x, data, ...) {
      proportion_ci_strat_wilson(x,
        strata = data[[strata]], weights = weights,
        max.iterations = max.iterations,
        conf.level = conf.level, correct = FALSE
      )
    }
  ) |>
    cards::as_cards_fn(
      stat_names =
        case_switch(
          method %in% c("strat_wilsoncc", "strat_wilsoncc") ~
            c("N", "n", "estimate", "conf.low", "conf.high", "conf.level", "weights", "method"),
          .default = c("N", "n", "estimate", "conf.low", "conf.high", "conf.level", "method")
        )
    )
}

.unique_values_sort <- function(data, variable, value = NULL) {
  unique_levels <-
    # styler: off
    if (is.logical(data[[variable]])) c(TRUE, FALSE)
  else if (is.factor(data[[variable]])) factor(levels(data[[variable]]), levels = levels(data[[variable]]))
  else unique(data[[variable]]) |> sort()
  # styler: on

  if (!is_empty(value) && !value %in% unique_levels) {
    cli::cli_warn(
      c("A value of {.code value={.val {value}}} for variable {.val {variable}}
         was passed, but is not one of the observed levels: {.val {unique_levels}}.",
        i = "This may be an error.",
        i = "If value is a valid, convert variable to factor with all levels specified to avoid this message."
      )
    )
  }
  if (!is_empty(value)) {
    unique_levels <- value
  }

  unique_levels
}

.as_dummy_column <- function(data, variable, levels, by, strata) {
  # define dummy variables and return tibble
  map(levels, ~ data[[variable]] == .x) |>
    set_names(paste0("this_is_not_a_column_name_anyone_would_choose_", variable, "_", levels, "...")) %>%
    {dplyr::tibble(!!!.)} |> # styler: off
    dplyr::bind_cols(data[c(by, strata)])
}

.levels_for_row <- function(data, by) {
  suppressMessages(cards::nest_for_ard(data = data, by = by, include_data = FALSE)) |>
    dplyr::select(cards::all_ard_groups(types = "levels")) |>
    map(unlist) |>
    reduce(.f = \(.x, .y) paste0(.x, .y)) |>
    as.character()
}

.as_dummy_row <- function(data, levels, by, strata) {
  data_col <- data[, by, drop = FALSE] |>
    reduce(.f = \(.x, .y) paste0(.x, .y)) |>
    as.character()

  # define dummy variables and return tibble
  df_res <- map(levels, ~ data_col == .x) |>
    set_names(paste0("this_is_not_a_column_name_anyone_would_choose_", levels, "...")) |>
    dplyr::bind_cols()

  if (!is_empty(strata)) {
    df_res <- df_res |> dplyr::bind_cols(data[, strata, drop = FALSE])
  }

  df_res
}


.calculate_ard_proportion_row <- function(data, variable, by, value, method,
                                          conf.level, strata, weights, max.iterations) {
  # if there are no by variables, then all row percents are 100%
  if (is_empty(by)) {
    df_res <-
      suppressMessages(
        cards::nest_for_ard(
          data = data[c(variable, by, strata)],
          by = variable
        )
      ) |>
      dplyr::rename(variable = "group1", variable_level = "group1_level") %>%
      {
        case_switch(
          !is_empty(value[[variable]]) ~ dplyr::filter(., .data$variable_level %in% !!value[[variable]]),
          .default = .
        )
      } |>
      dplyr::mutate(
        data = map(data, ~ dplyr::mutate(.x, ....ard_all_true.... = TRUE)),
        prop_ci_fun =
          map(
            .data$data,
            ~ .calculate_prop_ci_fun(
              data = .x,
              method = .env$method,
              conf.level = .env$conf.level,
              strata = .env$strata,
              weights = .env$weights,
              max.iterations = .env$max.iterations
            )
          ),
        result =
          map2(
            .data$data, .data$prop_ci_fun,
            ~ cards::ard_mvsummary(
              data = .x,
              variables = "....ard_all_true....",
              statistic = list("....ard_all_true...." = list(prop_ci = .y))
            ) |>
              tidyr::nest(res = -cards::all_ard_variables()) |>
              dplyr::select(-cards::all_ard_variables())
          )
      ) |>
      dplyr::select(-c("data", "prop_ci_fun")) |>
      tidyr::unnest(cols = "result") |>
      tidyr::unnest(cols = "res")

    return(df_res)
  }


  df_grouping_cols <- suppressMessages(cards::nest_for_ard(data, by = by, include_data = FALSE))
  levels <- .levels_for_row(data = data, by = by)

  suppressMessages(
    cards::nest_for_ard(
      data = data[c(variable, by, strata)],
      by = variable
    )
  ) |>
    dplyr::rename(variable = "group1", variable_level = "group1_level") %>%
    {
      case_switch(
        !is_empty(value[[variable]]) ~ dplyr::filter(., .data$variable_level %in% !!value[[variable]]),
        .default = .
      )
    } |>
    dplyr::mutate(
      df_grouping_cols = list(.env$df_grouping_cols),
      prop_ci_fun =
        map(
          .data$data,
          ~ .calculate_prop_ci_fun(
            data = .x,
            method = .env$method,
            conf.level = .env$conf.level,
            strata = .env$strata,
            weights = .env$weights,
            max.iterations = .env$max.iterations
          )
        ),
      result =
        map2(
          .data$data, .data$prop_ci_fun,
          ~ .as_dummy_row(data = .x, levels = levels, by = by, strata = strata) |>
            cards::ard_mvsummary(
              variables = c(everything(), -any_of(strata)),
              statistic = everything() ~ list(prop_ci = .y)
            ) |>
            tidyr::nest(res = -cards::all_ard_variables()) |>
            dplyr::select(-cards::all_ard_variables())
        )
    ) |>
    dplyr::select(-c("data", "prop_ci_fun")) |>
    tidyr::unnest(cols = c("df_grouping_cols", "result")) |>
    tidyr::unnest(cols = "res")
}

.calculate_ard_proportion_cell <- function(data, variable, by, value, method,
                                           conf.level, strata, weights, max.iterations) {
  # create the base of what the grouping and variable ARD will look like
  df_groups_variable <-
    suppressMessages(
      cards::nest_for_ard(data, by = c(by, variable), include_data = FALSE)
    ) |>
    dplyr::rename(
      variable = glue::glue("group{length(c(variable, by))}"),
      variable_level = glue::glue("group{length(c(variable, by))}_level")
    ) %>%
    {
      case_switch(
        !is_empty(value[[variable]]) ~ dplyr::filter(., .data$variable_level %in% !!value[[variable]]),
        .default = .
      )
    }

  # create a vector of all the unique values of by and variable pasted together
  levels <-
    df_groups_variable |>
    dplyr::select(cards::all_ard_groups("levels"), cards::all_ard_variables("levels")) |>
    map(unlist) |>
    reduce(.f = \(.x, .y) paste0(.x, .y)) |>
    as.character()

  # create a data frame of dummy columns indicating if each of the levels is obs in that row
  # data frame also contains the strata column is supplied
  dummy_data <-
    df_groups_variable |>
    dplyr::select(cards::all_ard_groups("levels"), cards::all_ard_variables("levels")) |>
    dplyr::mutate(across(everything(), unlist)) |>
    stats::setNames(
      df_groups_variable |>
        dplyr::select(cards::all_ard_groups("names"), cards::all_ard_variables("names")) |>
        dplyr::slice(1L) |>
        unlist() |>
        unname()
    ) |>
    dplyr::bind_cols(data.frame(...a_name_anyone_would_ever_pick... = levels)) |>
    dplyr::left_join(
      x = data[c(variable, by, strata)],
      y = _,
      by = c(variable, by)
    ) |>
    dplyr::mutate(
      ...a_name_anyone_would_ever_pick... =
        dplyr::coalesce(.data$...a_name_anyone_would_ever_pick..., paste(levels, collapse = ""))
    )

  # make dummy vector missing if any of the other variables are missing
  dummy_data[["...a_name_anyone_would_ever_pick..."]][apply(is.na(dummy_data[c(variable, by, strata)]), MARGIN = 1, FUN = any)] <- NA

  # finish processing dummy data
  dummy_data <- dummy_data |>
    dplyr::select(-any_of(c(variable, by))) %>%
    # styler: off
    {dplyr::bind_cols(
      .,
      map(
        levels,
        \(level) {
          (.[["...a_name_anyone_would_ever_pick..."]] == level)
        }
      ) |>
        stats::setNames(paste0("level_", levels)) |>
        dplyr::as_tibble()
    )} |>
    # styler: on
    dplyr::select(-"...a_name_anyone_would_ever_pick...")

  prop_ci_fun <-
    .calculate_prop_ci_fun(
      data = dummy_data,
      method = method,
      conf.level = conf.level,
      strata = strata,
      weights = weights,
      max.iterations = max.iterations
    )

  df_res <-
    cards::ard_mvsummary(
      data = dummy_data,
      variables = -any_of(strata),
      statistic = everything() ~ list(prop_ci = prop_ci_fun)
    ) |>
    tidyr::nest(res = -"variable") |>
    dplyr::select(-"variable")

  dplyr::bind_cols(df_groups_variable, df_res) |>
    tidyr::unnest("res")
}
