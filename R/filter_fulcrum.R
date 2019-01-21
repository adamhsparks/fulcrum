#' Filters Survey Data from get_fulcrum
#'
#' Filters data retrieved using \code{\link{get_fulcrum}}.  Data can be filtered
#' by locations surveyed, crop, disease, location description or season.
#'
#' @param fd Required. Fulcrum data to be filtered.  Data must be a result of
#'  \code{\link{get_fulcrum}}.
#' @param crop Optional. Character vector of crop(s) to filter on.
#' @param disease Optional. Character vector of disease(s) to filter on.
#' @param location Optional. Character vector of location(s) to filter on.
#' @param season Optional. Character vector of season(s) to filter on.
#'
#' @section Accepted \code{crop} Values:
#'  Acceptable values for crop are
#'  \itemize{
#'    \item \code{barley},
#'    \item \code{canola},
#'    \item \code{chickpea},
#'    \item \code{maize},
#'    \item \code{mungbean},
#'    \item \code{peanut},
#'    \item \code{sorghum},
#'    \item \code{soybean},
#'    \item \code{sunflower},
#'    \item \code{wheat}
#'  }
#'
#' @section Accepted \code{disease} Values:
#'  Acceptable values for disease are
#'  \itemize{
#'    \item \code{},
#'  }
#'
#' @section Accepted \code{location_description} Values:
#'  Acceptable values for location are
#'  \itemize{
#'    \item \code{farm field},
#'    \item \code{commercial trial},
#'    \item \code{research trial} or
#'    \item \code{roadside}.
#'  }
#'
#' @section Accepted \code{season} Values:
#'  Acceptable values for season are
#'  \itemize{
#'    \item \code{Winter 2018},
#'    \item \code{Summer 2018/19},
#'    \item \code{Winter 2019} or
#'    \item \code{Summer 2019/20}.
#'  }
#'
#' @return A \code{\link[tibble]{tibble}} of filtered Fulcrum data by the
#'  requested parameters.
#' @examples
#' \dontrun{
#' # map only mungbean surveys
#' x <- filter_fulcrum(fd = fulcrum_data, crop = "mungbean")
#' }
#' @author Sparks, Adam H. \email{adam.sparks@@usq.edu.au}
#' @seealso \code{\link{get_fulcrum}} for retrieving and formatting Fulcrum
#'  data
#'
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
#' @export filter_fulcrum

filter_fulcrum <- function(fd,
                           crop = NULL,
                           disease = NULL,
                           location_description = NULL,
                           season = NULL) {
  if (!is.null(crop)) {
    crop <- .simple_cap(crop)
  }

  if (!is.null(disease)) {
    disease <- tolower(disease)
  }

  if (!is.null(location_description)) {
    location_description <- tolower(location_description)
  }

  if (!is.null(season)) {
    season <- .simple_cap(season)
  }

  fd <-
    fd %>% dplyr::slice(
      match(crop, crop, 0L) |
        match(disease, disease, 0L) |
        match(location_description, location_description, 0L) |
        match(season, season, 0L)
    )
return(fd)
}