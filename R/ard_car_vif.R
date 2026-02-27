#' Regression VIF ARD
#'
#' @description
#' Function takes a regression model object and returns the variance inflation factor (VIF)
#' using [`car::vif()`] and converts it to a ARD structure
#'
#' @param x regression model object
#' See car::vif() for details
#'
#' @param ... arguments passed to `car::vif(...)`
#'
#' @return data frame
#' @name ard_car_vif
#' @rdname ard_car_vif
#' @export
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "car"))
#' lm(AGE ~ ARM + SEX, data = cards::ADSL) |>
#'   ard_car_vif()
ard_car_vif <- function(x, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed("car")

  # check inputs ---------------------------------------------------------------
  check_not_missing(x)

  vif <- cards::eval_capture_conditions(car::vif(x, ...))

  # if vif failed, set result as NULL, error will be kept through eval_capture_conditions()
  if (is.null(vif$result)) {
    # try to capture variable names from `terms()`
    lst_terms <- cards::eval_capture_conditions(attr(stats::terms(x), "term.labels"))
    # we cannot get variable names, error out
    if (!is.null(lst_terms[["error"]])) {
      cli::cli_abort(
        c("There was an error running {.fun car::vif}. See below.", x = vif[["error"]]),
        call = get_cli_abort_call()
      )
    }
    vif$result <- dplyr::tibble(
      variable = lst_terms[["result"]],
      VIF = list(NULL),
      GVIF = list(NULL),
      aGVIF = list(NULL),
      df = list(NULL)
    )
  }
  # if VIF is returned
  else if (!is.matrix(vif$result)) {
    vif$result <- dplyr::tibble(variable = names(vif$result), VIF = vif$result)
  }
  # if Generalized VIF is returned
  else if (is.matrix(vif$result)) {
    vif$result <-
      vif$result |>
      as.data.frame() %>%
      dplyr::mutate(., variable = rownames(.), .before = 1L) |>
      dplyr::rename(
        aGVIF = "GVIF^(1/(2*Df))",
        df = "Df"
      ) |>
      dplyr::tibble()
  }

  # Clean-up the result to fit the ard structure through pivot
  vif$result <-
    vif$result |>
    tidyr::pivot_longer(
      cols = -c("variable"),
      names_to = "stat_name",
      values_to = "stat"
    ) |>
    dplyr::mutate(
      context = "car_vif",
      stat = as.list(.data$stat),
      stat_label = ifelse(
        .data$stat_name == "aGVIF",
        "Adjusted GVIF",
        .data$stat_name
      ),
      fmt_fun = map(
        .data$stat,
        function(.x) {
          # styler: off
          if (is.integer(.x)) return(0L)
          if (is.numeric(.x)) return(1L)
          # styler: on
          NULL
        }
      )
    )

  # Bind the results and possible warning/errors together
  vif_return <- dplyr::tibble(
    vif$result,
    warning = vif["warning"],
    error = vif["error"]
  )

  # Clean up return object
  vif_return |>
    cards::as_card(check = FALSE) |>
    cards::tidy_ard_column_order()
}
