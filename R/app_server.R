#' @importFrom pipeR %>>%
app_server <- function(input, output, session) {
  name <- moduleServer(NS_SHIP_SELECTION, server_ship_selection, session)

  details <- reactive({
    ships$distances[ship_name == name()]
  })

  # Map output -----------------------------------------------------------------
  output$map <- leaflet::renderLeaflet({
    dets <- details()
    tiles <- isolate(map_tiles())

    # TODO: handle lack of data
    leaflet::leaflet() %>>%
      leaflet::addProviderTiles(tiles) %>>%
      leaflet::addAwesomeMarkers(
        lng = c(dets$lon_start, dets$lon_end),
        lat = c(dets$lat_start, dets$lat_end),
        label = c("Start", "End"),
        icon = leaflet::awesomeIcons(c("ship", "arrow-down"), "fa")
      )
  })

  # Travelled distance ---------------------------------------------------------
  output$dist <- renderText({
    dets <- details()
    round(dets$dist, 2)
  })

  # Map settings ---------------------------------------------------------------
  show_settings <- reactiveVal(FALSE)

  observeEvent(input$map_settings_toggle, {
    show <- !show_settings()
    show_settings(show)

    btn_label <- paste(if (show) "Hide" else "Show", "map settings")
    update_action_button(session, "map_settings_toggle", label = btn_label)

    shinyjs::toggleElement(
      "map_settings",
      anim = TRUE,
      time = 0.3,
      condition = show
    )
  })

  # Show labels setting updater ------------------------------------------------
  map_tiles <- reactiveVal(leaflet::providers$CartoDB.PositronNoLabels)

  observe({
    tiles <- leaflet::providers$CartoDB.PositronNoLabels
    if (input$show_labels) {
      tiles <- leaflet::providers$CartoDB.Positron
    }

    map_tiles(tiles)

    leaflet::leafletProxy("map") %>>%
      leaflet::clearTiles() %>>%
      leaflet::addProviderTiles(tiles)
  })

  # Show line setting updater --------------------------------------------------
  observe({
    dets <- details()
    m <- leaflet::leafletProxy("map") %>>% leaflet::clearShapes()

    if (input$show_line) {
      leaflet::addPolylines(
        m,
        lng = c(dets$lon_start, dets$lon_end),
        lat = c(dets$lat_start, dets$lat_end)
      )
    }
  })
}

server_ship_selection <- function(input, output, session) {
  observe({
    type <- input$type
    update_dropdown_input(session, "name", ships$type_names[[type]], value = NA)
  })

  observeEvent(input$type, ignoreInit = TRUE, once = TRUE, {
    shinyjs::enable("name")
    shinyjs::removeCssClass("card_type", "green")
    shinyjs::addCssClass("card_name", "green")
  })

  observeEvent(input$name, ignoreInit = TRUE, once = TRUE, {
    shinyjs::removeCssClass("card_name", "green")
    shinyjs::addCssClass("card_type", "blue")
    shinyjs::addCssClass("card_name", "blue")
    shinyjs::showElement("travelled_dist", asis = TRUE)
  })

  reactive(input$name)
}
