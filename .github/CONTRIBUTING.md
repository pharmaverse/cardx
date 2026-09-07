# Contribution Guidelines

🙏 Thank you for taking the time to contribute!

Your input is deeply valued, whether an issue, a pull request, or even feedback, regardless of size, content or scope.

## Table of contents

[👶 Getting started](#getting-started)

[📔 Code of Conduct](#code-of-conduct)

[🗃 License](#license)

[📜 Issues](#issues)

[🚩 Pull requests](#pull-requests)

[💻 Coding guidelines](#coding-guidelines)

[✨ Adding a new ARD function](#adding-a-new-ard-function)

[🧪 Testing](#testing)

[📋 Before you push](#before-you-push)

[🏆 Recognition model](#recognition-model)

[❓ Questions](#questions)

## Getting started

Please refer to the project [documentation][docs] for a brief introduction.

`cardx` extends the [`cards`](https://github.com/pharmaverse/cards) package.
`cards` provides the core Analysis Results Data (ARD) framework — the `card` class, the
tidiers, and the structural checks. `cardx` provides the *extra* ARD functions: thin,
consistent wrappers that run a statistical method from another package (`stats`,
`survival`, `survey`, `car`, `emmeans`, and others) and return the result as an ARD.

Because every function in `cardx` does the same kind of job, they all share the same
shape. Before writing anything new, read a couple of existing functions — the
conventions below are much easier to follow with an example in front of you:

* [`R/ard_stats_chisq_test.R`](../R/ard_stats_chisq_test.R) — the simplest complete wrapper. Start here.
* [`R/ard_stats_t_test.R`](../R/ard_stats_t_test.R) — two exported functions sharing one help page, with a shared internal formatter.
* [`R/ard_car_vif.R`](../R/ard_car_vif.R) — what to do when the wrapped package has no `broom` tidier and you must build the ARD by hand.

## Code of Conduct

A [Code of Conduct](CODE_OF_CONDUCT.md) governs this project. Participants and contributors are expected to follow the rules outlined therein.

## License

All your contributions will be covered by this project's [license][license].

## Issues

We use GitHub to track issues, feature requests, and bugs. Before submitting a new issue, please check if the issue has already been reported. If the issue already exists, please upvote the existing issue 👍.

For new feature requests, please elaborate on the context and the benefit the feature will have for users, developers, or other relevant personas.

## Pull requests

### GitHub Flow

This repository uses the [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow) model for collaboration. To submit a pull request:

1. Create a branch

   Please see the [branch naming convention](#branch-naming-convention) below. If you don't have write access to this repository, please fork it.

2. Make changes

    Make sure your code
    * passes all checks imposed by GitHub Actions
    * is well documented
    * is well tested with unit tests sufficiently covering the changes introduced

3. Create a pull request (PR)

   In the pull request description, please link the relevant issue (if any), provide a detailed description of the change, and include any assumptions.

4. Address review comments, if any

5. Post approval

   Merge your PR if you have write access. Otherwise, the reviewer will merge the PR on your behalf.

6. Pat yourself on the back

   Congratulations! 🎉
   You are now an official contributor to this project! We are grateful for your contribution.

### Branch naming convention

Suppose your changes are related to a current issue in the current project; please name your branch as follows: `<issue_id>_<short_description>`. Please use underscore (`_`) as a delimiter for word separation. For example, `420_fix_ui_bug` would be a suitable branch name if your change is resolving and UI-related bug reported in issue number `420` in the current project.

If your change affects multiple repositories, please name your branches as follows: `<issue_id>_<issue_repo>_<short description>`. For example, `69_awesomeproject_fix_spelling_error` would reference issue `69` reported in project `awesomeproject` and aims to resolve one or more spelling errors in multiple (likely related) repositories.

### Merging

Use **"Squash and merge"** or **"Rebase and merge"**. Before merging, add an entry to
`NEWS.md` under the `# cardx (development version)` heading (see
[Documentation and NEWS](#6-documentation-and-news)).

## Coding guidelines

This repository follows some unified processes and standards adopted by its maintainers to ensure software development is carried out consistently within teams and cohesively across other repositories.

### Style guide

This repository follows the standard [`tidyverse` style guide](https://style.tidyverse.org/).

Style is checked in CI by the **Style Check 👗** workflow job, which runs
[`styler`](https://styler.r-lib.org/). That job runs with `auto-update: false`, meaning
**CI will report style problems but will not fix them for you**. Run `styler` yourself
before pushing:

```r
styler::style_pkg()
```

A few conventions worth calling out, because `styler` will not enforce them:

* Use the **native pipe** `|>`. The magrittr `%>%` is re-exported for users, but new code in the package should use `|>`.
* Two-space indentation, UTF-8, no trailing whitespace. These come from `cardx.Rproj`, so RStudio and Positron pick them up automatically.
* Where hand alignment reads better than what `styler` produces — long `if`/`else` one-liners inside `cards::eval_capture_conditions()`, for instance — fence the block:

  ```r
  # styler: off
  if (!is_empty(by)) stats::t.test(data[[variable]] ~ data[[by]], ...) |> broom::tidy()
  else stats::t.test(data[[variable]], ...) |> broom::tidy()
  # styler: on
  ```

* Section banners inside functions are padded out to column 80. Copy the pattern from any existing `ard_*()` function.

### Dependency management

Lightweight is the right weight. This repository follows [tinyverse](https://www.tinyverse.org/) recommendations of limiting dependencies to a minimum.

In practice this means a hard rule:

> **A statistical package never goes in `Imports`.** It goes in `Suggests`, and the
> function that needs it calls `check_pkg_installed()` first.

The hard `Imports` are deliberately limited to `cards`, `cli`, `dplyr`, `glue`,
`lifecycle`, `rlang`, and `tidyr`. Everything else — `broom`, `survival`, `survey`,
`car`, `emmeans`, `smd`, and so on — lives in `Suggests` and is referenced as
`pkg::fun()`, never imported.

Before adding *any* new dependency, check whether the helper you want already exists
inside the package. `cardx` vendors a set of standalone files that provide much of
`purrr`, `stringr`, `forcats`, and `tibble` without a dependency:

| File | Provides |
| --- | --- |
| `R/import-standalone-check_pkg_installed.R` | `check_pkg_installed()`, `is_pkg_installed()`, `skip_if_pkg_not_installed()` |
| `R/import-standalone-checks.R` | `check_not_missing()`, `check_data_frame()`, `check_class()`, `check_scalar()`, `check_range()`, `check_string()`, and friends |
| `R/import-standalone-cli_call_env.R` | `set_cli_abort_call()`, `get_cli_abort_call()` |
| `R/import-standalone-purrr.R` | `map()`, `map_chr()`, `imap()`, `keep()`, `discard()`, `compact()`, `reduce()`, … |
| `R/import-standalone-stringr.R` | `str_detect()`, `str_replace()`, `str_remove()`, `str_extract()`, … |
| `R/import-standalone-forcats.R` | `fct_relevel()`, `fct_collapse()`, `fct_inorder()`, … |
| `R/import-standalone-tibble.R` | `deframe()`, `enframe()`, `rownames_to_column()`, … |

Call these bare — `map()`, not `purrr::map()`.

⚠️ **Never hand-edit a `R/import-standalone-*.R` file.** Each one is a vendored copy and
carries a `# Standalone file: do not edit by hand` header. Fix the problem in the
upstream repository, then refresh the copy:

```r
usethis::use_standalone("insightsengineering/standalone", "checks")
```

The same applies to `NAMESPACE` and everything in `man/` — both are generated by
`roxygen2`. Run `devtools::document()` instead of editing them.

### Dependency version management

If the code is not compatible with all (!) historical versions of a given dependent package, it is required to specify the minimal version in the `DESCRIPTION` file. In particular: if the development version requires (imports) the development version of another package — it is required to put `abc (>= 1.2.3.9000)`.

### Recommended development environment & tools

#### R & package versions

We continuously test our packages against the newest R version along with the most recent dependencies from CRAN and BioConductor. We recommend that your working environment is also set up in the same way. You can find the details about the R version and packages used in the `R CMD check` GitHub Action execution log — there is a step that prints out the R `sessionInfo()`.

The package supports R >= 4.2, and the `R-CMD-check-oldrel` workflow tests older
releases with only the hard dependencies installed. This is why the
`check_pkg_installed()` / `@examplesIf` / `skip_if_pkg_not_installed()` conventions
below are not optional: they are what allows `R CMD check` to pass on a machine where
`broom` or `survey` simply is not available.

If you discover bugs on older R versions or with an older set of dependencies, please create the relevant bug reports.

## Adding a new ARD function

### 1. Name the function and the file

Name the function `ard_<package>_<function>()`, after the package and function
supplying the statistic:

| Wrapped call | `cardx` function |
| --- | --- |
| `stats::t.test()` | `ard_stats_t_test()` |
| `car::vif()` | `ard_car_vif()` |
| `survey::svyttest()` | `ard_survey_svyttest()` |

Put it in `R/<function_name>.R` — one file per exported function or function family,
named exactly after the function. S3 methods for non-data-frame input put the class in
the file name, e.g. `R/ard_summary.survey.design.R`.

Small internal helpers live at the bottom of the same file, prefixed with a dot and
marked `@keywords internal` (for example `.format_ttest_results()`,
`.df_ttest_stat_labels()`).

### 2. Follow the standard function skeleton

Every exported function in the package has the same skeleton. Here it is, abridged from
[`R/ard_stats_chisq_test.R`](../R/ard_stats_chisq_test.R) — the real file also sets
`stat_label`s, covered in [step 3](#3-get-the-ard-columns-right):

```r
ard_stats_chisq_test <- function(data, by, variables, ...) {
  set_cli_abort_call()

  # check installed packages ---------------------------------------------------
  check_pkg_installed("broom")

  # check/process inputs -------------------------------------------------------
  check_not_missing(data)
  check_not_missing(variables)
  check_not_missing(by)
  check_data_frame(data)
  cards::process_selectors(data, by = {{ by }}, variables = {{ variables }})
  check_scalar(by)

  # return empty ARD if no variables selected ----------------------------------
  if (is_empty(variables)) {
    return(dplyr::tibble() |> cards::as_card(check = FALSE))
  }

  # build ARD ------------------------------------------------------------------
  lapply(
    variables,
    function(variable) {
      cards::tidy_as_ard(
        lst_tidy =
          cards::eval_capture_conditions(
            stats::chisq.test(x = data[[variable]], y = data[[by]], ...) |>
              broom::tidy()
          ),
        tidy_result_names = c("statistic", "p.value", "parameter", "method"),
        fun_args_to_record = c("correct", "p", "rescale.p", "simulate.p.value", "B"),
        formals = formals(stats::chisq.test),
        passed_args = dots_list(...),
        lst_ard_columns = list(group1 = by, variable = variable, context = "stats_chisq_test")
      )
    }
  ) |>
    dplyr::bind_rows() |>
    cards::as_card(check = FALSE)
}
```

The required elements, in order:

1. **`set_cli_abort_call()` is the first line of every exported function.** It makes
   downstream error messages point at the user's call rather than an internal one. Raise
   your own errors with `cli::cli_abort("message", call = get_cli_abort_call())`.
2. **`check_pkg_installed()`** before touching anything from `Suggests`. Pass a vector
   for several: `check_pkg_installed(c("car", "broom.helpers"))`. It reads the minimum
   version from `cardx`'s own `DESCRIPTION`, so declaring the version there is enough.
3. **Input checks**: `check_not_missing()` for each required argument, then
   `check_data_frame()` or `check_class()`, then
   `cards::process_selectors(data, by = {{ by }}, ...)` to resolve tidyselect arguments
   into character vectors in place, then any post-resolution checks such as
   `check_scalar(by)` or `check_range(conf.level, range = c(0, 1))`.
4. **An empty-selection short circuit** returning `dplyr::tibble() |> cards::as_card(check = FALSE)`.
5. **`cards::eval_capture_conditions()` around every statistical call.** Errors and
   warnings must land in the ARD's `error` and `warning` columns, not abort the function.
   If you reshape the data before the call, put the reshape *inside* the
   `eval_capture_conditions()` block too, so its failures are captured as well.
6. **`cards::as_card(check = FALSE)` to apply the `card` class**, followed by
   `cards::tidy_ard_column_order()` (and `cards::tidy_ard_row_order()` where relevant).
   Never set the class by hand with `structure()` or `class<-`.

Argument order is `data`, `variables`, `by`, then function-specific arguments, then
`...` passed on to the wrapped function.

### 3. Get the ARD columns right

The returned object has these columns, in this order:

`group1`, `group1_level` (then `group2`, … as needed), `variable`, `variable_level`,
`context`, `stat_name`, `stat_label`, `stat`, `fmt_fun`, `warning`, `error`.

`stat`, `fmt_fun`, `warning`, and `error` are list-columns.
`cards::tidy_ard_column_order()` puts them in order for you.

* `context` is the function name minus the `ard_` prefix, in snake case: `ard_car_vif()` sets `context = "car_vif"`.
* The formatting column is **`fmt_fun`**. `fmt_fn` is deprecated and only survives as a soft-deprecated argument in a couple of survey methods.
* Supply human-readable `stat_label`s. For more than a few statistics, write a
  `.df_*_stat_labels()` helper returning a `dplyr::tribble()` and left-join it on
  `stat_name`, then fill the gaps:

  ```r
  ret |>
    dplyr::left_join(.df_ttest_stat_labels(by = by), by = "stat_name") |>
    dplyr::mutate(stat_label = dplyr::coalesce(.data$stat_label, .data$stat_name))
  ```

  For a short fixed list, an inline `dplyr::case_when()` on `.data$stat_name` is fine.

### 4. Document it

Roxygen conventions:

* Every `@param` opens with a parenthesized type, then `\cr`, then an indented description:

  ```r
  #' @param data (`data.frame`)\cr
  #'   a data frame.
  #' @param by ([`tidy-select`][dplyr::dplyr_tidy_select])\cr
  #'   column name to compare by.
  #' @param conf.level (scalar `numeric`)\cr
  #'   confidence level for the confidence interval. Default is `0.95`.
  ```

* `@return` for new functions is `an ARD data frame of class 'card'`. Many older files
  say just `ARD data frame`; prefer the fuller wording in new code.
* `@family` is not used in this package — topics are grouped in `_pkgdown.yml` instead.
* When two related functions share a help page, document them in one block ending with
  `@name` and a bare `NULL`, then give each function `@rdname` and `@export`. See
  [`R/ard_stats_t_test.R`](../R/ard_stats_t_test.R).
* **Guard examples that need a suggested package** with `@examplesIf`, listing every
  suggested package the example touches:

  ```r
  #' @examplesIf cardx:::is_pkg_installed("broom")
  #' @examplesIf cardx:::is_pkg_installed(c("survival", "broom", "ggsurvfit"))
  ```

  Use `cards::ADSL`, `cards::ADTTE`, `cards::ADLB`, or `cards::ADAE` as example data.
  Plain `@examples` is only for examples that need nothing beyond `Imports`.

Then run `devtools::document()` and **commit** the regenerated `man/` files and
`NAMESPACE`. The CI `roxygen` job runs with `auto-update: false` and will fail the PR if
they are stale.

### 5. Register the function on the website

Add the new topic to [`_pkgdown.yml`](../_pkgdown.yml) under the matching
`subtitle: "{pkg} package"` block. The pkgdown build **fails** on a documented topic
that is missing from the reference index.

### 6. Documentation and NEWS

Add a bullet to `NEWS.md` under the `# cardx (development version)` heading. House
style is a complete sentence in the past tense, function names in backticks with
trailing parentheses, and the issue or PR number in parentheses at the end — plus the
contributor's handle if they are not a package author:

```md
* Added function `ard_stats_mood_test()` for the Mood two-sample test of scale. (#310, @yourhandle)
```

If your change introduces new jargon, add it to [`inst/WORDLIST`](../inst/WORDLIST); the
CI `spelling` job checks against that file.

## Testing

Tests live in `tests/testthat/test-<function_name>.R`, mirroring `R/` one-to-one. The
suite uses testthat edition 3 and runs in parallel.

**Skips go on the first line of the file, outside `test_that()`**, so the whole file
skips together on a machine without the dependency:

```r
skip_if_pkg_not_installed(c("broom", "car"))

test_that("ard_car_vif() works", {
  ...
})
```

Use `skip_if_pkg_not_installed()` — not `testthat::skip_if_not_installed()`. Add `withr`
to the list if the file calls `withr::local_options()`.

Note that `tests/testthat.R` calls `test_check("cardx", stop_on_warning = TRUE)`, so
**any unexpected warning fails the suite**. Expected warnings must be asserted or
captured.

A test file for a new ARD function is expected to cover four things:

1. **Correctness against the wrapped function.** Compare the extracted statistics to the raw call:

   ```r
   expect_equal(
     ard_chisqtest |> cards::get_ard_statistics(stat_name %in% c("statistic", "p.value")),
     with(cards::ADSL, chisq.test(AGEGR1, ARM)) |>
       broom::tidy() |>
       dplyr::select(statistic, p.value) |>
       unclass(),
     ignore_attr = TRUE
   )
   ```

2. **Additivity across variables** — the result for `variables = c(A, B)` equals `dplyr::bind_rows()` of the two single-variable results.
3. **Conditions are captured, not thrown** — a failing statistical call populates the `error` (or `warning`) column instead of aborting.
4. **ARD structure**, as the last test in the file:

   ```r
   test_that("ard_car_vif() follows ard structure", {
     expect_silent(
       lm(AGE ~ ARM + SEX, data = cards::ADSL) |>
         ard_car_vif() |>
         cards::check_ard_structure(method = FALSE)
     )
   })
   ```

   Pass `method = FALSE` when the ARD has no `method` statistic.

Snapshot tests are used heavily. Snapshot the data frame so individual values are
visible, and pin the console width when the ARD is wide:

```r
withr::local_options(list(width = 250))

expect_snapshot(ard_survival_survfit(...) |> as.data.frame())
```

Review changed snapshots with `testthat::snapshot_review()` and accept them with
`testthat::snapshot_accept()` — do not hand-edit files in `tests/testthat/_snaps/`.

Aim for full coverage of new code (generally 100%). Check with
`devtools::test_coverage()`.

## Before you push

```r
styler::style_pkg()
devtools::document()
devtools::test()
spelling::spell_check_package()
devtools::check()
```

`devtools::check()` is the real gate — it runs the examples, so a missing or wrong
`@examplesIf` guard shows up there.

## Recognition model

As mentioned previously, all contributions are deeply valued and appreciated. While all contribution data is available as part of the [repository insights][insights], to recognize a _significant_ contribution and hence add the contributor to the package authors list, the following rules are enforced:

* Minimum 5% of lines of code authored* (determined by `git blame` query) OR
* Being at the top 5 contributors in terms of number of commits OR lines added OR lines removed*

*Excluding auto-generated code, including but not limited to `roxygen` comments or `renv.lock` files.

The package maintainer also reserves the right to adjust the criteria to recognize contributions.

## Questions

If you have further questions regarding the contribution guidelines, please contact the package/repository maintainer.

<!-- urls -->
[docs]: https://pharmaverse.github.io/cardx/index.html
[license]: https://pharmaverse.github.io/cardx/main/LICENSE-text.html
[insights]: https://github.com/pharmaverse/cardx/pulse
