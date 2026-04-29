skip_if_pkg_not_installed(c("survival", "broom"))

test_that("ard_survival_survfit() works with times provided", {
  withr::local_options(width = 250)

  expect_snapshot(
    survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
      ard_survival_survfit(times = c(60, 180)) |>
      dplyr::mutate(
        stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))
      ) |>
      print(n = Inf)
  )
})

test_that("ard_survival_survfit() works with different type", {
  withr::local_options(width = 250)

  expect_snapshot(
    survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
      ard_survival_survfit(times = c(60, 180), type = "risk") |>
      dplyr::mutate(
        stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))
      ) |>
      print(n = Inf)
  )
})

test_that("ard_survival_survfit() works with probs provided", {
  withr::local_options(width = 250)

  expect_snapshot(
    survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
      ard_survival_survfit(probs = c(0.25, 0.75)) |>
      dplyr::mutate(
        stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))
      ) |>
      print(n = Inf)
  )
})

test_that("ard_survival_survfit() works with unstratified model", {
  withr::local_options(width = 250)

  expect_snapshot(
    survival::survfit(survival::Surv(time, status) ~ 1, data = survival::lung) |>
      ard_survival_survfit(times = c(60, 180)) |>
      dplyr::mutate(
        stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))
      ) |>
      print(n = Inf)
  )

  expect_snapshot(
    survival::survfit(survival::Surv(time, status) ~ 1, data = survival::lung) |>
      ard_survival_survfit(probs = c(0.5, 0.75)) |>
      dplyr::mutate(
        stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))
      ) |>
      print(n = Inf)
  )
})

test_that("ard_survival_survfit() works with multiple stratification variables", {
  withr::local_options(width = 250)

  expect_snapshot(
    survival::survfit(survival::Surv(time, status) ~ sex + ph.ecog, data = survival::lung) |>
      ard_survival_survfit(times = c(60, 180)) |>
      dplyr::mutate(
        stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))
      ) |>
      dplyr::select("group1", "group1_level", "group2", "group2_level") |>
      head(20) |>
      print(n = Inf)
  )

  expect_snapshot(
    survival::survfit(survival::Surv(time, status) ~ sex + ph.ecog, data = survival::lung) |>
      ard_survival_survfit(probs = c(0.5, 0.75)) |>
      dplyr::mutate(
        stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))
      ) |>
      dplyr::select("group1", "group1_level", "group2", "group2_level") |>
      head(20) |>
      print(n = Inf)
  )
})

test_that("ard_survival_survfit() works with competing risks", {
  withr::local_options(width = 250)

  set.seed(1)
  ADTTE_MS <- cards::ADTTE %>%
    dplyr::mutate(
      CNSR = dplyr::case_when(
        CNSR == 0 ~ "censor",
        runif(dplyr::n()) < 0.5 ~ "death from cancer",
        TRUE ~ "death other causes"
      ) %>% factor()
    )

  expect_snapshot(
    survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, data = ADTTE_MS) %>%
      ard_survival_survfit(times = c(60, 180)) |>
      dplyr::mutate(
        stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))
      ) |>
      print(n = Inf)
  )

  # error when type is specified
  expect_snapshot(
    survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, data = ADTTE_MS) %>%
      ard_survival_survfit(times = c(60, 180), type = "risk"),
    error = TRUE
  )
})

test_that("ard_survival_survfit() errors are properly handled", {
  formula <- survival::Surv(mpg, am) ~ cyl
  x <- survival::survfit(formula, data = mtcars)
  expect_snapshot(
    ard_survival_survfit(x, times = 25),
    error = TRUE
  )

  expect_snapshot(
    ard_survival_survfit(times = 25),
    error = TRUE
  )

  expect_snapshot(
    ard_survival_survfit("not_survfit"),
    error = TRUE
  )

  expect_snapshot(
    survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
      ard_survival_survfit(times = 100, type = "notatype"),
    error = TRUE
  )

  expect_snapshot(
    survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
      ard_survival_survfit(probs = c(0.25, 0.75), type = "risk"),
    error = TRUE
  )

  expect_snapshot(
    survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
      ard_survival_survfit(times = 100, probs = c(0.25, 0.75)),
    error = TRUE
  )

  expect_snapshot(
    survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
      ard_survival_survfit(times = 100, summary.args = list(extend = "notatype")),
    error = TRUE
  )


  expect_snapshot(
    ard_survival_survfit(
      x = cards::ADTTE,
      formula = survival::Surv(ttdeath, death) ~ trt,
      variables = "trt",
      probs = c(0.25, 0.50, 0.75)
    ),
    error = TRUE
  )

  expect_snapshot(
    ard_survival_survfit(
      x = cards::ADTTE,
      y = survival::Surv(ttdeath, death) ~ tte,
      probs = c(0.25, 0.50, 0.75)
    ),
    error = TRUE
  )
})

test_that("ard_survival_survfit() works with non-syntactic names", {
  expect_equal(
    survival::survfit(survival::Surv(time, status) ~ factor(sex) + `ph.ecog`, data = survival::lung) |>
      ard_survival_survfit(times = c(60, 180)) |>
      dplyr::mutate(
        stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))
      ),
    survival::survfit(survival::Surv(time, status) ~ sex + ph.ecog, data = survival::lung) |>
      ard_survival_survfit(times = c(60, 180)) |>
      dplyr::mutate(
        stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))
      )
  )
})

