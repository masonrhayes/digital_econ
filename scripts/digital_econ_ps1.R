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

# uncomment to write to tex -----
# 
### q1_model %>%  stargazer("latex", out = "output/q1_model.tex")

# Question 2 -----------
## value_of_collaboration = \beta l_distance + \alpha both_have_bitnet + \mu_{ij}

t = q2_univ_innov %>% 
  group_by(both_have_bitnet, instit1) %>% 
  summarize(across(contains(c("auth", "dist", "both")), mean)) %>% 
  arrange(instit1)

view(t)

q2_model = logistic_reg(engine = "glm")

q2_model_fit = q2_model %>% 
  fit.model_spec(coauthorship ~ l_distance + both_have_bitnet + totsoloauths, data = q2_univ_innov)
  

q2_model_fit %>% tidy()


distances = tibble(l_distance = rep(seq(0, 9, 0.1),2),
                   both_have_bitnet = c(rep(0, 91), rep(1,91)),
                   totsoloauths = mean(q2_univ_innov$totsoloauths))

pred_prob_of_coauthorship = predict(q2_model_fit, 
                                    new_data = distances, 
                                    type = "prob")

distances %>% 
  bind_cols(pred_prob_of_coauthorship) %>% 
  mutate(both_have_bitnet = as_factor(
    ifelse(both_have_bitnet ==1, "yes", "no"))
    ) %>% 
  ggplot(aes(l_distance, .pred_1))+
  geom_smooth(aes(color = both_have_bitnet))+
  ft_theme()+
  scale_color_economist()+
  ylab("Predicted probability of coauthorship")+
  xlab("Log of Distance")+
  labs(col = "Both have Bitnet")
