#' ARD Incidence Rate
#'
#' @description
#'
#' Function takes a time at risk variable (`time`) and event count variable (`count`) and calculates the incidence
#' rate in person-years.
#'
#' Incidence rate is calculated as: Total number of events that occurred / Total person-time at risk
#'
#' @param data (`data.frame`)\cr
#'   a data frame.
#' @param time ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name of time at risk variable.
#' @param count ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name of variable indicating count of events that occurred. If `NULL`, each row in `data` is assumed to
#'   correspond to a single event occurrence.
#' @param id ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
#'   column name used to identify unique subjects in `data`. If `NULL`, each row in `data` is assumed to correspond to
#'   a unique subject.
#' @param n_person_time (`numeric`)\cr
#'   amount of person-time to estimate incidence rate for. Defaults to 100.
#' @param unit_label (`string`)\cr
#'   label for the unit of values in `time` and estimated person-time output (e.g. `"years"` for person-years,
#'   `"days"` for person-days, etc.). If the desired person-time estimate unit does not match the current `time` unit,
#'   values of `time` should be converted to the correct unit during pre-processing. Defaults to `"time"` (person-time).
#' @param conf.level (`numeric`)\cr
#'   confidence level for the estimated incidence rate.
#' @param conf.type (`string`)\cr
#'   confidence interval type for the estimated incidence rate.
#'
#'   One of: `normal` (default), `normal-log`, `exact`, or `byar`.
#' @inheritParams cards::ard_summary
#'
#' @return an ARD data frame of class 'card'
#' @export
#'
#' @details
#' The formulas used to calculate the confidence interval for each CI type are as
#' follows, where \eqn{x_i} and \eqn{t_i} represent the number of events and follow-up
#' time for subject \eqn{i}, respectively.
#'
#' * `byar`: Byar's approximation of a Poisson CI. A continuity correction of 0.5 is included in the calculation.
#'
#'   \deqn{CI = (\sum{x_i} + 0.5) (1 - 1 / (9 \times (\sum{x_i} + 0.5)) \pm Z_{1 - \alpha / 2} / (3 \sqrt{\sum{x_i} + 0.5}))^3 / \sum{t_i}}
#'
#' * `normal`: Normal CI.
#'
#'   \deqn{CI = \sum{x_i} / \sum{t_i} \pm Z_{1 - \alpha / 2} \sqrt{\sum{x_i}} / \sum{t_i}}
#'
#' * `normal-log`: Normal-Log CI.
#'
#'   \deqn{CI = \exp(\log(\sum{x_i} / \sum{t_i}) \pm Z_{1 - \alpha / 2} / \sqrt{\sum{x_i}})}
#'
#' * `exact`: Exact CI for a Poisson mean.
#'
#'   \deqn{CI_{lower} = \chi^2_{\alpha / 2, 2\sum{x_i} + 2} / {2 \sum{t_i}}}
#'   \deqn{CI_{upper} = \chi^2_{1 - \alpha / 2, 2\sum{x_i} + 2} / {2 \sum{t_i}}}
#'
#' @examples
#' set.seed(1)
#' data <- data.frame(
#'   USUBJID = 1:100,
#'   TRTA = sample(LETTERS[1:3], 100, replace = TRUE),
#'   AETTE1 = abs(rnorm(100, mean = 0.5)),
#'   AETOT1 = sample(0:20, 100, replace = TRUE)
#' )
#'
#' data |>
#'   ard_incidence_rate(time = AETTE1, count = AETOT1, id = USUBJID, by = TRTA, unit_label = "years")
ard_incidence_rate <- function(data,
                               time,
                               count = NULL,
                               id = NULL,
                               by = NULL,
                               strata = NULL,
                               n_person_time = 100,
                               unit_label = "time",
                               conf.level = 0.95,
                               conf.type = c("normal", "normal-log", "exact", "byar")) {
  set_cli_abort_call()

  # check inputs ---------------------------------------------------------------
  check_data_frame(data)
  cards::process_selectors(
    data,
    time = {{ time }}, by = {{ by }}, strata = {{ strata }}, count = {{ count }}, id = {{ id }}
  )
  check_scalar(time)
  check_string(unit_label)
  check_scalar(count, allow_empty = TRUE)
  check_scalar(id, allow_empty = TRUE)
  check_scalar_range(conf.level, c(0, 1))
  check_numeric(n_person_time)
  check_scalar(n_person_time)
  if (!class(data[[time]]) %in% c("numeric", "integer")) {
    cli::cli_abort(
      message = paste(
        "The {.arg time} variable must be of type {.cls numeric/integer} but {.arg {time}} is",
        "{.obj_type_friendly {data[[time]]}}."
      ),
      call = get_cli_abort_call()
    )
  }


  conf.type <- arg_match(conf.type, error_call = get_cli_abort_call())

  # build ARD ------------------------------------------------------------------
  cards::ard_mvsummary(
    data = data,
    variables = all_of(time),
    by = any_of(by),
    strata = any_of(strata),
    statistic = all_of(time) ~ list(
      incidence_rate =
        .calc_incidence_rate(data, time, count, id, by, strata, n_person_time, unit_label, conf.level, conf.type)
    )
  ) |>
    dplyr::select(-"stat_label") |>
    dplyr::left_join(
      .df_incidence_rate_stat_labels(n_person_time, unit_label),
      by = "stat_name"
    ) |>
    dplyr::mutate(
      stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name),
      context = "incidence_rate",
    ) |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order() |>
    cards::tidy_ard_row_order()
}

