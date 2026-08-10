#' ARD Continuous Survey Statistics
#'
#' Returns an ARD of weighted statistics using the `{survey}` package.
#'
#' @param data (`survey.design`)\cr
#'   a design object often created with [`survey::svydesign()`].
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   columns to include in summaries.
#' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   results are calculated for **all combinations** of the columns specified,
#'   including unobserved combinations and unobserved factor levels.
#' @param statistic ([`formula-list-selector`][cards::syntax])\cr
#'   a named list, a list of formulas,
#'   or a single formula where the list element is a character vector of
#'   statistic names to include. See below for options.
#' @param fmt_fun ([`formula-list-selector`][cards::syntax])\cr
#'   a named list, a list of formulas,
#'   or a single formula where the list element is a named list of functions
#'   (or the RHS of a formula),
#'   e.g. `list(mpg = list(mean = \(x) round(x, digits = 2) |> as.character))`.
#' @param stat_label ([`formula-list-selector`][cards::syntax])\cr
#'   a named list, a list of formulas, or a single formula where
#'   the list element is either a named list or a list of formulas defining the
#'   statistic labels, e.g. `everything() ~ list(mean = "Mean", sd = "SD")` or
#'   `everything() ~ list(mean ~ "Mean", sd ~ "SD")`.
#' @inheritParams ard_tabulate.survey.design
#' @inheritParams rlang::args_dots_empty
#'
#' @section statistic argument:
#'
#' The following statistics are available:
#' `r cardx:::accepted_svy_stats(FALSE) |> shQuote("sh") |> paste(collapse = ", ")`,
#' where 'p##' is are the percentiles and `##` is an integer between 0 and 100.
#'
#' The design effect (`"deff"`) is calculated only when requested in the `statistic` argument.
#'
#'
#' @return an ARD data frame of class 'card'
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "survey"))
#' data(api, package = "survey")
#' dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
#'
#' ard_summary(
#'   data = dclus1,
#'   variables = api00,
#'   by = stype
#' )
ard_summary.survey.design <- function(data, variables, by = NULL,
                                      statistic = everything() ~ c("median", "p25", "p75"),
                                      fmt_fun = NULL,
                                      stat_label = NULL,
                                      fmt_fn = deprecated(),
                                      ...) {
  set_cli_abort_call()
  check_dots_empty()

  # deprecated args ------------------------------------------------------------
  if (lifecycle::is_present(fmt_fn)) {
    lifecycle::deprecate_soft(
      when = "0.2.5",
      what = "ard_summary(fmt_fn)",
      with = "ard_summary(fmt_fun)"
    )
    fmt_fun <- fmt_fn
  }

  # check installed packages ---------------------------------------------------
  check_pkg_installed(pkg = "survey")

  # check inputs ---------------------------------------------------------------
  check_not_missing(variables)

  # process inputs -------------------------------------------------------------
  cards::process_selectors(data$variables, variables = {{ variables }}, by = {{ by }})
  variables <- setdiff(variables, by)
  check_na_factor_levels(data$variables, by)

  cards::process_formula_selectors(
    data$variables[variables],
    statistic = statistic,
    fmt_fun = fmt_fun,
    stat_label = stat_label
  )
  cards::fill_formula_selectors(
    data$variables[variables],
    statistic = formals(asNamespace("cardx")[["ard_summary.survey.design"]])[["statistic"]] |> eval()
  )
  cards::check_list_elements(
    x = statistic,
    predicate = \(x) all(x %in% accepted_svy_stats()),
    error_msg = c("Error in the values of the {.arg statistic} argument for variable {.val {variable}}.",
      i = "Values must be in {.val {cardx:::accepted_svy_stats(FALSE)}}"
    )
  )

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # compute the weighted statistics --------------------------------------------
  df_stats <-
    map(
      names(statistic),
      function(variable) {
        map(
          statistic[[variable]],
          function(statistic) {
            .compute_svy_stat(data, variable = variable, by = by, stat_name = statistic)
          }
        )
      }
    ) |>
    dplyr::bind_rows() |>
    .restore_original_column_types(data = data$variables)

  # add stat_labels ------------------------------------------------------------
  df_stats <-
    df_stats |>
    dplyr::left_join(
      .default_svy_stat_labels(),
      by = "stat_name"
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name))
  if (!is_empty(stat_label)) {
    df_stats <-
      dplyr::rows_update(
        df_stats,
        dplyr::tibble(
          variable = names(stat_label),
          stat_name = map(.data$variable, ~ names(stat_label[[.x]])),
          stat_label = map(.data$variable, ~ stat_label[[.x]] |>
            unname() |>
            unlist())
        ) |>
          tidyr::unnest(cols = c("stat_name", "stat_label")),
        by = c("variable", "stat_name"),
        unmatched = "ignore"
      )
  }

  # add formatting stats -------------------------------------------------------
  df_stats$fmt_fun <- list(1L)
  if (!is_empty(fmt_fun)) {
    df_stats <-
      dplyr::rows_update(
        df_stats,
        dplyr::tibble(
          variable = names(fmt_fun),
          stat_name = map(.data$variable, ~ names(fmt_fun[[.x]])),
          fmt_fun = map(.data$variable, ~ fmt_fun[[.x]] |> unname())
        ) |>
          tidyr::unnest(cols = c("stat_name", "fmt_fun")),
        by = c("variable", "stat_name"),
        unmatched = "ignore"
      )
  }

  # add class and return ARD object --------------------------------------------
  df_stats |>
    dplyr::mutate(context = "continuous") |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}

