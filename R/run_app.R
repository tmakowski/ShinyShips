#' Run ShinyShips application
#'
#' @param ... Arguments passed on to `shiny::runApp`.
#'
#' @import shiny
#' @import shiny.semantic
#'
#' @export
run_app <- function(...) {
  app <- shinyApp(app_ui(), app_server)
  runApp(app, ...)
}
