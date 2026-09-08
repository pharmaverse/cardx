skip_if_pkg_not_installed("survey")

df_titanic_sml <- as.data.frame(Titanic) |> dplyr::slice(1:16)

# Test survey.design working (2x3)
test_that("ard_tabulate.survey.design() works", {
  svy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq)

  # setup for value checks
  df_titanic <- df_titanic_sml |> tidyr::uncount(weights = Freq)

  # denom = row, with by
  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  # denom = column, with by
  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_col, method = FALSE))

  # denom = cell, with by
  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # check the calculated stats are correct

  # section 1: by variable, row denominator
  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "n") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |> dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "N") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |> dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "p") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |> dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "p.std.error") |> unlist() |> unname() |> sort(),
    unname(c(
      survey::svyby(
        formula = reformulate2("Survived"),
        by = reformulate2("Age"),
        design = svy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se.SurvivedYes", "se.SurvivedNo")] |> unlist(),
      survey::svyby(
        formula = reformulate2("Survived"),
        by = reformulate2("Class"),
        design = svy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se.SurvivedYes", "se.SurvivedNo")] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "n_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "row") |> dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname()
  )

  # section 2: by variable, column denominator
  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col |> dplyr::arrange_all(), stat_name %in% "n") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col |> dplyr::arrange_all(), stat_name %in% "N") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col |> dplyr::arrange_all(), stat_name %in% "p") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist()
  )

  expect_equal(
    unname(cards::get_ard_statistics(ard_svy_cat_col |> dplyr::arrange_all(), stat_name %in% "p.std.error")) |> unlist() |> sort(),
    unname(c(
      survey::svyby(
        formula = reformulate2("Age"),
        by = reformulate2("Survived"),
        design = svy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se.AgeAdult", "se.AgeChild")] |> unlist(),
      survey::svyby(
        formula = reformulate2("Class"),
        by = reformulate2("Survived"),
        design = svy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se.Class1st", "se.Class2nd", "se.Class3rd", "se.ClassCrew")] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname()
  )

  # section 3: by variable, cell denominator
  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell |> dplyr::arrange_all(), stat_name %in% "n") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell |> dplyr::arrange_all(), stat_name %in% "N") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell |> dplyr::arrange_all(), stat_name %in% "p") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell |> dplyr::arrange_all(), stat_name %in% "p.std.error") |> unlist() |> unname() |> sort(),
    unname(c(
      as.data.frame(survey::svymean(
        x = inject(~ interaction(!!sym(bt("Survived")), !!sym(bt("Class")))),
        design = svy_titanic,
        na.rm = TRUE,
        deff = "Design Effect"
      ))[, "SE"] |> unlist(),
      as.data.frame(survey::svymean(
        x = inject(~ interaction(!!sym(bt("Survived")), !!sym(bt("Age")))),
        design = svy_titanic,
        na.rm = TRUE,
        deff = "Design Effect"
      ))[, "SE"] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname()
  )


  # denom = row, without by
  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  # denom = column, without by
  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # denom = cell, without by
  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # check the calculated stats are correct

  # section 4: without by variable, row denominator
  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "n") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "p.std.error") |> unlist() |> unname() |> sort(),
    c(dplyr::tibble(
      variable_level = unique(svy_titanic$variables[["Class"]]) |> sort() |> as.character(),
      p = 1,
      p.std.error = 0,
      deff = NaN
    ) |> dplyr::select("p.std.error") |> unlist() |> unname(), dplyr::tibble(
      variable_level = unique(svy_titanic$variables[["Age"]]) |> sort() |> as.character(),
      p = 1,
      p.std.error = 0,
      deff = NaN
    ) |> dplyr::select("p.std.error") |> unlist() |> unname())
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "n_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname()
  )

  # section 5: without by variable, column denominator
  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p.std.error") |> unlist() |> unname(),
    c(
      survey::svymean(reformulate2("Class"), design = svy_titanic, na.rm = TRUE, deff = "Design Effect") |>
        dplyr::as_tibble(rownames = "var_level") |>
        dplyr::select("SE") |> unlist() |> unname(),
      survey::svymean(reformulate2("Age"), design = svy_titanic, na.rm = TRUE, deff = "Design Effect") |>
        dplyr::as_tibble(rownames = "var_level") |>
        dplyr::select("SE") |> unlist() |> unname()
    )
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname()
  )

  # section 6: without by variable, cell denominator
  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p.std.error") |> unlist() |> unname(),
    c(
      survey::svymean(reformulate2("Class"), design = svy_titanic, na.rm = TRUE, deff = "Design Effect") |>
        dplyr::as_tibble(rownames = "var_level") |>
        dplyr::select("SE") |> unlist() |> unname(),
      survey::svymean(reformulate2("Age"), design = svy_titanic, na.rm = TRUE, deff = "Design Effect") |>
        dplyr::as_tibble(rownames = "var_level") |>
        dplyr::select("SE") |> unlist() |> unname()
    )
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname()
  )
})

