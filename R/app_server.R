app_server <- function(input, output, session) {
  name <- moduleServer(NS_SHIP_SELECTION, server_ship_selection, session)

  details <- reactive({
    ships$distances[ship_name == name()]
  })
}

server_ship_selection <- function(input, output, session) {
  observe({
    type <- input$type
    update_dropdown_input(session, "name", ships$type_names[[type]])
  })

  reactive(input$name)
}
