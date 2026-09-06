skip_if_pkg_not_installed("survey")

# `svyrep.design` is a sibling class of `survey.design`, not a subclass, so
# these methods must be registered separately. See #355.

make_designs <- function() {
  e <- new.env()
  utils::data("api", package = "survey", envir = e)
  des <- survey::svydesign(
    id = ~dnum, weights = ~pw, data = e$apiclus1, fpc = ~fpc
  )
  list(des = des, rep = survey::as.svrepdesign(des))
}

make_designs_tidy <- function() {
  skip_if_pkg_not_installed("srvyr")
  e <- new.env()
  utils::data("api", package = "survey", envir = e)
  des <- e$apiclus1 |>
    srvyr::as_survey_design(ids = dnum, weights = pw, fpc = fpc)
  list(des_tidy = des, rep_tidy = srvyr::as_survey_rep(des))
}

test_that("the ard_* generics dispatch on svyrep.design", {
  d <- make_designs()

  expect_no_error(ard_attributes(d$rep, variables = c(sname, dname)))
  expect_no_error(ard_total_n(d$rep))
  expect_no_error(ard_missing(d$rep, variables = api00))
  expect_no_error(ard_tabulate(d$rep, variables = stype))
  expect_no_error(ard_tabulate_value(d$rep, variables = stype, value = list(stype = "E")))
  expect_no_error(ard_summary(d$rep, variables = api00))
})

test_that("svyrep.design results follow the ard structure", {
  d <- make_designs()

  expect_invisible(
    cards::check_ard_structure(ard_tabulate(d$rep, variables = stype), method = FALSE)
  )
  expect_invisible(
    cards::check_ard_structure(ard_summary(d$rep, variables = api00), method = FALSE)
  )
  expect_invisible(
    cards::check_ard_structure(ard_missing(d$rep, variables = api00), method = FALSE)
  )
  expect_invisible(
    cards::check_ard_structure(ard_total_n(d$rep), method = FALSE)
  )
})

test_that("svyrep.design gives the same weighted point estimates as survey.design", {
  d <- make_designs()

  # the sampling weights are identical, so weighted n/N/p must agree exactly;
  # only the variance estimation method differs
  get_stat <- function(x, nm) unlist(x$stat[x$stat_name == nm])

  lin <- ard_tabulate(d$des, variables = stype)
  rep <- ard_tabulate(d$rep, variables = stype)

  expect_equal(get_stat(lin, "n"), get_stat(rep, "n"))
  expect_equal(get_stat(lin, "N"), get_stat(rep, "N"))
  expect_equal(get_stat(lin, "p"), get_stat(rep, "p"))

  expect_equal(
    get_stat(ard_summary(d$des, variables = api00), "median"),
    get_stat(ard_summary(d$rep, variables = api00), "median")
  )
})

test_that("svyrep.design uses replicate variance", {
  d <- make_designs()
  get_stat <- function(x, nm) unlist(x$stat[x$stat_name == nm])

  lin_se <- get_stat(ard_tabulate(d$des, variables = stype), "p.std.error")
  rep_se <- get_stat(ard_tabulate(d$rep, variables = stype), "p.std.error")

  # expect the SE to be different between linear and replicate methods
  expect_false(isTRUE(all.equal(lin_se, rep_se)))

  # and they must match what survey itself reports for the same design
  expect_equal(
    rep_se,
    as.numeric(survey::SE(survey::svymean(~stype, d$rep))),
    ignore_attr = TRUE
  )
})

test_that("all replicate types are supported", {
  data(api, package = "survey")
  clus <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
  strat <- survey::svydesign(id = ~1, strata = ~stype, weights = ~pw, data = apistrat, fpc = ~fpc)

  set.seed(8675309)
  # survey emits construction-time notes here (e.g. FPC dropped in conversion)
  # that are unrelated to the dispatch being tested
  designs <- suppressWarnings(list(
    JK1 = survey::as.svrepdesign(clus),
    JKn = survey::as.svrepdesign(strat, type = "JKn"),
    bootstrap = survey::as.svrepdesign(clus, type = "bootstrap", replicates = 25),
    subbootstrap = survey::as.svrepdesign(clus, type = "subbootstrap", replicates = 25),
    Fay = survey::as.svrepdesign(strat, type = "Fay", fay.rho = 0.3)
  ))

  for (nm in names(designs)) {
    expect_no_error(ard_tabulate(designs[[nm]], variables = stype))
    expect_no_error(ard_summary(designs[[nm]], variables = api00))
  }

  # BRR built directly with svrepdesign(), per gtsummary#1441
  data(scd, package = "survey")
  brr_rep <- 2 * cbind(
    c(1, 0, 1, 0, 1, 0), c(1, 0, 0, 1, 0, 1),
    c(0, 1, 1, 0, 0, 1), c(0, 1, 0, 1, 1, 0)
  )
  scdrep <- suppressWarnings(survey::svrepdesign(
    data = scd, type = "BRR", repweights = brr_rep, combined.weights = FALSE
  ))
  expect_no_error(ard_summary(scdrep, variables = arrests))
})

test_that("ard_tabulate.svyrep.design() works with by", {
  d <- make_designs()

  expect_no_error(ard_by <- ard_tabulate(d$rep, variables = stype, by = both))
  expect_invisible(cards::check_ard_structure(ard_by, method = FALSE))
})

test_that("survey and srvyr objects return same results",{
  skip_if_pkg_not_installed("srvyr")

  d <- make_designs()
  td <- make_designs_tidy()

  lin <- ard_tabulate(d$des, variables = stype)
  rep <- ard_tabulate(d$rep, variables = stype)
  lin_tidy <- ard_tabulate(td$des, variables = stype)
  rep_tidy <- ard_tabulate(td$rep, variables = stype)

  expect_equal(lin, lin_tidy)
  expect_equal(rep, rep_tidy)

  catci_lin <- ard_categorical_ci(d$des, variables = sch.wide, method = "xlogit")
  catci_rep <- ard_categorical_ci(d$rep, variables = sch.wide, method = "xlogit")
  catci_lin_tidy <- ard_categorical_ci(td$des, variables = sch.wide, method = "xlogit")
  catci_rep_tidy <- ard_categorical_ci(td$rep, variables = sch.wide, method = "xlogit")

  expect_equal(catci_lin, catci_lin_tidy)
  expect_equal(catci_rep, catci_rep_tidy)

  conci_lin <- ard_continuous_ci(d$des, variables = api00)
  conci_rep <- ard_continuous_ci(d$rep, variables = api00)
  conci_lin_tidy <- ard_continuous_ci(td$des, variables = api00)
  conci_rep_tidy <- ard_continuous_ci(td$rep, variables = api00)

  expect_equal(conci_lin, conci_lin_tidy)
  expect_equal(conci_rep, conci_rep_tidy)
})