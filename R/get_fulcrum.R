#' Fetches Data from Fulcrum.app and Formats Them for Use in Reporting
#'
#' Fetch and clean Fulcrum data from USQ/DAFQ in-paddock surveys of crop
#' disease incidence and oher related notes for reporting.
#' @param url A url provided by \url{https://www.fulcrumapp.com/} for sharing a
#' 'CSV' format fill of Fulcrum data
#' @return A tidy data frame \code{tibble} object of Fulcrum survey data
#' @examples
#'
#' \dontrun{
#' # using a URL set in the .Renviron, get data from Fulcrum
#' x <- get_fulcrum()
#' }
#'
#' \dontrun{
#' # specify a url to get data from Fulcrum
#' x <- get_fulcrum(url = "https://web.fulcrumapp.com/shares/########.csv")
#' }
#'
#' @author Sparks, Adam H. \email{adam.sparks@@usq.edu.au}
#' @export get_fulcrum
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
get_fulcrum <- function(url = NULL) {
  # get URL using system environment if not otherwise provided -----------------
  if (is.null(url)) {
    url <- Sys.getenv("FULCRUM_DATA_URL")
  }

  # fetch data from fulcrumapp.com ---------------------------------------------
  fd <- .fetch_data(.url = url)

  # create a tibble for crop metadata ------------------------------------------
  # crop
  # cultivar
  # growth_stage
  crop_meta <-
    fd %>% dplyr::select(.data$fulcrum_id,
                          .data$crop:.data$winter_cereal_growth_stage_) %>%
    tidyr::gather(key = "crop_gs",
                  value = "growth_stage",
                  -c("fulcrum_id", "crop", "cultivar")) %>%
    dplyr::select(-"crop_gs") %>%
    tidyr::drop_na("growth_stage")

  actual_yield <-
    fd %>% dplyr::select(.data$fulcrum_id, .data$actual_yield)

  previous_crop <-
    fd %>% dplyr::select(.data$fulcrum_id,
                         .data$immediate_previous_crop:crop_3rd_previous_season)

  # create tibble for disease observations -------------------------------------
  # disease
  # incidence in paddock
  disease_incidence <- .create_di_df(.fd = fd)

  # if there is something not described, move description from incidence field
  # to disease field
  #
  # filter only
  other_disease <-
    disease_incidence %>%
    dplyr::filter(grepl("other", .data$disease) &
                    !grepl("describe", .data$disease)) %>%
    tidyr::drop_na(.data$incidence)

  describe_other <-
    disease_incidence %>%
    dplyr::filter(grepl("describe", .data$disease)) %>%
    dplyr::select(-.data$disease) %>%
    dplyr::rename(disease = .data$incidence) %>%
    dplyr::distinct()

  other_disease <-
    dplyr::left_join(describe_other, other_disease, by = "fulcrum_id") %>%
    dplyr::mutate(disease = ifelse(!is.na("disease"),
                                   "disease.x",
                                   "disease.y")) %>%
    dplyr::select(-c("disease.x", "disease.y"))

  # remove any "other" diseases requiring description from original and add
  # `other_disease` for final `disease_incidence` tibble
  disease_incidence <-
    disease_incidence %>%
    dplyr::filter(!grepl("other", .data$disease)) %>%
    dplyr::left_join(disease_incidence,
                     other_disease,
                     by = c("fulcrum_id", "disease", "incidence")) %>%
    tidyr::drop_na(.data$incidence)

  # create a tibble for geocoded locations -------------------------------------
  # lon
  # lat
  # nearest town
  # region
  xy <- fd %>%
    dplyr::select(
      .data$fulcrum_id,
      .data$latitude,
      .data$longitude,
      .data$nearest_town,
      .data$region
    ) %>%
    dplyr::mutate(nearest_town = tolower(.data$nearest_town)) %>%
    dplyr::mutate(nearest_town = tools::toTitleCase(.data$nearest_town))

  # create a tibble for observer and observation metadata ----------------------
  # when created
  # when modified
  # who created
  # who modified
  # version (1 is original)
  # what season does the observation cover
  # how many plants were checked
  observation_meta <-
    fd %>%
    dplyr::select(
      .data$fulcrum_id,
      .data$created_at:version,
      .data$season,
      .data$total_plant_count
    )

  # create a tibble for paddock information ------------------------------------
  # USQ paddock identifcation number
  # Type of location (farm field, commercial trial, etc.)
  # landform (irrigated or dryland)
  # grower's name
  # grower's contact info
  # agronomist's name
  # agronomist's contact info
  # any freeform notes taken
  paddock_meta <-
    fd %>%
    dplyr::select(
      .data$fulcrum_id,
      .data$paddockproperty:.data$location_description,
      .data$landform,
      .data$grower,
      .data$agronomist,
      .data$notes
    ) %>%
    dplyr::mutate(grower = tolower(.data$grower)) %>%
    dplyr::mutate(grower = tools::toTitleCase(.data$grower)) %>%
    dplyr::mutate(agronomist = tolower(.data$agronomist)) %>%
    dplyr::mutate(agronomist = tools::toTitleCase(.data$agronomist))

  return(
    out <-
      dplyr::left_join(observation_meta, paddock_meta, by = "fulcrum_id") %>%
      dplyr::left_join(xy, by = "fulcrum_id") %>%
      dplyr::left_join(crop_meta, by = "fulcrum_id") %>%
      dplyr::left_join(actual_yield, by = "fulcrum_id") %>%
      dplyr::left_join(previous_crop, by = "fulcrum_id" ) %>%
      dplyr::left_join(disease_incidence, by = "fulcrum_id") %>%
      dplyr::mutate(created_at = lubridate::as_datetime(.data$created_at,
                                                        tz = "GMT")) %>%
      dplyr::mutate(updated_at = lubridate::as_datetime(.data$updated_at,
                                                        tz = "GMT")) %>%
      dplyr::mutate(
        system_created_at = lubridate::as_datetime(.data$system_created_at,
                                                   tz = "GMT")
      ) %>%
      dplyr::mutate(
        system_updated_at = lubridate::as_datetime(.data$system_updated_at,
                                                   tz = "GMT")
      ) %>%
      dplyr::mutate(incidence = as.integer(.data$incidence))
  )
}
