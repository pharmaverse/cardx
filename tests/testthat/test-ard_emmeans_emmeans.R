skip_if_pkg_not_installed(c("emmeans", "survey", "lme4"))

test_that("ard_emmeans_emmeans() works", {
  withr::local_options(width = 250)

  expect_silent(
    ard_emmeans_emmeans <-
      ard_emmeans_emmeans(
        data = mtcars,
        formula = vs ~ am + mpg,
        method = "glm",
        method.args = list(family = binomial),
        response_type = "dichotomous"
      )
  )
  expect_snapshot(ard_emmeans_emmeans |> print(columns = "all"))

  expect_equal(
    cards::get_ard_statistics(ard_emmeans_emmeans, stat_name %in% "method")[1],
    list(method = "Least-squares means")
  )
  expect_equal(
    cards::get_ard_statistics(ard_emmeans_emmeans, stat_name %in% "estimate") |>
      unlist() |>
      unname(),
    glm(vs ~ am + mpg, data = mtcars, family = binomial) |>
      emmeans::emmeans(specs = ~am, regrid = "response") |>
      summary(infer = TRUE) |>
      getElement("prob")
  )

  expect_silent(
    ard_emmeans_emmeans_lme4 <-
      ard_emmeans_emmeans(
        data = mtcars,
        formula = vs ~ am + (1 | cyl),
        method = "glmer",
        method.args = list(family = binomial),
        package = "lme4",
        response_type = "dichotomous"
      )
  )
  expect_equal(
    cards::get_ard_statistics(ard_emmeans_emmeans_lme4, stat_name %in% "method")[1],
    list(method = "Least-squares means")
  )
  expect_equal(
    cards::get_ard_statistics(ard_emmeans_emmeans_lme4, stat_name %in% "estimate") |>
      unlist() |>
      unname(),
    lme4::glmer(vs ~ am + (1 | cyl), data = mtcars, family = binomial) |>
      emmeans::emmeans(specs = ~am, regrid = "response") |>
      summary(infer = TRUE) |>
      getElement("prob")
  )

  #styler: off
  data(api, package = "survey")
  dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1 |> dplyr::slice(1:50), fpc = ~fpc)
  expect_silent({
    ard_emmeans_emmeans_svy <-
      dclus1 |>
      ard_emmeans_emmeans(
        formula = api00 ~ sch.wide,
        method = "svyglm",
        package = "survey"
      )}
  )
  # styler: on
  expect_equal(
    cards::get_ard_statistics(ard_emmeans_emmeans_svy, stat_name %in% "estimate") |>
      unlist() |>
      unname(),
    survey::svyglm(api00 ~ sch.wide, design = dclus1) |>
      emmeans::emmeans(specs = ~sch.wide, regrid = "response") |>
      summary(infer = TRUE) |>
      getElement("emmean")
  )

  rclus1 <- survey::as.svrepdesign(dclus1)
  expect_silent({
    ard_emmeans_emmeans_svy <-
      rclus1 |>
      ard_emmeans_emmeans(
        formula = api00 ~ sch.wide,
        method = "svyglm",
        package = "survey"
      )
  })
  # styler: on
  expect_equal(
    cards::get_ard_statistics(ard_emmeans_emmeans_svy, stat_name %in% "estimate") |>
      unlist() |>
      unname(),
    # `data` is passed explicitly here: a `svyglm()` fit on a replicate design is
    # of class 'svrepglm' and is built inside survey, so the environment on its
    # terms is a survey frame. `emmeans:::recover_data.svyglm()` re-evaluates
    # `object$call$design` in that environment, where `rclus1` is not visible.
    survey::svyglm(api00 ~ sch.wide, design = rclus1) |>
      emmeans::emmeans(specs = ~sch.wide, regrid = "response", data = apiclus1) |>
      summary(infer = TRUE) |>
      getElement("emmean")
  )
})

test_that("ard_emmeans_emmeans() follows ard structure", {
  expect_silent(
    ard_emmeans_emmeans(
      data = mtcars,
      formula = vs ~ am + mpg,
      method = "glm",
      method.args = list(family = binomial),
      response_type = "dichotomous"
    ) |>
      cards::check_ard_structure()
  )
})

test_that("ard_emmeans_emmeans() errors are returned correctly", {
  withr::local_options(width = 250)

  expect_silent(
    ard <- ard_emmeans_emmeans(
      data = mtcars,
      formula = vs ~ am + mpg,
      method = "glm",
      method.args = list(family = nothing),
      response_type = "dichotomous"
    )
  )

  expect_snapshot(ard |> print(columns = "all"))

  expect_length(unique(ard$error), 1)
  expect_snapshot_value(ard$error[[1]])
})
