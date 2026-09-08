# ard_tabulate.survey.design() returns an error when variables have all NAs

    Code
      ard_tabulate(svy_titanic, variables = c(Class, Age), by = Survived,
      denominator = "row")
    Condition
      Error in `ard_tabulate()`:
      ! Column "Class" is all missing and cannot be tabulated.
      i Only columns of class <factor> can be tabulated when all values are missing.

---

    Code
      ard_tabulate(svy_titanic, variables = c(Class, Age), by = Survived,
      denominator = "column")
    Condition
      Error in `ard_tabulate()`:
      ! Column "Class" is all missing and cannot be tabulated.
      i Only columns of class <factor> can be tabulated when all values are missing.

---

    Code
      ard_tabulate(svy_titanic, variables = c(Class, Age), by = Survived,
      denominator = "cell")
    Condition
      Error in `ard_tabulate()`:
      ! Column "Class" is all missing and cannot be tabulated.
      i Only columns of class <factor> can be tabulated when all values are missing.

# ard_tabulate.svyrep.design() returns an error when variables have all NAs

    Code
      ard_tabulate(rsvy_titanic, variables = c(Class, Age), by = Survived,
      denominator = "row")
    Condition
      Error in `ard_tabulate()`:
      ! Column "Class" is all missing and cannot be tabulated.
      i Only columns of class <factor> can be tabulated when all values are missing.

---

    Code
      ard_tabulate(rsvy_titanic, variables = c(Class, Age), by = Survived,
      denominator = "column")
    Condition
      Error in `ard_tabulate()`:
      ! Column "Class" is all missing and cannot be tabulated.
      i Only columns of class <factor> can be tabulated when all values are missing.

---

    Code
      ard_tabulate(rsvy_titanic, variables = c(Class, Age), by = Survived,
      denominator = "cell")
    Condition
      Error in `ard_tabulate()`:
      ! Column "Class" is all missing and cannot be tabulated.
      i Only columns of class <factor> can be tabulated when all values are missing.

# ard_tabulate.survey.design(by) messages about protected names

    Code
      ard_tabulate(svy_mtcars, by = variable, variables = gear)
    Condition
      Error in `ard_tabulate()`:
      ! The `by` argument cannot include variables named "variable", "variable_level", "group1_level", "p", and "n".

---

    Code
      ard_tabulate(svy_mtcars, by = p.std.error, variables = name)
    Condition
      Error in `ard_tabulate()`:
      ! The `variables` argument cannot include variables named "by", "name", "n", "p", and "p.std.error".

# ard_tabulate.svyrep.design(by) messages about protected names

    Code
      ard_tabulate(rsvy_mtcars, by = variable, variables = gear)
    Condition
      Error in `ard_tabulate()`:
      ! The `by` argument cannot include variables named "variable", "variable_level", "group1_level", "p", and "n".

---

    Code
      ard_tabulate(rsvy_mtcars, by = p.std.error, variables = name)
    Condition
      Error in `ard_tabulate()`:
      ! The `variables` argument cannot include variables named "by", "name", "n", "p", and "p.std.error".

# ard_tabulate.survey.design() messaging with all NA lgl variables

    Code
      ard_tabulate(survey::svydesign(~1, data = dplyr::tibble(fct = factor(c(NA, NA),
      levels = c("no", "yes")), lgl = c(NA, NA)), weights = ~1), variables = lgl)
    Condition
      Error in `ard_tabulate()`:
      ! Column "lgl" is all missing and cannot be tabulated.
      i Only columns of class <factor> can be tabulated when all values are missing.

# ard_tabulate.svyrep.design() messaging with all NA lgl variables

    Code
      ard_tabulate(rsvy_na, variables = lgl)
    Condition
      Error in `ard_tabulate()`:
      ! Column "lgl" is all missing and cannot be tabulated.
      i Only columns of class <factor> can be tabulated when all values are missing.

