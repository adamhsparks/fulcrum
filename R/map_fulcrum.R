#' Maps Locations Surveyed Using Data from get_fulcrum
#'
#' Generates maps of locations surveyed using \code{\link{get_fulcrum}} data.
#' Maps can be of all locations surveyed, or by crop, disease, location
#'  description or season.
#'
#' @param fd Required. Fulcrum data to use for mapping. Must be supplied from
#' \code{\link{get_fulcrum}}.
#' @param crop Optional. Map by crop type. If not specified all crops are
#'  mapped.
#' @param disease Optional. Map by disease of interest. If not specified, all
#' diseases are mapped. Overrides crop type.
#' @param location Optional. Map by location type. If not specified all
#'  locations are mapped.
#' @param season Optional. Map by season. If not specified, all seasons mapped.
#'
#' @section Crop Values:
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
#' @section Disease Values:
#'  Acceptable values for disease are
#'  \itemize{
#'    \item \code{},
#'  }
#'
#' @section Location Values:
#'  Acceptable values for location are
#'  \itemize{
#'    \item \code{farm field},
#'    \item \code{commercial trial},
#'    \item \code{research trial} or
#'    \item \code{roadside}.
#'  }
#'
#' @section Season Values:
#'  Acceptable values for season are
#'  \itemize{
#'    \item \code{Winter 2018},
#'    \item \code{Summer 2018/19},
#'    \item \code{Winter 2019} or
#'    \item \code{Summer 2019/20}.
#'  }
#'
#' @return A map of Fulcrum data
#' @examples
#'
#' \dontrun{
#' # map all surveys in Fulcrum database
#' fulcrum_data <- get_fulcrum()
#' map <- map_fulcrum(fd = fulcrum_data)
#' }
#'
#' \dontrun{
#' # map only mungbean surveys
#' map <- map_fulcrum(fd = fulcrum_data, crop = "mungbean")
#' }
#' @author Sparks, Adam H. \email{adam.sparks@@usq.edu.au}
#' @seealso \code{\link{get_fulcrum}} for retrieving and formatting Fulcrum
#'  data
#'
#' @importFrom magrittr "%>%"
#' @export map_fulcrum

map_fulcrum <- function(fd,
                        crop = NULL,
                        disease = NULL,
                        location = NULL,
                        season = NULL) {

}