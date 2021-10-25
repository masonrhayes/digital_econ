# University innovation dataset --------
univ_innov = read_csv("data/university_innovation.csv") %>% 
  mutate(across(starts_with("instit"), as_factor))# making institution and hasbitnet be factor variables instead of numeric

## Question 1 data
q1_univ_innov = univ_innov %>% 
  mutate(coauthorship = ifelse(allcoauths > 0, 1, 0)) %>%
  mutate(both_have_bitnet = hasbitnet1 * hasbitnet2) %>% 
  mutate(fraction_coauthored = allcoauths/(totsoloauths + allcoauths)) %>% 
  mutate(fraction_soloauthored = 1 - fraction_coauthored)

## Question 2 data

q2_univ_innov = q1_univ_innov %>% 
  mutate(allcoauths = allcoauths +1,
         totsoloauths = totsoloauths + 1)%>% 
  mutate(coauthorship = as_factor(coauthorship))




# Patents dataset -------
patents = read_csv("data/indigo_patents.csv") %>% 
  mutate(twea_passed = ifelse(ten_yr >= 1917, 1, 0)) %>% 
  mutate(ten_yr_count_total = ten_yr_count_france + ten_yr_count_germany + ten_yr_count_usa) %>% 
  mutate(ten_yr_german_share = ten_yr_count_germany/ten_yr_count_total)

## Create treatment group = class IDs where German patents are present

german_data = patents %>% 
  group_by(class_id) %>% 
  filter(ten_yr_count_germany > 0)

french_data = patents %>% 
  group_by(class_id) %>% 
  filter(ten_yr_count_france > 0)

us_data = patents %>% 
  group_by(class_id) %>% 
  filter(ten_yr_count_usa > 0)


patents = patents %>% 
  mutate(french_presence = ifelse(class_id %in% french_data$class_id, 1 , 0)) %>% 
  mutate(german_presence = ifelse(class_id %in% german_data$class_id, 1, 0)) %>% 
  mutate(us_presence = ifelse(class_id %in% us_data$class_id, 1, 0)) %>% 
  mutate(treated_group = german_presence) %>% 
  mutate(did = treated_group * twea_passed)


