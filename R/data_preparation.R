#' Prepare sysdata.rda with processed ships data
#'
#' @param ships_data_path A path to ships.csv input data.
#' @param ... Arguments passed on to `usethis::use_data`.
prepare_data <- function(ships_data_path, ...) {
  assertthat::assert_that(
    is.character(ships_data_path), length(ships_data_path) == 1,
    file.exists(ships_data_path)
  )

  ships_data <- data.table::fread(ships_data_path)
  type_names <- get_type_names_mapping(ships_data)

  ships <- list(
    types = names(type_names),
    type_names = type_names,
    distances = get_ships_distances(ships_data)
  )

  usethis::use_data(ships, internal = TRUE, ...)

  invisible(ships)
}

#' Extract ship type to names mapping
#'
#' @param ships A `data.table` with ships raw data.
#'
#' @return A named `list` with ship types as names and ship names as elements.
get_type_names_mapping <- function(ships) {
  assertthat::assert_that(data.table::is.data.table(ships))

  ship_types <- sort(unique(ships$ship_type))

  type_names <- list()
  for (type in ship_types) {
    type_names[[type]] <- sort(unique(ships[ship_type == type]$SHIPNAME))
  }

  type_names
}

#' Extract max distance per ship between consecutive observations
#'
#' @inheritParams get_type_names_mapping
#'
#' @return A `data.table` with SHIP_ID, travel start point, end point, and
#'   travelled distance for the maximum travelled distance.
#'
#' @import data.table
get_ships_distances <- function(ships) {
  assertthat::assert_that(data.table::is.data.table(ships))

  ships_coords <- ships[order(DATETIME), .(SHIPNAME, LAT, LON)]

  # Removing rows where the ship has not moved and omitting stationary ships
  unique_coords <- unique(ships_coords)
  moving_ships <- unique_coords[, .(LAT, LON, n = .N), by = .(SHIPNAME)][n > 1]

  sailed_dists <- moving_ships[,
    .(
      dist      = calc_lag_distances(LAT, LON),
      lat_start = data.table::shift(LAT),
      lon_start = data.table::shift(LON),
      lat_end   = LAT,
      lon_end   = LON
    ),
    by = .(SHIPNAME)
  ]

  max_dists <- sailed_dists[,
    .(
      max_dist = max(dist, na.rm = TRUE)
    ),
    by = .(SHIPNAME)
  ]

  max_dists_coords <- max_dists[sailed_dists, on = .(SHIPNAME)][max_dist == dist]

  # Rows are sorted by DATETIME therefore, tail(..., 1) is latest observation
  max_dists_coords[,
    .(
      dist      = tail(dist, 1),
      lat_start = tail(lat_start, 1),
      lon_start = tail(lon_start, 1),
      lat_end   = tail(lat_end, 1),
      lon_end   = tail(lon_end, 1)
    ),
    by = SHIPNAME
  ]
}
