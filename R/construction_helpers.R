#' Construction Helpers
#'
#' These functions help construct calls to various types of models.
#'
#' - `construct_model()`: Builds models of the form `method(data = data, formula = formula, method.args!!!)`.
#'    If the `package` argument is specified, that package is temporarily attached
#'    when the model is evaluated.
#'
#' - `reformulate2()`: This is a copy of `reformulate()` except that variable
#'    names that contain a space are wrapped in backticks.
#'
#' - `bt()`: Adds backticks to a character vector.
#'
#' - `bt_strip()`: Removes backticks from a string if it begins and ends with a backtick.
#'
#' @param data
#'  - `construct_model.data.frame()` (`data.frame`) a data frame
#'  - `construct_model.survey.design()` (`survey.design`) a survey design object
#' @param x (`character`)\cr
#'  character vector, typically of variable names
#' @param formula (`formula`)\cr
#'   a formula
#' @param method (`string`)\cr
#'   string of function naming the function to be called, e.g. `"glm"`.
#'   If function belongs to a library that is not attached, the package name
#'   must be specified in the `package` argument.
#' @param method.args (named `list`)\cr
#'   named list of arguments that will be passed to `method`.
#'
#'   Note that this list may contain non-standard evaluation components.
#'   If you are wrapping this function in other functions, the argument
#'   must be passed in a way that does not evaluate the list, e.g.
#'   using rlang's  embrace operator `{{ . }}`.
#' @param package (`string`)\cr
#'   a package name that will be temporarily loaded when function
#'   specified in `method` is executed.
#' @param pattern,pattern_term,pattern_response DEPRECATED
#' @inheritParams rlang::eval_tidy
#' @inheritParams stats::reformulate
#' @inheritParams rlang::args_dots_empty
#'
#' @return depends on the calling function
#' @name construction_helpers
#'
#' @examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = c("withr", "lme4", "broom.helpers", "broom.mixed")))
#' construct_model(
#'   data = mtcars,
#'   formula = am ~ mpg + (1 | vs),
#'   method = "glmer",
#'   method.args = list(family = binomial),
#'   package = "lme4"
#' ) |>
#'   broom.mixed::tidy()
#'
#' construct_model(
#'   data = mtcars |> dplyr::rename(`M P G` = mpg),
#'   formula = reformulate2(c("M P G", "cyl"), response = "hp"),
#'   method = "lm"
#' ) |>
#'   ard_regression() |>
#'   dplyr::filter(stat_name %in% c("term", "estimate", "p.value"))
NULL

#' @rdname construction_helpers
#' @export
construct_model <- function(data, ...) {
  UseMethod("construct_model")
}

#' @rdname construction_helpers
#' @export
construct_model.data.frame <- function(data, formula, method, method.args = list(), package = "base", env = caller_env(), ...) {
  set_cli_abort_call()
  # check pkg installations ----------------------------------------------------
  check_dots_empty()
  check_pkg_installed(c("withr", package))

  check_not_missing(formula)
  check_class(formula, cls = "formula")

  check_not_missing(method)
  check_string_or_function(method)
  if (is_string(method)) check_not_namespaced(method)

  # convert method.args to list of expressions (to account for NSE inputs) -----
  method.args <- .as_list_of_exprs({{ method.args }})

  # build model ----------------------------------------------------------------
  call_to_run <- call2(.fn = method, formula = formula, data = data, !!!method.args)

  try_fetch(
    withr::with_namespace(
      package = package,
      eval_tidy(call_to_run, env = env)
    ),
    error = function(e) {
      msg <- "There was an error evaluating the model"
      if (is_string(method)) {
        call_to_run$data <- expr(.)
        msg <- paste(msg, "{.code {truncate_call(call_to_run)}}")
      }

      cli::cli_abort(
        message = msg,
        parent = e,
        call = get_cli_abort_call()
      )
    }
  )
}

