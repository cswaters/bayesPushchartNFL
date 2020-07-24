#' load_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList numericInput
mod_load_data_ui <- function(id, max_sprd) {
  shiny::tagList(
    shiny::fillRow(
      shiny::numericInput(
        inputId = NS(id, 'sprd'),
        label = 'Select spread',
        min = 1,
        max = max_sprd,
        value = 3,
        width = "50%"
      ),
      shiny::numericInput(
        inputId = NS(id, 'wnd'),
        label = 'Select window',
        min = 0,
        max = 3,
        step = .5,
        value = 0,
        width = "50%"
      )
    )
  )

}

#' load_data Server Function
#'
#' @noRd
mod_load_data_server <- function(id, df) {
  shiny::moduleServer(id, function(input, output, session) {
    pt_sprd <- shiny::reactive({
      get_push_results(seq(1, get_n_percentile(df, sprv)),
                       df,
                       input$wnd) %>%
        ps_filter_df(input$sprd)
    })
    shiny::reactive(pt_sprd())
  })
  
}

## To be copied in the UI
# mod_load_data_ui("load_data_ui_1")

## To be copied in the server
# callModule(mod_load_data_server, "load_data_ui_1")
