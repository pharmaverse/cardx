**What changes are proposed in this pull request?**
* Style this entry in a way that can be copied directly into `NEWS.md`. (#<issue number>, @<username>)

Provide more detail here as needed.

**Reference GitHub issue associated with pull request.** _e.g., 'closes #<issue number>'_


--------------------------------------------------------------------------------

Pre-review Checklist (if item does not apply, mark is as complete)
- [ ] **All** GitHub Action workflows pass with a :white_check_mark:
- [ ] PR branch has pulled the most recent updates from master branch: `usethis::pr_merge_main()`
- [ ] If a bug was fixed, a unit test was added.
- [ ] If a new `ard_*()` function was added, it passes the ARD structural checks from `cards::check_ard_structure()`.
- [ ] If a new `ard_*()` function was added, `set_cli_abort_call()` has been set.
- [ ] If a new `ard_*()` function was added and it depends on another package (such as, `broom`), the package has been added to `Suggests` in `DESCRIPTION`, `check_pkg_installed("broom")` has been set in the function call, and the following added to the roxygen comments: `@examplesIf cardx:::is_pkg_installed("broom")`
- [ ] If a new `ard_*()` function was added, the topic has been added to `_pkgdown.yml` and `devtools::document()` was run and the updated `man/` and `NAMESPACE` files committed.
- [ ] Code coverage is suitable for any new functions/features (generally, 100% coverage for new code): `devtools::test_coverage()`

Reviewer Checklist (if item does not apply, mark is as complete)

- [ ] If a bug was fixed, a unit test was added.
- [ ] Code coverage is suitable for any new functions/features: `devtools::test_coverage()`

When the branch is ready to be merged:
- [ ] Update `NEWS.md` with the changes from this pull request under the heading "`# cardx (development version)`". If there is an issue associated with the pull request, reference it in parentheses at the end update (see `NEWS.md` for examples).
- [ ] **All** GitHub Action workflows pass with a :white_check_mark:
- [ ] Approve Pull Request
- [ ] Merge the PR. Please use "Squash and merge" or "Rebase and merge".
