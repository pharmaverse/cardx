# ard_attributes.survey.design() and ard_attributes.svyrep.design() works

    Code
      attr(dclus1$variables$sname, "label") <- "School Name"
      attr_des <- as.data.frame(ard_attributes(dclus1, variables = c(sname, dname), label = list(dname = "District Name")))

---

    Code
      attr(rclus1$variables$sname, "label") <- "School Name"
      attr_rep <- as.data.frame(ard_attributes(rclus1, variables = c(sname, dname), label = list(dname = "District Name")))

