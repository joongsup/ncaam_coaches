
grab_records <- function(src){
  
  coach <- src[["URL"]] %>% read_html() %>% html_nodes(xpath = src[["Table"]]) %>% html_table(fill = TRUE)
  records <- coach[[1]]$Overall
  year <- coach[[1]]$Season
  df_coach <- tibble(year, records)
  df_coach <- df_coach %>% filter(nchar(records) < 6)
  df_coach <- df_coach %>% separate(records, c("win", "loss"), convert = TRUE)
  df_coach <- df_coach %>% mutate(win_cum = cumsum(win), career_yr = row_number())
  
  df_coach
}