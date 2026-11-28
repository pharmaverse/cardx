adae <- cards::ADAE |>
  dplyr::rowwise() |>
  dplyr::mutate(time = max(.data$ASTDY, 0))

adtte <- cards::ADTTE

test_that("ard_incidence_rate() works", {
  # default arguments
  expect_silent(
    res <- adtte |>
      ard_incidence_rate(time = AVAL, count = CNSR, id = USUBJID, unit_label = "years")
  )
  expect_snapshot(res |> print(columns = "all"))
  expect_equal(res$stat_label[1], "Incidence rate per 100 Person-Years")

  adae_single <- adae |>
    dplyr::group_by(USUBJID) |>
    dplyr::summarize(count = dplyr::n(), time = mean(time) * dplyr::n()) # create equal-sized times

  # one row per subject
  expect_silent(
    res <- adae_single |>
      ard_incidence_rate(time = time, count = count, id = USUBJID, unit_label = "days")
  )
  expect_snapshot(res |> print(columns = "all"))

  # multiple rows per subject
  lifecycle::expect_deprecated(
    res <- adae |>
      ard_incidence_rate(time = time, unit_label = "days")
  )
  expect_snapshot(res |> print(columns = "all"))

  # custom arguments
  lifecycle::expect_deprecated(
    res <- adae |>
      ard_incidence_rate(time = time, id = USUBJID, n_person_time = 50, unit_label = "days")
  )
  expect_snapshot(res |> print(columns = "all"))
  expect_equal(res$stat_label[1], "Incidence rate per 50 Person-Days")
})

test_that("ard_incidence_rate() reports `n` and `N` correctly", {
  # multiple rows per subject: a subject is counted once in `n` and `N`
  res <- data.frame(
    USUBJID = c("a", "a", "b", "b", "c"),
    time = c(1, 2, 1, 1, 3),
    count = c(0, 2, 0, 0, NA)
  ) |>
    ard_incidence_rate(time = time, count = count, id = USUBJID)
  expect_equal(
    res |> dplyr::filter(.data$stat_name %in% c("n", "N")) |> dplyr::pull("stat_label"),
    c("Number of Subjects with an Event", "Number of Subjects at Risk")
  )
  res <- cards::get_ard_statistics(res)
  expect_equal(res$n, 1L)
  expect_equal(res$N, 3L)
})

test_that("ard_incidence_rate() reports std.error per `n_person_time`, like the estimate and CI", {
  for (n_person_time in c(1, 100)) {
    res <- adtte |>
      ard_incidence_rate(time = AVAL, count = CNSR, id = USUBJID, n_person_time = n_person_time) |>
      cards::get_ard_statistics()
    z <- stats::qnorm(0.975)
    expect_equal(res$conf.low, res$estimate - z * res$std.error)
    expect_equal(res$conf.high, res$estimate + z * res$std.error)
  }
})

test_that("ard_incidence_rate(conf.type) works", {
  # conf.type = "normal-log"
  expect_silent(
    res <- adtte |>
      ard_incidence_rate(time = AVAL, count = CNSR, id = USUBJID, unit_label = "years", conf.type = "normal-log")
  )
  expect_snapshot(res |> print(columns = "all"))

  # conf.type = "exact"
  expect_silent(
    res <- adtte |>
      ard_incidence_rate(time = AVAL, count = CNSR, id = USUBJID, unit_label = "years", conf.type = "exact")
  )
  expect_snapshot(res |> print(columns = "all"))

  # conf.type = "byar"
  expect_silent(
    res <- adtte |>
      ard_incidence_rate(time = AVAL, count = CNSR, id = USUBJID, unit_label = "years", conf.type = "byar")
  )
  expect_snapshot(res |> print(columns = "all"))
})

test_that("ard_incidence_rate() errors are handled correctly", {
  # incorrect time
  expect_snapshot(
    res <- adtte |>
      ard_incidence_rate(time = SEX, count = CNSR, id = USUBJID),
    error = TRUE
  )

  # incorrect unit_label
  expect_snapshot(
    res <- adtte |>
      ard_incidence_rate(time = AVAL, count = CNSR, id = USUBJID, unit_label = 10),
    error = TRUE
  )

  # incorrect conf.type
  expect_snapshot(
    res <- adtte |>
      ard_incidence_rate(time = AVAL, count = CNSR, id = USUBJID, unit_label = "years", conf.type = "standard"),
    error = TRUE
  )
})
