# University innovation dataset --------
univ_innov = read_csv("data/university_innovation.csv") %>% 
  mutate(across(starts_with("instit"), as_factor))# making institution and hasbitnet be factor variables instead of numeric

q1_univ_innov = univ_innov %>% 
  mutate(coauthorship = ifelse(allcoauths > 0, 1, 0)) %>%
  mutate(both_have_bitnet = hasbitnet1 * hasbitnet2)








# Patents dataset -------
patents = read_csv("data/indigo_patents.csv")
