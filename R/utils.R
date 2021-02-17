#' Get unique rows from a `data.frame`
#'
#' @param dt An input `data.frame`.
#' @param col_names A vector of column names to subset from `df`.
#'
#' @return A `data.frame` with unique rows.
get_unique_rows <- function(dt, col_names) {
  assertthat::assert_that(
    is.data.table(dt),
    is.vector(col_names),
    length(col_names) > 0,
    all(col_names %in% colnames(dt))
  )

  unique_rows <- unique(dt[, ..col_names, drop = FALSE])
  rownames(unique_rows) <- NULL
  unique_rows
}
