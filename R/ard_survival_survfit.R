#' ARD Survival Estimates
#'
#' @description
#' Analysis results data for survival quantiles and x-year survival estimates, extracted
#' from a [survival::survfit()] model.
#'
#' @param x (`survfit` or `data.frame`)\cr
#'   an object of class `survfit` created with [survival::survfit()] or a data frame. See below for details.
#' @param times (`numeric`)\cr
#'   a vector of times for which to return survival probabilities.
#' @param probs (`numeric`)\cr
#'   a vector of probabilities with values in (0,1) specifying the survival quantiles to return.
#' @param type (`string` or `NULL`)\cr
#'   type of statistic to report. Available for Kaplan-Meier time estimates only, otherwise `type`
#'   is ignored. Default is `NULL`.
#'   Must be one of the following:
#'   ```{r, echo = FALSE}
#'   dplyr::tribble(
#'     ~type,          ~transformation,
#'     '`"survival"`', '`x`',
#'     '`"risk"`',     '`1 - x`',
#'     '`"cumhaz"`',   '`-log(x)`',
#'   ) %>%
#'   knitr::kable()
#'   ```
#' @param y (`Surv` or `string`)\cr
#'   an object of class `Surv` created using [survival::Surv()]. This object will be passed as the left-hand side of
#'   the formula constructed and passed to [survival::survfit()]. This object can also be passed as a string.
#' @param variables ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   stratification variables to be passed as the right-hand side of the formula constructed and passed to
#'   [survival::survfit()]. Default is `NULL` for an unstratified model, e.g. `Surv() ~ 1`.
#' @param method.args (named `list`)\cr
#'   named list of arguments that will be passed to [survival::survfit()].
#' @inheritParams rlang::args_dots_empty
#'
#' @section Formula Specification:
#' When passing a [`survival::survfit()`] object to `ard_survival_survfit()`,
#' the `survfit()` call must use an evaluated formula and not a stored formula.
#' Including a proper formula in the call allows the function to accurately
#' identify all variables included in the estimation. See below for examples:
#'
#' ```r
#' library(cardx)
#' library(survival)
#'
#' # include formula in `survfit()` call
#' survfit(Surv(time, status) ~ sex, lung) |> ard_survival_survfit(time = 500)
#'
#' # you can also pass a data frame to `ard_survival_survfit()` as well.
#' lung |>
#'   ard_survival_survfit(y = Surv(time, status), variables = "sex", time = 500)
#' ```
#' You **cannot**, however, pass a stored formula, e.g. `survfit(my_formula, lung)`,
#' but you can use stored formulas with `rlang::inject(survfit(!!my_formula, lung))`.
#'
#' @section Variable Classes:
#' When the `survfit` method is called, the class of the stratifying variables
#' will be returned as a factor.
#'
#' When the data frame method is called, the original classes are retained in the
#' resulting ARD.
#'
#' @return an ARD data frame of class 'card'
#' @name ard_survival_survfit
#'
#' @details
#' * Only one of either the `times` or `probs` parameters can be specified.
#' * Times should be provided using the same scale as the time variable used to fit the provided
#'   survival fit model.
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("survival", "broom", "ggsurvfit")))
#' library(survival)
#' library(ggsurvfit)
#'
#' survfit(Surv_CNSR(AVAL, CNSR) ~ TRTA, data = cards::ADTTE) |>
#'   ard_survival_survfit(times = c(60, 180))
#'
#' survfit(Surv_CNSR(AVAL, CNSR) ~ TRTA, data = cards::ADTTE, conf.int = 0.90) |>
#'   ard_survival_survfit(probs = c(0.25, 0.5, 0.75))
#'
#' cards::ADTTE |>
#'   ard_survival_survfit(y = Surv_CNSR(AVAL, CNSR), variables = c("TRTA", "SEX"), times = 90)
#'
#' # Competing Risks Example ---------------------------
#' set.seed(1)
#' ADTTE_MS <- cards::ADTTE %>%
#'   dplyr::mutate(
#'     CNSR = dplyr::case_when(
#'       CNSR == 0 ~ "censor",
#'       runif(dplyr::n()) < 0.5 ~ "death from cancer",
#'       TRUE ~ "death other causes"
#'     ) %>% factor()
#'   )
#'
#' survfit(Surv(AVAL, CNSR) ~ TRTA, data = ADTTE_MS) %>%
#'   ard_survival_survfit(times = c(60, 180))
NULL

#' @rdname ard_survival_survfit
#' @export
ard_survival_survfit <- function(x, ...) {
  set_cli_abort_call()

  check_not_missing(x)
  UseMethod("ard_survival_survfit")
}

