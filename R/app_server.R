#' @importFrom pipeR %>>%
app_server <- function(input, output, session) {
  ship <- moduleServer(NS_SHIP_SELECTION, server_ship_selection, session)

  details <- reactive({
    s <- ship()
    ships$distances[ship_type == s$type & ship_name == s$name]
  })

  # Map output -----------------------------------------------------------------
  output$map <- leaflet::renderLeaflet({
    dets <- details()
    tiles <- isolate(map_tiles())

    m <- leaflet::leaflet() %>>% leaflet::addProviderTiles(tiles)

    if (nrow(dets) == 0) {
      return(m)
    }

    has_moved <- !is.na(dets$dist)
    if (has_moved) {
      labels <- c("Ship's position", "Ships's destination")
      icon_names <- c("ship", "arrow-down")
      lng <- c(dets$lon_start, dets$lon_end)
      lat <- c(dets$lat_start, dets$lat_end)
    } else {
      labels <- "Ship's position"
      icon_names <- "ship"
      lng <- dets$lon_end
      lat <- dets$lat_end
    }

    m %>>%
      leaflet::addAwesomeMarkers(
        lng = lng,
        lat = lat,
        label = labels,
        icon = leaflet::awesomeIcons(icon_names, "fa")
      )
  })

  # Travelled distance ---------------------------------------------------------
  output$dist <- renderText({
    dets <- details()
    dist <- dets$dist
    req(!is.null(dist))

    if (is.na(dist)) {
      return("Ship did not move")
    }

    paste("Travelled distance:", round(dist, 2) , "m")
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
    update_dropdown_input(session, "name", ships$type_names[[type]])
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

  reactive(list(type = input$type, name = input$name))
}
