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

test_that("test get_ships_distances", {
  # Assert check
  expect_error(get_ships_distances(data.frame()))
  expect_error(get_ships_distances(data.table::data.table()))

  # Calculation check
  # Highest value selection
  ships_data1 <- data.table::data.table(
    SHIPNAME = "Ship1",
    DATETIME = 1:3,
    LAT = c(0, 1, 10),
    LON = c(0, 1, 10)
  )
  res1 <- data.table::data.table(
    ship_name = "Ship1",
    dist = geosphere::distGeo(c(1, 1), c(10, 10)),
    lat_start = 1,
    lon_start = 1,
    lat_end = 10,
    lon_end = 10
  )
  expect_equal(get_ships_distances(ships_data1), res1)

  # Ommiting ships with too few observations
  ships_data2 <- data.table::rbindlist(list(
    ships_data1,
    data.table::data.table(ship_name = "Ship2", DATETIME = 1, LAT = 0, LON = 0)
  ))
  expect_equal(get_ships_distances(ships_data2), res1)

  # Ommiting consecutive observations without moving
  ships_data3 <- data.table::rbindlist(list(
    ships_data1,
    data.table::data.table(
      SHIPNAME = "Ship2",
      DATETIME = 1:3,
      LAT = c(0, 0, 0),
      LON = c(0, 0, 0)
    )
  ))
  expect_equal(get_ships_distances(ships_data3), res1)

  # Selecting latest observation
  ships_data4 <- data.table::data.table(
    SHIPNAME = "Ship1",
    DATETIME = 1:3,
    LAT = c(0, 0, 0),
    LON = c(0, 1, 0)
  )
  res4 <- data.table::data.table(
    ship_name = "Ship1",
    dist = geosphere::distGeo(c(0, 1), c(0, 0)),
    lat_start = 0,
    lon_start = 1,
    lat_end = 0,
    lon_end = 0
  )
  expect_equal(get_ships_distances(ships_data4), res4)
})