.default_svy_stat_labels <- function(stat_label = NULL) {
  dplyr::tribble(
    ~stat_name, ~stat_label,
    "mean", "Mean",
    "median", "Median",
    "var", "Variance",
    "sd", "Standard Deviation",
    "sum", "Sum",
    "deff", "Design Effect",
    "mean.std.error", "SE(Mean)",
    "min", "Minimum",
    "max", "Maximum",
    "p25", "25% Percentile",
    "p75", "75% Percentile"
  )
}

accepted_svy_stats <- function(expand_quantiles = TRUE) {
  base_stats <-
    c("mean", "median", "min", "max", "sum", "var", "sd", "mean.std.error", "deff")
  if (expand_quantiles) {
    return(c(base_stats, paste0("p", 0:100)))
  }
  c(base_stats, "p##")
}


# this function calculates the summary for a single variable, single statistic
# and for all `by` levels. it returns an ARD data frame
.compute_svy_stat <- function(data, variable, by = NULL, stat_name) {
  # difftime variable needs to be transformed into numeric for svyquantile
  if (inherits(data$variables[[variable]], "difftime")) {
    data$variables[[variable]] <- unclass(data$variables[[variable]])
  }

  # styler: off
  if (stat_name %in% "mean") args <- list(FUN = survey::svymean)
  else if (stat_name %in% "sum") args <- list(FUN = survey::svytotal)
  else if (stat_name %in% "var") args <- list(FUN = survey::svyvar)
  else if (stat_name %in% "sd") args <- list(FUN = \(...) survey::svyvar(...) |> sqrt())
  else if (stat_name %in% "mean.std.error") args <- list(FUN = \(...) survey::svymean(...) |> survey::SE())
  else if (stat_name %in% "deff") args <- list(FUN = \(...) survey::svymean(..., deff = TRUE) |> survey::deff())
  else if (stat_name %in% "min") args <- list(FUN = \(x, design, na.rm, ...) min(design$variables[[all.vars(x)]], na.rm = na.rm))
  else if (stat_name %in% "max") args <- list(FUN = \(x, design, na.rm, ...) max(design$variables[[all.vars(x)]], na.rm = na.rm))
  # define functions for the quantiles
  else if (stat_name %in% c("median", paste0("p", 0:100))) {
    quantile <- ifelse(stat_name %in% "median", 0.5, as.numeric(substr(stat_name, 2, nchar(stat_name))) / 100)
    # univariate results are returned in a different format from stratified.
    args <-
      if (is_empty(by)) list(FUN = \(...) survey::svyquantile(...)[[1]], quantiles = quantile)
    else list(FUN = \(...) survey::svyquantile(...), quantiles = quantile)
  }
  # styler: on

  # adding additional args to pass
  args <-
    args |>
    append(
      list(
        design = data,
        # if all values are NA, turn na.rm to FALSE to avoid error
        na.rm = !all(is.na(data$variables[[variable]])),
        keep.var = FALSE
      )
    )


  # if no by variable, calculate univariate statistics
  if (is_empty(by)) {
    args$x <- reformulate2(variable)
    # calculate statistic (and remove FUN from the argument list)
    stat <-
      cards::eval_capture_conditions(
        do.call(args$FUN, args = args |> utils::modifyList(list(FUN = NULL)))
      )
    # if the result was calculated, then put it into a tibble
    if (!is.null(stat[["result"]])) {
      df_stat <-
        dplyr::tibble(variable, stat[["result"]][1]) |>
        set_names(c("variable", "stat")) |>
        dplyr::mutate(
          stat = as.list(unname(.data$stat)),
          warning = list(stat[["warning"]]),
          error = list(stat[["error"]])
        )
    }
    # otherwise, if there was an error return tibble with error message
    else {
      df_stat <-
        dplyr::tibble(
          variable = .env$variable,
          stat = list(NULL),
          warning = list(.env$stat[["warning"]]),
          error = list(.env$stat[["error"]])
        )
    }
  }

  # if there is by variable(s), calculate statistics for the combinations
  else {
    args$formula <- reformulate2(variable)
    args$by <- reformulate2(by)
    stat <-
      if (stat_name %in% c("median", paste0("p", 0:100))) {
        cards::eval_capture_conditions(
          do.call(survey::svyby, args) |> set_names(c(by, "quantile", "ci.2.5", "ci.97.5", "se"))
        )
      } else if (stat_name %in% "deff") {
        stat <-
          cards::eval_capture_conditions(
            do.call(
              survey::svyby,
              args |> utils::modifyList(list(FUN = survey::svymean, deff = TRUE))
            ) |>
              dplyr::select(all_of(by), dplyr::last_col()) # the last column is DEff
          )
      } else {
        cards::eval_capture_conditions(do.call(survey::svyby, args))
      }

    # if the result was calculated, then put it into a tibble
    if (!is.null(stat[["result"]])) {
      df_stat <- stat[["result"]][seq_len(length(by) + 1L)] |>
        dplyr::as_tibble() %>%
        # adding unobserved combinations of "by" variables
        {
          dplyr::full_join(
            cards::nest_for_ard(data$variables, by = by, key = "...ard_no_one_will_ever_pick_this...", rename = FALSE, list_columns = FALSE) |>
              dplyr::select(-"...ard_no_one_will_ever_pick_this..."),
            .,
            by = by
          )
        } |>
        set_names(paste0("group", seq_along(by), "_level"), "stat") |>
        dplyr::bind_cols(
          dplyr::tibble(!!!c(by, variable)) |>
            set_names(paste0("group", seq_along(by)), "variable")
        ) |>
        dplyr::mutate(
          dplyr::across(c(cards::all_ard_groups("levels"), "stat"), as.list),
          warning = list(.env$stat[["warning"]]),
          error = list(.env$stat[["error"]])
        )
    }
    # otherwise, if there was an error return tibble with error message
    else {
      df_stat <-
        cards::nest_for_ard(data$variables, by = by, key = "...ard_no_one_will_ever_pick_this...") |>
        dplyr::select(-"...ard_no_one_will_ever_pick_this...") |>
        dplyr::mutate(
          variable = .env$variable,
          stat = list(NULL),
          warning = list(.env$stat[["warning"]]),
          error = list(.env$stat[["error"]])
        )
    }
  }

  df_stat |>
    dplyr::mutate(
      stat_name = .env$stat_name,
      across(
        c(cards::all_ard_groups("levels"), cards::all_ard_variables("levels")),
        ~ map(.x, as.character)
      )
    )
}


