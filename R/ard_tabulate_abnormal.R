#' ARD Abnormality Counts
#'
#' @description
#'
#' Function counts participants with abnormal analysis range values.
#'
#' For each abnormality specified via the `abnormal` parameter (e.g. Low or High), statistic `n` is
#' calculated as the number of patients with this abnormality recorded, and statistic `N` is calculated as
#' the total number of patients with at least one post-baseline assessment. `p` is calculated as
#' `n / N`. If `excl_baseline_abn=TRUE` then participants with abnormality at baseline are excluded
#' from all statistic calculations.
#'
#' @param data (`data.frame`)\cr
#'   a data frame.
#' @param postbaseline ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name of post-baseline reference range indicator variable.
#' @param baseline ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name of baseline reference range indicator variable.
#' @param id ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name used to identify unique participants in `data`. If `NULL`, each row in `data` is assumed to correspond
#'   to a unique participants.
#' @param abnormal (`list`)\cr
#'   a named list of abnormalities to assess for. Each element should specify all levels of `postbaseline`/`baseline`
#'   that should be included when assessing for a given abnormality, with the name specifying the name of the
#'   abnormality. Any levels specified but not present in the data are ignored.
#' @param excl_baseline_abn (`logical`)\cr
#'   whether participants with baseline abnormality should be excluded from calculations. Defaults to `TRUE`.
#' @param quiet (scalar `logical`)\cr
#'   logical indicating whether to suppress additional messaging. Default is `FALSE`.
#' @inheritParams cards::ard_summary
#'
#' @return an ARD data frame of class 'card'
#' @export
#'
#' @examples
#' # Load Data -------------------
#' set.seed(1)
#' adlb <- cards::ADLB
#' adlb$BNRIND <- ifelse(
#'   adlb$BNRIND != "N",
#'   sample(c("LOW", "LOW LOW", "HIGH", "HIGH HIGH"), nrow(adlb), replace = TRUE),
#'   "NORMAL"
#' )
#'
#' # Example 1 -------------------
#' adlb |>
#'   ard_tabulate_abnormal(
#'     postbaseline = LBNRIND, baseline = BNRIND, id = USUBJID, by = TRTA,
#'     abnormal = list(Low = c("LOW", "LOW LOW"), High = c("HIGH", "HIGH HIGH"))
#'   )
ard_tabulate_abnormal <- function(data,
                                  postbaseline,
                                  baseline,
                                  id = NULL,
                                  by = NULL,
                                  strata = NULL,
                                  abnormal = list(Low = "LOW", High = "HIGH"),
                                  excl_baseline_abn = TRUE,
                                  quiet = FALSE) {
  set_cli_abort_call()

  # check inputs ---------------------------------------------------------------
  check_data_frame(data)
  cards::process_selectors(
    data,
    postbaseline = {{ postbaseline }}, baseline = {{ baseline }}, id = {{ id }}, by = {{ by }}, strata = {{ strata }}
  )
  check_not_missing(abnormal)
  check_scalar_logical(excl_baseline_abn)
  check_scalar_logical(quiet)
  check_class(abnormal, "list")

  if (!is_named(abnormal)) {
    cli::cli_abort(
      "{.arg abnormal} must be a named list, where each name corresponds to a different abnormality/direction.",
      call = get_cli_abort_call()
    )
  }
  if (!all(is.character(unlist(abnormal)))) {
    cli::cli_abort(
      "Each abnormal level of {.var {postbaseline}} specified via {.arg abnormal} must be a {.cls string}.",
      call = get_cli_abort_call()
    )
  }

  # print abnormality levels ---------------------------------------------------
  if (!quiet) {
    for (i in seq_along(abnormal)) {
      vec <- cli::cli_vec(abnormal[[i]], style = list("vec-sep" = ", ", "vec-sep2" = ", ", "vec-last" = ", "))
      cli::cli_inform("Abnormality {.val {names(abnormal)[i]}} created {cli::qty(abnormal[[i]])} {?from/by merging} level{?s}: {.val {vec}}")
    }
  }

  # build ARD ------------------------------------------------------------------
  data <- data |>
    dplyr::mutate(
      dplyr::across(
        all_of(c(postbaseline, baseline)),
        \(x) {
          # combine levels specified for each abnormality
          do.call(fct_collapse, args = c(list(f = x), abnormal)) |>
            suppressWarnings()
        }
      )
    )

  # calculate statistics for each abnormality
  lapply(
    names(abnormal),
    function(abn) {
      cards::ard_mvsummary(
        data = data,
        variables = all_of(postbaseline),
        by = any_of(by),
        strata = any_of(strata),
        statistic = all_of(postbaseline) ~ list(
          abnormal =
            .calc_abnormal(data, abn, postbaseline, baseline, id, excl_baseline_abn)
        )
      ) |>
        dplyr::bind_cols(dplyr::tibble(variable_level = list(abn)))
    }
  ) |>
    dplyr::bind_rows() |>
    dplyr::mutate(
      stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name),
      context = "categorical_abnormal",
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order() |>
    cards::tidy_ard_row_order()
}

# function to perform calculations -------------------------------------------
.calc_abnormal <- function(data, abnormality, postbaseline, baseline, id, excl_baseline_abn) {
  cards::as_cards_fn(
    \(x, data, ...) {
      # if `excl_baseline_abn=FALSE` then do not exclude baseline abnormal from numerator/denominator calculations
      baseline_not_abn <- if (excl_baseline_abn) !data[[baseline]] %in% abnormality else TRUE # baseline visit not abnormal
      postbaseline_abn <- data[[postbaseline]] %in% abnormality # post-baseline visit abnormal

      # numerator: unique participants with any abnormal post-baseline visit, baseline visit not abnormal
      n <- data |>
        dplyr::filter(postbaseline_abn & baseline_not_abn) |>
        dplyr::select(all_of(id)) |>
        dplyr::distinct() |>
        nrow()

      # denominator: unique participants with any post-baseline visit, baseline visit not abnormal (if )
      N <- data |>
        dplyr::filter(baseline_not_abn) |>
        dplyr::select(all_of(id)) |>
        dplyr::distinct() |>
        nrow()

      dplyr::tibble(n = n, N = N, p = n / N)
    },
    stat_names = c("n", "N", "p")
  )
}
