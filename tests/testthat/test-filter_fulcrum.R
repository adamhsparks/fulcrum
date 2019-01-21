context("filter_fulcrum")
# Check that filter_fulcrum() returns requested data ---------------------------

test_that("filter_fulcrum returns requested data", {
  x <- get_fulcrum()
  y <- filter_fulcrum(x, crop = "barley")
  expect_equal(unique(y$crop), "Barley")

  y <- filter_fulcrum(x, season = "Winter 2018")
  expect_equal(unique(y$season), "Winter 2018")

  y <- filter_fulcrum(x, location_description = "farm field")
  expect_equal(unique(y$location_description), "Farm field")

  y <- filter_fulcrum(x, disease = "rust")
  expect_equal(unique(y$disease), "rust")
})
