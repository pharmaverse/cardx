skip_if_pkg_not_installed(c("car", "broom.helpers"))

test_that("ard_car_vif() works", {
  expect_snapshot(
    lm(AGE ~ ARM + SEX, data = cards::ADSL) |>
      ard_car_vif() |>
      as.data.frame()
  )

  expect_snapshot(
    lm(AGE ~ BMIBL + EDUCLVL, data = cards::ADSL) |>
      ard_car_vif() |>
      as.data.frame()
  )
})

test_that("ard_car_vif() works with non-syntactic predictor names", {
  df <- cards::ADSL
  names(df)[names(df) == "BMIBL"] <- "BMI Baseline"

  expect_snapshot(
    lm(AGE ~ `BMI Baseline` + EDUCLVL, data = df) |>
      ard_car_vif() |>
      as.data.frame()
  )
})

test_that("ard_car_vif() works with non-syntactic interaction-only terms", {
  df <- cards::ADSL
  names(df)[names(df) == "BMIBL"] <- "BMI Baseline"

  expect_snapshot(
    lm(AGE ~ ARM + `BMI Baseline`:SEX, data = df) |>
      ard_car_vif() |>
      as.data.frame()
  )
})

test_that("ard_car_vif() appropriate errors are given for model with only 1 term", {
  expect_equal(
    lm(AGE ~ ARM, data = cards::ADSL) |>
      ard_car_vif() |>
      dplyr::select(error) %>%
      is.null(),
    FALSE
  )
})


test_that("ard_vif() issues friendly messaging for incorrect object passed in/can't get terms of model", {
  expect_snapshot(
    error = TRUE,
    cards::ADSL |> ard_car_vif()
  )
})

test_that("ard_car_vif() follows ard structure", {
  expect_silent(
    lm(AGE ~ ARM + SEX, data = cards::ADSL) |>
      ard_car_vif() |>
      cards::check_ard_structure(method = FALSE)
  )
})
