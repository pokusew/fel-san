library(tidyverse)

setwd("./elections")

# Load data and inspect the variables
electionData <- read.csv("GlobalElections_Czech elections.csv")

## Select
electionData2 <- electionData %>%
  select(year, district, legid, year, dtv, cnty, dm)

electionData2 <- electionData2 %>%
  select(-cnty, -dm)

## Filter
# Note, if we don't save the query result, it will be redirected to stdout
electionData2 %>%
  filter(legid == 1)

electionData2 %>%
  filter(year == 1998)

electionData2 %>%
  filter(year == 2000 & legid == 2)

## Mutate (add/alter a column)
electionData2 %>%
  mutate(mil_votes = dtv / 100000)

## Combination
electionData %>%
  select(year, district, legid, year, dtv) %>%
  filter(legid == 2) %>%
  mutate(mil_votes = dtv / 100000)

# ------------------- Advanced ---------------------
lowerHouseElections <- electionData %>%
  filter(legid == 1)

# What is the difference of voters for ODS and CSSD in district Jihocesky throughout the years (lower house)?
# Optional: pick your hometown district
# Hint: ODS ~ p8, CSSD ~ p2
lowerHouseElections %>%
  filter(cnty == 'Czech Republic' & district == 'Jihocesky') %>%
  select(year, dtv, dm, p8v, p2v) %>%
  mutate(diff_8_2 = p8v - p2v)

# What is the percentage of people voting for communists throughout the years (Jihocesky kraj)
# Optional: pick your hometown district
# Hint: KSCM ~ p16
lowerHouseElections %>%
  filter(cnty == "Czech Republic" & district == "Jihocesky") %>%
  mutate(pct_communists = p16v / dtv) %>%
  select(year, dtv, dm, p16v, pct_communists)

# How many people voted for left and how many people voted for right wing in 1998?
# Assume right wing ODS+KDU-CSL, left wing CSSD+KSCM
# Party codes: p2 CSSD, p3 KDU-CSL, p8 ODS, p16 KSCM
electionData %>%
  filter(legid == 1 &
           year == 1998 &
           cnty == "Czech Republic") %>%
  select(year, district, dtv, dm, p2v, p3v, p8v, p16v) %>%
  summarise(across(where(is.numeric), sum)) %>%
  mutate(votes_rightwing = p8v + p3v, votes_leftwing = p2v + p16v) %>%
  mutate(votes_check = votes_rightwing + votes_leftwing)

# More on the usage of summarise:
# https://dplyr.tidyverse.org/articles/colwise.html
