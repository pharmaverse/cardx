#' @description
#' The `ard_emmeans_emmeans()` function calculates least-squares means using the 'emmeans'
#' package using the following
#'
#' ```r
#' emmeans::emmeans(object = <regression model>, specs = ~ <primary covariate>) |>
#'   summary(emmeans, calc = c(n = ".wgt."))
#' ```
#'
#' The arguments `data`, `formula`, `method`, `method.args`, `package` are used
#' to construct the regression model via `cardx::construct_model()`.
#'
#' @export
#' @rdname ard_emmeans
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "emmeans"))
#' # LS Means
#' ard_emmeans_emmeans(
#'   data = mtcars,
#'   formula = mpg ~ am + cyl,
#'   method = "lm"
#' )
#'
#' ard_emmeans_emmeans(
#'   data = mtcars,
#'   formula = vs ~ am + mpg,
#'   method = "glm",
#'   method.args = list(family = binomial),
#'   response_type = "dichotomous"
#' )
ard_emmeans_emmeans <- function(data,
                                formula,
                                method,
                                method.args = list(),
                                package = "base",
                                response_type = c("continuous", "dichotomous"),
                                conf.level = 0.95,
                                primary_covariate =
                                  stats::terms(formula) |>
                                    attr("term.labels") |>
                                    getElement(1L)) {
  set_cli_abort_call()

  # check package installation -------------------------------------------------
  check_pkg_installed(c("emmeans", package))
  check_not_missing(data)
  check_not_missing(formula)
  check_not_missing(method)
  check_class(data, c("data.frame", "survey.design"))
  check_class(formula, cls = "formula")
  check_string(package)
  check_string(primary_covariate)
  check_scalar(conf.level)
  check_range(conf.level, range = c(0, 1))
  response_type <- arg_match(response_type, error_call = get_cli_abort_call())

  data_in <- if (dplyr::last(class(data)) == "survey.design") data$variables else data

  # build ARD ------------------------------------------------------------------
  result <- cards::ard_mvsummary(
    data = data_in,
    variables = all_of(primary_covariate),
    statistic = all_of(primary_covariate) ~ list(
      emmeans =
        .calc_emmeans(
          data = data, formula = formula, method = method,
          method.args = {{ method.args }}, package = package,
          response_type = response_type, conf.level = conf.level,
          primary_covariate = primary_covariate
        )
    )
  )
  # unlist stat column
  if (length(result$stat[[which(result$stat_label == "variable_level")]]) > 1) {
    result <- result |> tidyr::unnest_longer(col = "stat")
  }

  result |>
    dplyr::select(-"stat_label") |>
    dplyr::left_join(
      .df_emmeans_stat_labels("emmeans"),
      by = "stat_name"
    ) |>
    dplyr::mutate(
      variable = "contrast",
      variable_level = if ("variable_level" %in% .data$stat_name) {
        rep_len(.data$stat[.data$stat_name == "variable_level"], length.out = nrow(result))
      } else {
        NA
      },
      group1 = .env$primary_covariate,
      stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name),
      context = "emmeans_emmeans"
    ) |>
    dplyr::filter(!is.na(.data$stat)) |>
    dplyr::filter(.data$stat_name != "variable_level") |>
    dplyr::arrange(.data$variable_level) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order() |>
    cards::tidy_ard_row_order()
}

# function to perform calculations ---------------------------------------------
.calc_emmeans <- function(data, formula, method,
                          method.args,
                          package,
                          response_type,
                          conf.level,
                          primary_covariate) {
  cards::as_cards_fn(
    \(x, ...) {
      # construct primary model ------------------------------------------------
      mod <-
        construct_model(
          data = data, formula = formula, method = method,
          method.args = {{ method.args }},
          package = package, env = caller_env()
        )

      # emmeans ----------------------------------------------------------------
      emmeans_args <- list(object = mod, specs = reformulate2(primary_covariate))
      if (response_type %in% "dichotomous") emmeans_args <- c(emmeans_args, list(regrid = "response"))
      emmeans <-
        withr::with_namespace(
          package = "emmeans",
          code = do.call("emmeans", args = emmeans_args)
        )

      # calculate mean estimates ---------------------------------------------
      results <-
        summary(emmeans, calc = c(n = ".wgt.")) |>
        dplyr::as_tibble() |>
        dplyr::rename(
          estimate = any_of(c("emmean", "prob")),
          n = any_of("n")
        ) |>
        dplyr::rename(variable_level = all_of(primary_covariate)) |>
        dplyr::mutate(variable_level = as.character(.data$variable_level))

      # convert results to ARD format ------------------------------------------
      results |>
        dplyr::as_tibble() |>
        dplyr::rename(
          conf.low = any_of("asymp.LCL"),
          conf.high = any_of("asymp.UCL"),
          conf.low = any_of("lower.CL"),
          conf.high = any_of("upper.CL"),
          std.error = any_of("SE")
        ) |>
        dplyr::select(any_of(c(
          "variable_level", "estimate",
          "std.error", "df", "n",
          "conf.low", "conf.high", "p.value"
        ))) |>
        dplyr::mutate(
          conf.level = .env$conf.level,
          method = "Least-squares means"
        ) |>
        dplyr::mutate(across(everything(), ~ .x |> as.list()))
    },
    stat_names = c("variable_level", "estimate", "std.error", "df", "conf.low", "conf.high", "p.value", "conf.level", "method", "n")
  )
}
