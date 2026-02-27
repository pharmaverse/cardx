#' ARD Categorical Survey Statistics
#'
#' @description
#' Compute tabulations on survey-weighted data.
#'
#' The counts and proportion (`"N"`, `"n"`, `"p"`) are calculated using `survey::svytable()`,
#' and the standard errors and design effect (`"p.std.error"`, `"deff"`) are
#' calculated using `survey::svymean()`.
#'
#' The design effect (`"deff"`) is calculated only when requested in the `statistic` argument.
#'
#' The unweighted statistics are calculated with `cards::ard_tabulate.data.frame()`.
#'
#' @param data (`survey.design`)\cr
#'   a design object often created with [`survey::svydesign()`].
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   columns to include in summaries.
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   results are calculated for **all combinations** of the column specified
#'   and the variables. A single column may be specified.
#' @param denominator (`string`)\cr
#'   a string indicating the type proportions to calculate. Must be one of
#'   `"column"` (the default), `"row"`, and `"cell"`.
#' @param statistic ([`formula-list-selector`][cards::syntax])\cr
#'   a named list, a list of formulas,
#'   or a single formula where the list element is a character vector of
#'   statistic names to include. See default value for options.
#' @param fmt_fun ([`formula-list-selector`][cards::syntax])\cr
#'   a named list, a list of formulas,
#'   or a single formula where the list element is a named list of functions
#'   (or the RHS of a formula),
#'   e.g. `list(mpg = list(mean = \(x) round(x, digits = 2) |> as.character()))`.
#' @param stat_label ([`formula-list-selector`][cards::syntax])\cr
#'   a named list, a list of formulas, or a single formula where
#'   the list element is either a named list or a list of formulas defining the
#'   statistic labels, e.g. `everything() ~ list(mean = "Mean", sd = "SD")` or
#'   `everything() ~ list(mean ~ "Mean", sd ~ "SD")`.
#' @param fmt_fn `r lifecycle::badge("deprecated")`
#' @inheritParams rlang::args_dots_empty
#'
#' @return an ARD data frame of class 'card'
#' @export
#'
#' @examplesIf cardx:::is_pkg_installed("survey")
#' svy_titanic <- survey::svydesign(~1, data = as.data.frame(Titanic), weights = ~Freq)
#'
#' ard_tabulate(svy_titanic, variables = c(Class, Age), by = Survived)
ard_tabulate.survey.design <- function(data,
                                       variables,
                                       by = NULL,
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
  check_pkg_installed(pkg = "survey")
  check_dots_empty()

  # deprecated args ------------------------------------------------------------
  if (lifecycle::is_present(fmt_fn)) {
    lifecycle::deprecate_soft(
      when = "0.2.5",
      what = "ard_tabulate(fmt_fn)",
      with = "ard_tabulate(fmt_fun)"
    )
    fmt_fun <- fmt_fn
  }

  # process arguments ----------------------------------------------------------
  check_not_missing(variables)
  cards::process_selectors(
    data = data$variables,
    variables = {{ variables }},
    by = {{ by }}
  )
  variables <- setdiff(variables, by)
  check_scalar(by, allow_empty = TRUE)

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  check_na_factor_levels(data$variables, c(by, variables))

  cards::process_formula_selectors(
    data = data$variables[variables],
    statistic = statistic,
    fmt_fun = fmt_fun,
    stat_label = stat_label
  )
  cards::fill_formula_selectors(
    data = data$variables[variables],
    statistic = formals(asNamespace("cardx")[["ard_tabulate.survey.design"]])[["statistic"]] |> eval(),
  )
  accepted_svy_stats <- c("n", "N", "p", "p.std.error", "deff", "n_unweighted", "N_unweighted", "p_unweighted")
  cards::check_list_elements(
    x = statistic,
    predicate = \(x) all(x %in% accepted_svy_stats),
    error_msg = c("Error in the values of the {.arg statistic} argument.",
      i = "Values must be in {.val {accepted_svy_stats}}"
    )
  )
  denominator <- arg_match(denominator)

  # Check if deff is in any of the requested statistics
  deff <- any(map_lgl(statistic, ~ "deff" %in% .x))

  # check the missingness
  walk(
    variables,
    \(.x) {
      if (all(is.na(data$variables[[.x]])) &&
        !inherits(data$variables[[.x]], "factor")) {
        cli::cli_abort(
          c("Column {.val {.x}} is all missing and cannot be tabulated.",
            i = "Only columns of class {.cls factor} can be tabulated when all values are missing."
          ),
          call = get_cli_abort_call()
        )
      }
    }
  )

  # return note about column names that result in errors -----------------------
  if (any(by %in% c("variable", "variable_level", "group1_level", "p", "n"))) {
    cli::cli_abort(
      "The {.arg by} argument cannot include variables named {.val {c('variable', 'variable_level', 'group1_level', 'p', 'n')}}.",
      call = get_cli_abort_call()
    )
  }

  if (any(variables %in% c("by", "name", "n", "p", "p.std.error"))) {
    cli::cli_abort(
      "The {.arg variables} argument cannot include variables named {.val {c('by', 'name', 'n', 'p', 'p.std.error')}}.",
      call = get_cli_abort_call()
    )
  }


  # calculate counts -----------------------------------------------------------
  # this tabulation accounts for unobserved combinations
  svytable_counts <- .svytable_counts(data, variables, by, denominator)

  # calculate rate SE and DEFF -------------------------------------------------
  svytable_rates <- .svytable_rate_stats(data, variables, by, denominator, deff)

  # convert results into a proper ARD object -----------------------------------
  cards <-
    svytable_counts |>
    # merge in the SE(p) and DEFF
    dplyr::left_join(
      svytable_rates |> dplyr::select(-"p"),
      by = intersect(c("group1", "group1_level", "variable", "variable_level"), names(svytable_counts))
    ) |>
    # make columns list columns
    dplyr::mutate(across(-any_of(c("group1", "variable")), as.list)) |>
    tidyr::pivot_longer(
      cols = -c(cards::all_ard_groups(), cards::all_ard_variables()),
      names_to = "stat_name",
      values_to = "stat"
    ) |>
    # keep statistics requested by user
    dplyr::inner_join(
      statistic |> enframe("variable", "stat_name") |> tidyr::unnest(cols = "stat_name"),
      by = c("variable", "stat_name")
    )

  # add unweighted statistics --------------------------------------------------
  statistic_unweighted <- statistic |>
    lapply(\(x) keep(x, ~ endsWith(.x, "_unweighted")) |> str_remove("_unweighted$")) |>
    compact()

  if (!is_empty(statistic_unweighted)) {
    cards_unweighted <-
      ard_tabulate(
        data = data[["variables"]],
        variables = all_of(names(statistic_unweighted)),
        by = any_of(by),
        statistic = statistic_unweighted,
        denominator = denominator
      ) |>
      # all the survey levels are reported as character, so we do the same here.
      dplyr::mutate(
        across(
          c(cards::all_ard_groups("levels"), cards::all_ard_variables("levels")),
          ~ map(.x, as.character)
        )
      ) |>
      dplyr::select(-c("stat_label", "fmt_fun", "warning", "error")) |>
      dplyr::mutate(
        stat_name =
          dplyr::recode_values(.data$stat_name, "n" ~ "n_unweighted", "N" ~ "N_unweighted", "p" ~ "p_unweighted")
      )
    cards <- cards |> dplyr::bind_rows(cards_unweighted) # styler: off
  }

  # final processing of fmt_fun ------------------------------------------------
  cards <- cards |>
    .process_nested_list_as_df(
      arg = fmt_fun,
      new_column = "fmt_fun"
    ) |>
    .default_svy_cat_fmt_fun()

  # merge in statistic labels --------------------------------------------------
  cards <- cards |>
    .process_nested_list_as_df(
      arg = stat_label,
      new_column = "stat_label",
      unlist = TRUE
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name))

  # return final object --------------------------------------------------------
  cards |>
    .restore_original_column_types(data = data$variables) |>
    dplyr::mutate(
      context = "categorical",
      warning = list(NULL),
      error = list(NULL),
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order() |>
    cards::tidy_ard_row_order()
}