test_that("ard_survival_survfit() errors with stratified Cox model", {
  withr::local_namespace("survival")
  expect_snapshot(
    error = TRUE,
    coxph(Surv(time, status) ~ age + strata(sex), survival::lung) |>
      survfit() |>
      ard_survival_survfit()
  )
})

test_that("ard_survival_survfit() works with '=' in strata variable level labels", {
  withr::local_options(width = 250)

  lung2 <- survival::lung %>%
    dplyr::mutate(age_bin = factor(ifelse(age < 60, "<60", ">=60")))

  expect_snapshot(
    survival::survfit(survival::Surv(time, status) ~ age_bin, data = lung2) |>
      ard_survival_survfit(times = 100)
  )
})

test_that("ard_survival_survfit() preserves parentheses in strata level labels", {
  lung2 <- survival::lung %>%
    dplyr::mutate(sex_lbl = factor(ifelse(sex == 1, "Male (M)", "Female (F)")))

  res <- survival::survfit(survival::Surv(time, status) ~ sex_lbl, data = lung2) |>
    ard_survival_survfit(times = 100)

  levels <- unique(unlist(res$group1_level))
  levels <- levels[!is.na(levels)]
  expect_setequal(as.character(levels), c("Female (F)", "Male (M)"))
})

test_that("extract_strata() returns safely and warns on 0-row datasets", {
  mock_fit <- list(call = list(formula = ~ strata(TRT01A)))
  mock_df <- data.frame(time = numeric(0), strata = character(0))

  expect_snapshot_warning(
    res <- extract_strata(mock_fit, mock_df)
  )
  expect_equal(nrow(res), 0)
})

test_that("ard_survival_survfit() follows ard structure", {
  expect_silent(
    survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
      ard_survival_survfit(times = c(60, 180)) |>
      cards::check_ard_structure(method = FALSE)
  )
})

test_that("ard_survival_survfit() extends to times outside range", {
  withr::local_options(width = 250)

  expect_snapshot(
    survival::survfit(survival::Surv(AVAL, CNSR) ~ TRTA, cards::ADTTE) |>
      ard_survival_survfit(times = 200) |>
      print(n = Inf)
  )

  expect_snapshot(
    survival::survfit(survival::Surv(AVAL, 1 - CNSR) ~ TRTA, cards::ADTTE) |>
      ard_survival_survfit(times = 200) |>
      print(n = Inf)
  )

  expect_snapshot(
    survival::survfit(survival::Surv(AVAL, 1 - CNSR) ~ TRTA, cards::ADTTE) |>
      ard_survival_survfit(times = 200, summary.args = list(extend = FALSE)) |>
      print(n = Inf)
  )
})

test_that("ard_survival_survfit.data.frame() works as expected", {
  withr::local_options(width = 250)

  # quoted y expression
  expect_snapshot(
    res_quo <-
      ard_survival_survfit(
        x = mtcars,
        y = "survival::Surv(mpg, am)",
        variables = "vs",
        times = 20,
        method.args = list(start.time = 0, id = cyl)
      ) |>
      dplyr::mutate(
        stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))
      ) |>
      print(n = Inf)
  )

  # unquoted y expression
  res_unquo <-
    ard_survival_survfit(
      x = mtcars,
      y = survival::Surv(mpg, am),
      variables = "vs",
      times = 20,
      method.args = list(start.time = 0, id = cyl)
    ) |>
    dplyr::mutate(
      stat = lapply(stat, function(x) ifelse(is.numeric(x), cards::round5(x, 3), x))
    )

  expect_equal(res_quo, res_unquo)

  # check type
  expect_equal(
    ard_survival_survfit(
      x = mtcars,
      y = "survival::Surv(mpg, am)",
      variables = "vs",
      times = 20,
      method.args = list(start.time = 0, id = cyl)
    ) |>
      dplyr::pull("group1_level") |>
      unlist() |>
      class(),
    class(mtcars$vs)
  )

  # adding another check type
  expect_silent(
    tbl <-
      ard_survival_survfit(
        x = cards::ADTTE,
        variables = "TRTA",
        y = "survival::Surv(time = AVAL, event = 1 - CNSR, type = 'right', origin = 0)",
        times = c(6, 12)
      )
  )
  expect_equal(
    cards::rename_ard_columns(tbl) |>
      dplyr::pull("TRTA") |>
      class(),
    class(cards::ADTTE$TRTA)
  )
})

test_that("ard_survival_survfit.data.frame(variables=NULL) for unstratified model", {
  skip_if_pkg_not_installed("ggsurvfit")

  expect_equal(
    cards::ADTTE |>
      ard_survival_survfit(
        y = ggsurvfit::Surv_CNSR(AVAL, CNSR),
        variables = NULL,
        times = 90
      ),
    survival::survfit(ggsurvfit::Surv_CNSR() ~ 1, data = cards::ADTTE) |>
      ard_survival_survfit(times = 90)
  )
})
