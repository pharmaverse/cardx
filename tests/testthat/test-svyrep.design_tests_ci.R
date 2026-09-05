skip_if_pkg_not_installed("survey")

# `svyrep.design` is a sibling class of `survey.design`, not a subclass. These
# functions previously rejected replicate designs with a class guard, even
# though the underlying `survey` functions support them. See #355.

make_designs <- function() {
  e <- new.env()
  utils::data("api", package = "survey", envir = e)
  des <- survey::svydesign(
    id = ~dnum, weights = ~pw, data = e$apiclus1, fpc = ~fpc
  )
  list(des = des, rep = survey::as.svrepdesign(des))
}

get_stat <- function(x, nm) unlist(x$stat[x$stat_name == nm])

test_that("ard_survey_svychisq() accepts a svyrep.design", {
  skip_if_pkg_not_installed("broom")
  d <- make_designs()

  expect_error(
    ard_rep <- ard_survey_svychisq(d$rep, variables = stype, by = both),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_rep, method = FALSE))

  # the p-value must come from the replicate design, not the linearized one
  ard_lin <- ard_survey_svychisq(d$des, variables = stype, by = both)
  expect_false(
    isTRUE(all.equal(get_stat(ard_lin, "p.value"), get_stat(ard_rep, "p.value")))
  )

  # and it must match what survey itself reports for that design
  expect_equal(
    get_stat(ard_rep, "p.value"),
    as.numeric(survey::svychisq(~ stype + both, d$rep)$p.value),
    ignore_attr = TRUE
  )
})

test_that("ard_survey_svyttest() accepts a svyrep.design", {
  skip_if_pkg_not_installed("broom")
  d <- make_designs()

  expect_error(
    ard_rep <- ard_survey_svyttest(d$rep, variable = api00, by = sch.wide, conf.level = 0.95),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_rep, method = FALSE))

  expect_equal(
    get_stat(ard_rep, "estimate"),
    as.numeric(survey::svyttest(api00 ~ sch.wide, d$rep)$estimate),
    ignore_attr = TRUE
  )
})

test_that("ard_survey_svyranktest() accepts a svyrep.design", {
  skip_if_pkg_not_installed("broom")
  d <- make_designs()

  # `test` is a required argument of ard_survey_svyranktest()
  expect_error(
    ard_rep <- ard_survey_svyranktest(
      d$rep, variable = api00, by = sch.wide, test = "wilcoxon"
    ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_rep, method = FALSE))

  expect_equal(
    get_stat(ard_rep, "p.value"),
    as.numeric(
      survey::svyranktest(api00 ~ sch.wide, d$rep, test = "wilcoxon")$p.value
    ),
    ignore_attr = TRUE
  )
})

test_that("ard_continuous_ci() dispatches on svyrep.design", {
  d <- make_designs()

  expect_error(ard_rep <- ard_continuous_ci(d$rep, variables = api00), NA)
  expect_invisible(cards::check_ard_structure(ard_rep, method = FALSE))

  # the interval must be the replicate one, and must match survey directly
  ard_lin <- ard_continuous_ci(d$des, variables = api00)
  expect_false(
    isTRUE(all.equal(get_stat(ard_lin, "conf.low"), get_stat(ard_rep, "conf.low")))
  )
  expect_equal(
    c(get_stat(ard_rep, "conf.low"), get_stat(ard_rep, "conf.high")),
    as.numeric(confint(survey::svymean(~api00, d$rep), df = survey::degf(d$rep))),
    ignore_attr = TRUE
  )
})

test_that("ard_categorical_ci() dispatches on svyrep.design", {
  d <- make_designs()

  expect_error(ard_rep <- ard_categorical_ci(d$rep, variables = sch.wide), NA)
  expect_invisible(cards::check_ard_structure(ard_rep, method = FALSE))

  ard_lin <- ard_categorical_ci(d$des, variables = sch.wide)
  expect_false(
    isTRUE(all.equal(get_stat(ard_lin, "conf.low"), get_stat(ard_rep, "conf.low")))
  )
})

test_that("the class guards still reject non-survey input", {
  expect_error(ard_survey_svychisq(mtcars, variables = am, by = vs))
  expect_error(ard_continuous_ci(letters))
})
