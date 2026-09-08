skip_if_pkg_not_installed("survey")

test_that("ard_total_n.survey.design() works", {
  expect_snapshot(
    survey::svydesign(~1, data = as.data.frame(Titanic), weights = ~Freq) |>
      ard_total_n()
  )
})

test_that("ard_total_n.svyrep.design() works", {
  rsvy_titanic <- survey::svydesign(~1, data = as.data.frame(Titanic), weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  expect_snapshot(
    rsvy_titanic |>
      ard_total_n()
  )
})

test_that("ard_total_n.survey.design() follows ard structure", {
  expect_silent(
    survey::svydesign(~1, data = as.data.frame(Titanic), weights = ~Freq) |>
      ard_total_n() |>
      cards::check_ard_structure(method = FALSE)
  )
})

test_that("ard_total_n.svyrep.design() follows ard structure", {
  rsvy_titanic <- survey::svydesign(~1, data = as.data.frame(Titanic), weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  expect_silent(
    rsvy_titanic |>
      ard_total_n() |>
      cards::check_ard_structure(method = FALSE)
  )
})

# test for https://stackoverflow.com/questions/79673577
test_that("ard_total_n.survey.design() using `update()`", {
  database <- data.frame(
    INDIV_AGE = rnorm(100, mean = 50, sd = 4),
    INDIV_GENDER = rbinom(n = 100, size = 1, prob = 0.6),
    PAIN_SCALE = factor(sample(c("Low", "Elevated"), size = 100, replace = T)),
    FLOWER_COLOR = factor(sample(c("Blue", "Red"), size = 100, replace = T)),
    poids = rnorm(100, mean = 2, sd = 0.8)
  )
  database[1, "INDIV_GENDER"] <- NA

  expect_silent(
    survey::svydesign(
      id = ~1,
      weights = ~poids,
      data = database
    ) |>
      subset(!is.na(INDIV_GENDER)) |>
      ard_total_n()
  )
})

# test for https://stackoverflow.com/questions/79673577
test_that("ard_total_n.svyrep.design() using `update()`", {
  database <- data.frame(
    INDIV_AGE = rnorm(100, mean = 50, sd = 4),
    INDIV_GENDER = rbinom(n = 100, size = 1, prob = 0.6),
    PAIN_SCALE = factor(sample(c("Low", "Elevated"), size = 100, replace = T)),
    FLOWER_COLOR = factor(sample(c("Blue", "Red"), size = 100, replace = T)),
    poids = rnorm(100, mean = 2, sd = 0.8)
  )
  database[1, "INDIV_GENDER"] <- NA

  rsvy_database <- survey::svydesign(
    id = ~1,
    weights = ~poids,
    data = database
  ) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  expect_silent(
    rsvy_database |>
      subset(!is.na(INDIV_GENDER)) |>
      ard_total_n()
  )
})

test_that("ard_total_n() errors are reported against the generic", {
  # the `svyrep.design` method delegates to the `survey.design` method; the
  # error must still name the generic, not the method delegated to
  reported_fn <- function(expr) {
    tryCatch(expr, error = function(e) as.character(conditionCall(e)[[1]]))
  }
  dclus1 <- survey::svydesign(~1, data = as.data.frame(Titanic), weights = ~Freq)
  rclus1 <- suppressWarnings(survey::as.svrepdesign(dclus1))

  expect_equal(reported_fn(ard_total_n(dclus1, bogus = 1)), "ard_total_n")
  expect_equal(reported_fn(ard_total_n(rclus1, bogus = 1)), "ard_total_n")
})
