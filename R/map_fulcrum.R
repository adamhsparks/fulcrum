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
    ggplot2::geom_sf(data = fulcrum::oz_label,
                     linetype = "dotdash") +
    ggplot2::geom_sf(data = fulcrum::oz_outline,
                     fill = NA,
                     size = 0.65) +
    ggplot2::geom_text(
      data = fulcrum::oz_label,
      position = ggplot2::position_nudge(y = -55),
      size = 5,
      vjust = -1,
      hjust = 0.85,
      mapping = ggplot2::aes(
        x = fulcrum::oz_label$COORDS_X,
        y = fulcrum::oz_label$COORDS_Y,
        label = ifelse(
          fulcrum::oz_label$abbrev == "J.B.T." |
            fulcrum::oz_label$abbrev == "Tas.",
          "",
          fulcrum::oz_label$abbrev
        )
      )
    ) +
    ggplot2::geom_hex(data = fd,
                      ggplot2::aes(x = fd$X,
                                   y = fd$Y)) +
    ggplot2::xlab("Longitude") +
    ggplot2::ylab("Latitude") +
    ggplot2::labs(caption = "Data: Naturalearthdata and DAQ00186")
}