#' @rdname ard_survival_survfit
#' @export
ard_survival_survfit.survfit <- function(x, times = NULL, probs = NULL, type = NULL, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed(c("survival", "broom"))

  # check/process inputs -------------------------------------------------------
  if (is.name(x$call$formula)) {
    cli::cli_abort(
      message = paste(
        "The call in the survfit object {.arg x} must be an evaluated formula.",
        "Please see {.help [{.fun ard_survival_survfit}](cardx::ard_survival_survfit)} documentation for details on properly specifying formulas."
      ),
      call = get_cli_abort_call()
    )
  }
  if (inherits(x, "survfitcox")) {
    cli::cli_abort("Argument {.arg x} cannot be class {.cls survfitcox}.",
      call = get_cli_abort_call()
    )
  }

  # competing risks models cannot use the type argument
  if (inherits(x, c("survfitms", "survfitcoxms")) && !is.null(type)) {
    cli::cli_abort("Cannot use {.arg type} argument with {.code survfit} models with class {.cls {c('survfitms', 'survfitcoxms')}}.",
      call = get_cli_abort_call()
    )
  }
  if (!is.null(probs)) check_range(probs, c(0, 1))
  if (sum(is.null(times), is.null(probs)) != 1) {
    cli::cli_abort("One and only one of {.arg times} and {.arg probs} must be specified.")
  }

  # for regular KM estimators, we allow the type argument
  if (!inherits(x, "survfitms") && !is.null(type)) {
    type <- arg_match(type, values = c("survival", "risk", "cumhaz"))
  }

  # cannot specify type arg when probs supplied
  if (!is.null(probs) && !is.null(type)) {
    cli::cli_abort("Cannot use {.arg type} argument when {.arg probs} argument specifed.",
      call = get_cli_abort_call()
    )
  }

  # build ARD ------------------------------------------------------------------
  est_type <- ifelse(is.null(probs), "times", "probs")
  tidy_survfit <- switch(est_type,
    "times" = .process_survfit_time(x, times, type %||% "survival"),
    "probs" = .process_survfit_probs(x, probs)
  )

  .format_survfit_results(tidy_survfit)
}

#' @rdname ard_survival_survfit
#' @export
ard_survival_survfit.data.frame <- function(x, y,
                                            variables = NULL,
                                            times = NULL, probs = NULL, type = NULL,
                                            method.args = list(conf.int = 0.95, conf.type = "log"), ...) {
  set_cli_abort_call()

  # check/process inputs -------------------------------------------------------
  check_not_missing(y)
  cards::process_selectors(x, variables = {{ variables }})

  # process outcome as string --------------------------------------------------
  y <- enquo(y)
  # if a character was passed, return it as is
  if (tryCatch(is.character(eval_tidy(y)), error = \(e) FALSE)) y <- eval_tidy(y) # styler: off
  # otherwise, convert expr to string
  else y <- expr_deparse(quo_get_expr(y))  # styler: off
  check_class(
    with(x, eval(parse_expr(y))),
    cls = "Surv",
    message =
      "The {.arg y} argument must be a string or expression that evaluates to an object of class {.cls Surv}
     most often created with {.fun survival::Surv} or {.fun ggsurvfit::Surv_CNSR}."
  )


  # build model ----------------------------------------------------------------
  survfit_formula <-
    case_switch(
      !is_empty(variables) ~ stats::reformulate(termlabels = bt(variables), response = y),
      .default = stats::reformulate(termlabels = "1", response = y)
    )

  ard <- construct_model(
    data = x,
    formula = survfit_formula,
    method = "survfit",
    package = "survival",
    method.args = {{ method.args }}
  ) |>
    ard_survival_survfit(times = times, probs = probs, type = type)

  ard_overall <- ard[ard$variable == "..ard_survival_survfit..", ]

  ard |>
    dplyr::filter(ard$variable != "..ard_survival_survfit..") |>
    .restore_original_column_types(data = x) |>
    dplyr::bind_rows(ard_overall)
}

