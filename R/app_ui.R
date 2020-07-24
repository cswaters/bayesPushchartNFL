#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    miniUI::miniPage(
      miniUI::gadgetTitleBar('bayesPushchartNFL'),
      miniUI::miniContentPanel(
        mod_prob_plots_ui("prob_plots_ui_1"),
        mod_load_data_ui("load_data_ui_1", 
                         max_sprd=get_n_percentile(nfl_scores, sprv))
        )
      )
    )
  
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'bayesPushchartNFL'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

