## code to prepare `nfl_scores` dataset goes here
fb_link <- 'https://www.dropbox.com/s/u36f8ftdrs7dle5/GAME.csv?dl=1'
nfl_scores <- vroom::vroom(fb_link)
nfl_scores <- dplyr::filter(nfl_scores, !is.na(sprv)) # drop missing spreads
nfl_scores <- dplyr::select(nfl_scores, gid, seas, wk, ptsh, ptsv, sprv)
usethis::use_data(nfl_scores, overwrite = TRUE)

