get_games <- function(df, .ps, .wnd) {
  df %>%
    dplyr::mutate(
      match_sprd_h = dplyr::between(sprv, .ps - .wnd, .ps + .wnd) * 1,
      match_sprd_v = dplyr::between(sprv, -.ps - .wnd, -.ps + .wnd) *
        1,
      pushed_h = (match_sprd_h == 1) & ((ptsh - ptsv) == .ps),
      pushed_v = (match_sprd_v == 1) & ((ptsv - ptsh) == .ps)
    )
}

push_subtotals <- function(df) {
  df %>%
    dplyr::group_by(seas) %>%
    dplyr::summarise(
      games = dplyr::n(),
      # total n games
      tot_match_h = sum(match_sprd_h),
      # n games matching spread @ home
      tot_match_v = sum(match_sprd_v),
      # n games matching spread visitor
      tot_push_h = sum(pushed_h),
      # home fav pushes
      tot_push_v = sum(pushed_v) # away fav pushes
    ) %>%
    dplyr::ungroup()
}

push_pcts <- function(df) {
  df %>%
    dplyr::transmute(
      seas,
      games,
      games_in_wnd = tot_match_h + tot_match_v,
      # games fall in between window
      games_pushed = tot_push_h + tot_push_v,
      # games pushed of window games
      seas_push_pct = games_pushed / games_in_wnd,
      cum_wnd_games = cumsum(games_in_wnd),
      # cum by season window games
      cum_pushes = cumsum(games_pushed),
      # cum pushes by season
      cum_push_pct = cum_pushes / cum_wnd_games # push pct cum by season
    )
}

push_chart_pipeline <- function(df, .ps, .wnd=0) {
  get_games(df, .ps, .wnd) %>%
    push_subtotals() %>%
    push_pcts()
}


clean_push_results <- function(.push_results) {
  .push_results %>%
    dplyr::mutate(
      seas_push_pct = ifelse(is.na(seas_push_pct), 0, seas_push_pct),
      cum_push_pct = ifelse(is.na(cum_push_pct), 0, cum_push_pct)
    )
}


#' Get push results for a set of point spreads
#'
#' @param .pt_sprds numeric vector. Set of point spreads
#' @param .scores_df dataframe. Final scores, point spread, and season
#' @param .wnd window of points to include in the push results
#'
#' @return dataframe
#' @export
#'
#' @examples
#' /dontrun{
#'  get_push_results(1:14, nfl_scores, 1.5)
#' }
get_push_results <- function(.pt_sprds, .scores_df, .wnd = 0) {
  .pt_sprds %>%
    purrr::map(
      ~ push_chart_pipeline(df = .scores_df, .ps = .x, .wnd = .wnd) %>%
        dplyr::mutate(ps = .x) %>%
        dplyr::select(ps, dplyr::everything())
    ) %>%
    dplyr::bind_rows() %>% 
    clean_push_results()
}