#' Process Survival Fit For Time Estimates
#'
#' @inheritParams cards::tidy_as_ard
#' @inheritParams ard_survival_survfit
#' @param start.time (`numeric`)\cr
#'   default starting time. See [survival::survfit0()] for more details.
#'
#' @return a `tibble`
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("survival", "broom")))
#' survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
#'   cardx:::.process_survfit_time(times = c(60, 180), type = "risk")
#'
#' @keywords internal
.process_survfit_time <- function(x, times, type, start.time = NULL) {
  # add start time
  min_time <- min(x$time)
  if (is.null(start.time) && min_time < 0) {
    cli::cli_inform(paste(
      "The {.arg start.time} argument has not been set and negative times have been observed. Please set start",
      "time via the {.arg start.time} argument, otherwise the minimum observed time will be used by default."
    ))
    start.time <- min_time
  } else if (is.null(start.time)) {
    start.time <- 0
  }
  x <- survival::survfit0(x, start.time) %>%
    summary(times, extend = TRUE)

  # process competing risks/multi-state models
  multi_state <- inherits(x, "summary.survfitms")

  if (multi_state) {
    # selecting state to show
    state <- setdiff(unique(x$states), "(s0)")[[1]]
    cli::cli_inform("Multi-state model detected. Showing probabilities into state '{state}'.")
    x$n.risk <- x$n.risk[, 1]
    ms_cols <- c("pstate", "std.err", "upper", "lower")
    state_col <- which(colnames(x$pstate) == state)
    x[ms_cols] <- lapply(x[ms_cols], function(m) m[, state_col])
    x$surv <- x$pstate
  }

  # tidy survfit results
  x_cols <- intersect(names(x), c("time", "n.risk", "surv", "std.err", "upper", "lower", "strata"))
  tidy_x <- data.frame(x[x_cols]) %>%
    dplyr::rename(estimate = "surv", std.error = "std.err", conf.high = "upper", conf.low = "lower") %>%
    dplyr::mutate(
      conf.level = x$conf.int,
      conf.type = x$conf.type
    )

  strat <- "strata" %in% names(tidy_x)

  # get requested estimates
  df_stat <- tidy_x %>%
    # find max time
    dplyr::group_by_at(., dplyr::vars(dplyr::any_of("strata"))) %>%
    dplyr::mutate(time_max = max(.data$time)) %>%
    dplyr::ungroup() %>%
    # add requested timepoints
    dplyr::full_join(
      tidy_x %>%
        dplyr::select(any_of("strata")) %>%
        dplyr::distinct() %>%
        dplyr::mutate(
          time = list(.env$times),
          col_name = list(paste("stat", seq_len(length(.env$times)), sep = "_"))
        ) %>%
        tidyr::unnest(cols = c("time", "col_name")),
      by = unlist(intersect(c("strata", "time"), names(tidy_x)))
    )

  if (strat) {
    df_stat <- df_stat %>% dplyr::arrange(.data$strata)
  }

  df_stat <- df_stat %>%
    dplyr::arrange(.data$time) %>%
    # if user-specified time is after max time, make estimate NA
    dplyr::mutate_at(
      dplyr::vars("estimate", "conf.high", "conf.low"),
      ~ ifelse(.data$time > .data$time_max, NA_real_, .)
    ) %>%
    dplyr::mutate(context = type) %>%
    dplyr::select(!dplyr::any_of(c("time_max", "col_name")))

  # convert estimates to requested type
  if (type != "survival") {
    df_stat <- df_stat %>%
      dplyr::mutate(dplyr::across(
        any_of(c("estimate", "conf.low", "conf.high")),
        if (type == "cumhaz") ~ -log(.x) else ~ 1 - .x
      )) %>%
      dplyr::rename(conf.low = "conf.high", conf.high = "conf.low")
  }

  df_stat <- extract_strata(x, df_stat)

  df_stat
}

#' Process Survival Fit For Quantile Estimates
#'
#' @inheritParams cards::tidy_as_ard
#' @inheritParams ard_survival_survfit
#'
#' @return a `tibble`
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "survival"))
#' survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
#'   cardx:::.process_survfit_probs(probs = c(0.25, 0.75))
#'
#' @keywords internal
.process_survfit_probs <- function(x, probs) {
  # calculate survival quantiles and add estimates to df
  df_stat <- map2(
    probs,
    seq_along(probs),
    ~ stats::quantile(x, probs = .x) %>%
      as.data.frame() %>%
      set_names(c("estimate", "conf.low", "conf.high")) %>%
      dplyr::mutate(strata = row.names(.)) %>%
      dplyr::select(dplyr::any_of(c("n.risk", "strata", "estimate", "std.error", "conf.low", "conf.high"))) %>%
      dplyr::mutate(
        conf.level = x$conf.int,
        conf.type = x$conf.type,
        prob = .x
      )
  ) %>%
    dplyr::bind_rows() %>%
    `rownames<-`(NULL) %>%
    dplyr::mutate(context = "survival_survfit") %>%
    dplyr::as_tibble()

  if (length(x$n) == 1) df_stat <- df_stat %>% dplyr::select(-"strata")

  df_stat <- extract_strata(x, df_stat)

  df_stat
}