# check for functions with NA factor levels (these are not allowed)
check_na_factor_levels <- function(data, variables) {
  walk(
    variables,
    \(variable) {
      if (is.factor(data[[variable]]) && any(is.na(levels(data[[variable]])))) {
        cli::cli_abort(
          "Column {.val {variable}} is a factor with {.val {NA}} levels, which are not allowed.",
          call = get_cli_abort_call()
        )
      }
    }
  )
}

# this function returns a tibble with the SE(p) and DEFF
.svytable_rate_stats <- function(data, variables, by, denominator, deff) {
  if (!is_empty(by)) by_lvls <- .unique_values_sort(data$variables, by) # styler: off
  if (!is_empty(by) && length(by_lvls) == 1L) {
    data$variables[[by]] <-
      case_switch(
        inherits(data$variables[[by]], "factor") ~ fct_expand(data$variables[[by]], paste("not", by_lvls)),
        .default = factor(data$variables[[by]], levels = c(by_lvls, paste("not", by_lvls)))
      )
  }
  if (!is_empty(by) && inherits(data$variables[[by]], "logical")) {
    data$variables[[by]] <- factor(data$variables[[by]], levels = c(TRUE, FALSE))
  }
  if (!is_empty(by) && !inherits(data$variables[[by]], "factor")) {
    data$variables[[by]] <- factor(data$variables[[by]])
  }

  lapply(
    variables,
    \(variable) {
      # convert the variable to a factor if not already one or a lgl, so we get the correct rate stats from svymean
      if (!inherits(data$variables[[variable]], c("factor", "logical"))) {
        data$variables[[variable]] <- factor(data$variables[[variable]])
      }

      # there are issues with svymean() when a variable has only one level. adding a second as needed
      variable_lvls <- .unique_values_sort(data$variables, variable)
      if (length(variable_lvls) == 1L) {
        data$variables[[variable]] <-
          case_switch(
            inherits(data$variables[[variable]], "factor") ~ fct_expand(data$variables[[variable]], paste("not", variable_lvls)),
            .default = factor(data$variables[[variable]], levels = c(variable_lvls, paste("not", variable_lvls)))
          )
      }
      if (inherits(data$variables[[variable]], "logical")) {
        data$variables[[variable]] <- factor(data$variables[[variable]], levels = c(TRUE, FALSE))
      }
      if (!inherits(data$variables[[variable]], "factor")) {
        data$variables[[variable]] <- factor(data$variables[[variable]])
      }

      # each combination of denominator and whether there is a by variable is handled separately
      result <-
        case_switch(
          # by variable and column percentages
          !is_empty(by) && denominator == "column" ~
            .one_svytable_rates_by_column(data, variable, by, deff),
          # by variable and row percentages
          !is_empty(by) && denominator == "row" ~
            .one_svytable_rates_by_row(data, variable, by, deff),
          # by variable and cell percentages
          !is_empty(by) && denominator == "cell" ~
            .one_svytable_rates_by_cell(data, variable, by, deff),
          # no by variable and column/cell percentages
          denominator %in% c("column", "cell") ~
            .one_svytable_rates_no_by_column_and_cell(data, variable, deff),
          # no by variable and row percentages
          denominator == "row" ~
            .one_svytable_rates_no_by_row(data, variable, deff)
        )

      # if a level was added, remove the fake level
      if (length(variable_lvls) == 1L) {
        result <- result |> dplyr::filter(.data$variable_level %in% variable_lvls)
      }
      if (!is_empty(by) && length(by_lvls) == 1L) {
        result <- result |> dplyr::filter(.data$group1_level %in% by_lvls)
      }

      result
    }
  ) |>
    dplyr::bind_rows()
}

