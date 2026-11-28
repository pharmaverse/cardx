# cifmodeling (1.2.4)

* GitHub: <https://github.com/gestimation/cifmodeling>
* Email: <mailto:gestimation@gmail.com>
* GitHub mirror: <https://github.com/cran/cifmodeling>

Run `revdepcheck::revdep_details(, "cifmodeling")` for more info

## In both

*   R CMD check timed out


# crane (0.3.2)

* GitHub: <https://github.com/insightsengineering/crane>
* Email: <mailto:joe.zhu@roche.com>
* GitHub mirror: <https://github.com/cran/crane>

Run `revdepcheck::revdep_details(, "crane")` for more info

## In both

*   checking tests ...
     ```
       Running 'testthat.R'
      ERROR
     Running the tests in 'tests/testthat.R' failed.
     Last 13 lines of output:
       +   7 2         time    X1      2        "list(\"2~ 1          5.0        "list(\"3~
       and 1 more ...
       * Run `testthat::snapshot_accept("tbl_roche_subgroups", "testthat")` to accept the change.
       * Run `testthat::snapshot_review("tbl_roche_subgroups", "testthat")` to review the change.
       
       ── Snapshots ───────────────────────────────────────────────────────────────────
       To review and process snapshots locally:
       * Locate check directory.
       * Copy 'tests/testthat/_snaps' to local package.
       * Run `testthat::snapshot_accept()` to accept all changes.
       * Run `testthat::snapshot_review()` to review all changes.
       [ FAIL 2 | WARN 0 | SKIP 0 | PASS 722 ]
       Error:
       ! Test failures.
       Execution halted
     ```

*   R CMD check timed out


# smdi (0.3.3)

* GitHub: <https://github.com/janickweberpals/smdi>
* Email: <mailto:janick.developer@gmail.com>
* GitHub mirror: <https://github.com/cran/smdi>

Run `revdepcheck::revdep_details(, "smdi")` for more info

## In both

*   checking running R code from vignettes ...
     ```
     ...
     Errors in running code in vignettes:
     when running code in 'a_data_generation.Rmd'
       ...
       restarting interrupted promise evaluation
     
       When sourcing 'a_data_generation.R':
     Error: ! Could not evaluate cli `{}` expression: `project_name()`.
     Caused by error in `proj_set(".")`:
     ! ✖ Path
       'C:/Users/DanielSjoberg/AppData/Local/Temp/RtmpycGbAA/filea02c190f7f46/vignettes/'
       does not appear to be inside a project or package.
     ℹ Read more in the help for `usethis::proj_get()`.
     Execution halted
     when running code in 'b_routine_diagnostics.Rmd'
       ...
     > library(here)
     here() starts at C:/Users/DanielSjoberg/AppData/Local/Temp/RtmpqsbzvV/file7b582dd339ed/vignettes
     
     > library(knitr)
     
     > include_graphics(here("vignettes", "smdi_diagnose_table.png"))
     
       When sourcing 'b_routine_diagnostics.R':
     Error: Cannot find the file(s): "C:/Users/DanielSjoberg/AppData/Local/Temp/RtmpqsbzvV/file7b582dd339ed/vignettes/vignettes/smdi_diagnose_table.png"
     Execution halted
     ```

*   R CMD check timed out


# summarySCI (1.0.0)

* GitHub: <https://github.com/SAKK-Statistics/summarySCI>
* Email: <mailto:Charlotte.Micheloud@swisscancerinstitute.ch>
* GitHub mirror: <https://github.com/cran/summarySCI>

Run `revdepcheck::revdep_details(, "summarySCI")` for more info

## In both

*   R CMD check timed out


