source("scripts/source.R")
source("scripts/load_data.R")

attach(patents)

view(patents)


patents %>% 
  group_by(twea_passed,ten_yr) %>% 
  mutate(france_germany_count_diff = ten_yr_count_germany - ten_yr_count_france) %>% 
  summarize(across(contains("count"), mean))

summary_stat_functions = list(~round(mean(.), 3),
                              ~round(sd(.), 3),
                              sum)
q1_table = patents %>% 
  group_by(twea_passed) %>% 
  summarize(across(contains(c("ten_yr_count_fr", "ten_yr_count_ge")), summary_stat_functions)) %>%
  setNames(., c("TWEA Passed", "FR Mean", "FR SD", "DE Mean", "DE SD"))

q1_table

q1_table_b = patents %>% 
  group_by(treated_group) %>% 
  summarize(across(contains(c("ten_yr_count_fr", "ten_yr_count_ge")), summary_stat_functions)) %>%
  setNames(., c("German AND French Presence", "FR Mean", "FR SD", "DE Mean", "DE SD"))

q1_table_b

# Question 2 ---------

q2_table = patents %>% 
  group_by(treated_group) %>% 
  summarize(across(contains(c("ten_yr_count_usa")), summary_stat_functions)) %>% 
  set_names(c("Treated Group", "Mean", "SD", "Count"))

q2_table = patents %>% 
  group_by(twea_passed, treated_group) %>% 
  summarize(across(contains(c("ten_yr_count_usa", "count_ger")), summary_stat_functions)) %>% 
  set_names(c("TWEA Passed", "Treated Group", "Mean US", "SD US", "Count US", "Mean DE", "SD DE", "Count DE")) %>% 
  arrange(`TWEA Passed`, `Treated Group`)

q2_table
# Question 3 ---------

q3_table = patents %>% 
  group_by(twea_passed) %>% 
  summarize(across(contains(c("count_f", "count_ger", "count_us")), summary_stat_functions)) %>% 
  setNames(., c("TWEA Passed", "FR Mean", "FR SD", "DE Mean", "DE SD", "US Mean", "US SD")) %>% arrange(`TWEA Passed`)

q3_table


q3_model1 = patents %>% 
  lm(formula = ten_yr_count_usa ~ twea_passed + treated_group + did)

summary(q3_model1)

q3_model2 = patents %>%
  mutate(class_id = as_factor(class_id),
         ten_yr = as_factor(ten_yr)) %>% 
  felm(formula = ten_yr_count_usa ~ did | class_id + ten_yr)

summary(q3_model2)

# see stargazer.R

patents %>% 
  group_by(treated_group) %>% 
  summarize(across(contains("ten_yr_c"), mean))


# Question 5 -----

patents %>% 
  filter(ten_yr %>% between(1899,1919)) %>% 
  group_by(treated_group, ten_yr) %>% 
  summarize(across(contains(c("ten_yr_count")), list(mean, sum)))
  

patents %>% 
  mutate(class_id = as_factor(class_id),
       ten_yr = as_factor(ten_yr)) %>% 
  felm(formula = ten_yr_count_usa ~ treated_group + treated_group*ten_yr) %>%
  summary()


q5_model = patents %>% 
  mutate(class_id = as_factor(class_id),
         ten_yr = as_factor(ten_yr)) %>% 
  felm(formula = ten_yr_count_usa ~  treated_group + treated_group*ten_yr | class_id)

q5_table = q5_model %>% 
  tidy() %>% 
  filter(term %notin% c("ten_yr1880", "ten_yr1890", "treated_group:ten_yr1880",
                        "treated_group:ten_yr1890", "treated_group"))
q5_table

## Does treatment effect change from 1920-1930 period to 1930-1940 period ?

beta = q5_model$coefficients
se = q5_model$se

(beta[6]-beta[7])/(sqrt(se[6]^2 + se[7]^2))

# Question 6 ----

## Placebo of french classes with TWEA passing

placebo_model1= patents %>% 
  mutate(class_id = as_factor(class_id),
         ten_yr = as_factor(ten_yr)) %>% 
  mutate(placebo_did_french = french_presence*twea_passed) %>% 
  felm(formula = ten_yr_count_usa ~ french_presence + twea_passed + placebo_did_french)

## Placebo of twea passing affecting french patent rates?
placebo_model2 =patents %>% 
  mutate(class_id = as_factor(class_id),
         ten_yr = as_factor(ten_yr)) %>% 
  felm(formula = ten_yr_count_france ~ treated_group + twea_passed + did)

# Question 7 -------

q7_model1 = patents %>% 
  mutate(class_id = as_factor(class_id),
         ten_yr = as_factor(ten_yr)) %>% 
  mutate(placebo_did_french = french_presence*twea_passed) %>% 
  felm(formula = ten_yr_count_germany ~ french_presence + twea_passed + placebo_did_french)

q7_model1 %>% tidy()

## In markets with French presence after TWEA, German patent filings went down. This is probably just because the French classes are the same as the German ones.

q7_model2 = patents %>% 
  mutate(class_id = as_factor(class_id),
         ten_yr = as_factor(ten_yr)) %>% 
  mutate(placebo_did_french = french_presence*twea_passed) %>% 
  felm(formula = ten_yr_count_germany ~ german_presence + twea_passed + did)

q7_model2 %>% 
  tidy()