.one_svytable_rates_no_by_row <- function(data, variable, deff) {
  result <- dplyr::tibble(
    variable = .env$variable,
    variable_level = unique(data$variables[[variable]]) |> sort() |> as.character(),
    p = 1,
    p.std.error = 0
  )
  if (isTRUE(deff)) {
    result$deff <- NaN
  }
  result
}

.one_svytable_rates_no_by_column_and_cell <- function(data, variable, deff) {
  survey::svymean(reformulate2(variable), design = data, na.rm = TRUE, deff = deff) |>
    dplyr::as_tibble(rownames = "var_level") |>
    dplyr::mutate(
      variable_level = str_remove(.data$var_level, pattern = paste0("^", .env$variable)),
      variable = .env$variable
    ) |>
    dplyr::select("variable", "variable_level", p = "mean", p.std.error = "SE", any_of("deff"))
}

.one_svytable_rates_by_cell <- function(data, variable, by, deff) {
  df_interaction_id <-
    .df_all_combos(data, variable, by) |>
    dplyr::mutate(
      var_level =
        glue::glue("interaction({.env$by}, {.env$variable}){.data$group1_level}.{.data$variable_level}")
    )

  survey::svymean(
    x = inject(~ interaction(!!sym(bt(by)), !!sym(bt(variable)))),
    design = data,
    na.rm = TRUE,
    deff = deff
  ) |>
    dplyr::as_tibble(rownames = "var_level") |>
    dplyr::left_join(df_interaction_id, by = "var_level") |>
    dplyr::select(
      cards::all_ard_groups(), cards::all_ard_variables(),
      p = "mean", p.std.error = "SE", any_of("deff")
    )
}

