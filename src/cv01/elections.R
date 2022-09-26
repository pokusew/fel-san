library(dplyr)

setwd("./elections")
electionData <- read.csv("GlobalElections_Czech elections.csv")

lower_house_elections <- electionData %>%
  filter(legid == 1)

# TASK 1: Create pie charts showing election attendence (voters vs. non-voters) for all lower house elections
# (years 96, 98, 02 and 06)

# We want this table:
#    year     votes_total
# 1  1996     6573423
# 2  1998     6554186
# 3  2002     4768006
# 4  2006     5348976
votes_total_per_year <- lower_house_elections %>%
  group_by(year) %>%
  summarise(votes_total = sum(dtv))
# how it would look without dplyr:
# votes_total_per_year <- aggregate(lower_house_elections$dtv, by=list(lower_house_elections$year), FUN=sum)

population_per_year <- c(7990770, 8116836, 8264482, 8333305)

# Create table:
# voters_perc non_voters_perc
# 82.3            17.7
# 80.7            19.3
# 57.7            42.3
# 64.2            35.8
pie_data <- data.frame(
  voters_perc = ____,
  non_voters_perc = _____
)

# Prepare placeholders for 4 pie charts
par(mfrow = c(2, 2))

for(i in  1:nrow(pie_data)){
  labels <- c(
    paste0("Voters ", ____, "%"),
    paste0("Non-voters ", ____, "%")
  )
  pie(x = as.numeric(pie_data[i,]), labels = labels)
}

# ====================================================================================================
# TASK 2: Create a bar chart showing results for lower house elections 2006.
#     display number of seats each qualified party aquired
# ------------------------------------------------------------------------------------
electionLabels <- read.csv("labels.csv", stringsAsFactors = FALSE, encoding = 'UTF-8')

lh_2006 <- _____

# Select only columns indicating number of seats for each party (suffix "s" for seats)
ps_cols <- grep("p[0-9]*s", colnames(lh_2006), value = TRUE)

# Create table with seats for each qualified party
# p1s p2s p3s p8s p16s
#   6  74  13  81   26
total_ps <- ____

# Replace party codes with party names
winning_party_codes <- gsub("s", "" , colnames(total_ps))

party_names <- electionLabels %>%
  select(winning_party_codes)

names(total_ps) <- party_names

# Create a table for plotting
#                                                   Strana Zelených [SZ]  6
#                              Česká Strana Sociálně Demokratická [ČSSD] 74
#  Křesťanská a Demokratická Unie-Československá Strana Lidová [KDU-CSL] 13
#                                     Občanská Demokratická Strana [ODS] 81
#                             Komunistická Strana Čech and Moravy [KSČM] 26
barplot_data <- as.data.frame(t(total_ps)) %>%
  tibble::rownames_to_column("Party")

p <- ggplot(data=barplot_data, aes(x=Party, y=V1, fill=Party)) +
  geom_bar(stat="identity") +
  theme(axis.text.x=element_blank()) +
  scale_fill_brewer(palette="Set1")
# View the plot
p
