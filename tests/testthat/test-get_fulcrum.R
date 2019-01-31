context("get_fulcrum")
# Check that get_fulcrum fetches data and returns a proper data.frame object ---

test_that("get_fulcrum returns an sf object", {
  x <- get_fulcrum()
  expect_is(x, "sf")
  expect_named(
    x,
    c(
      "fulcrum_id",
      "created_at",
      "updated_at",
      "created_by",
      "updated_by",
      "system_created_at",
      "system_updated_at",
      "version",
      "season",
      "total_plant_count",
      "paddockproperty",
      "location_description",
      "landform",
      "grower",
      "agronomist",
      "notes",
      "nearest_town",
      "region",
      "state",
      "crop",
      "cultivar",
      "growth_stage",
      "actual_yield",
      "immediate_previous_crop",
      "crop_2nd_previous_season",
      "crop_3rd_previous_season",
      "disease",
      "incidence",
      "lon",
      "lat",
      "geometry"
    )
  )
})