# function to perform calculations -------------------------------------------
.calc_incidence_rate <- function(data, time, count, id, by, strata, n_person_time, unit_label, conf.level, conf.type) {
  cards::as_cards_fn(
    \(x, data, ...) {
      # calculate number of unique IDs with >=1 event
      N <- if (!is_empty(id)) {
        sum(!is.na(unique(data[[id]])))
      } else {
        nrow(data)
      }

      # calculate total person-years
      tot_person_time <- sum(x, na.rm = TRUE)

      # calculate total number of events
      n_events <- if (!is_empty(count)) sum(data[[count]], na.rm = TRUE) else nrow(data)

      rate_est <- n_events / tot_person_time
      rate_se <- sqrt(rate_est / tot_person_time)
      alpha <- 1 - conf.level
      if (conf.type %in% c("normal", "normal-log")) {
        rate_ci <- if (conf.type == "normal") {
          rate_est + c(-1, 1) * stats::qnorm(1 - alpha / 2) * rate_se
        } else {
          exp(log(rate_est) + c(-1, 1) * stats::qnorm(1 - alpha / 2) * rate_se / rate_est)
        }
        conf.low <- rate_ci[1]
        conf.high <- rate_ci[2]
      } else if (conf.type == "exact") {
        conf.low <- stats::qchisq(p = alpha / 2, df = 2 * n_events) / (2 * tot_person_time)
        conf.high <- stats::qchisq(p = 1 - alpha / 2, df = 2 * n_events + 2) / (2 * tot_person_time)
      } else if (conf.type == "byar") {
        seg_1 <- n_events + 0.5
        seg_2 <- 1 - 1 / (9 * (n_events + 0.5))
        seg_3 <- stats::qnorm(1 - alpha / 2) * sqrt(1 / (n_events + 0.5)) / 3
        conf.low <- seg_1 * ((seg_2 - seg_3)^3) / tot_person_time
        conf.high <- seg_1 * ((seg_2 + seg_3)^3) / tot_person_time
      }

      dplyr::tibble(
        estimate = rate_est * n_person_time,
        std.error = rate_se,
        conf.low = conf.low * n_person_time,
        conf.high = conf.high * n_person_time,
        conf.type = conf.type,
        conf.level = conf.level,
        tot_person_time = tot_person_time,
        n_events = n_events,
        N = N
      )
    },
    stat_names = c(
      "estimate", "std.error", "conf.low", "conf.high", "conf.type", "conf.level",
      "tot_person_time", "n_events", "N"
    )
  )
}

.df_incidence_rate_stat_labels <- function(n_person_time, unit_label) {
  time_unit <- paste0("Person-", str_replace(unit_label, "([[:alpha:]])", substr(toupper(unit_label), 1, 1)))

  dplyr::tribble(
    ~stat_name, ~stat_label,
    "estimate", paste("Incidence rate per", n_person_time, time_unit),
    "std.error", "Standard Error",
    "conf.low", "CI Lower Bound",
    "conf.high", "CI Upper Bound",
    "conf.type", "CI Type",
    "conf.level", "CI Confidence Level",
    "tot_person_time", paste(time_unit, "at Risk"),
    "n_events", "Number of Events Observed",
    "N", "Number of Subjects Observed"
  )
}
