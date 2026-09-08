skip_if_pkg_not_installed("survey")

data(api, package = "survey")
dclus1 <- survey::svydesign(id = ~dnum, weights = ~pw, data = apiclus1 |> dplyr::slice(1:50), fpc = ~fpc)
rclus1 <- survey::as.svrepdesign(dclus1)

test_that("ard_continuous_ci.survey.design(data)", {
  expect_snapshot(
    ard_continuous_ci(dclus1, variables = c(api00, api99)) |>
      as.data.frame() |>
      dplyr::select(-warning, -error)
  )
})

test_that("ard_continuous_ci.svyrep.design(data)", {
  expect_snapshot(
    ard_continuous_ci(rclus1, variables = c(api00, api99)) |>
      as.data.frame() |>
      dplyr::select(-warning, -error)
  )
})


test_that("ard_continuous_ci.survey.design(variables)", {
  expect_silent(
    ard <- ard_continuous_ci(dclus1, variables = c(api00, api99))
  )

  expect_equal(
    cards::get_ard_statistics(ard, variable %in% "api00", stat_name %in% c("estimate", "std.error")),
    survey::svymean(~api00, design = dclus1) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("estimate", "std.error"))
  )

  expect_equal(
    cards::get_ard_statistics(ard, variable %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svymean(~api00, design = dclus1) |>
      confint(level = 0.95, df = survey::degf(dclus1)) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )

  expect_equal(
    ard_continuous_ci(dclus1, variables = starts_with("xxxxxx")),
    dplyr::tibble() |> cards::as_card(check = FALSE)
  )

  # check NA values don't affect result
  dclus1_with_na <- dclus1
  dclus1_with_na$variables[["api00"]][1:25] <- NA
  expect_equal(
    ard_continuous_ci(dclus1_with_na, variables = api00),
    dclus1_with_na |>
      subset(!is.na(api00)) |>
      ard_continuous_ci(variables = api00, df = survey::degf(dclus1_with_na))
  )
})

test_that("ard_continuous_ci.svyrep.design(variables)", {
  expect_silent(
    ard <- ard_continuous_ci(rclus1, variables = c(api00, api99))
  )

  expect_equal(
    cards::get_ard_statistics(ard, variable %in% "api00", stat_name %in% c("estimate", "std.error")),
    survey::svymean(~api00, design = rclus1) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("estimate", "std.error"))
  )

  expect_equal(
    cards::get_ard_statistics(ard, variable %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svymean(~api00, design = rclus1) |>
      confint(level = 0.95, df = survey::degf(rclus1)) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )

  expect_equal(
    ard_continuous_ci(rclus1, variables = starts_with("xxxxxx")),
    dplyr::tibble() |> cards::as_card(check = FALSE)
  )

  # check NA values don't affect result
  rclus1_with_na <- rclus1
  rclus1_with_na$variables[["api00"]][1:25] <- NA
  expect_equal(
    ard_continuous_ci(rclus1_with_na, variables = api00),
    rclus1_with_na |>
      subset(!is.na(api00)) |>
      ard_continuous_ci(variables = api00, df = survey::degf(rclus1_with_na))
  )
})

test_that("ard_continuous_ci.survey.design(by)", {
  expect_silent(
    ard <- ard_continuous_ci(dclus1, variables = c(api00, api99), by = sch.wide)
  )

  expect_equal(
    cards::get_ard_statistics(ard, map(group1_level, as.character) %in% "No", map(variable, as.character) %in% "api00", stat_name %in% c("estimate", "std.error")),
    survey::svymean(~api00, design = dclus1 |> subset(sch.wide == "No")) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("estimate", "std.error"))
  )

  expect_equal(
    cards::get_ard_statistics(ard, map(group1_level, as.character) %in% "No", map(variable, as.character) %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svymean(~api00, design = dclus1 |> subset(sch.wide == "No")) |>
      confint(level = 0.95, df = survey::degf(dclus1)) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )

  # check that by variables of different classes still work
  expect_equal(
    ard$stat,
    {
      dclus1_copy <- dclus1
      dclus1_copy$variables$sch.wide <- dclus1_copy$variables$sch.wide |> as.integer()
      ard_continuous_ci(dclus1_copy, variables = c(api00, api99), by = sch.wide) |> dplyr::pull("stat")
    }
  )

  expect_equal(
    ard$stat,
    {
      dclus1_copy <- dclus1
      dclus1_copy$variables$sch.wide <- dclus1_copy$variables$sch.wide |> as.character()
      ard_continuous_ci(dclus1_copy, variables = c(api00, api99), by = sch.wide) |> dplyr::pull("stat")
    }
  )

  # check type
  expect_true(ard$group1_level |> unique() |> map_lgl(is.factor) |> all())
})

