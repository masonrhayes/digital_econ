# Load libraries and repeated functions
source("scripts/source.R")

# Load data -- put all code in this file for any mutations/changes that are not temporary
source("scripts/load_data.R")

# Question 1------

## How many unique institutions are there? ----

length(unique(univ_innov$instit1)) # there are 269

q1_model = q1_univ_innov %>%
  felm(formula = coauthorship ~ l_distance + both_have_bitnet + totsoloauths | instit2)

## Look at Q1 Model and coefficients
summary(q1_model)

round(q1_model$coefficients*100, digits = 4)

# Write model to latex
q1_model %>% 
  stargazer("latex", out = "output/q1_model.tex")


