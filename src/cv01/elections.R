library(dplyr)
library(ggplot2)

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
voters_perc <- round((votes_total_per_year$votes_total / population_per_year) * 100, digits = 1)
non_voters_perc <- 100 - voters_perc
pie_data <- data.frame(
  voters_perc = voters_perc,
  non_voters_perc = non_voters_perc
)

# Prepare pdf file for the charts
# pdf(
#   file = "elections_attendence.pdf",
#   width = 10,
#   height = 10
# )
# Prepare placeholders for 4 pie charts
par(mfrow = c(2, 2))
for (i in seq_len(nrow(pie_data))) {
  labels <- c(
    paste0("Voters ", pie_data$voters_perc[i], "%"),
    paste0("Non-voters ", pie_data$non_voters_perc[i], "%")
  )
  pie(
    main = paste0("Elections ", votes_total_per_year$year[i]),
    x = as.numeric(pie_data[i,]),
    labels = labels,
    col = c("#39B500", "#FF7878")
  )
}
# Save and close the pdf file
# dev.off()

# ====================================================================================================
# TASK 2: Create a bar chart showing results for lower house elections 2006.
#     display number of seats each qualified party aquired
# ------------------------------------------------------------------------------------
electionLabels <- read.csv("labels.csv", stringsAsFactors = FALSE, encoding = "UTF-8")

lh_2006 <- lower_house_elections %>%
  filter(year == 2006) %>% # here we got data per district
  # sum (across districts) only columns indicating number of seats for each party (suffix "s" for seats)
  # special care must be taken to correctly sum NA and integers in one column
  summarise(across(matches("p[0-9]*s"), ~sum(.x, na.rm = TRUE)))

# Create table with seats for each qualified party
# p1s p2s p3s p8s p16s
#   6  74  13  81   26
# option 1: using dplyr's select
# total_ps <- lh_2006 %>%
#   select(where(~.x > 0))
# option 2: just plain R
total_ps <- lh_2006[, lh_2006 > 0]

# Replace party codes with party names
winning_party_codes <- gsub("s", "", colnames(total_ps))

party_names <- electionLabels %>%
  # all_of needed https://tidyselect.r-lib.org/reference/faq-external-vector.html
  select(all_of(winning_party_codes))

names(total_ps) <- party_names
row.names(total_ps) <- "Seats"

# Create a table for plotting
#                                                                  Party Seats
#                                                   Strana Zelených [SZ]  6
#                              Česká Strana Sociálně Demokratická [ČSSD] 74
#  Křesťanská a Demokratická Unie-Československá Strana Lidová [KDU-CSL] 13
#                                     Občanská Demokratická Strana [ODS] 81
#                             Komunistická Strana Čech and Moravy [KSČM] 26
barplot_data <- as.data.frame(t(total_ps)) %>%
  tibble::rownames_to_column("Party")

p <- ggplot(data = barplot_data, aes(x = Party, y = Seats, fill = Party)) +
  ylab("Number of seats") +
  ggtitle("Lower house elections 2006 in Czech Republic") +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_blank()) +
  # scale_fill_brewer(palette="Set1") +
  scale_fill_manual(values = c("#F34F1E", "#DB1521", "#FDCF37", "#003A86", "#48AC4A"))
# View the plot
p
# Save the plot as an image too
ggsave(
  # note: pdf has problems with accents (at least on macOS)
  #       see https://stackoverflow.com/questions/12768176/unicode-characters-in-ggplot2-pdf-output
  filename = "cz_lower_house_elections_2006.png",
  width = 3000,
  height = 2000,
  dpi = 320,
  units = "px"
)
