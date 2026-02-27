#' ARD survey continuous CIs
#'
#' One-sample confidence intervals for continuous variables' means and medians.
#' Confidence limits are calculated with `survey::svymean()` and `survey::svyquantile()`.
#'
#'
#' @inheritParams ard_summary.survey.design
#' @param method (`string`)\cr
#'   Method for confidence interval calculation.
#'   When `"svymean"`, the calculation is computed via `survey::svymean()`.
#'   Otherwise, it is calculated via`survey::svyquantile(interval.type=method)`
#' @param conf.level (scalar `numeric`)\cr
#'   confidence level for confidence interval. Default is `0.95`.
#' @param df (`numeric`)\cr
#'   denominator degrees of freedom, passed to `survey::confint(df)`.
#'   Default is `survey::degf(data)`.
#' @param ... arguments passed to `survey::confint()`
#'
#' @return ARD data frame
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "survey"))
#' data(api, package = "survey")
#' dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
#'
#' ard_continuous_ci(dclus1, variables = api00)
#' ard_continuous_ci(dclus1, variables = api00, method = "svymedian.xlogit")
ard_continuous_ci.survey.design <- function(data,
                                            variables,
                                            by = NULL,
                                            method = c("svymean", "svymedian.mean", "svymedian.beta", "svymedian.xlogit", "svymedian.asin", "svymedian.score"),
                                            conf.level = 0.95,
                                            df = survey::degf(data),
                                            ...) {
  set_cli_abort_call()

  # check inputs ---------------------------------------------------------------
  check_not_missing(data)
  check_class(data, "survey.design")
  check_not_missing(variables)

  cards::process_selectors(
    data = data$variables,
    variables = {{ variables }},
    by = {{ by }}
  )
  check_scalar(by, allow_empty = TRUE)
  check_scalar_range(conf.level, range = c(0, 1))
  method <- arg_match(method)

  walk(
    variables,
    \(variable) {
      if (!is.numeric(data$variables[[variable]])) {
        cli::cli_inform(
          "Column {.val {variable}} is not {.cls numeric} and results may be an unexpected format."
        )
      }
    }
  )

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # calculate and return ARD of one sample CI ----------------------------------
  .calculate_ard_continuous_survey_ci(
    FUN = ifelse(method == "svymean", .svymean_confint_wrapper, .svyquantile_confint_wrapper),
    data = data,
    variables = variables,
    by = by,
    conf.level = conf.level,
    method = method,
    df = df,
    ...
  ) |>
    .restore_original_column_types(data = data$variables)
}

.calculate_ard_continuous_survey_ci <- function(FUN, data, variables, by, conf.level, ...) {
  # calculate results ----------------------------------------------------------
  map(
    variables,
    function(variable) {
      .calculate_one_ard_continuous_survey_ci(
        FUN = FUN,
        data = data,
        variable = variable,
        by = by,
        conf.level = conf.level,
        ...
      )
    }
  ) |>
    dplyr::bind_rows()
}

.calculate_one_ard_continuous_survey_ci <- function(FUN, data, variable, by, conf.level, ...) {
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
          group1_level = as.character(by_levels) |> as.list()
        ) |>
        dplyr::mutate(group1 = .env$by, variable = .env$variable),
      .default =
        dplyr::tibble(variable = .env$variable)
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
      context = "survey_continuous_ci"
    ) |>
    dplyr::select(-"lst_result") |>
    dplyr::ungroup() |>
    tidyr::unnest("result") |>
    dplyr::mutate(
      stat_label = .data$stat_name,
      fmt_fun = map(.data$stat, ~ case_switch(is.numeric(.x) ~ 2L, .default = as.character))
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}

.svymean_confint_wrapper <- function(data, variable, conf.level, df, ...) {
  lst_results <-
    cards::eval_capture_conditions({
      svymean <-
        survey::svymean(x = reformulate2(variable), design = data, na.rm = TRUE)

      lst_svymean <- as.data.frame(svymean) |>
        as.list() |>
        set_names(c("estimate", "std.error"))

      lst_confint <- stats::confint(svymean, level = conf.level, df = df, ...) |>
        as.data.frame() |>
        as.list() |>
        set_names(c("conf.low", "conf.high"))

      c(lst_svymean, lst_confint)
    })

  # add NULL results if error
  if (is_empty(lst_results[["result"]])) {
    lst_results[["result"]] <- rep_named(c("estimate", "std.error", "conf.low", "conf.high"), list(NULL))
  }

  # add other args
  lst_results[["result"]] <- lst_results[["result"]] |> append(list(conf.level = conf.level))

  # return list result
  lst_results
}

.svyquantile_confint_wrapper <- function(data, variable, conf.level, method, df, ...) {
  lst_results <-
    cards::eval_capture_conditions({
      svyquantile <-
        survey::svyquantile(
          x = reformulate2(variable), design = data, quantiles = 0.5,
          na.rm = TRUE, interval.type = str_remove(method, pattern = "^svymedian\\.")
        )

      lst_svyquantile <- svyquantile |>
        getElement(1L) |>
        as.data.frame() |>
        dplyr::select(1L, last_col()) |>
        as.list() |>
        set_names(c("estimate", "std.error"))

      lst_confint <- stats::confint(svyquantile, level = conf.level, df = df, ...) |>
        as.data.frame() |>
        as.list() |>
        set_names(c("conf.low", "conf.high"))

      c(lst_svyquantile, lst_confint)
    })

  # add NULL results if error
  if (is_empty(lst_results[["result"]])) {
    lst_results[["result"]] <- rep_named(c("estimate", "std.error", "conf.low", "conf.high"), list(NULL))
  }

  # add other args
  lst_results[["result"]] <- lst_results[["result"]] |> append(list(conf.level = conf.level))

  # return list result
  lst_results
}
