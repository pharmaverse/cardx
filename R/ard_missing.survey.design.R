#' ARD Missing Survey Statistics
#'
#' Compute Analysis Results Data (ARD) for statistics related to data missingness for survey objects
#'
#' @inheritParams ard_tabulate.survey.design
#'
#' @return an ARD data frame of class 'card'
#' @export
#'
#' @examplesIf cardx:::is_pkg_installed("survey")
#' svy_titanic <- survey::svydesign(~1, data = as.data.frame(Titanic), weights = ~Freq)
#'
#' ard_missing(svy_titanic, variables = c(Class, Age), by = Survived)
ard_missing.survey.design <- function(data,
                                      variables,
                                      by = NULL,
                                      statistic =
                                        everything() ~ c(
                                          "N_obs", "N_miss", "N_nonmiss", "p_miss", "p_nonmiss",
                                          "N_obs_unweighted", "N_miss_unweighted", "N_nonmiss_unweighted",
                                          "p_miss_unweighted", "p_nonmiss_unweighted"
                                        ),
                                      fmt_fun = NULL,
                                      stat_label =
                                        everything() ~ list(
                                          N_obs = "Total N",
                                          N_miss = "N Missing",
                                          N_nonmiss = "N not Missing",
                                          p_miss = "% Missing",
                                          p_nonmiss = "% not Missing",
                                          N_obs_unweighted = "Total N (unweighted)",
                                          N_miss_unweighted = "N Missing (unweighted)",
                                          N_nonmiss_unweighted = "N not Missing (unweighted)",
                                          p_miss_unweighted = "% Missing (unweighted)",
                                          p_nonmiss_unweighted = "% not Missing (unweighted)"
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
      what = "ard_missing(fmt_fn)",
      with = "ard_missing(fmt_fun)"
    )
    fmt_fun <- fmt_fn
  }

  # process inputs -------------------------------------------------------------
  check_not_missing(variables)
  cards::process_selectors(
    data = data$variables,
    variables = {{ variables }},
    by = {{ by }}
  )

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # convert all variables to T/F whether it's missing --------------------------
  data$variables <- data$variables |>
    dplyr::mutate(across(all_of(variables), Negate(is.na), .names = "lgl_{.col}"))

  cards::process_formula_selectors(
    data$variables[variables],
    statistic = statistic,
    fmt_fun = fmt_fun,
    stat_label = stat_label
  )
  cards::fill_formula_selectors(
    data$variables[variables],
    statistic = formals(asNamespace("cardx")[["ard_missing.survey.design"]])[["statistic"]] |> eval()
  )
  cards::fill_formula_selectors(
    data$variables[variables],
    stat_label = formals(asNamespace("cardx")[["ard_missing.survey.design"]])[["stat_label"]] |> eval()
  )

  stats_available <- c(
    "N_obs", "N_miss", "N_nonmiss", "p_miss", "p_nonmiss",
    "N_obs_unweighted", "N_miss_unweighted", "N_nonmiss_unweighted",
    "p_miss_unweighted", "p_nonmiss_unweighted"
  )
  cards::check_list_elements(
    x = statistic,
    predicate = \(x) is.character(x) && all(x %in% stats_available),
    error_msg = "Elements passed in the {.arg statistic} argument must be one or more of {.val {stats_available}}"
  )

  # calculate results ----------------------------------------------------------
  result <-
    ard_tabulate(
      data = data,
      variables = all_of(paste0("lgl_", variables)),
      by = any_of(by),
      statistic = everything() ~ c("n", "N", "p", "n_unweighted", "N_unweighted", "p_unweighted")
    ) |>
    dplyr::mutate(
      variable = str_remove(.data$variable, pattern = "^lgl_")
    )

  # rename the stats for missingness -------------------------------------------
  result <- result |>
    dplyr::mutate(
      stat_name =
        dplyr::case_when(
          .data$stat_name %in% "N" ~ "N_obs",
          .data$stat_name %in% "n" & .data$variable_level %in% FALSE ~ "N_miss",
          .data$stat_name %in% "n" & .data$variable_level %in% TRUE ~ "N_nonmiss",
          .data$stat_name %in% "p" & .data$variable_level %in% FALSE ~ "p_miss",
          .data$stat_name %in% "p" & .data$variable_level %in% TRUE ~ "p_nonmiss",
          .data$stat_name %in% "N_unweighted" ~ "N_obs_unweighted",
          .data$stat_name %in% "n_unweighted" & .data$variable_level %in% FALSE ~ "N_miss_unweighted",
          .data$stat_name %in% "n_unweighted" & .data$variable_level %in% TRUE ~ "N_nonmiss_unweighted",
          .data$stat_name %in% "p_unweighted" & .data$variable_level %in% FALSE ~ "p_miss_unweighted",
          .data$stat_name %in% "p_unweighted" & .data$variable_level %in% TRUE ~ "p_nonmiss_unweighted"
        )
    ) |>
    dplyr::select(-cards::all_ard_variables("levels"), -"stat_label", -"fmt_fun") |>
    dplyr::slice(1L, .by = c(cards::all_ard_groups(), cards::all_ard_variables(), "stat_name"))

  # final processing of fmt_fun ------------------------------------------------
  result <- result |>
    .process_nested_list_as_df(
      arg = fmt_fun,
      new_column = "fmt_fun"
    ) |>
    .default_svy_cat_fmt_fun()

  # merge in statistic labels --------------------------------------------------
  result <- result |>
    .process_nested_list_as_df(
      arg = stat_label,
      new_column = "stat_label",
      unlist = TRUE
    ) |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name))

  # return final object --------------------------------------------------------
  result |>
    dplyr::mutate(context = "missing") |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}
