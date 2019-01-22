#' Create a Map of Survey Sites
#'
#' Generates a map of surveyed paddocks for all or selected crops or diseases.
#' Paddocks are not identified to lat/lon, but binned in hexes to avoid accurate
#' identification being possible.
#'
#' @param fd Required. Fulcrum data to be filtered.  Data must be a result of
#'  \code{\link{get_fulcrum}}.
#'
#' @return A hexbin map of survey locations as a \pkg{\link[ggplot2]{ggplot2}}
#' object.
#' @author adam.sparks@@usq.edu.au
#' @export map_fulcrum
#'
map_fulcrum <- function(fd) {
  fd <- unique(tibble::as_tibble(sf::st_coordinates(fd)))

  ggplot2::ggplot() +
    ggplot2::geom_sf(data = oz_label,
                     linetype = "dotdash") +
    ggplot2::geom_sf(data = oz_outline,
                     fill = NA,
                     size = 0.65) +
    ggplot2::geom_text(
      data = oz_label,
      position = ggplot2::position_nudge(y = -55),
      size = 5,
      vjust = -1,
      hjust = 0.85,
      mapping = ggplot2::aes(
        x = COORDS_X,
        y = COORDS_Y,
        label = ifelse(abbrev == "J.B.T." | abbrev == "Tas.",
                       "",
                       abbrev)
      )
    ) +
    ggplot2::geom_hex(data = fd,
                      ggplot2::aes(x = X,
                                   y = Y)) +
    ggplot2::xlab("Longitude") +
    ggplot2::ylab("Latitude") +
    ggplot2::labs(caption = "Data: Naturalearthdata and DAQ00186")
}