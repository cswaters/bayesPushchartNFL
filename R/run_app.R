#' Run the Shiny Application
#'
#' @param ... A series of options to be used inside the app.
#'
#' @export
#' @importFrom shiny runGadget paneViewer
#' @importFrom golem with_golem_options
run_app <- function(
  ...
) {
  with_golem_options(
    app = shiny::runGadget(
      app = app_ui, 
      server = app_server,
      viewer = shiny::paneViewer(300)
    ), 
    golem_opts = list(...)
  )
}
