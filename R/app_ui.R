app_ui <- function() {
  semanticPage(
    title = "Shiny Ships",
    margin = "10px 10%",
    h1("Shiny Ships"),
    ui_ship_selection(),
    segment(
      class = "raised",
      leaflet::leafletOutput("map", height = "600px")
    ),
    segment(
      h3(class = "header", "Map settings"),
      checkboxInput("labels", "Show labels")
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
