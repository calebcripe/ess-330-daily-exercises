# Name: Caleb Cripe
# Date: 02/24/25
# Purpose: Create a faceted plot of cumulative cases & deaths by US region.

library(tidyverse)
library(dplyr)
library(tidyr)
library(flextable)
library(ggplot2)
covid_data = read_csv('https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv')

df <- data.frame(
  state = state.name,
  abbrv = state.abb,
  region = state.region
)

covid_data <- left_join(covid_data, df, by = "state") 

covid_data <- covid_data %>%
  filter(!is.na(region))

covid_data <- covid_data %>%
  group_by(region, abbrv) %>%
  arrange(date) %>%
  mutate(
    daily_cases = cases - lag(cases, default = 0),
    daily_deaths = deaths - lag(deaths, default = 0),
    cumulative_cases = cumsum(cases),
    cumulative_deaths = cumsum(deaths),
  )

covid_data_long <- covid_data %>%
  pivot_longer(cols = c("cases", "deaths"),
               names_to = "metric",
               values_to = "value")

covid_data$date <- as.Date(covid_data$date)

ggplot(covid_data_long, aes(x = date, y = value, color = metric)) +
  geom_line() +
  labs(
    title = "Cumulative Cases & Deaths by US Region",
    x = "Date",
    y = "Total Count",
    color = "Metric"
  ) +
  facet_wrap(~ region) +
  theme_classic()        
    
  
