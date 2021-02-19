#' Prepare sysdata.rda with processed ships data
#'
#' @param ships_data_path A path to ships.csv input data.
#' @param ... Arguments passed on to `usethis::use_data`.
#'
#' @examples
#' \dontrun{
#' prepare_data("dev/data_raw/ships.csv.gz", overwrite = TRUE)
#' }
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
#' @param ships_data A `data.table` with ships raw data.
#'
#' @return A named `list` with ship types as names and ship names as elements.
get_type_names_mapping <- function(ships_data) {
  assertthat::assert_that(
    data.table::is.data.table(ships_data),
    nrow(ships_data) > 0
  )

  ship_types <- sort(unique(ships_data$ship_type))

  type_names <- list()
  for (type in ship_types) {
    type_names[[type]] <- sort(unique(ships_data[ship_type == type]$SHIPNAME))
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
get_ships_distances <- function(ships_data) {
  assertthat::assert_that(
    data.table::is.data.table(ships_data),
    nrow(ships_data) > 0
  )

  ships_coords <- ships_data[order(DATETIME), .(SHIPNAME, LAT, LON)]

  # Removing consecutive rows where the ship has not moved - leaving only the
  # newest (sorted by DATETIME) observation
  ships_coords[,
    has_moved := data.table::shift(LAT, type = "lead") != LAT |
      data.table::shift(LON, type = "lead") != LON,
    by = .(SHIPNAME)
  ]
  unique_coords <- ships_coords[has_moved | is.na(has_moved)]

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
  ships_distances <- max_dists_coords[,
    .(
      dist      = tail(dist, 1),
      lat_start = tail(lat_start, 1),
      lon_start = tail(lon_start, 1),
      lat_end   = tail(lat_end, 1),
      lon_end   = tail(lon_end, 1)
    ),
    by = SHIPNAME
  ]

  data.table::setnames(ships_distances, "SHIPNAME", "ship_name")

  ships_distances
}
