# Replicate-weight survey designs (`svyrep.design`) are a sibling class of
# `survey.design`, not a subclass, so they do not inherit the methods defined
# for `survey.design`. The implementations below are shared with those methods:
# the statistics are computed by `survey::svymean()`, `svytotal()`, `svyvar()`,
# `svyquantile()`, `svytable()` and `svyby()`, each of which already handles
# replicate designs, so no separate calculation is required. See #355.

#' @rdname ard_attributes
#' @export
ard_attributes.svyrep.design <- ard_attributes.survey.design

#' @rdname ard_missing.survey.design
#' @export
ard_missing.svyrep.design <- ard_missing.survey.design

#' @rdname ard_tabulate.survey.design
#' @export
ard_tabulate.svyrep.design <- ard_tabulate.survey.design

#' @rdname ard_tabulate_value.survey.design
#' @export
ard_tabulate_value.svyrep.design <- ard_tabulate_value.survey.design

#' @rdname ard_summary.survey.design
#' @export
ard_summary.svyrep.design <- ard_summary.survey.design

#' @rdname ard_total_n.survey.design
#' @export
ard_total_n.svyrep.design <- ard_total_n.survey.design
