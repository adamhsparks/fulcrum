#' Produce Boxplots of Disease Survey Data for a Given Crop
#'
#' @param fd Fulcrum data retrieved using \code{get_fulcrum}.
#' @param crop_graph Crop of interest to produce a graph for.
#'
#' #' @section Accepted \code{crop} Values:
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
#' @author adam.sparks@@usq.edu.au
#' @export disease_boxplot

disease_boxplot <- function(fd, crop_graph) {
  x <- filter_fulcrum(fd, crop = crop_graph)
  ggplot2::ggplot(x,
                  ggplot2::aes(
                    x = .data$disease,
                    y = (.data$incidence / .data$total_plant_count) * 100
                  )) +
    ggplot2::geom_boxplot() +
    ggplot2::coord_flip() +
    ggplot2::ylab("Incidence (% of Total)") +
    ggplot2::xlab("Common Disease Name")
}