# process stratifying variables
extract_strata <- function(x, df_stat) {
  # Safe Subsetting: protect downstream engines from empty datasets
  if (nrow(df_stat) == 0) {
    cli::cli_warn("Dataset {.arg df_stat} is empty.")
    return(df_stat)
  }

  x_terms_raw <- attr(stats::terms(stats::as.formula(x$call$formula)), "term.labels")
  # strip function wrappers like strata(), factor() from term labels,
  # extracting only the first argument (the variable name)
  x_terms <- sub("^\\w+\\(\\s*([^,)]+).*\\)$", "\\1", x_terms_raw)

  if (length(x_terms) > 0L) {
    # build split pattern using the raw term labels (as they appear in strata strings)
    # escape each term for regex, then join with | alternation
    escaped_terms <- vapply(x_terms_raw, function(t) {
      paste0("(^|, )", gsub("([()|.^$*+?{}\\[\\]\\\\])", "\\\\\\1", t, perl = TRUE), "=")
    }, character(1), USE.NAMES = FALSE)
    split_pattern <- paste(escaped_terms, collapse = "|")

    # Factor Safety: explicit coercion prevents hidden evaluation overhead
    strata_vec <- as.character(df_stat[["strata"]])

    # Replace inefficient rbind() loop with vectorized lapply
    strata_list <- lapply(strata_vec, function(i) {
      terms_str <- strsplit(i, split_pattern)[[1]]
      terms_str[nchar(terms_str) > 0]
    })

    # Efficiently construct the data frame in one go
    strata_lvls <- as.data.frame(do.call(rbind, strata_list))

    if (nrow(strata_lvls) > 0) {
      strata_lvls <- cbind(strata_lvls, t(x_terms))
      names(strata_lvls) <- c(
        t(sapply(seq_along(x_terms), function(i) c(paste0("group", i, "_level"), paste0("group", i))))
      )

      # Bind new columns and drop the old strata column
      df_stat <- cbind(df_stat, strata_lvls) |>
	      dplyr::select(-"strata")
    }
  }

  df_stat
}

#' Convert Tidied Survival Fit to ARD
#'
#' @inheritParams cards::tidy_as_ard
#'
#' @return an ARD data frame of class 'card'
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("survival", "broom")))
#' cardx:::.format_survfit_results(
#'   broom::tidy(survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE))
#' )
#'
#' @keywords internal
.format_survfit_results <- function(tidy_survfit) {
  est <- if ("time" %in% names(tidy_survfit)) "time" else "prob"
  conf.level <- tidy_survfit[["conf.level"]][1]
  conf.type <- tidy_survfit[["conf.type"]][1]

  ret <- tidy_survfit %>%
    dplyr::select(-dplyr::any_of(c("conf.level", "conf.type"))) %>%
    dplyr::mutate(dplyr::across(
      dplyr::any_of(
        c("n.risk", "estimate", "std.error", "conf.high", "conf.low", "time", "prob")
      ),
      ~ as.list(.)
    )) %>%
    tidyr::pivot_longer(
      cols = dplyr::any_of(c("n.risk", "estimate", "std.error", "conf.high", "conf.low")),
      names_to = "stat_name",
      values_to = "stat"
    ) %>%
    dplyr::mutate(
      variable = est,
      variable_level = .data[[est]]
    ) %>%
    dplyr::select(-all_of(est))

  # statistics applicable to all calculations
  if (!is.null(conf.level) && !is.null(conf.type)) {
    ret <- ret %>%
      dplyr::bind_rows(
        dplyr::tibble(
          context = "survival",
          stat_name = c("conf.level", "conf.type"),
          stat = list(conf.level, conf.type),
          variable = "..ard_survival_survfit.."
        )
      )
  }

  ret %>%
    dplyr::left_join(
      .df_survfit_stat_labels(),
      by = "stat_name"
    ) %>%
    dplyr::mutate(
      fmt_fun = lapply(
        .data$stat,
        function(x) {
          switch(is.integer(x),
            0L
          ) %||% switch(is.numeric(x),
            1L
          )
        }
      ),
      stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name)
    ) %>%
    dplyr::mutate(dplyr::across(matches("group[0-9]*_level"), ~ as.list(as.factor(.x)))) %>%
    dplyr::mutate(
      warning = list(NULL),
      error = list(NULL)
    ) %>%
    cards::as_card(check = FALSE) %>%
    cards::tidy_ard_column_order() %>%
    cards::tidy_ard_row_order()
}

.df_survfit_stat_labels <- function() {
  dplyr::tribble(
    ~stat_name, ~stat_label,
    "n.risk", "Number of Subjects at Risk",
    "estimate", "Survival Probability",
    "std.error", "Standard Error (untransformed)",
    "conf.low", "CI Lower Bound",
    "conf.high", "CI Upper Bound",
    "prob", "Quantile",
    "time", "Time",
    "conf.level", "CI Confidence Level",
    "conf.type", "CI Type"
  )
}
