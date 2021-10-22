# University innovation dataset --------
univ_innov = read_csv("data/university_innovation.csv") %>% 
  mutate(across(starts_with("instit"), as_factor))# making institution and hasbitnet be factor variables instead of numeric

## Question 1 data
q1_univ_innov = univ_innov %>% 
  mutate(coauthorship = ifelse(allcoauths > 0, 1, 0)) %>%
  mutate(both_have_bitnet = hasbitnet1 * hasbitnet2)

## Question 2 data

q2_univ_innov = q1_univ_innov %>% 
  mutate(allcoauths = allcoauths +1,
         totsoloauths = totsoloauths + 1) %>% 
  mutate(coauthorship_ratio = allcoauths/(totsoloauths + allcoauths)) %>% 
  mutate(coauthorship = as_factor(coauthorship))






# Patents dataset -------
patents = read_csv("data/indigo_patents.csv")
