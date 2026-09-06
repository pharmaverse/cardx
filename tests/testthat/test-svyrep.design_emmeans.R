skip_if_pkg_not_installed(c("survey", "emmeans"))

# `svyrep.design` is a sibling class of `survey.design`, not a subclass. These
# functions previously rejected replicate designs, and additionally tested the
# design class with `dplyr::last(class(data))`, which does not identify a
# `svyrep.design` at all. See #355.

get_stat <- function(x, nm) unlist(x$stat[x$stat_name == nm])

test_that("ard_emmeans_emmeans() accepts a svyrep.design", {
  data(api, package = "survey")
  rep_des <- survey::as.svrepdesign(
    survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
  )

  expect_no_error(
    ard_rep <- ard_emmeans_emmeans(
      rep_des, api00 ~ sch.wide, method = "svyglm", package = "survey"
    )
  )
  expect_invisible(cards::check_ard_structure(ard_rep, method = FALSE))
  expect_true(all(vapply(ard_rep$error, is.null, logical(1))))
})

test_that("ard_emmeans_contrast() accepts a svyrep.design", {
  data(api, package = "survey")
  rep_des <- survey::as.svrepdesign(
    survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
  )

  expect_no_error(
    ard_rep <- ard_emmeans_contrast(
      rep_des, api00 ~ sch.wide, method = "svyglm", package = "survey"
    )
  )
  expect_invisible(cards::check_ard_structure(ard_rep, method = FALSE))
  expect_true(all(vapply(ard_rep$error, is.null, logical(1))))
})

test_that("emmeans results use replicate variance, not linearization", {
  data(api, package = "survey")
  lin_des <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
  rep_des <- survey::as.svrepdesign(lin_des)

  ard_lin <- ard_emmeans_emmeans(
    lin_des, api00 ~ sch.wide, method = "svyglm", package = "survey"
  )
  ard_rep <- ard_emmeans_emmeans(
    rep_des, api00 ~ sch.wide, method = "svyglm", package = "survey"
  )

  expect_true(all(vapply(ard_lin$error, is.null, logical(1))))
  expect_true(all(vapply(ard_rep$error, is.null, logical(1))))

  # the sampling weights are identical, so the point estimates must agree
  expect_equal(get_stat(ard_lin, "estimate"), get_stat(ard_rep, "estimate"))

  # the standard errors should not be equal
  expect_false(
    isTRUE(all.equal(get_stat(ard_lin, "std.error"), get_stat(ard_rep, "std.error")))
  )
})

test_that("construct_model() dispatches on svyrep.design", {
  data(api, package = "survey")
  rep_des <- survey::as.svrepdesign(
    survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
  )

  expect_no_error(
    mod <- construct_model(
      rep_des, api00 ~ sch.wide, method = "svyglm", package = "survey"
    )
  )
  expect_s3_class(mod, "svyglm")
  expect_s3_class(mod, "svrepglm")
})

test_that("data.frame input is unaffected by the class-test change", {
  data(api, package = "survey")

  expect_no_error(
    ard_df <- ard_emmeans_emmeans(
      apiclus1, api00 ~ sch.wide, method = "lm", package = "stats"
    )
  )
  expect_invisible(cards::check_ard_structure(ard_df, method = FALSE))
  expect_true(all(vapply(ard_df$error, is.null, logical(1))))
})
