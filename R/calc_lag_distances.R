#' Calculate distance between consecutive points
#'
#' @param lats A numeric vector of latitude values.
#' @param lons A numeric vector of longitude values.
#'
#' @return A numeric vector of distances in meters between consecutive pairs of
#'   points. Preceeded by a `NA`.
calc_lag_distances <- function(lats, lons) {
  assertthat::assert_that(
    is.atomic(lats), is.numeric(lats),
    is.atomic(lons), is.numeric(lons),
    length(lats) == length(lons),
    length(lats) > 1
  )

  dists <- sapply(2:length(lats), function(i) {
    geosphere::distGeo(c(lats[i - 1], lons[i - 1]), c(lats[i], lons[i]))
  })

  c(NA, dists)
}
