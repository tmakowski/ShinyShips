#' Get unique rows from a `data.frame`
#'
#' @param df An input `data.frame`.
#' @param col_names A vector of column names to subset from `df`.
#'
#' @return A `data.frame` with unique rows.
get_unique_rows <- function(df, col_names) {
  assertthat::assert_that(
    is.data.frame(df),
    is.vector(col_names),
    length(col_names) > 0,
    all(col_names %in% colnames(df))
  )

  unique_rows <- unique(df[, col_names, drop = FALSE])
  rownames(unique_rows) <- NULL
  unique_rows
}
