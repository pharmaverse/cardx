# NA

**What changes are proposed in this pull request?** \* Style this entry
in a way that can be copied directly into `NEWS.md`. (#, @)

Provide more detail here as needed.

**Reference GitHub issue associated with pull request.** *e.g., ‘closes
\#’*

------------------------------------------------------------------------

Pre-review Checklist (if item does not apply, mark is as complete) - \[
\] **All** GitHub Action workflows pass with a ✅ - \[ \] PR branch has
pulled the most recent updates from master branch:
[`usethis::pr_merge_main()`](https://usethis.r-lib.org/reference/pull-requests.html) -
\[ \] If a bug was fixed, a unit test was added. - \[ \] If a new
`ard_*()` function was added, it passes the ARD structural checks from
[`cards::check_ard_structure()`](https://insightsengineering.github.io/cards/latest-tag/reference/check_ard_structure.html). -
\[ \] If a new `ard_*()` function was added, `set_cli_abort_call()` has
been set. - \[ \] If a new `ard_*()` function was added and it depends
on another package (such as, `broom`), `is_pkg_installed("broom")` has
been set in the function call and the following added to the roxygen
comments:
`@examplesIf do.call(asNamespace("cardx")$is_pkg_installed, list(pkg = "broom""))` -
\[ \] Code coverage is suitable for any new functions/features
(generally, 100% coverage for new code):
[`devtools::test_coverage()`](https://devtools.r-lib.org/reference/test.html)

Reviewer Checklist (if item does not apply, mark is as complete)

If a bug was fixed, a unit test was added.

Code coverage is suitable for any new functions/features:
[`devtools::test_coverage()`](https://devtools.r-lib.org/reference/test.html)

When the branch is ready to be merged: - \[ \] Update `NEWS.md` with the
changes from this pull request under the heading
“`# cardx (development version)`”. If there is an issue associated with
the pull request, reference it in parentheses at the end update (see
`NEWS.md` for examples). - \[ \] **All** GitHub Action workflows pass
with a ✅ - \[ \] Approve Pull Request - \[ \] Merge the PR. Please use
“Squash and merge” or “Rebase and merge”.
