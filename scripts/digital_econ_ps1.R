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

summary(q1_model)

q1_model %>% tidy()

# Question 2 -----------
## value_of_collaboration = \beta l_distance + \alpha both_have_bitnet + \mu_{ij}

## Q2 Model B -----

q2_model_b = q2_univ_innov %>% 
  glm(formula = coauthorship ~ l_distance + both_have_bitnet + totsoloauths, family = "binomial")


q2_univ_innov %>% 
  mutate(pred_prob = predict(object = q2_model_b,
                             type = "response")) %>% 
  mutate(both_have_bitnet = as_factor(
    ifelse(both_have_bitnet ==1, "yes", "no"))
  ) %>% 
  ggplot(aes(l_distance, pred_prob))+
  geom_smooth(aes(color = both_have_bitnet))+
  ft_theme()+
  scale_color_economist()+
  ylab("Predicted probability of coauthorship")+
  xlab("Log of Distance")+
  labs(col = "Both have Bitnet")

## Sumarize the predicted probability of coauthorship between university i and j
q2_univ_innov %>% 
  mutate(pred_prob = predict(object = q2_model_b,
                             type = "response")) %>% 
  group_by(both_have_bitnet) %>%
  summarize(across(contains('pred'), list(mean, sd, min, max))) %>% 
  set_names(c("both_have_bitnet", "mean", "sd", "min", "max"))
  
q1_univ_innov %>% 
  group_by(both_have_bitnet) %>% 
  summarize(across(contains("auth"), mean))

q2_model_c = q2_univ_innov %>% 
  mutate(choose_coauthor_over_solo = ifelse(fraction_coauthored >= 0.50, 1, 0)) %>% 
  felm(formula = fraction_coauthored ~ l_distance + both_have_bitnet + totsoloauths | instit2)

q2_model_c %>% tidy()# %>% stargazer("latex", out = "output/q2_model_c.text")

## Probability of coauthorship is 0.1415 percentage points higher when both have bitnet


## Question 3 ---------
## The empirical counterpart is the mean fraction of coauthored papers

q3_summary = q2_univ_innov %>% 
  group_by(both_have_bitnet) %>% 
  summarize(across(contains("fraction_coauthored"), list(mean, sd, max))) %>% 
  setNames(., c("both_have_bitnet", "mean", "sd", "max")) # %>% stargazer(type = "latex", title = "Fraction Coauthored Summary Statistics", out = "output/q3_summary.tex")

q3_summary

## coauthorship rate vs log distance

q2_univ_innov %>% 
  mutate(both_have_bitnet = as_factor(
  ifelse(both_have_bitnet ==1, "yes", "no"))
) %>% 
  ggplot(aes(l_distance, fraction_coauthored))+
  geom_jitter(aes(color = both_have_bitnet))+
  ft_theme()+
  scale_color_economist()+
  ylab("Likelihood of choosing coauthorship over soloauthorship")+
  xlab("Log of Distance")+
  labs(col = "Both have Bitnet")

# question 4-------

