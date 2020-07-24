#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  p_grid <- seq(0.01, 0.15, .01)
  seasons <- get_seasons(nfl_scores)
  results <- mod_load_data_server('load_data_ui_1', df = nfl_scores)
  
  mod_prob_plots_server("prob_plots_ui_1", results, p_grid, seasons)
  
  shiny::observeEvent(input$done, {
    shiny::stopApp()
  })
}
