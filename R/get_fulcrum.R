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
#' fd <- get_fulcrum()
#' }
#'
#' \dontrun{
#' # specify a url to get data from Fulcrum
#' fd <- get_fulcrum(url = "https://web.fulcrumapp.com/shares/########.csv")
#' }
#'
#' @author Sparks, Adam H. \email{adam.sparks@@usq.edu.au}
#' @export get_fulcrum
#' @importFrom magrittr "%>%"
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
    fd  %>% dplyr::select(fulcrum_id, crop:winter_cereal_growth_stage_) %>%
    tidyr::gather(key = crop_gs,
                  value = growth_stage,
                  c(-fulcrum_id, -crop, -cultivar)) %>%
    dplyr::select(-crop_gs) %>%
    tidyr::drop_na(growth_stage)

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
    dplyr::filter(grepl("other", disease) &
                    !grepl("describe", disease)) %>%
    tidyr::drop_na(incidence)

  describe_other <-
    disease_incidence %>%
    dplyr::filter(grepl("describe", disease)) %>%
    dplyr::select(-disease) %>%
    dplyr::rename(disease = incidence) %>%
    dplyr::distinct()

  other_disease <-
    dplyr::left_join(describe_other, other_disease, by = "fulcrum_id") %>%
    dplyr::mutate(disease = ifelse(!is.na(disease.x), disease.x, disease.y)) %>%
    dplyr::select(-disease.x, -disease.y)

  # remove any "other" diseases requiring description from original and add
  # `other_disease` for final `disease_incidence` tibble
  disease_incidence <-
    dplyr::filter(disease_incidence, !grepl("other", disease)) %>%
    dplyr::left_join(disease_incidence,
                     other_disease,
                     by = c("fulcrum_id", "disease", "incidence")) %>%
    tidyr::drop_na(incidence)

  # create a tibble for geocoded locations -------------------------------------
  # lon
  # lat
  # nearest town
  # region
  xy <- fd %>%
    dplyr::select(fulcrum_id, latitude, longitude, nearest_town, region) %>%
    dplyr::mutate(nearest_town = tolower(nearest_town)) %>%
    dplyr::mutate(nearest_town = tools::toTitleCase(nearest_town))

  # create a tibble for observer and observation metadata ----------------------
  # when created
  # when modified
  # who created
  # who modified
  # version (1 is original)
  # what season does the observation cover
  # how many plants were checked
  observation_meta <- fd %>%
    dplyr::select(fulcrum_id, created_at:version, season, total_plant_count)

  # create a tibble for paddock information ------------------------------------
  # USQ paddock identifcation number
  # Type of location (farm field, commercial trial, etc.)
  # landform (irrigated or dryland)
  # grower's name
  # grower's contact info
  # agronomist's name
  # agronomist's contact info
  # any freeform notes taken
  paddock_meta <- fd %>%
    dplyr::select(
      fulcrum_id,
      paddockproperty:location_description,
      landform,
      grower:agronomists_phone_number,
      notes
    ) %>%
    dplyr::mutate(grower = tolower(grower)) %>%
    dplyr::mutate(grower = tools::toTitleCase(grower)) %>%
    dplyr::mutate(grower = tolower(agronomist)) %>%
    dplyr::mutate(grower = tools::toTitleCase(agronomist))

  return(
    out <-
      dplyr::left_join(observation_meta, paddock_meta, by = "fulcrum_id") %>%
      dplyr::left_join(., xy, by = "fulcrum_id") %>%
      dplyr::left_join(., crop_meta, by = "fulcrum_id") %>%
      dplyr::left_join(., disease_incidence, by = "fulcrum_id") %>%
      dplyr::mutate(created_at = lubridate::as_datetime(created_at,
                                                        tz = "GMT")) %>%
      dplyr::mutate(updated_at = lubridate::as_datetime(updated_at,
                                                        tz = "GMT")) %>%
      dplyr::mutate(
        system_created_at = lubridate::as_datetime(system_created_at,
                                                   tz = "GMT")
      ) %>%
      dplyr::mutate(
        system_updated_at = lubridate::as_datetime(system_updated_at,
                                                   tz = "GMT")
      ) %>%
      dplyr::mutate(created_by = as.factor(created_by)) %>%
      dplyr::mutate(updated_by = as.factor(updated_by)) %>%
      dplyr::mutate(season = as.factor(season)) %>%
      dplyr::mutate(location_description = as.factor(location_description)) %>%
      dplyr::mutate(landform = as.factor(landform)) %>%
      dplyr::mutate(region = as.factor(region)) %>%
      dplyr::mutate(crop = as.factor(crop)) %>%
      dplyr::mutate(growth_stage = as.factor(growth_stage)) %>%
      dplyr::mutate(disease = as.factor(disease)) %>%
      dplyr::mutate(incidence = as.integer(incidence))
  )
}