# Test svyrep.design working (2x3)
test_that("ard_tabulate.svyrep.design() works", {
  rsvy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  # setup for value checks
  df_titanic <- df_titanic_sml |> tidyr::uncount(weights = Freq)

  # denom = row, with by
  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  # denom = column, with by
  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_col, method = FALSE))

  # denom = cell, with by
  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # check the calculated stats are correct

  # section 1: by variable, row denominator
  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "n") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |> dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "N") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |> dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "p") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |> dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "p.std.error") |> unlist() |> unname() |> sort(),
    unname(c(
      survey::svyby(
        formula = reformulate2("Survived"),
        by = reformulate2("Age"),
        design = rsvy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se1", "se2")] |> unlist(),
      survey::svyby(
        formula = reformulate2("Survived"),
        by = reformulate2("Class"),
        design = rsvy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se1", "se2")] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "n_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "row") |> dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname()
  )

  # section 2: by variable, column denominator
  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col |> dplyr::arrange_all(), stat_name %in% "n") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col |> dplyr::arrange_all(), stat_name %in% "N") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col |> dplyr::arrange_all(), stat_name %in% "p") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist()
  )

  expect_equal(
    unname(cards::get_ard_statistics(ard_svy_cat_col |> dplyr::arrange_all(), stat_name %in% "p.std.error")) |> unlist() |> sort(),
    unname(c(
      survey::svyby(
        formula = reformulate2("Age"),
        by = reformulate2("Survived"),
        design = rsvy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se1", "se2")] |> unlist(),
      survey::svyby(
        formula = reformulate2("Class"),
        by = reformulate2("Survived"),
        design = rsvy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se1", "se2", "se3", "se4")] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname()
  )

  # section 3: by variable, cell denominator
  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell |> dplyr::arrange_all(), stat_name %in% "n") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell |> dplyr::arrange_all(), stat_name %in% "N") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell |> dplyr::arrange_all(), stat_name %in% "p") |> unlist(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      dplyr::arrange_all() |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell |> dplyr::arrange_all(), stat_name %in% "p.std.error") |> unlist() |> unname() |> sort(),
    unname(c(
      as.data.frame(survey::svymean(
        x = inject(~ interaction(!!sym(bt("Survived")), !!sym(bt("Class")))),
        design = rsvy_titanic,
        na.rm = TRUE,
        deff = "Design Effect"
      ))[, "SE"] |> unlist(),
      as.data.frame(survey::svymean(
        x = inject(~ interaction(!!sym(bt("Survived")), !!sym(bt("Age")))),
        design = rsvy_titanic,
        na.rm = TRUE,
        deff = "Design Effect"
      ))[, "SE"] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p_unweighted") |> unlist() |> unname(),
    ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname()
  )


  # denom = row, without by
  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  # denom = column, without by
  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # denom = cell, without by
  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # check the calculated stats are correct

  # section 4: without by variable, row denominator
  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "n") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "p.std.error") |> unlist() |> unname() |> sort(),
    c(dplyr::tibble(
      variable_level = unique(rsvy_titanic$variables[["Class"]]) |> sort() |> as.character(),
      p = 1,
      p.std.error = 0,
      deff = NaN
    ) |> dplyr::select("p.std.error") |> unlist() |> unname(), dplyr::tibble(
      variable_level = unique(rsvy_titanic$variables[["Age"]]) |> sort() |> as.character(),
      p = 1,
      p.std.error = 0,
      deff = NaN
    ) |> dplyr::select("p.std.error") |> unlist() |> unname())
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "n_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname()
  )

  # section 5: without by variable, column denominator
  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p.std.error") |> unlist() |> unname(),
    c(
      survey::svymean(reformulate2("Class"), design = rsvy_titanic, na.rm = TRUE, deff = "Design Effect") |>
        dplyr::as_tibble(rownames = "var_level") |>
        dplyr::select("SE") |> unlist() |> unname(),
      survey::svymean(reformulate2("Age"), design = rsvy_titanic, na.rm = TRUE, deff = "Design Effect") |>
        dplyr::as_tibble(rownames = "var_level") |>
        dplyr::select("SE") |> unlist() |> unname()
    )
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname()
  )

  # section 6: without by variable, cell denominator
  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = NULL, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p.std.error") |> unlist() |> unname(),
    c(
      survey::svymean(reformulate2("Class"), design = rsvy_titanic, na.rm = TRUE, deff = "Design Effect") |>
        dplyr::as_tibble(rownames = "var_level") |>
        dplyr::select("SE") |> unlist() |> unname(),
      survey::svymean(reformulate2("Age"), design = rsvy_titanic, na.rm = TRUE, deff = "Design Effect") |>
        dplyr::as_tibble(rownames = "var_level") |>
        dplyr::select("SE") |> unlist() |> unname()
    )
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p_unweighted") |> unlist() |> unname(),
    cards::ard_tabulate(df_titanic_sml, variables = c(Class, Age), by = NULL, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname()
  )
})

test_that("ard_tabulate.survey.design() returns an error when variables have all NAs", {
  svy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq)

  # row denom
  svy_titanic$variables$Class <- NA

  expect_snapshot(
    ard_tabulate(
      svy_titanic,
      variables = c(Class, Age),
      by = Survived,
      denominator = "row"
    ),
    error = TRUE
  )

  # column denom
  expect_snapshot(
    ard_tabulate(
      svy_titanic,
      variables = c(Class, Age),
      by = Survived,
      denominator = "column"
    ),
    error = TRUE
  )

  # cell denom
  expect_snapshot(
    ard_tabulate(
      svy_titanic,
      variables = c(Class, Age),
      by = Survived,
      denominator = "cell"
    ),
    error = TRUE
  )
})