.one_svytable_rates_by_row <- function(data, variable, by, deff) {
  survey::svyby(
    formula = reformulate2(by),
    by = reformulate2(variable),
    design = data,
    FUN = survey::svymean,
    na.rm = TRUE,
    deff = deff
  ) |>
    dplyr::as_tibble() |>
    tidyr::pivot_longer(-all_of(variable)) |>
    dplyr::mutate(
      stat =
        dplyr::case_when(
          startsWith(.data$name, paste0("se.", by)) | startsWith(.data$name, paste0("se.`", by, "`")) ~ "p.std.error",
          startsWith(.data$name, paste0("DEff.", by)) | startsWith(.data$name, paste0("DEff.`", by, "`")) ~ "deff",
          TRUE ~ "p"
        ),
      name =
        str_remove_all(.data$name, "se\\.") %>%
          str_remove_all("DEff\\.") %>%
          str_remove_all(by) %>%
          str_remove_all("`")
    ) |>
    tidyr::pivot_wider(names_from = "stat", values_from = "value") |>
    (\(x) set_names(x, c("variable_level", "group1_level", names(x)[-c(1:2)])))() |>
    dplyr::mutate(
      group1 = .env$by,
      variable = .env$variable,
      across(c("group1_level", "variable_level"), as.character)
    )
}

.one_svytable_rates_by_column <- function(data, variable, by, deff) {
  survey::svyby(
    formula = reformulate2(variable),
    by = reformulate2(by),
    design = data,
    FUN = survey::svymean,
    na.rm = TRUE,
    deff = deff
  ) |>
    dplyr::as_tibble() |>
    tidyr::pivot_longer(-all_of(by)) |>
    dplyr::mutate(
      stat =
        dplyr::case_when(
          startsWith(.data$name, paste0("se.", variable)) | startsWith(.data$name, paste0("se.`", variable, "`")) ~ "p.std.error",
          startsWith(.data$name, paste0("DEff.", variable)) | startsWith(.data$name, paste0("DEff.`", variable, "`")) ~ "deff",
          TRUE ~ "p"
        ),
      name =
        str_remove_all(.data$name, "se\\.") %>%
          str_remove_all("DEff\\.") %>%
          str_remove_all(variable) %>%
          str_remove_all("`")
    ) |>
    tidyr::pivot_wider(names_from = "stat", values_from = "value") |>
    (\(x) set_names(x, c("group1_level", "variable_level", names(x)[-c(1:2)])))() |>
    dplyr::mutate(
      group1 = .env$by,
      variable = .env$variable,
      across(c("group1_level", "variable_level"), as.character)
    )
}

.svytable_counts <- function(data, variables, by, denominator) {
  df_counts <-
    lapply(
      variables,
      \(variable) {
        # perform weighted tabulation
        df_count <-
          survey::svytable(formula = reformulate2(c(by, variable)), design = data) |>
          dplyr::as_tibble()
        if (is_empty(by)) {
          names(df_count) <- c("variable_level", "n")
          df_count$variable <- variable
        } else {
          names(df_count) <- c("group1_level", "variable_level", "n")
          df_count$variable <- variable
          df_count$group1 <- by
        }

        # adding unobserved levels
        .df_all_combos(data, variable, by) %>%
          dplyr::left_join(
            df_count,
            by = names(.)
          ) |>
          tidyr::replace_na(list(n = 0)) # unobserved levels assigned zero count
      }
    ) |>
    dplyr::bind_rows()

  # add big N and p, then return data frame of results
  switch(denominator,
    "column" =
      df_counts |>
        dplyr::mutate(
          .by = c(cards::all_ard_groups(), cards::all_ard_variables("names")),
          N = sum(.data$n),
          p = .data$n / .data$N
        ),
    "row" =
      df_counts |>
        dplyr::mutate(
          .by = cards::all_ard_variables(),
          N = sum(.data$n),
          p = .data$n / .data$N
        ),
    "cell" =
      df_counts |>
        dplyr::mutate(
          .by = c(cards::all_ard_groups("names"), cards::all_ard_variables("names")),
          N = sum(.data$n),
          p = .data$n / .data$N
        )
  )
}

