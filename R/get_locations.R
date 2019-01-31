#' Fetches Data from Fulcrum.app and Returns Only Locations and Location Information
#'
#' Fetch and clean Fulcrum data from USQ/DAFQ in-paddock surveys and create
#' a dataframe of locations and crops surveyed with no disease data
#' @param fulcrum_url A url provided by \url{https://www.fulcrumapp.com/} for sharing a
#' 'CSV' format fill of Fulcrum data
#' @return A \code{\link[sf]{sf}} object of locations and location information,
#' but no disease data.
#' @examples
#'
#' \dontrun{
#' # using a URL set in the .Renviron, get data from Fulcrum
#' x <- get_locations()
#' }
#'
#' \dontrun{
#' # specify a url to get data from Fulcrum
#' x <- get_locations(fulcrum_url = "https://web.fulcrumapp.com/shares/########.csv")
#' }
#'
#' @author Sparks, Adam H. \email{adam.sparks@@usq.edu.au}
#' @export get_locations
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
get_locations <- function(fulcrum_url = NULL) {
  # get URL using system environment if not otherwise provided -----------------
  if (is.null(url)) {
    fulcrum_url <- Sys.getenv("FULCRUM_DATA_URL")
  }

  # fetch data from fulcrumapp.com ---------------------------------------------
  fd <- .fetch_data(.url = fulcrum_url)

  location_meta <-
    fd %>% dplyr::select(.data$fulcrum_id:.data$cultivar) %>%
    dplyr::mutate(nearest_town = tolower(.data$nearest_town)) %>%
    dplyr::mutate(nearest_town = tools::toTitleCase(.data$nearest_town)) %>%
    dplyr::mutate(
      state = dplyr::case_when(
        .data$region == "Central Queensland" ~ "Queensland",
        .data$region == "Southern Queensland" ~ "Queensland",
        .data$region == "Northern New South Wales" ~ "New South Wales"
      )
    ) %>%
    dplyr::mutate(created_at = lubridate::as_datetime(.data$created_at,
                                                      tz = "GMT")) %>%
    dplyr::mutate(updated_at = lubridate::as_datetime(.data$updated_at,
                                                      tz = "GMT")) %>%
    dplyr::mutate(system_created_at = lubridate::as_datetime(.data$system_created_at,
                                                             tz = "GMT")) %>%
    dplyr::mutate(system_updated_at = lubridate::as_datetime(.data$system_updated_at,
                                                             tz = "GMT")) %>%
    dplyr::mutate(lon = .data$longitude) %>%
    dplyr::mutate(lat = .data$latitude) %>%
    sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
    sf::st_transform(crs = 3577) %>%
    dplyr::select(-c(
      .data$version:.data$assigned_to,
      .data$location_description_other
    ))

  return(location_meta)
}
