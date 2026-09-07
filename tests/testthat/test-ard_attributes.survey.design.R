skip_if_pkg_not_installed(c("survey", "withr"))

test_that("ard_attributes.survey.design() and ard_attributes.svyrep.design() works", {
  withr::local_options(list(width = 120))
  data(api, package = "survey")
  dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
  rclus1 <- survey::as.svrepdesign(dclus1)

  expect_snapshot({
    attr(dclus1$variables$sname, "label") <- "School Name"

    attr_des <- ard_attributes(
      dclus1,
      variables = c(sname, dname),
      label = list(dname = "District Name")
    ) |>
      as.data.frame()
  })

  expect_snapshot({
    attr(rclus1$variables$sname, "label") <- "School Name"

    attr_rep <- ard_attributes(
      rclus1,
      variables = c(sname, dname),
      label = list(dname = "District Name")
    ) |>
      as.data.frame()
  })

  expect_equal(attr_rep, attr_des)
})
