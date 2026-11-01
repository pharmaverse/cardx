skip_if_pkg_not_installed("broom")

test_that("ard_stats_mantelhaen_test() works", {
  expect_silent(
    ard_mantelhaentest <- cards::ADSL |>
      ard_stats_mantelhaen_test(by = ARM, variables = AGEGR1, strata = SEX)
  )

  # `two.sided.method` was added to `mantelhaen.test()` in R-devel
  expect_setequal(
    ard_mantelhaentest$stat_name,
    c(
      "statistic", "p.value", "parameter", "method", "alternative", "correct", "exact", "conf.level",
      if ("two.sided.method" %in% names(formals(stats::mantelhaen.test))) "two.sided.method"
    )
  )
  expect_true(all(ard_mantelhaentest$context == "stats_mantelhaen_test"))
  expect_true(all(ard_mantelhaentest$group1 == "ARM"))
  expect_true(all(ard_mantelhaentest$group2 == "SEX"))
  expect_true(all(ard_mantelhaentest$variable == "AGEGR1"))

  expect_equal(
    ard_mantelhaentest |>
      cards::get_ard_statistics(stat_name %in% c("statistic", "p.value", "parameter", "method")),
    with(cards::ADSL, mantelhaen.test(AGEGR1, ARM, SEX)) |>
      broom::tidy() |>
      dplyr::select(statistic, p.value, parameter, method) |>
      unclass(),
    ignore_attr = TRUE
  )
  expect_equal(
    ard_mantelhaentest |>
      cards::get_ard_statistics(stat_name %in% c("alternative", "correct", "exact", "conf.level")),
    list(alternative = "two.sided", correct = TRUE, exact = FALSE, conf.level = 0.95)
  )
  expect_equal(
    ard_mantelhaentest |>
      dplyr::filter(stat_name %in% c("statistic", "correct", "conf.level")) |>
      dplyr::select(stat_name, stat_label) |>
      deframe() |>
      as.list(),
    list(
      statistic = "Generalized Cochran-Mantel-Haenszel Statistic",
      correct = "Continuity Correction",
      conf.level = "CI Confidence Level"
    )
  )

  # custom arguments to stats::mantelhaen.test()
  expect_silent(
    ard_mantelhaentest <- cards::ADSL |>
      ard_stats_mantelhaen_test(
        by = ARM, variable = AGEGR1, strata = SEX,
        alternative = "less", correct = FALSE, exact = TRUE, conf.level = 0.90
      )
  )

  expect_equal(
    ard_mantelhaentest |>
      cards::get_ard_statistics(stat_name %in% c("statistic", "p.value", "parameter")),
    with(
      cards::ADSL,
      mantelhaen.test(AGEGR1, ARM, SEX, alternative = "less", correct = FALSE, exact = TRUE, conf.level = 0.90)
    ) |>
      broom::tidy() |>
      dplyr::select(statistic, p.value, parameter) |>
      unclass(),
    ignore_attr = TRUE
  )
  expect_equal(
    ard_mantelhaentest |>
      cards::get_ard_statistics(stat_name %in% c("alternative", "correct", "exact", "conf.level")),
    list(alternative = "less", correct = FALSE, exact = TRUE, conf.level = 0.90)
  )
  expect_equal(
    ard_mantelhaentest |>
      dplyr::filter(stat_name == "statistic") |>
      dplyr::pull(stat_label),
    "Mantel-Haenszel X-squared Statistic"
  )
})

test_that("ard_stats_mantelhaen_test() displays errors correctly", {
  data <- cards::ADSL |>
    dplyr::mutate(ARM = "ARM A")

  expect_silent(
    ard_mantelhaentest <- data |>
      ard_stats_mantelhaen_test(by = ARM, variables = AGEGR1, strata = SEX)
  )
  expect_equal(nrow(ard_mantelhaentest), 9)
  expect_equal(ard_mantelhaentest$error, as.list(rep("'x' and 'y' must have at least 2 levels", 9)))
})

test_that("ard_stats_mantelhaen_test() follows ard structure", {
  expect_silent(
    cards::ADSL |>
      ard_stats_mantelhaen_test(by = ARM, variables = AGEGR1, strata = SEX) |>
      cards::check_ard_structure()
  )
})