#' @rdname construction_helpers
#' @export
construct_model.survey.design <- function(data, formula, method, method.args = list(), package = "survey", env = caller_env(), ...) {
  set_cli_abort_call()
  # check pkg installations ----------------------------------------------------
  check_dots_empty()
  check_pkg_installed(c("withr", package))

  check_not_missing(formula)
  check_class(formula, cls = "formula")

  check_not_missing(method)
  check_string_or_function(method)
  if (is_string(method)) check_not_namespaced(method)

  # convert method.args to list of expressions (to account for NSE inputs) -----
  method.args <- .as_list_of_exprs({{ method.args }})

  # build model ----------------------------------------------------------------
  call_to_run <- call2(.fn = method, formula = formula, design = data, !!!method.args)

  try_fetch(
    withr::with_namespace(
      package = package,
      eval_tidy(call_to_run, env = env)
    ),
    error = function(e) {
      msg <- "There was an error evaluating the model"
      if (is_string(method)) {
        call_to_run$design <- expr(.)
        msg <- paste(msg, "{.code {truncate_call(call_to_run)}}")
      }

      cli::cli_abort(
        message = msg,
        parent = e,
        call = get_cli_abort_call()
      )
    }
  )
}

# `svyrep.design` is a sibling class of `survey.design`, not a subclass, so it
# needs its own method. The model is fit by `survey::svyglm()`, which already
# handles replicate designs. See #355.

#' @rdname construction_helpers
#' @export
construct_model.svyrep.design <- function(data, ..., env = caller_env()) {
  # claim the abort call before delegating, so errors are reported against this
  # method rather than the `survey.design` method it delegates to
  set_cli_abort_call()
  construct_model.survey.design(data = data, ..., env = env)
}

.as_list_of_exprs <- function(x, arg_name = "method.args") {
  x_enexpr <- enexpr(x)
  if (is_call_simple(x_enexpr)) {
    return(call_args(x_enexpr))
  }

  cli::cli_abort(
    c("There was an error processing the {.arg {arg_name}} argument.",
      i = "Expecting a simple call. See {.help rlang::is_call_simple} for details."
    ),
    call = get_cli_abort_call()
  )
}

#' @rdname construction_helpers
#' @export
reformulate2 <- function(termlabels, response = NULL, intercept = TRUE,
                         env = parent.frame(),
                         pattern_term = NULL, pattern_response = NULL) {
  # deprecated argument --------------------------------------------------------
  if (!missing(pattern_term)) lifecycle::deprecate_warn("0.2.1", what = "cardx::reformulate2(pattern_term)", details = "Argument has been ignored.") # styler: off
  if (!missing(pattern_response)) lifecycle::deprecate_warn("0.2.1", what = "cardx::reformulate2(pattern_response)", details = "Argument has been ignored.") # styler: off

  stats::reformulate(
    termlabels = bt(termlabels),
    response = bt(response),
    intercept = intercept,
    env = env
  )
}

#' @rdname construction_helpers
#' @export
bt <- function(x, pattern = NULL) {
  # deprecated argument --------------------------------------------------------
  if (!missing(pattern)) lifecycle::deprecate_warn("0.2.1", what = "cardx::bt(pattern)", details = "Argument has been ignored.") # styler: off

  if (is_empty(x)) {
    return(x)
  }

  ifelse(
    make.names(x) != x & !str_detect(x, "^`.*`$"),
    paste0("`", x, "`"),
    x
  )
}

#' @rdname construction_helpers
#' @export
bt_strip <- function(x) {
  ifelse(
    str_detect(x, "^`.*`$"),
    substr(x, 2, nchar(x) - 1),
    x
  )
}

check_not_namespaced <- function(x,
                                 arg_name = rlang::caller_arg(x),
                                 class = "check_not_namespaced",
                                 call = get_cli_abort_call()) {
  check_string(x, arg_name = arg_name, call = call, class = "check_not_namespaced")

  if (str_detect(x, "::")) {
    cli::cli_abort(
      "Argument {.arg {arg_name}} cannot be namespaced when passed as a {.cls string}.",
      call = call,
      class = class
    )
  }

  invisible(x)
}


check_string_or_function <- function(x,
                                     arg_name = rlang::caller_arg(x),
                                     class = "check_string_or_function",
                                     call = get_cli_abort_call()) {
  if (!is.function(x) && !is_string(x)) {
    cli::cli_abort(
      c("Argument {.arg {arg_name}} must be a {.cls string} or {.cls function}."),
      call = call,
      class = class
    )
  }

  invisible(x)
}

truncate_call <- function(call, max_out = 100) {
  call_text <- expr_text(call)
  if (nchar(call_text) > max_out) {
    call_text <- paste(substr(call_text, 1, max_out), "...")
  }
  call_text
}
