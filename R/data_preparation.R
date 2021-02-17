#' Extract unique ship type and name pairs
#'
#' @param ships_data_path A path to ships.csv input data.
#'
#' @return A `data.table` with unique (ship type, ship name) pairs.
get_unique_type_name_pairs <- function(ships_data_path) {
  assertthat::assert_that(
    is.character(ships_data_path), length(ships_data_path) == 1,
    file.exists(ships_data_path)
  )

  ships <- data.table::fread(ships_data_path)
  get_unique_rows(ships, c("ship_type", "SHIPNAME"))
}