test_that("ard_continuous_ci.svyrep.design(by)", {
  expect_silent(
    ard <- ard_continuous_ci(rclus1, variables = c(api00, api99), by = sch.wide)
  )

  expect_equal(
    cards::get_ard_statistics(ard, map(group1_level, as.character) %in% "No", map(variable, as.character) %in% "api00", stat_name %in% c("estimate", "std.error")),
    survey::svymean(~api00, design = rclus1 |> subset(sch.wide == "No")) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("estimate", "std.error"))
  )

  expect_equal(
    cards::get_ard_statistics(ard, map(group1_level, as.character) %in% "No", map(variable, as.character) %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svymean(~api00, design = rclus1 |> subset(sch.wide == "No")) |>
      confint(level = 0.95, df = survey::degf(rclus1)) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )

  # check that by variables of different classes still work
  expect_equal(
    ard$stat,
    {
      rclus1_copy <- rclus1
      rclus1_copy$variables$sch.wide <- rclus1_copy$variables$sch.wide |> as.integer()
      ard_continuous_ci(rclus1_copy, variables = c(api00, api99), by = sch.wide) |> dplyr::pull("stat")
    }
  )

  expect_equal(
    ard$stat,
    {
      rclus1_copy <- rclus1
      rclus1_copy$variables$sch.wide <- rclus1_copy$variables$sch.wide |> as.character()
      ard_continuous_ci(rclus1_copy, variables = c(api00, api99), by = sch.wide) |> dplyr::pull("stat")
    }
  )

  # check type
  expect_true(ard$group1_level |> unique() |> map_lgl(is.factor) |> all())
})

