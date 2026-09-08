skip_if_pkg_not_installed(c("survey", "broom"))

data(api, package = "survey")
dclus2 <- survey::svydesign(id = ~ dnum + snum, fpc = ~ fpc1 + fpc2, data = apiclus2 |> dplyr::slice(1:50))
rclus2 <- suppressWarnings(survey::as.svrepdesign(dclus2))

test_that("ard_survey_svyranktest() works for survey.design objects", {
  svyranktest <- lapply(
    c("wilcoxon", "vanderWaerden", "median", "KruskalWallis"),
    function(x) {
      ard_survey_svyranktest(
        dclus2,
        variable = enroll,
        by = comp.imp,
        test = x
      )
    }
  )

  expect_snapshot(svyranktest[[1]] |> as.data.frame() |> dplyr::select(stat_label, stat))
  expect_snapshot(svyranktest[[2]] |> as.data.frame() |> dplyr::select(stat_label, stat))
  expect_snapshot(svyranktest[[3]] |> as.data.frame() |> dplyr::select(stat_label, stat))
  expect_snapshot(svyranktest[[4]] |> as.data.frame() |> dplyr::select(stat_label, stat))
})

test_that("ard_survey_svyranktest() works for svyrep.design objects", {
  svyranktest <- lapply(
    c("wilcoxon", "vanderWaerden", "median", "KruskalWallis"),
    function(x) {
      ard_survey_svyranktest(
        rclus2,
        variable = enroll,
        by = comp.imp,
        test = x
      )
    }
  )

  expect_snapshot(svyranktest[[1]] |> as.data.frame() |> dplyr::select(stat_label, stat))
  expect_snapshot(svyranktest[[2]] |> as.data.frame() |> dplyr::select(stat_label, stat))
  expect_snapshot(svyranktest[[3]] |> as.data.frame() |> dplyr::select(stat_label, stat))
  expect_snapshot(svyranktest[[4]] |> as.data.frame() |> dplyr::select(stat_label, stat))
})

test_that("exact values match for ard_svyranktest works for survey.design objects", {
  svywilcox <- ard_survey_svyranktest(
    dclus2,
    variable = enroll,
    by = comp.imp,
    test = "wilcoxon"
  )
  expect_equal(
    cards::get_ard_statistics(
      svywilcox,
      stat_name %in% c("estimate", "p.value")
    ),
    survey::svyranktest(enroll ~ comp.imp, dclus2, test = "wilcoxon")[c("estimate", "p.value")],
    ignore_attr = TRUE
  )
})

test_that("exact values match for ard_svyranktest works for svyrep.design objects", {
  svywilcox <- ard_survey_svyranktest(
    rclus2,
    variable = enroll,
    by = comp.imp,
    test = "wilcoxon"
  )
  expect_equal(
    cards::get_ard_statistics(
      svywilcox,
      stat_name %in% c("estimate", "p.value")
    ),
    survey::svyranktest(enroll ~ comp.imp, rclus2, test = "wilcoxon")[c("estimate", "p.value")],
    ignore_attr = TRUE
  )
})

test_that("ard_survey_svyranktest() follows ard structure for survey.design objects", {
  expect_silent(
    ard_survey_svyranktest(
      dclus2,
      variable = enroll,
      by = comp.imp,
      test = "wilcoxon"
    ) |>
      cards::check_ard_structure()
  )
})

test_that("ard_survey_svyranktest() follows ard structure for svyrep.design objects", {
  expect_silent(
    ard_survey_svyranktest(
      rclus2,
      variable = enroll,
      by = comp.imp,
      test = "wilcoxon"
    ) |>
      cards::check_ard_structure()
  )
})
