# Univ Innov ----------

# Q1 ----

q1_model %>%  stargazer(type = "latex", title = "Q1 Model" ,
                        out = "output/univ_innov/q1_model.tex",
                        label = "p1q1_model",
                        digits = 5,
                        dep.var.labels = "Coauthorship")


q2_model_c %>% tidy() 






# Question 3

q3_summary %>% stargazer(summary = FALSE,
                       type = "latex",
                       title = "Fraction Coauthored",
                       out = "output/univ_innov/q3_table.tex",
                       label = "q3_summary",
                       digits = 5)
# Question 4
# 
q4_model %>% stargazer(type = "latex",
                       title = "Log Linear Model with Institution FE",
                       out = "output/univ_innov/q4_table.tex",
                       label = "q4_table",
                       digits = 4)






# Patents -----------


## Q2 ------

q2_table %>% stargazer(summary = FALSE, type = "latex", title = "Ten Year Patent Filings, US and DE", out = "output/patents/q2_table.tex", label = "q2_table")

# throw models for q3 into stargazer ----

q3_model1 %>% stargazer(type = "latex", title = "Linear Model (no FE)", digits = 3, out = "output/patents/q3_model1.tex", label = "table3.1", dep.var.labels = "Ten Year Count USA")

q3_model2 %>% stargazer(type = "latex", title = "Linear Model (FE)", digits = 3, out = "output/patents/q3_model2.tex", label = "table3.2", dep.var.labels = "Ten Year Count USA")

# Question 5-------

q5_model %>% stargazer(type = "latex", title = "Treatment Effects by Year", digits = 3, out = "output/patents/q5_model.tex", label = "table5.1", dep.var.labels = "Ten Year Count USA")
# Q5 table

q5_table %>% stargazer(type = "latex", summary = FALSE, title = "Treatment Effects by Year", digits = 3, out = "output/patents/q5_table.tex", label = "table5.2", dep.var.labels = "Ten Year Count USA")

# Question 6 --------

placebo_model1 %>% 
  stargazer(type = "latex",
            title = "Placebo DiD 1",
            digits = 3,
            out = "output/patents/q6_placebo1.tex",
            label = "model6.1_placebo",
            dep.var.labels = "Ten Year Count USA")

placebo_model2 %>% 
  stargazer(type = "latex",
            title = "Placebo DiD 2",
            digits = 3,
            out = "output/patents/q6_placebo2.tex",
            label = "model6.1_placebo",
            dep.var.labels = "Ten Year Count FR")
