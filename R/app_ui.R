app_ui <- function() {
  semanticPage(
    shinyjs::useShinyjs(),
    title = "Shiny Ships",
    margin = "10px 10%",
    ui_ship_selection(),
    segment(
      class = "raised top attached",
      leaflet::leafletOutput("map", height = "600px")
    ),
    shinyjs::hidden(
      segment(
        id = "map_settings",
        class = "raised attached",
        checkbox_input("labels", "Show labels", is_marked = FALSE),
        checkbox_input("line", "Show line")
      )
    ),
    button(
      "map_settings_toggle",
      "Show settings",
      class = "bottom attached fluid"
    )
  )
}

ui_ship_selection <- function() {
  ns <- NS(NS_SHIP_SELECTION)

  cards(
    class = "two",
    style = "margin-right: 10%; margin-left: 10%;",
    card(
      div(
        class = "content",
        div(class = "header", "Ship type"),
        div(
          class = "description",
          dropdown_input(ns("type"), ships$types, value = ships$types[1])
        )
      )
    ),
    card(
      div(
        class = "content",
        div(class = "header", "Ship name"),
        div(class = "description", dropdown_input(ns("name"), NULL))
      )
    )
  )
}
