app_server <- function(input, output, session) {
  moduleServer(NS_SHIP_SELECTION, server_ship_selection, session)
}

server_ship_selection <- function(input, output, session) {
  observe({
    type <- input$type
    update_dropdown_input(session, "name", ships$type_names[[type]])
  })
}