.df_all_combos <- function(data, variable, by) {
  df <-
    tidyr::expand_grid(
      group1_level = switch(!is_empty(by),
        .unique_and_sorted(data$variables[[by]])
      ),
      variable_level = .unique_and_sorted(data$variables[[variable]])
    ) |>
    dplyr::mutate(variable = .env$variable)
  if (!is_empty(by)) df$group1 <- by
  df <- dplyr::relocate(df, any_of(c("group1", "group1_level", "variable", "variable_level")))

  # convert levels to character for merging later
  df |>
    dplyr::mutate(
      across(
        c(cards::all_ard_groups("levels"), cards::all_ard_variables("levels")),
        as.character
      )
    )
}

case_switch <- function(..., .default = NULL) {
  dots <- dots_list(...)

  for (f in dots) {
    if (isTRUE(eval(f_lhs(f), envir = attr(f, ".Environment")))) {
      return(eval(f_rhs(f), envir = attr(f, ".Environment")))
    }
  }

  return(.default)
}

.default_svy_cat_fmt_fun <- function(x) {
  x |>
    dplyr::mutate(
      fmt_fun =
        pmap(
          list(.data$stat_name, .data$stat, .data$fmt_fun),
          function(stat_name, stat, fmt_fun) {
            if (!is_empty(fmt_fun)) {
              return(fmt_fun)
            }
            if (stat_name %in% c("p", "p_miss", "p_nonmiss", "p_unweighted")) {
              return(cards::label_round(digits = 1, scale = 100))
            }
            if (stat_name %in% c("n", "N", "N_miss", "N_nonmiss", "N_obs", "n_unweighted", "N_unweighted")) {
              return(cards::label_round(digits = 0))
            }
            if (is.integer(stat)) {
              return(0L)
            }
            if (is.numeric(stat)) {
              return(1L)
            }
            return(as.character)
          }
        )
    )
}

#' Convert Nested Lists to Column
#'
#' Some arguments, such as `stat_label`, are passed as nested lists. This
#' function properly unnests these lists and adds them to the results data frame.
#'
#' @param x (`data.frame`)\cr
#'   result data frame
#' @param arg (`list`)\cr
#'   the nested list
#' @param new_column (`string`)\cr
#'   new column name
#' @param unlist (`logical`)\cr
#'   whether to fully unlist final results
#'
#' @return a data frame
#' @keywords internal
#'
#' @examples
#' ard <- ard_tabulate(cards::ADSL, by = "ARM", variables = "AGEGR1")
#'
#' cardx:::.process_nested_list_as_df(ard, NULL, "new_col")
.process_nested_list_as_df <- function(x, arg, new_column, unlist = FALSE) {
  # add column if not already present
  if (!new_column %in% names(x)) {
    x[[new_column]] <- list(NULL)
  }

  # process argument if not NULL, and update new column
  if (!is_empty(arg)) {
    df_argument <-
      imap(
        arg,
        function(enlst_arg, variable) {
          lst_stat_names <-
            x[c("variable", "stat_name")] |>
            dplyr::filter(.data$variable %in% .env$variable) |>
            unique() %>%
            {stats::setNames(as.list(.[["stat_name"]]), .[["stat_name"]])} # styler: off

          cards::compute_formula_selector(
            data = lst_stat_names,
            x = enlst_arg
          ) %>%
            # styler: off
            {dplyr::tibble(
              variable = variable,
              stat_name = names(.),
              "{new_column}" := unname(.)
            )}
          # styler: on
        }
      ) |>
      dplyr::bind_rows()

    x <- x |> dplyr::rows_update(df_argument, by = c("variable", "stat_name"), unmatched = "ignore")
  }

  if (isTRUE(unlist)) {
    x[[new_column]] <- lapply(x[[new_column]], function(x) x %||% NA) |> unlist()
  }

  x
}
