app_ui <- function() {
  semanticPage(
    h1("Hello world!"),
    ui_ship_selection()
  )
}

ui_ship_selection <- function() {
  ns <- NS(NS_SHIP_SELECTION)

  split_layout(
    dropdown_input(ns("type"), ships$types),
    dropdown_input(ns("name"), NULL)
  )
}
