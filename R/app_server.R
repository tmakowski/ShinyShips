#' @importFrom pipeR %>>%
app_server <- function(input, output, session) {
  name <- moduleServer(NS_SHIP_SELECTION, server_ship_selection, session)

  details <- reactive({
    ships$distances[ship_name == name()]
  })

  # Tiles updater -------------------------------------------------------------
  observe({
    tiles <- leaflet::providers$CartoDB.PositronNoLabels
    if (input$labels) {
      tiles <- leaflet::providers$CartoDB.Positron
    }

    leaflet::leafletProxy("map") %>>%
      leaflet::clearTiles() %>>%
      leaflet::addProviderTiles(tiles)
  })

  # Map output -----------------------------------------------------------------
  output$map <- leaflet::renderLeaflet({
    dets <- details()

    # TODO: handle lack of data
    leaflet::leaflet() %>>%
      leaflet::addMarkers(
        lng = c(dets$lon_start, dets$lon_end),
        lat = c(dets$lat_start, dets$lat_end),
        label = c("Start", "End")
      )
  })

  # Map settings ---------------------------------------------------------------
  show_settings <- reactiveVal(FALSE)

  observeEvent(input$map_settings_toggle, {
    show <- !show_settings()
    show_settings(show)

    btn_label <- paste(if (show) "Hide" else "Show", "settings")
    update_action_button(session, "map_settings_toggle", label = btn_label)

    shinyjs::toggleElement("map_settings", condition = show)
  })
}

server_ship_selection <- function(input, output, session) {
  observe({
    type <- input$type
    update_dropdown_input(session, "name", ships$type_names[[type]])
  })

  reactive(input$name)
}
