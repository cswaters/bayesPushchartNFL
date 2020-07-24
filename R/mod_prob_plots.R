#' prob_plots UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_prob_plots_ui <- function(id) {
  tagList(plotly::plotlyOutput(NS(id,'plot')))
}

#' prob_plots Server Function
#'
#' @noRd
mod_prob_plots_server <- function(id, df, p_grid, seasons) {
  shiny::moduleServer(id, function(input, output, session) {
    output$plot <- plotly::renderPlotly({
      get_push_estimates(shiny::req(df()), p_grid, seasons = seasons)
      
    })
    
  })
  
}

## To be copied in the UI
# mod_prob_plots_ui("prob_plots_ui_1")

## To be copied in the server
# callModule(mod_prob_plots_server, "prob_plots_ui_1")
