# gtsummary (2.5.0)

* GitHub: <https://github.com/ddsjoberg/gtsummary>
* Email: <mailto:danield.sjoberg@gmail.com>
* GitHub mirror: <https://github.com/cran/gtsummary>

Run `revdepcheck::revdep_details(, "gtsummary")` for more info

## Newly broken

*   R CMD check timed out


## Newly fixed

*   checking tests ...
     ```
       Running ‘spelling.R’
       Comparing ‘spelling.Rout’ to ‘spelling.Rout.save’ ... OK
       Running ‘testthat.R’
      ERROR
     Running the tests in ‘tests/testthat.R’ failed.
     Last 13 lines of output:
        36.             └─cards::check_ard_structure(...)
        37.               └─cards:::.message_or_error(...)
        38.                 └─cli::cli_abort(msg, call = call, .envir = envir)
        39.                   └─rlang::abort(...)
       
       ── Snapshots ───────────────────────────────────────────────────────────────────
       To review and process snapshots locally:
       * Locate check directory.
       * Copy 'tests/testthat/_snaps' to local package.
       * Run `testthat::snapshot_accept()` to accept all changes.
       * Run `testthat::snapshot_review()` to review all changes.
       [ FAIL 124 | WARN 17 | SKIP 0 | PASS 1669 ]
       Error:
       ! Test failures.
       Execution halted
     ```

## In both

*   checking examples ... ERROR
     ```
     ...
     > ADAE_subset <- dplyr::filter(dplyr::filter(cards::ADAE, AEBODSYS %in% 
     +     c("SKIN AND SUBCUTANEOUS TISSUE DISORDERS", "EAR AND LABYRINTH DISORDERS")), 
     +     .by = AEBODSYS, dplyr::row_number() < 20)
     > tbl <- tbl_hierarchical(data = ADAE_subset, variables = c(AEBODSYS, AEDECOD), 
     +     by = TRTA, denominator = cards::ADSL, id = USUBJID, overall_row = TRUE)
     > filter_hierarchical(tbl, sum(n) < 2)
     Error in `filter_hierarchical()`:
     ! The following columns are not present: "stat_name", "stat_label",
       "stat", "fmt_fun", "warning", and "error".
     Backtrace:
          ▆
       1. ├─base::withAutoprint(...)
       2. │ └─base::source(...)
       3. │   ├─base::withVisible(eval(ei, envir))
       4. │   └─base::eval(ei, envir)
       5. │     └─base::eval(ei, envir)
       6. ├─gtsummary::filter_hierarchical(tbl, sum(n) < 2)
       7. └─gtsummary:::filter_hierarchical.tbl_hierarchical(...)
       8.   └─gtsummary:::.reshape_ard_compare(x, x_ard, ard_args)
       9.     └─cards::as_card(dplyr::mutate(dplyr::group_keys(x_ard), pre_idx = dplyr::row_number()))
      10.       └─cards::check_ard_structure(...)
      11.         └─cards:::.message_or_error(...)
      12.           └─cli::cli_abort(msg, call = call, .envir = envir)
      13.             └─rlang::abort(...)
     Execution halted
     ```

