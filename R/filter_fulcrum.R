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
#' x <- get_fulcrum()
#' # map only mungbean surveys
#' x <- filter_fulcrum(fd = x, crop = "mungbean")
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

  target_c <- crop
  target_d <- disease
  target_ld <- location_description
  target_s <- season

  if (!is.null(crop)) {
    target_c <- .simple_cap(target_c)
  }

  if (!is.null(disease)) {
    target_d <- tolower(target_d)
  }

  if (!is.null(location_description)) {
    target_ld <- .simple_cap(target_ld)
  }

  if (!is.null(season)) {
    target_s <- .simple_cap(target_s)
  }

  fd <-
    fd %>%
    dplyr::filter(
    crop %in% target_c |
      disease %in% target_d |
      location_description %in% target_ld |
      season %in% target_s
    )
  return(fd)
}