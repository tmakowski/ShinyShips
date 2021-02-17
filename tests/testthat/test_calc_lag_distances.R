context("calc_lag_distances")

test_that("test calc_lag_distances", {
  # Assert check
  expect_error(calc_lag_distances(list(1, 2), c(1, 2)))
  expect_error(calc_lag_distances(c("1", "2"), c(1, 2)))
  expect_error(calc_lag_distances(c(1, 2), list(1, 2)))
  expect_error(calc_lag_distances(c(1, 2), c("1", "2")))
  expect_error(calc_lag_distances(c(1, 2), 1))
  expect_error(calc_lag_distances(1, 1))


  # Calculation check
  expect_equal(calc_lag_distances(c(1, 1), c(2, 2)), c(NA, 0))
})
