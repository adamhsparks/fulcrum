#' Fetches Data from Fulcrum and Formats it for Use in Reporting

#' @import data.table

fetch_fulcrum <- function() {

FULCRUM_DATA_URL <- Sys.getenv("FULCRUM_DATA_URL")

test <-
  fread(FULCRUM_DATA_URL)

# melt growth stage data frame
# supress warnings if there are columns of NA, they are imported as logi

gs <- suppressWarnings(melt(test[, 1:36],
                                        id.vars = names(test[, c(1:27)]),
                                        value.name = "Growth Stage"))
# drop `variable` (growth stage name since crop is already given)
gs[, variable := NULL]
gs <- gs[!is.na(gs$`Growth Stage`),]

# create data.table for disease observations
observations <- suppressWarnings(
  melt(
    test[, c(1, 38:176)],
    id.vars = names(test[, c(1, 168:176)]),
    variable.name = "disease",
    value.name = "incidence"
  )
)

# remove any rows for crops not observed in paddock
observations <- na.omit(observations, cols = "Incidence")

setkey(observations, "fulcrum_id")
setkey(gs, "fulcrum_id")

# reorder observations by fulcrum_id
observations <-
  observations[order(observations[["fulcrum_id"]])]

# create final data.table to return by performing left-join
out <- observations[gs, on = "fulcrum_id"]

# convert commonly mis-capitalised words to title case
cols <- c("nearest_town", "grower", "agronomist", "cultivar")
out[, (cols) := lapply(.SD, tools::toTitleCase), .SDcols = cols]
return(out)
}