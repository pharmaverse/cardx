skip_if_pkg_not_installed("smd")

test_that("ard_smd_smd() works", {
  expect_error(
    ard_smd <-
      mtcars |>
      ard_smd_smd(by = vs, variables = am, std.error = TRUE),
    NA
  )

  expect_equal(
    ard_smd |>
      cards::get_ard_statistics(stat_name %in% c("estimate", "std.error")),
    smd::smd(x = mtcars$am, g = mtcars$vs, std.error = TRUE) |>
      dplyr::select(-term) |>
      unclass(),
    ignore_attr = TRUE
  )

  # test that the function works with multiple variables at once
  expect_equal(
    dplyr::bind_rows(
      ard_smd,
      mtcars |>
        ard_smd_smd(by = vs, variables = gear, std.error = TRUE)
    ),
    mtcars |>
      ard_smd_smd(by = vs, variables = c(am, gear), std.error = TRUE)
  )
})

test_that("ard_smd() works with survey data", {
  skip_if_pkg_not_installed("survey")

  data(api, package = "survey")
  dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)

  expect_error(
    ard_smd <-
      dclus1 |>
      ard_smd_smd(by = both, variable = api00, std.error = TRUE) |>
      suppressMessages(),
    NA
  )

  expect_equal(
    ard_smd |>
      cards::get_ard_statistics(stat_name %in% c("estimate", "std.error")),
    smd::smd(x = apiclus1$api00, g = apiclus1$both, w = weights(dclus1), std.error = TRUE) |>
      dplyr::select(-term) |>
      unclass(),
    ignore_attr = TRUE
  )
})

test_that("ard_smd() works with survey replicate data", {
  skip_if_pkg_not_installed("survey")

  data(api, package = "survey")
  dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
  rclus1 <- survey::as.svrepdesign(dclus1)

  expect_error(
    ard_smd <-
      rclus1 |>
      ard_smd_smd(by = both, variable = api00, std.error = TRUE) |>
      suppressMessages(),
    NA
  )

  expect_equal(
    ard_smd |>
      cards::get_ard_statistics(stat_name %in% c("estimate", "std.error")),
    smd::smd(
      x = apiclus1$api00,
      g = apiclus1$both,
      w = weights(rclus1, type = "sampling"),
      std.error = TRUE
    ) |>
      dplyr::select(-term) |>
      unclass(),
    ignore_attr = TRUE
  )

  # the SMD is a function of the sampling weights only, so the replicate
  # design returns the same results as the design it was created from
  expect_equal(
    ard_smd,
    dclus1 |>
      ard_smd_smd(by = both, variable = api00, std.error = TRUE) |>
      suppressMessages()
  )
})

test_that("ard_smd() works for designs built with survey::svrepdesign()", {
  skip_if_pkg_not_installed("survey")

  data(api, package = "survey")
  dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
  rclus1 <- survey::as.svrepdesign(dclus1)

  # rebuild the design the way a replicate-weight data set arrives: the
  # replicate weights supplied directly, with the sampling weights separate
  rep_api <- survey::svrepdesign(
    data = apiclus1,
    weights = ~pw,
    repweights = weights(rclus1, type = "replication") |> as.matrix(),
    type = "other",
    scale = rclus1$scale,
    rscales = rclus1$rscales,
    combined.weights = FALSE
  )

  expect_error(
    ard_smd <-
      rep_api |>
      ard_smd_smd(by = both, variable = api00, std.error = TRUE) |>
      suppressMessages(),
    NA
  )

  # `smd::smd()` never sees the replicate weights, so the result must come from
  # the sampling weights passed to `weights=`
  expect_equal(
    ard_smd |>
      cards::get_ard_statistics(stat_name %in% c("estimate", "std.error")),
    smd::smd(x = apiclus1$api00, g = apiclus1$both, w = apiclus1$pw, std.error = TRUE) |>
      dplyr::select(-term) |>
      unclass(),
    ignore_attr = TRUE
  )

  # and therefore agrees with the same design expressed as a linearized design
  expect_equal(
    ard_smd,
    dclus1 |>
      ard_smd_smd(by = both, variable = api00, std.error = TRUE) |>
      suppressMessages()
  )
})

test_that("ard_smd_smd() cautions that the survey design is not used", {
  skip_if_pkg_not_installed("survey")

  data(api, package = "survey")
  dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
  rclus1 <- survey::as.svrepdesign(dclus1)

  # `survey.design`, with standard errors -- the CI and SE are calculated from
  # the weights alone, so the caution applies
  expect_message(
    ard_smd_smd(dclus1, by = both, variables = api00, std.error = TRUE),
    "the confidence interval and standard error calculation do not take into account the survey design, only the weights.",
    fixed = TRUE
  )

  # `svyrep.design` is cautioned about identically -- the replicate weights are
  # no more used than the design structure is
  expect_message(
    ard_smd_smd(rclus1, by = both, variables = api00, std.error = TRUE),
    "the confidence interval and standard error calculation do not take into account the survey design, only the weights.",
    fixed = TRUE
  )

  # the caution is emitted once per call, not once per variable
  expect_length(
    capture_messages(
      ard_smd_smd(rclus1, by = both, variables = c(api00, api99), std.error = TRUE)
    ),
    1L
  )

  # with `std.error = FALSE` neither a CI nor an SE is returned, and the
  # estimate is properly weighted, so there is nothing to caution about
  expect_no_message(
    ard_smd_smd(dclus1, by = both, variables = api00, std.error = FALSE)
  )
  expect_no_message(
    ard_smd_smd(rclus1, by = both, variables = api00, std.error = FALSE)
  )
  expect_setequal(
    ard_smd_smd(dclus1, by = both, variables = api00, std.error = FALSE)$stat_name,
    c("estimate", "method", "gref")
  )

  # a data frame carries no design to disregard, so nothing is emitted
  expect_no_message(
    ard_smd_smd(mtcars, by = vs, variables = am, std.error = TRUE)
  )
  expect_no_message(
    ard_smd_smd(mtcars, by = vs, variables = am, std.error = FALSE)
  )
})

test_that("ard_smd_smd() error messaging", {
  # mis-specify the gref argument
  expect_error(
    bad_gref <-
      ard_smd_smd(cards::ADSL, by = SEX, variables = AGE, std.error = TRUE, gref = 0) |>
      as.data.frame(),
    NA
  )
  # check all the stats still appear despite the errors
  expect_equal(nrow(bad_gref), 3L)
  expect_setequal(bad_gref$stat_name, c("estimate", "std.error", "gref"))
  # check the error message it the one we expect
  expect_equal(
    bad_gref$error |> unique() |> cli::ansi_strip(),
    "gref must be an integer within 2"
  )
})

test_that("ard_smd_smd() follows ard structure", {
  expect_silent(
    mtcars |>
      ard_smd_smd(by = vs, variables = am, std.error = TRUE) |>
      cards::check_ard_structure()
  )
})
