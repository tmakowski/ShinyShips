context("data_preparation")

test_that("test get_type_names_mapping", {
  # Assert check
  expect_error(get_type_names_mapping(data.frame()))
  expect_error(get_type_names_mapping(data.table::data.table()))

  # Calculation check
  ships_data1 <- data.table::data.table(ship_type = "TypeA", SHIPNAME = "Ship1")
  res1 <- list("TypeA" = "Ship1")
  expect_equal(get_type_names_mapping(ships_data1), res1)

  # Uniqueness
  ships_data2 <- data.table::data.table(
    ship_type = c("TypeA", "TypeA"),
    SHIPNAME = c("Ship1", "Ship1")
  )
  res2 <- list("TypeA" = "Ship1")
  expect_equal(get_type_names_mapping(ships_data2), res2)

  # Sorting
  ships_data3 <- data.table::data.table(
    ship_type = c("TypeB", "TypeB", "TypeA"),
    SHIPNAME = c("Ship2", "Ship1", "Ship1")
  )
  res3 <- list("TypeA" = "Ship1", "TypeB" = c("Ship1", "Ship2"))
  expect_equal(get_type_names_mapping(ships_data3), res3)
})