# some operations coerce the variable types to character.
# this function will convert the `_level` values to their original types
.restore_original_column_types <- function(ard, data) {
  # identify grouping variable names with associated levels --------------------
  by <- character()
  for (v in names(dplyr::select(ard, cards::all_ard_groups("names")))) {
    if (paste0(v, "_level") %in% names(ard)) by <- c(by, ard[[v]][1]) # styler: off
  }
  variables <- character()
  if ("variable" %in% names(ard)) {
    variables <- ard[["variable"]] |> unique()
  }

  # if there are no levels to correct, then return ard as it is
  if (is_empty(variables) && is_empty(by)) return(ard) # styler: off

  # add an ID for sorting
  ard$...ard_id_for_sorting... <- seq_len(nrow(ard))

  # nest the raw data with original types --------------------------------------
  if (!is_empty(variables)) {
    if (!"variable_level" %in% names(ard)) df_variable_orginal_types <- unique(ard["variable"]) # styler: off
    else if (!all(variables %in% names(data))) { # for survfit summaries, the times/probs var is not in the data
      df_variable_orginal_types <- unique(ard[c("variable", "variable_level")])
    } else {
      df_variable_orginal_types <-
        map(
          variables,
          ~ cards::nest_for_ard(tidyr::drop_na(data[.x]), by = .x, include_data = FALSE) |>
            stats::setNames(c("variable", "variable_level"))
        ) |>
        dplyr::bind_rows()
    }
  }
  if (!is_empty(by)) {
    df_by_orginal_types <-
      cards::nest_for_ard(tidyr::drop_na(data[by]), by = by, include_data = FALSE)
  }

  # combine groups and variables together
  if (!is_empty(variables) && !is_empty(by)) {
    df_original_types <-
      dplyr::cross_join(df_by_orginal_types, df_variable_orginal_types)
  } else if (!is_empty(variables)) {
    df_original_types <- df_variable_orginal_types
  } else if (!is_empty(by)) {
    df_original_types <- df_by_orginal_types
  }

  # unlisting the sorting according the character value
  df_original_types <- df_original_types |>
    dplyr::arrange(across(everything(), ~ map(., as.character) |> unlist()))

  ard_nested <- ard |>
    tidyr::nest(..ard_data... = -c(cards::all_ard_groups(), cards::all_ard_variables())) |>
    dplyr::arrange(across(
      c(cards::all_ard_groups(), cards::all_ard_variables()),
      ~ map(., as.character) |> unlist()
    ))

  # if all columns match, then replace the coerced character cols with their original type/class
  all_cols_equal <-
    every(
      names(df_original_types) |> setdiff("variable_level"),
      ~ all(
        unlist(ard_nested[[.x]]) == as.character(unlist(df_original_types[[.x]])) |
          (is.na(unlist(ard_nested[[.x]])) & is.na(unlist(df_original_types[[.x]])))
      )
    )
  # the variable level needs to be handled separately because there can be mixed type and we can't unlist
  if (isTRUE(all_cols_equal) && "variable_level" %in% names(df_original_types)) {
    all_cols_equal <-
      seq_len(nrow(df_original_types)) |>
      map_lgl(
        ~ identical(
          as.character(df_original_types[["variable_level"]][[.x]]),
          as.character(ard_nested[["variable_level"]][[.x]])
        )
      ) |>
      all()
  }

  if (isTRUE(all_cols_equal)) {
    return(
      dplyr::bind_cols(
        df_original_types,
        dplyr::select(ard_nested, -all_of(names(df_original_types))),
        .name_repair = "minimal"
      ) |>
        tidyr::unnest(cols = "..ard_data...") |>
        dplyr::arrange(.data$...ard_id_for_sorting...) |>
        dplyr::select(-"...ard_id_for_sorting...") |>
        cards::as_card(check = FALSE)
    )
  }

  # I hope this message is never triggered!
  cli::cli_inform(c(
    "If you see this message, variable levels have been coerced to character, which could cause downstream issues.",
    "*" = "Please post a reproducible example to {.url https://github.com/pharmaverse/cardx/issues/new}, so we can address in the next release.",
    "i" = "You can create a minimal reproducible example with {.fun reprex::reprex}."
  ))

  ard |>
    dplyr::arrange(.data$...ard_id_for_sorting...) |>
    dplyr::select(-"...ard_id_for_sorting...")
}