test_that("ard_continuous_ci.survey.design(conf.level)", {
  expect_silent(
    ard <- ard_continuous_ci(dclus1, variables = c(api00, api99), conf.level = 0.80)
  )

  expect_equal(
    cards::get_ard_statistics(ard, variable %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svymean(~api00, design = dclus1) |>
      confint(level = 0.80, df = survey::degf(dclus1)) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )
})

test_that("ard_continuous_ci.svyrep.design(conf.level)", {
  expect_silent(
    ard <- ard_continuous_ci(rclus1, variables = c(api00, api99), conf.level = 0.80)
  )

  expect_equal(
    cards::get_ard_statistics(ard, variable %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svymean(~api00, design = rclus1) |>
      confint(level = 0.80, df = survey::degf(rclus1)) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )
})

test_that("ard_continuous_ci.survey.design(method,variables)", {
  expect_silent(
    ard <- ard_continuous_ci(dclus1, variables = c(api00, api99), method = "svymedian.beta")
  )

  expect_equal(
    cards::get_ard_statistics(ard, variable %in% "api00", stat_name %in% c("estimate", "std.error")),
    survey::svyquantile(~api00, design = dclus1, quantiles = 0.5, interval.type = "beta") |>
      getElement(1L) |>
      as.data.frame() |>
      dplyr::select(quantile, se) |>
      as.list() |>
      set_names(c("estimate", "std.error"))
  )

  expect_equal(
    cards::get_ard_statistics(ard, variable %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svyquantile(~api00, design = dclus1, quantiles = 0.5, interval.type = "beta") |>
      confint(level = 0.95) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )
})

test_that("ard_continuous_ci.svyrep.design(method,variables)", {
  expect_silent(
    ard <- ard_continuous_ci(rclus1, variables = c(api00, api99), method = "svymedian.beta")
  )

  expect_equal(
    cards::get_ard_statistics(ard, variable %in% "api00", stat_name %in% c("estimate", "std.error")),
    survey::svyquantile(~api00, design = rclus1, quantiles = 0.5, interval.type = "beta") |>
      getElement(1L) |>
      as.data.frame() |>
      dplyr::select(quantile, se) |>
      as.list() |>
      set_names(c("estimate", "std.error"))
  )

  expect_equal(
    cards::get_ard_statistics(ard, variable %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svyquantile(~api00, design = rclus1, quantiles = 0.5, interval.type = "beta") |>
      confint(level = 0.95) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )
})

test_that("ard_continuous_ci.survey.design(method,by)", {
  expect_silent(
    ard <- ard_continuous_ci(dclus1, variables = c(api00, api99), by = sch.wide, method = "svymedian.beta")
  )

  expect_equal(
    cards::get_ard_statistics(ard, map(group1_level, as.character) %in% "No", map(variable, as.character) %in% "api00", stat_name %in% c("estimate", "std.error")),
    survey::svyquantile(~api00, design = dclus1 |> subset(sch.wide == "No"), quantiles = 0.5, interval.type = "beta") |>
      getElement(1L) |>
      as.data.frame() |>
      dplyr::select(quantile, se) |>
      as.list() |>
      set_names(c("estimate", "std.error"))
  )

  expect_equal(
    cards::get_ard_statistics(ard, map(group1_level, as.character) %in% "No", map(variable, as.character) %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svyquantile(~api00, design = dclus1 |> subset(sch.wide == "No"), quantiles = 0.5, interval.type = "beta") |>
      confint(level = 0.95) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )
})

test_that("ard_continuous_ci.svyrep.design(method,by)", {
  expect_silent(
    ard <- ard_continuous_ci(rclus1, variables = c(api00, api99), by = sch.wide, method = "svymedian.beta")
  )

  expect_equal(
    cards::get_ard_statistics(ard, map(group1_level, as.character) %in% "No", map(variable, as.character) %in% "api00", stat_name %in% c("estimate", "std.error")),
    survey::svyquantile(~api00, design = rclus1 |> subset(sch.wide == "No"), quantiles = 0.5, interval.type = "beta") |>
      getElement(1L) |>
      as.data.frame() |>
      dplyr::select(quantile, se) |>
      as.list() |>
      set_names(c("estimate", "std.error"))
  )

  expect_equal(
    cards::get_ard_statistics(ard, map(group1_level, as.character) %in% "No", map(variable, as.character) %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svyquantile(~api00, design = rclus1 |> subset(sch.wide == "No"), quantiles = 0.5, interval.type = "beta") |>
      confint(level = 0.95) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )
})

test_that("ard_continuous_ci.survey.design(...)", {
  # pass the df argument to `confint()`
  expect_silent(
    ard_svymean <-
      ard_continuous_ci(dclus1, variables = c(api00, api99), df = 50)
  )
  expect_silent(
    ard_svyquantile <-
      ard_continuous_ci(dclus1, variables = c(api00, api99), method = "svymedian.beta", df = 50)
  )

  expect_equal(
    cards::get_ard_statistics(ard_svymean, variable %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svymean(~api00, design = dclus1) |>
      confint(level = 0.95, df = 50) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )

  expect_equal(
    cards::get_ard_statistics(ard_svyquantile, variable %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svyquantile(~api00, design = dclus1, quantiles = 0.5, interval.type = "beta") |>
      confint(level = 0.95, df = 50) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )
})

test_that("ard_continuous_ci.svyrep.design(...)", {
  # pass the df argument to `confint()`
  expect_silent(
    ard_svymean <-
      ard_continuous_ci(rclus1, variables = c(api00, api99), df = 50)
  )
  expect_silent(
    ard_svyquantile <-
      ard_continuous_ci(rclus1, variables = c(api00, api99), method = "svymedian.beta", df = 50)
  )

  expect_equal(
    cards::get_ard_statistics(ard_svymean, variable %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svymean(~api00, design = rclus1) |>
      confint(level = 0.95, df = 50) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )

  expect_equal(
    cards::get_ard_statistics(ard_svyquantile, variable %in% "api00", stat_name %in% c("conf.low", "conf.high")),
    survey::svyquantile(~api00, design = rclus1, quantiles = 0.5, interval.type = "beta") |>
      confint(level = 0.95, df = 50) |>
      as.data.frame() |>
      as.list() |>
      set_names(c("conf.low", "conf.high"))
  )
})

test_that("ard_continuous_ci.survey.design() errors are captured", {
  expect_snapshot(
    ard_continuous_ci(dclus1, variables = c(api00, api99), df = letters)
  )
  expect_snapshot(
    ard_continuous_ci(dclus1, variables = sch.wide, method = "svymedian.beta")
  )
})

test_that("ard_continuous_ci.svyrep.design() errors are captured", {
  expect_snapshot(
    ard_continuous_ci(rclus1, variables = c(api00, api99), df = letters)
  )
  expect_snapshot(
    ard_continuous_ci(rclus1, variables = sch.wide, method = "svymedian.beta")
  )
})

test_that("ard_continuous_ci.survey.design() follows ard structure", {
  expect_silent(
    ard_continuous_ci(dclus1, variables = c(api00, api99), df = 50) |>
      cards::check_ard_structure(method = FALSE)
  )
})

test_that("ard_continuous_ci.svyrep.design() follows ard structure", {
  expect_silent(
    ard_continuous_ci(rclus1, variables = c(api00, api99), df = 50) |>
      cards::check_ard_structure(method = FALSE)
  )
})

test_that("ard_continuous_ci() errors are reported against the generic", {
  # the `svyrep.design` method delegates to the `survey.design` method; the
  # error must still name the generic, not the method delegated to
  reported_fn <- function(expr) {
    tryCatch(expr, error = function(e) as.character(conditionCall(e)[[1]]))
  }

  expect_equal(
    reported_fn(ard_continuous_ci(dclus1, variables = api00, method = "not_a_method")),
    "ard_continuous_ci"
  )
  expect_equal(
    reported_fn(ard_continuous_ci(rclus1, variables = api00, method = "not_a_method")),
    "ard_continuous_ci"
  )
})
