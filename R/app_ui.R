app_ui <- function() {
  semanticPage(
    title = "Shiny Ships",
    ui_ship_selection()
  )
}

ui_ship_selection <- function() {
  ns <- NS(NS_SHIP_SELECTION)

  split_layout(
    # TODO: add labels
    dropdown_input(ns("type"), ships$types, value = ships$types[1]),
    dropdown_input(ns("name"), NULL)
  )
}
