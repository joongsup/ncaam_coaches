install.packages("rvest")
url <- "https://en.wikipedia.org/wiki/Roy_Williams_(coach)#Head_coaching_record"

library(tidyverse)
library(rvest)

rw <- url %>% read_html() %>% 
  html_nodes(xpath = "//*[@id=\"mw-content-text\"]/table[3]") %>% html_table(fill = TRUE)

rw_records <- rw[[1]]$Overall
rw_year <- rw[[1]]$Season
df_rw <- tibble(rw_year, rw_records)
df_rw <- df_rw %>% filter(nchar(rw_records) < 6)
df_rw <- df_rw %>% separate(rw_records, c("win", "loss"), convert = TRUE)
df_rw <- df_rw %>% mutate(win_cum = cumsum(win), career_yr = row_number())

df_rw %>% ggplot(aes(x = career_yr, y = win_cum)) + geom_point()

src <- read.csv("input_data_table.csv", header = TRUE, as.is = TRUE, quote = "")
coach <- src[2, "URL"] %>% read_html() %>% html_nodes(xpath = src[2, "Table"]) %>% html_table(fill = TRUE)
records <- coach[[1]]$Overall
year <- coach[[1]]$Season
df_coach <- tibble(year, records)
df_coach <- df_coach %>% filter(nchar(records) < 6)
df_coach <- df_coach %>% separate(records, c("win", "loss"), convert = TRUE)
df_coach <- df_coach %>% mutate(win_cum = cumsum(win), career_yr = row_number())

src$career_records <- apply(src, 1, grab_records)

coaches <- read.csv("input_data_table.csv", header = TRUE, as.is = TRUE, quote = "")
coaches$career_records <- apply(coaches, 1, grab_records)
coaches$latest_win_total <- 
  
map_int(coaches$carrer_records, win_cum)
