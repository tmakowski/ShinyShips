#' Run ShinyShips application
#'
#' @param ... Arguments passed on to `shiny::shinyApp` `options` argument.
#'
#' @import shiny
#' @import shiny.semantic
#'
#' @export
run_app <- function(...) {
  shinyApp(app_ui(), app_server, options = list(...))
}
