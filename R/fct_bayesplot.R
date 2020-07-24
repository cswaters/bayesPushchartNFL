calc_bayes <- function(df, x, p_grid) {
  prior <- rep(1, length(p_grid))
  likelihood <- dbinom(
    x = df$cum_pushes[x],
    size = df$cum_wnd_games[x],
    prob = p_grid
  )
  bayes_numerator <- likelihood * prior
  posterior <-
    bayes_numerator / sum(bayes_numerator)
  posterior
}
calc_push_val <- function(df, p_grid) {
  n_records <- 1:nrow(df)
  n_records %>%
    purrr::map_dfc(~ calc_bayes(df = df, x = .x, p_grid = p_grid))
}
plot_push_probs <- function(df, p_grid) {
  n <- length(p_grid)
  g <- data.frame(
    p_grid = p_grid,
    prior = rep(1 / n, n)
  ) %>%
    dplyr::bind_cols(df) %>%
    tidyr::gather(key, val, -p_grid) %>%
    dplyr::mutate(posterior=round(val,3),
                  pushrate=p_grid) %>% 
    ggplot2::ggplot(ggplot2::aes(pushrate, posterior)) +
    #ggplot2::geom_point(shape=2) +
    #ggplot2::geom_line() +
    ggplot2::geom_area(alpha=.3) +
    ggplot2::scale_x_continuous(labels = scales::percent_format()) +
    ggplot2::scale_y_continuous(labels = scales::percent_format()) +
    ggplot2::facet_wrap(dplyr::vars(key)) +
    ggplot2::labs(x="", y = "Posterior probability") +
    ggplot2::theme_minimal(base_size = 7)
  plotly::ggplotly(g) %>% 
    plotly::config(displayModeBar = FALSE)
}

get_push_estimates <- function(df, p_grid, seasons) {
  pushes <- calc_push_val(df, p_grid) %>%
    purrr::set_names(seasons)
  plot_push_probs(pushes, p_grid)
}
