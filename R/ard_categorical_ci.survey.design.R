#' ARD survey categorical CIs
#'
#' Confidence intervals for categorical variables calculated via
#' [`survey::svyciprop()`].
#'
#' @inheritParams ard_summary.survey.design
#' @inheritParams ard_categorical_ci.data.frame
#' @param method (`string`)\cr
#'   Method passed to `survey::svyciprop(method)`
#' @param df (`numeric`)\cr
#'   denominator degrees of freedom, passed to `survey::svyciprop(df)`.
#'   Default is `survey::degf(data)`.
#' @param ... arguments passed to `survey::svyciprop()`
#'
#' @return ARD data frame
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "survey"))
#' data(api, package = "survey")
#' dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
#'
#' ard_categorical_ci(dclus1, variables = sch.wide)
#' ard_categorical_ci(dclus1, variables = sch.wide, value = sch.wide ~ "Yes", method = "xlogit")
ard_categorical_ci.survey.design <- function(data,
                                             variables,
                                             by = NULL,
                                             method = c("logit", "likelihood", "asin", "beta", "mean", "xlogit"),
                                             conf.level = 0.95,
                                             value = list(where(is_binary) ~ 1L, where(is.logical) ~ TRUE),
                                             df = survey::degf(data),
                                             ...) {
  set_cli_abort_call()
  check_dots_empty()

  # check inputs ---------------------------------------------------------------
  check_not_missing(data)
  check_class(data, "survey.design")
  check_not_missing(variables)

  cards::process_selectors(
    data = data$variables,
    variables = {{ variables }},
    by = {{ by }}
  )
  cards::process_formula_selectors(
    data = data$variables,
    value = value
  )
  check_scalar(by, allow_empty = TRUE)
  check_scalar_range(conf.level, range = c(0, 1))
  method <- arg_match(method)

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # calculate and return ARD of one sample CI ----------------------------------
  .calculate_ard_onesample_survey_ci(
    FUN = .svyciprop_wrapper,
    data = data,
    variables = variables,
    by = by,
    conf.level = conf.level,
    method = method,
    df = df,
    value = value,
    ...
  )
}

.calculate_ard_onesample_survey_ci <- function(FUN, data, variables, by, conf.level, value, ...) {
  # calculate results ----------------------------------------------------------
  map(
    variables,
    function(variable) {
      .calculate_one_ard_categorical_survey_ci(
        FUN = FUN,
        data = data,
        variable = variable,
        by = by,
        conf.level = conf.level,
        value = value[[variable]],
        ...
      )
    }
  ) |>
    dplyr::bind_rows()
}

.calculate_one_ard_categorical_survey_ci <- function(FUN, data, variable, by, conf.level, value, ...) {
  variable_levels <- .unique_values_sort(data$variables, variable = variable)
  if (!is_empty(by)) {
    by_levels <- .unique_values_sort(data$variables, variable = by)
    lst_data <-
      map(
        by_levels,
        ~ call2("subset", expr(data), expr(!!sym(by) == !!.x)) |> eval()
      ) |>
      set_names(as.character(by_levels))
  }

  df_full <-
    case_switch(
      !is_empty(by) ~
        tidyr::expand_grid(
          group1_level = as.character(by_levels) |> as.list(),
          variable_level = as.character(variable_levels) |> as.list()
        ) |>
        dplyr::mutate(group1 = .env$by, variable = .env$variable),
      .default =
        dplyr::tibble(
          variable = .env$variable,
          variable_level = as.character(variable_levels) |> as.list()
        )
    ) |>
    dplyr::rowwise() |>
    dplyr::mutate(
      lst_result =
        FUN(
          data =
            case_switch(
              is_empty(.env$by) ~ data,
              .default = lst_data[[.data$group1_level]]
            ),
          variable = .data$variable,
          variable_level = .data$variable_level,
          conf.level = .env$conf.level,
          ...
        ) |>
          list(),
      result =
        .data$lst_result[["result"]] |>
          enframe("stat_name", "stat") |>
          list(),
      warning = .data$lst_result["warning"] |> unname(),
      error = .data$lst_result["error"] |> unname(),
      context = "categorical_ci"
    ) |>
    dplyr::select(-"lst_result") |>
    dplyr::ungroup() |>
    tidyr::unnest("result") |>
    dplyr::mutate(
      stat_label = .data$stat_name,
      fmt_fun = map(.data$stat, ~ case_switch(is.numeric(.x) ~ 2L, .default = as.character))
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order() |>
    .restore_original_column_types(data = data$variables)

  # if a value was passed for the variable, subset on those results
  if (!is_empty(value)) {
    df_full <- df_full |>
      dplyr::filter(unlist(.data$variable_level) %in% .env$value)
  }

  df_full
}


.svyciprop_wrapper <- function(data, variable, variable_level, conf.level, method, df, ...) {
  lst_results <-
    cards::eval_capture_conditions(
      survey::svyciprop(
        formula = inject(~ I(!!sym(variable) == !!variable_level)),
        design = data,
        method = method,
        level = conf.level,
        df = df,
        ...
      ) %>%
        {list(.[[1]], attr(., "ci"))} |> # styler: off
        unlist() |>
        set_names(c("estimate", "conf.low", "conf.high")) |>
        as.list()
    )

  # add NULL results if error
  if (is_empty(lst_results[["result"]])) {
    lst_results[["result"]] <- rep_named(c("estimate", "conf.low", "conf.high"), list(NULL))
  }

  # add other args
  lst_results[["result"]] <- lst_results[["result"]] |> append(list(method = method, conf.level = conf.level))

  # return list result
  lst_results
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