test_that("ard_tabulate.svyrep.design() returns an error when variables have all NAs", {
  rsvy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  # row denom
  rsvy_titanic$variables$Class <- NA

  expect_snapshot(
    ard_tabulate(
      rsvy_titanic,
      variables = c(Class, Age),
      by = Survived,
      denominator = "row"
    ),
    error = TRUE
  )

  # column denom
  expect_snapshot(
    ard_tabulate(
      rsvy_titanic,
      variables = c(Class, Age),
      by = Survived,
      denominator = "column"
    ),
    error = TRUE
  )

  # cell denom
  expect_snapshot(
    ard_tabulate(
      rsvy_titanic,
      variables = c(Class, Age),
      by = Survived,
      denominator = "cell"
    ),
    error = TRUE
  )
})

# - Do we get results for unobserved factor levels in the `by` and `variable` variables?
test_that("ard_tabulate.survey.design() works for unobserved factor levels", {
  svy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq)
  svy_titanic$variables$Survived <- fct_expand(svy_titanic$variables$Survived, "Unknown")

  # data setup for equality checks
  df_titanic <- df_titanic_sml |> tidyr::uncount(weights = Freq)
  df_titanic$Survived <- fct_expand(df_titanic$Survived, "Unknown")

  # for unweighted <-
  df_uw <- df_titanic_sml
  df_uw$Survived <- fct_expand(df_uw$Survived, "Unknown")

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_col, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "n") |> unlist() |> sort(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "p.std.error") |> unlist() |> unname() |> sort(),
    unname(c(
      survey::svyby(
        formula = reformulate2("Survived"),
        by = reformulate2("Age"),
        design = svy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se.SurvivedYes", "se.SurvivedNo", "se.SurvivedUnknown")] |> unlist(),
      survey::svyby(
        formula = reformulate2("Survived"),
        by = reformulate2("Class"),
        design = svy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se.SurvivedYes", "se.SurvivedNo", "se.SurvivedUnknown")] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "n_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> sort()
  )

  expect_equal(
    unname(cards::get_ard_statistics(ard_svy_cat_col |> dplyr::arrange_all(), stat_name %in% "p.std.error")) |> unlist() |> sort(),
    unname(c(
      survey::svyby(
        formula = reformulate2("Age"),
        by = reformulate2("Survived"),
        design = svy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se.AgeAdult", "se.AgeChild")] |> unlist(),
      survey::svyby(
        formula = reformulate2("Class"),
        by = reformulate2("Survived"),
        design = svy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se.Class1st", "se.Class2nd", "se.Class3rd", "se.ClassCrew")] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell |> dplyr::arrange_all(), stat_name %in% "p.std.error") |> unlist() |> unname() |> sort(),
    unname(c(
      as.data.frame(survey::svymean(
        x = inject(~ interaction(!!sym(bt("Survived")), !!sym(bt("Class")))),
        design = svy_titanic,
        na.rm = TRUE,
        deff = "Design Effect"
      ))[, "SE"] |> unlist(),
      as.data.frame(survey::svymean(
        x = inject(~ interaction(!!sym(bt("Survived")), !!sym(bt("Age")))),
        design = svy_titanic,
        na.rm = TRUE,
        deff = "Design Effect"
      ))[, "SE"] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname() |> sort()
  )
  # variables have unobserved levels, no by variable
  svy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq)
  svy_titanic$variables$Class <- fct_expand(svy_titanic$variables$Survived, "Peasant")

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # variable AND by have unobserved levels
  svy_titanic$variables$Survived <- fct_expand(svy_titanic$variables$Survived, "Unknown")

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))
})

# - Do we get results for unobserved factor levels in the `by` and `variable` variables?
test_that("ard_tabulate.svyrep.design() works for unobserved factor levels", {
  rsvy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()
  rsvy_titanic$variables$Survived <- fct_expand(rsvy_titanic$variables$Survived, "Unknown")

  # data setup for equality checks
  df_titanic <- df_titanic_sml |> tidyr::uncount(weights = Freq)
  df_titanic$Survived <- fct_expand(df_titanic$Survived, "Unknown")

  # for unweighted <-
  df_uw <- df_titanic_sml
  df_uw$Survived <- fct_expand(df_uw$Survived, "Unknown")

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_col, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "n") |> unlist() |> sort(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "p.std.error") |> unlist() |> unname() |> sort(),
    unname(c(
      survey::svyby(
        formula = reformulate2("Survived"),
        by = reformulate2("Age"),
        design = rsvy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se2", "se1", "se3")] |> unlist(),
      survey::svyby(
        formula = reformulate2("Survived"),
        by = reformulate2("Class"),
        design = rsvy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se2", "se1", "se3")] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "n_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> sort()
  )

  expect_equal(
    unname(cards::get_ard_statistics(ard_svy_cat_col |> dplyr::arrange_all(), stat_name %in% "p.std.error")) |> unlist() |> sort(),
    unname(c(
      survey::svyby(
        formula = reformulate2("Age"),
        by = reformulate2("Survived"),
        design = rsvy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se1", "se2")] |> unlist(),
      survey::svyby(
        formula = reformulate2("Class"),
        by = reformulate2("Survived"),
        design = rsvy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se1", "se2", "se3", "se4")] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell |> dplyr::arrange_all(), stat_name %in% "p.std.error") |> unlist() |> unname() |> sort(),
    unname(c(
      as.data.frame(survey::svymean(
        x = inject(~ interaction(!!sym(bt("Survived")), !!sym(bt("Class")))),
        design = rsvy_titanic,
        na.rm = TRUE,
        deff = "Design Effect"
      ))[, "SE"] |> unlist(),
      as.data.frame(survey::svymean(
        x = inject(~ interaction(!!sym(bt("Survived")), !!sym(bt("Age")))),
        design = rsvy_titanic,
        na.rm = TRUE,
        deff = "Design Effect"
      ))[, "SE"] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname() |> sort()
  )
  # variables have unobserved levels, no by variable
  rsvy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()
  rsvy_titanic$variables$Class <- fct_expand(rsvy_titanic$variables$Survived, "Peasant")

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # variable AND by have unobserved levels
  rsvy_titanic$variables$Survived <- fct_expand(rsvy_titanic$variables$Survived, "Unknown")

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))
})

# - Do we get results for unobserved logical levels in the `by` and `variable` variables?
test_that("ard_tabulate.survey.design() works for unobserved logical levels", {
  svy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq)
  svy_titanic$variables$Survived <- rep(TRUE, length(svy_titanic$variables$Survived))

  df_titanic <- df_titanic_sml |> tidyr::uncount(weights = Freq)
  df_titanic$Survived <- rep(TRUE, length(df_titanic$Survived))

  # for unweighted
  df_uw <- df_titanic_sml
  df_uw$Survived <- rep(TRUE, length(df_uw$Survived))

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_col, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "n") |> unlist() |> sort(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "p.std.error") |> unlist() |> unname() |> sort(),
    unname(c(
      survey::svyby(
        formula = reformulate2("Survived"),
        by = reformulate2("Age"),
        design = svy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se.SurvivedFALSE", "se.SurvivedTRUE")] |> unlist(),
      survey::svyby(
        formula = reformulate2("Survived"),
        by = reformulate2("Class"),
        design = svy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se.SurvivedFALSE", "se.SurvivedTRUE")] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "n_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> sort()
  )

  expect_equal(
    unname(cards::get_ard_statistics(ard_svy_cat_col |> dplyr::arrange_all(), stat_name %in% "p.std.error")) |> unlist() |> sort(),
    unname(c(
      survey::svyby(
        formula = reformulate2("Age"),
        by = reformulate2("Survived"),
        design = svy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se.AgeAdult", "se.AgeChild")] |> unlist(),
      survey::svyby(
        formula = reformulate2("Class"),
        by = reformulate2("Survived"),
        design = svy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se.Class1st", "se.Class2nd", "se.Class3rd", "se.ClassCrew")] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell |> dplyr::arrange_all(), stat_name %in% "p.std.error" & group1_level == TRUE) |> unlist() |> unname() |> sort(),
    unname(c(
      as.data.frame(survey::svymean(
        x = inject(~ interaction(!!sym(bt("Survived")), !!sym(bt("Class")))),
        design = svy_titanic,
        na.rm = TRUE,
        deff = "Design Effect"
      ))[, "SE"] |> unlist(),
      as.data.frame(survey::svymean(
        x = inject(~ interaction(!!sym(bt("Survived")), !!sym(bt("Age")))),
        design = svy_titanic,
        na.rm = TRUE,
        deff = "Design Effect"
      ))[, "SE"] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname() |> sort()
  )

  # variables have unobserved levels, no by variable
  svy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq)
  svy_titanic$variables$Age <- rep(TRUE, length(svy_titanic$variables$Age))

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # variable AND by have unobserved levels
  svy_titanic$variables$Survived <- rep(TRUE, length(svy_titanic$variables$Survived))

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))
})

# - Do we get results for unobserved logical levels in the `by` and `variable` variables?
test_that("ard_tabulate.svyrep.design() works for unobserved logical levels", {
  rsvy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()
  rsvy_titanic$variables$Survived <- rep(TRUE, length(rsvy_titanic$variables$Survived))

  df_titanic <- df_titanic_sml |> tidyr::uncount(weights = Freq)
  df_titanic$Survived <- rep(TRUE, length(df_titanic$Survived))

  # for unweighted
  df_uw <- df_titanic_sml
  df_uw$Survived <- rep(TRUE, length(df_uw$Survived))

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_col, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "n") |> unlist() |> sort(),
    ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row |> dplyr::arrange_all(), stat_name %in% "p.std.error") |> unlist() |> unname() |> sort(),
    unname(c(
      survey::svyby(
        formula = reformulate2("Survived"),
        by = reformulate2("Age"),
        design = rsvy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se1", "se2")] |> unlist(),
      survey::svyby(
        formula = reformulate2("Survived"),
        by = reformulate2("Class"),
        design = rsvy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se1", "se2")] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "n_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "N_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_row, stat_name %in% "p_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "row") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> sort()
  )

  expect_equal(
    unname(cards::get_ard_statistics(ard_svy_cat_col |> dplyr::arrange_all(), stat_name %in% "p.std.error")) |> unlist() |> sort(),
    unname(c(
      survey::svyby(
        formula = reformulate2("Age"),
        by = reformulate2("Survived"),
        design = rsvy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se1", "se2")] |> unlist(),
      survey::svyby(
        formula = reformulate2("Class"),
        by = reformulate2("Survived"),
        design = rsvy_titanic,
        FUN = survey::svymean,
        na.rm = TRUE,
        deff = "Design Effect"
      )[, c("se1", "se2", "se3", "se4")] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "n_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "N_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_col, stat_name %in% "p_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "column") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N") |> unlist(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p") |> unlist() |> sort(),
    cards::ard_tabulate(df_titanic, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell |> dplyr::arrange_all(), stat_name %in% "p.std.error" & group1_level == TRUE) |> unlist() |> unname() |> sort(),
    unname(c(
      as.data.frame(survey::svymean(
        x = inject(~ interaction(!!sym(bt("Survived")), !!sym(bt("Class")))),
        design = rsvy_titanic,
        na.rm = TRUE,
        deff = "Design Effect"
      ))[, "SE"] |> unlist(),
      as.data.frame(survey::svymean(
        x = inject(~ interaction(!!sym(bt("Survived")), !!sym(bt("Age")))),
        design = rsvy_titanic,
        na.rm = TRUE,
        deff = "Design Effect"
      ))[, "SE"] |> unlist()
    )) |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "n_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "n") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "N_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "N") |> unlist() |> unname() |> sort()
  )

  expect_equal(
    cards::get_ard_statistics(ard_svy_cat_cell, stat_name %in% "p_unweighted") |> unlist() |> unname() |> sort(),
    cards::ard_tabulate(df_uw, variables = c(Class, Age), by = Survived, denominator = "cell") |>
      cards::get_ard_statistics(stat_name %in% "p") |> unlist() |> unname() |> sort()
  )

  # variables have unobserved levels, no by variable
  rsvy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()
  rsvy_titanic$variables$Age <- rep(TRUE, length(rsvy_titanic$variables$Age))

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # variable AND by have unobserved levels
  rsvy_titanic$variables$Survived <- rep(TRUE, length(rsvy_titanic$variables$Survived))

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))
})

# - Does the work around apply for variables with only 1 level
test_that("ard_tabulate.survey.design() works with variables with only 1 level", {
  svy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq)
  svy_titanic$variables$Survived <- rep("Yes", length(svy_titanic$variables$Survived))

  # by variable only has 1 level
  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_col, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # variables have only 1 level, no by variable
  svy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq)
  svy_titanic$variables$Age <- as.factor(rep("Child", length(svy_titanic$variables$Age)))

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # variable AND by have only 1 level
  svy_titanic$variables$Survived <- as.factor(rep("Yes", length(svy_titanic$variables$Survived)))

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        svy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))
})

# - Does the work around apply for variables with only 1 level
test_that("ard_tabulate.svyrep.design() works with variables with only 1 level", {
  rsvy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()
  rsvy_titanic$variables$Survived <- rep("Yes", length(rsvy_titanic$variables$Survived))

  # by variable only has 1 level
  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_col, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # variables have only 1 level, no by variable
  rsvy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()
  rsvy_titanic$variables$Age <- as.factor(rep("Child", length(rsvy_titanic$variables$Age)))

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  # variable AND by have only 1 level
  rsvy_titanic$variables$Survived <- as.factor(rep("Yes", length(rsvy_titanic$variables$Survived)))

  expect_error(
    ard_svy_cat_row <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "row"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_row, method = FALSE))

  expect_error(
    ard_svy_cat_col <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "column"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))

  expect_error(
    ard_svy_cat_cell <-
      ard_tabulate(
        rsvy_titanic,
        variables = c(Class, Age),
        by = Survived,
        denominator = "cell"
      ),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_svy_cat_cell, method = FALSE))
})

test_that("ard_tabulate.survey.design(by) messages about protected names", {
  svy_mtcars <-
    survey::svydesign(
      ids = ~1,
      data = mtcars |>
        dplyr::mutate(
          variable = am,
          variable_level = cyl,
          by = am,
          by_level = cyl,
          group1_level = disp,
          n = carb,
          p.std.error = drat,
          name = hp,
          p = vs
        ),
      weights = ~1
    )

  expect_snapshot(
    error = TRUE,
    ard_tabulate(svy_mtcars, by = variable, variables = gear)
  )

  expect_error(
    ard_tabulate(svy_mtcars, by = variable_level, variables = gear),
    'The `by` argument cannot include variables named "variable", "variable_level", "group1_level", "p", and "n".'
  )

  expect_snapshot(
    error = TRUE,
    ard_tabulate(svy_mtcars, by = p.std.error, variables = name)
  )

  expect_error(
    ard_tabulate(svy_mtcars, by = p.std.error, variables = name),
    'The `variables` argument cannot include variables named "by", "name", "n", "p", and "p.std.error".'
  )
})

test_that("ard_tabulate.svyrep.design(by) messages about protected names", {
  rsvy_mtcars <-
    survey::svydesign(
      ids = ~1,
      data = mtcars |>
        dplyr::mutate(
          variable = am,
          variable_level = cyl,
          by = am,
          by_level = cyl,
          group1_level = disp,
          n = carb,
          p.std.error = drat,
          name = hp,
          p = vs
        ),
      weights = ~1
    ) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  expect_snapshot(
    error = TRUE,
    ard_tabulate(rsvy_mtcars, by = variable, variables = gear)
  )

  expect_error(
    ard_tabulate(rsvy_mtcars, by = variable_level, variables = gear),
    'The `by` argument cannot include variables named "variable", "variable_level", "group1_level", "p", and "n".'
  )

  expect_snapshot(
    error = TRUE,
    ard_tabulate(rsvy_mtcars, by = p.std.error, variables = name)
  )

  expect_error(
    ard_tabulate(rsvy_mtcars, by = p.std.error, variables = name),
    'The `variables` argument cannot include variables named "by", "name", "n", "p", and "p.std.error".'
  )
})

# - test if function parameters can be used as variable names without error
test_that("ard_tabulate.survey.design() works when using generic names ", {
  svy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq)

  svy_titanic2 <- svy_titanic
  svy_titanic2$variables <- svy_titanic$variables %>%
    dplyr::rename("variable" = Class, "variable_level" = Age, "by" = Survived, "group1_level" = Sex)


  expect_equal(
    ard_tabulate(svy_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(svy_titanic2, variables = c(variable, variable_level), by = by, denominator = "row") |> dplyr::select(stat)
  )

  # rename vars

  svy_titanic2$variables <- svy_titanic$variables %>%
    dplyr::rename("N" = Class, "p" = Age, "name" = Survived, "group1_level" = Sex)

  expect_equal(
    ard_tabulate(svy_titanic, variables = c(Class), by = Survived, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(svy_titanic2, variables = c(N), by = name, denominator = "row") |> dplyr::select(stat)
  )

  # rename vars
  svy_titanic2$variables <- svy_titanic$variables %>%
    dplyr::rename("n" = Class, "mean" = Age, "p.std.error" = Survived, "n_unweighted" = Sex)

  expect_equal(
    ard_tabulate(svy_titanic, variables = c(Sex, Age), by = Survived, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(svy_titanic2, variables = c(n_unweighted, mean), by = p.std.error, denominator = "row") |> dplyr::select(stat)
  )

  expect_equal(
    ard_tabulate(svy_titanic, variables = Sex, by = Survived, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(svy_titanic2, variables = n_unweighted, by = p.std.error, denominator = "row") |> dplyr::select(stat)
  )

  # rename vars
  svy_titanic2$variables <- svy_titanic$variables %>%
    dplyr::rename("N_unweighted" = Class, "p_unweighted" = Age, "column" = Survived, "row" = Sex)

  expect_equal(
    ard_tabulate(svy_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(svy_titanic2, variables = c(N_unweighted, p_unweighted), by = column, denominator = "row") |> dplyr::select(stat)
  )

  expect_equal(
    ard_tabulate(svy_titanic, variables = c(Survived, Sex), by = Class, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(svy_titanic2, variables = c(column, row), by = N_unweighted, denominator = "row") |> dplyr::select(stat)
  )

  expect_equal(
    ard_tabulate(svy_titanic, variables = c(Class, Survived), by = Age, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(svy_titanic2, variables = c(N_unweighted, column), by = p_unweighted, denominator = "row") |> dplyr::select(stat)
  )

  expect_equal(
    ard_tabulate(svy_titanic, variables = c(Class, Survived), by = Sex, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(svy_titanic2, variables = c(N_unweighted, column), by = row, denominator = "row") |> dplyr::select(stat)
  )

  # rename vars
  svy_titanic2$variables <- svy_titanic$variables %>%
    dplyr::rename("cell" = Class, "p_unweighted" = Age, "column" = Survived, "row" = Sex)

  expect_equal(
    ard_tabulate(svy_titanic, variables = c(Class, Survived), by = Age, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(svy_titanic2, variables = c(cell, column), by = p_unweighted, denominator = "row") |> dplyr::select(stat)
  )

  expect_equal(
    ard_tabulate(svy_titanic, variables = c(Sex, Survived), by = Class, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(svy_titanic2, variables = c(row, column), by = cell, denominator = "row") |> dplyr::select(stat)
  )
})

# - test if function parameters can be used as variable names without error
test_that("ard_tabulate.svyrep.design() works when using generic names ", {
  rsvy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  rsvy_titanic2 <- rsvy_titanic
  rsvy_titanic2$variables <- rsvy_titanic$variables %>%
    dplyr::rename("variable" = Class, "variable_level" = Age, "by" = Survived, "group1_level" = Sex)


  expect_equal(
    ard_tabulate(rsvy_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(rsvy_titanic2, variables = c(variable, variable_level), by = by, denominator = "row") |> dplyr::select(stat)
  )

  # rename vars

  rsvy_titanic2$variables <- rsvy_titanic$variables %>%
    dplyr::rename("N" = Class, "p" = Age, "name" = Survived, "group1_level" = Sex)

  expect_equal(
    ard_tabulate(rsvy_titanic, variables = c(Class), by = Survived, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(rsvy_titanic2, variables = c(N), by = name, denominator = "row") |> dplyr::select(stat)
  )

  # rename vars
  rsvy_titanic2$variables <- rsvy_titanic$variables %>%
    dplyr::rename("n" = Class, "mean" = Age, "p.std.error" = Survived, "n_unweighted" = Sex)

  expect_equal(
    ard_tabulate(rsvy_titanic, variables = c(Sex, Age), by = Survived, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(rsvy_titanic2, variables = c(n_unweighted, mean), by = p.std.error, denominator = "row") |> dplyr::select(stat)
  )

  expect_equal(
    ard_tabulate(rsvy_titanic, variables = Sex, by = Survived, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(rsvy_titanic2, variables = n_unweighted, by = p.std.error, denominator = "row") |> dplyr::select(stat)
  )

  # rename vars
  rsvy_titanic2$variables <- rsvy_titanic$variables %>%
    dplyr::rename("N_unweighted" = Class, "p_unweighted" = Age, "column" = Survived, "row" = Sex)

  expect_equal(
    ard_tabulate(rsvy_titanic, variables = c(Class, Age), by = Survived, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(rsvy_titanic2, variables = c(N_unweighted, p_unweighted), by = column, denominator = "row") |> dplyr::select(stat)
  )

  expect_equal(
    ard_tabulate(rsvy_titanic, variables = c(Survived, Sex), by = Class, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(rsvy_titanic2, variables = c(column, row), by = N_unweighted, denominator = "row") |> dplyr::select(stat)
  )

  expect_equal(
    ard_tabulate(rsvy_titanic, variables = c(Class, Survived), by = Age, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(rsvy_titanic2, variables = c(N_unweighted, column), by = p_unweighted, denominator = "row") |> dplyr::select(stat)
  )

  expect_equal(
    ard_tabulate(rsvy_titanic, variables = c(Class, Survived), by = Sex, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(rsvy_titanic2, variables = c(N_unweighted, column), by = row, denominator = "row") |> dplyr::select(stat)
  )

  # rename vars
  rsvy_titanic2$variables <- rsvy_titanic$variables %>%
    dplyr::rename("cell" = Class, "p_unweighted" = Age, "column" = Survived, "row" = Sex)

  expect_equal(
    ard_tabulate(rsvy_titanic, variables = c(Class, Survived), by = Age, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(rsvy_titanic2, variables = c(cell, column), by = p_unweighted, denominator = "row") |> dplyr::select(stat)
  )

  expect_equal(
    ard_tabulate(rsvy_titanic, variables = c(Sex, Survived), by = Class, denominator = "row") |> dplyr::select(stat),
    ard_tabulate(rsvy_titanic2, variables = c(row, column), by = cell, denominator = "row") |> dplyr::select(stat)
  )
})

test_that("ard_tabulate.survey.design(statistic) properly excluded unweighted stats not selected", {
  svy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq)

  expect_equal(
    ard_tabulate(
      svy_titanic,
      variables = Sex,
      statistic = ~ c("N", "N_unweighted")
    ) |>
      dplyr::select(variable, variable_level, stat_name, stat_label, stat),
    ard_tabulate(
      svy_titanic,
      variables = Sex
    ) |>
      dplyr::filter(stat_name %in% c("N", "N_unweighted")) |>
      dplyr::select(variable, variable_level, stat_name, stat_label, stat)
  )
})

test_that("ard_tabulate.svyrep.design(statistic) properly excluded unweighted stats not selected", {
  rsvy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  expect_equal(
    ard_tabulate(
      rsvy_titanic,
      variables = Sex,
      statistic = ~ c("N", "N_unweighted")
    ) |>
      dplyr::select(variable, variable_level, stat_name, stat_label, stat),
    ard_tabulate(
      rsvy_titanic,
      variables = Sex
    ) |>
      dplyr::filter(stat_name %in% c("N", "N_unweighted")) |>
      dplyr::select(variable, variable_level, stat_name, stat_label, stat)
  )
})

test_that("ard_tabulate.survey.design() follows ard structure", {
  svy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq)

  expect_silent(
    ard_tabulate(
      svy_titanic,
      variables = c(Class, Age),
      by = Survived,
      denominator = "row"
    ) |>
      cards::check_ard_structure(method = FALSE)
  )
})

test_that("ard_tabulate.svyrep.design() follows ard structure", {
  rsvy_titanic <- survey::svydesign(~1, data = df_titanic_sml, weights = ~Freq) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  expect_silent(
    ard_tabulate(
      rsvy_titanic,
      variables = c(Class, Age),
      by = Survived,
      denominator = "row"
    ) |>
      cards::check_ard_structure(method = FALSE)
  )
})

test_that("ard_tabulate.survey.design() original types are retained", {
  svy_titanic <-
    survey::svydesign(
      ~1,
      data = df_titanic_sml |> dplyr::mutate(
        Class.dbl = as.numeric(Class),
        Class.int = as.integer(Class)
      ),
      weights = ~Freq
    )

  # factors and integer check
  expect_silent(
    ard <-
      ard_tabulate(svy_titanic, variables = c(Class, Age, Class.int, Class.dbl), by = Survived)
  )
  expect_equal(
    unlist(ard$group1_level) |> levels(),
    levels(df_titanic_sml$Survived)
  )
  expect_true(
    dplyr::filter(ard, variable %in% "Class") |>
      dplyr::pull("variable_level") |>
      getElement(1L) |>
      is.factor()
  )
  expect_true(
    dplyr::filter(ard, variable %in% "Age") |>
      dplyr::pull("variable_level") |>
      getElement(1L) |>
      is.factor()
  )
  expect_true(
    dplyr::filter(ard, variable %in% "Class.int") |>
      dplyr::pull("variable_level") |>
      getElement(1L) |>
      is.integer()
  )
  expect_true(
    dplyr::filter(ard, variable %in% "Class.dbl") |>
      dplyr::pull("variable_level") |>
      getElement(1L) |>
      is.numeric()
  )
})

test_that("ard_tabulate.svyrep.design() original types are retained", {
  rsvy_titanic <-
    survey::svydesign(
      ~1,
      data = df_titanic_sml |> dplyr::mutate(
        Class.dbl = as.numeric(Class),
        Class.int = as.integer(Class)
      ),
      weights = ~Freq
    ) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  # factors and integer check
  expect_silent(
    ard <-
      ard_tabulate(rsvy_titanic, variables = c(Class, Age, Class.int, Class.dbl), by = Survived)
  )
  expect_equal(
    unlist(ard$group1_level) |> levels(),
    levels(df_titanic_sml$Survived)
  )
  expect_true(
    dplyr::filter(ard, variable %in% "Class") |>
      dplyr::pull("variable_level") |>
      getElement(1L) |>
      is.factor()
  )
  expect_true(
    dplyr::filter(ard, variable %in% "Age") |>
      dplyr::pull("variable_level") |>
      getElement(1L) |>
      is.factor()
  )
  expect_true(
    dplyr::filter(ard, variable %in% "Class.int") |>
      dplyr::pull("variable_level") |>
      getElement(1L) |>
      is.integer()
  )
  expect_true(
    dplyr::filter(ard, variable %in% "Class.dbl") |>
      dplyr::pull("variable_level") |>
      getElement(1L) |>
      is.numeric()
  )
})

test_that("ard_tabulate.survey.design() works with all NA fct variables", {
  expect_silent(
    ard_fct_na <-
      survey::svydesign(
        ~1,
        data =
          dplyr::tibble(
            fct = factor(c(NA, NA), levels = c("no", "yes")),
            lgl = c(NA, NA)
          ),
        weights = ~1
      ) |>
      ard_tabulate(variables = fct)
  )

  # all Ns should be zero
  expect_equal(
    ard_fct_na |>
      dplyr::filter(!startsWith(stat_name, "p") & stat_name != "deff") |>
      dplyr::pull(stat) |>
      unlist() |>
      unique(),
    0L
  )

  # all percentages (and deff) should be NaN
  expect_true(
    ard_fct_na |>
      dplyr::filter((startsWith(stat_name, "p") | stat_name == "deff") & stat_name != "p.std.error") |>
      dplyr::pull(stat) |>
      unique() |>
      unlist() |>
      is.nan()
  )
})

test_that("ard_tabulate.svyrep.design() with all NA fct variables", {
  # An all-missing factor is tabulated for a `survey.design` (zero counts, NaN
  # percentages), but not for a `svyrep.design`: `survey::svymean(na.rm = TRUE)`
  # drops every row, so every replicate estimate is NA and `survey::svrVar()`
  # aborts. The error surfaces from `survey`, not from cardx.
  rsvy_na <-
    survey::svydesign(
      ~1,
      data =
        dplyr::tibble(
          fct = factor(c(NA, NA), levels = c("no", "yes")),
          lgl = c(NA, NA)
        ),
      weights = ~1
    ) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  expect_error(
    rsvy_na |> ard_tabulate(variables = fct),
    "All replicates contained NAs"
  )

  # a partially missing factor is unaffected
  rsvy_some_na <-
    survey::svydesign(
      ~1,
      data =
        dplyr::tibble(
          fct = factor(c(NA, NA, "no", "yes"), levels = c("no", "yes")),
          w = rep(1, 4)
        ),
      weights = ~w
    ) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  expect_error(
    ard_fct_some_na <- rsvy_some_na |> ard_tabulate(variables = fct),
    NA
  )
  expect_invisible(cards::check_ard_structure(ard_fct_some_na, method = FALSE))

  # the missing rows are excluded from the denominator, so the two observed
  # levels each account for half of the non-missing weight
  expect_equal(
    cards::get_ard_statistics(ard_fct_some_na, stat_name %in% "p") |> unlist() |> unname(),
    c(0.5, 0.5)
  )
  expect_equal(
    cards::get_ard_statistics(ard_fct_some_na, stat_name %in% "n_unweighted") |> unlist() |> unname(),
    c(1, 1)
  )
})

test_that("ard_tabulate.survey.design() messaging with all NA lgl variables", {
  expect_snapshot(
    error = TRUE,
    survey::svydesign(
      ~1,
      data =
        dplyr::tibble(
          fct = factor(c(NA, NA), levels = c("no", "yes")),
          lgl = c(NA, NA)
        ),
      weights = ~1
    ) |>
      ard_tabulate(variables = lgl)
  )
})

test_that("ard_tabulate.svyrep.design() messaging with all NA lgl variables", {
  rsvy_na <-
    survey::svydesign(
      ~1,
      data =
        dplyr::tibble(
          fct = factor(c(NA, NA), levels = c("no", "yes")),
          lgl = c(NA, NA)
        ),
      weights = ~1
    ) |>
    survey::as.svrepdesign() |>
    suppressWarnings()

  expect_snapshot(
    error = TRUE,
    rsvy_na |>
      ard_tabulate(variables = lgl)
  )
})
