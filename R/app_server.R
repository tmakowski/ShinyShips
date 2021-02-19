#' @importFrom pipeR %>>%
app_server <- function(input, output, session) {
  name <- moduleServer(NS_SHIP_SELECTION, server_ship_selection, session)

  details <- reactive({
    ships$distances[ship_name == name()]
  })

  output$map <- leaflet::renderLeaflet({
    dets <- details()

    leaflet::leaflet() %>>%
      leaflet::addTiles() %>>%
      leaflet::addMarkers(
        lng = c(dets$lon_start, dets$lon_end),
        lat = c(dets$lat_start, dets$lat_end)
      )
  })
}

server_ship_selection <- function(input, output, session) {
  observe({
    type <- input$type
    update_dropdown_input(session, "name", ships$type_names[[type]])
  })

  reactive(input$name)
}
