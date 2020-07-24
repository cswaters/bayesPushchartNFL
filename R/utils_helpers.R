get_seasons <- function(df) {
  paste0('seas_', unique(df$seas))
}

ps_filter_df <- function(df, .pt_sprd) {
  dplyr::filter(df, ps == .pt_sprd)
}

get_n_percentile <- function(df, .ps_col, .n=.98){
  df %>% 
    dplyr::pull({{.ps_col}}) %>% 
    quantile(.,.n) %>% 
    floor()
}




