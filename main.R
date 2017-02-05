library(tidyverse)
library(rvest)

source("utils.R")

#---------------
# read data
#---------------
coaches <- read.csv("input_data_table.csv", header = TRUE, as.is = TRUE, quote = "")
coaches$career_records <- apply(coaches, 1, grab_records)
# why not working? 
#coaches <- src %>% mutate(career_records = apply(coaches, 1, grab_records))
setNames(coaches$career_records, coaches$Coach)
# latest wins
coaches$latest_wins <- coaches$career_records %>% map_int(function(x) x$win_cum[nrow(x)])

#---------------
# total wins
#---------------
coaches %>% ggplot(aes(x = reorder(Coach, latest_wins), y = latest_wins)) + geom_bar(stat = "identity") + coord_flip() + theme_bw()

#---------------
# win by career year
#---------------
#df_career_records <- bind_rows(coaches$career_records, .id = "Coach")
#df_career_records <- rbindlist(coaches$career_records, idcol = "Coach")

df_career_records <- coaches %>% unnest() %>% select(Coach, career_yr, win_cum)
df_career_records$type <- ifelse(df_career_records$Coach %in% c("Dean Smith", "Roy Williams", "Coach K"), TRUE, FALSE)
df_career_records %>% ggplot(aes(x = career_yr, y = win_cum)) + geom_point(aes(group = Coach, colour = type)) + geom_line(aes(group = Coach, colour = type)) + theme_bw() + stat_smooth()

