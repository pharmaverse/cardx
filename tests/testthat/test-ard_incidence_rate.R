# one row per subject, including subjects without any adverse events
adsl_ae <- cards::ADSL |>
  dplyr::left_join(
    cards::ADAE |> dplyr::count(.data$USUBJID, name = "n_ae"),
    by = "USUBJID"
  ) |>
  dplyr::mutate(n_ae = dplyr::coalesce(.data$n_ae, 0L))

adtte <- cards::ADTTE

test_that("ard_incidence_rate() works", {
  # default arguments
  expect_silent(
    res <- adtte |>
      ard_incidence_rate(time = AVAL, count = CNSR, id = USUBJID, unit_label = "years")
  )
  expect_snapshot(res |> print(columns = "all"))
  expect_equal(res$stat_label[1], "Incidence rate per 100 Person-Years")

  # one row per subject, with subjects without events
  expect_silent(
    res <- adsl_ae |>
      ard_incidence_rate(time = TRTDUR, count = n_ae, id = USUBJID, unit_label = "days")
  )
  expect_snapshot(res |> print(columns = "all"))

  # without `id`, each row is a unique subject
  expect_equal(
    adsl_ae |>
      ard_incidence_rate(time = TRTDUR, count = n_ae, unit_label = "days") |>
      cards::get_ard_statistics(),
    res |>
      cards::get_ard_statistics()
  )

  # custom arguments
  expect_silent(
    res <- adsl_ae |>
      ard_incidence_rate(time = TRTDUR, count = n_ae, id = USUBJID, n_person_time = 50, unit_label = "days")
  )
  expect_snapshot(res |> print(columns = "all"))
  expect_equal(res$stat_label[1], "Incidence rate per 50 Person-Days")
})

test_that("ard_incidence_rate() reports `n` and `N` correctly", {
  # one row per subject
  res <- adsl_ae |>
    ard_incidence_rate(time = TRTDUR, count = n_ae, id = USUBJID, by = ARM) |>
    dplyr::filter(.data$stat_name %in% c("n", "N")) |>
    dplyr::mutate(group1_level = unlist(.data$group1_level), stat = unlist(.data$stat)) |>
    dplyr::arrange(.data$group1_level)
  expected <- adsl_ae |>
    dplyr::summarize(
      n = sum(.data$n_ae > 0),
      N = dplyr::n(),
      .by = "ARM"
    ) |>
    dplyr::arrange(.data$ARM)
  expect_equal(
    res |> dplyr::filter(.data$stat_name == "n") |> dplyr::pull("stat"),
    expected$n
  )
  expect_equal(
    res |> dplyr::filter(.data$stat_name == "N") |> dplyr::pull("stat"),
    expected$N
  )

  # multiple rows per subject: a subject is counted once in `n` and `N`
  res <- data.frame(
    USUBJID = c("a", "a", "b", "b", "c"),
    time = c(1, 2, 1, 1, 3),
    count = c(0, 2, 0, 0, NA)
  ) |>
    ard_incidence_rate(time = time, count = count, id = USUBJID) |>
    cards::get_ard_statistics()
  expect_equal(res$n, 1L)
  expect_equal(res$N, 3L)
  expect_equal(res$n_events, 2)
  expect_equal(res$tot_person_time, 8)

  # labels
  res <- adtte |>
    ard_incidence_rate(time = AVAL, count = CNSR, id = USUBJID)
  expect_equal(
    res |> dplyr::filter(.data$stat_name %in% c("n", "N")) |> dplyr::pull("stat_label"),
    c("Number of Subjects with an Event", "Number of Subjects at Risk")
  )
})

test_that("ard_incidence_rate(count = NULL) is deprecated", {
  lifecycle::expect_deprecated(
    res <- adsl_ae |>
      ard_incidence_rate(time = TRTDUR, id = USUBJID)
  )
  res <- cards::get_ard_statistics(res)
  # each row is an event, so every subject has an event
  expect_equal(res$n_events, nrow(adsl_ae))
  expect_equal(res$n, res$N)
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

test_that("ard_incidence_rate() follows ard structure", {
  expect_silent(
    adtte |>
      ard_incidence_rate(time = AVAL, count = CNSR, id = USUBJID, by = TRTA) |>
      cards::check_ard_structure(method = FALSE)
  )
})
