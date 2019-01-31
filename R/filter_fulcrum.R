#' Filters Survey Data from get_fulcrum
#'
#' Filters data retrieved using \code{\link{get_fulcrum}}.  Data can be filtered
#' by locations surveyed, crop, disease, location description or season.
#'
#' @param fd Required. Fulcrum data to be filtered.  Data must be a result of
#'  \code{\link{get_fulcrum}}.
#' @param crop Optional. Character vector of crop(s) to filter on.
#' @param disease Optional. Character vector of disease(s) to filter on.
#' @param location_description Optional. Character vector of location(s) to filter on.
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
#'    \item \code{Fusarium head blightscab},
#'    \item \code{Net form net blotch},
#'    \item \code{Spot form net blotch},
#'    \item \code{Powdery mildew},
#'    \item \code{Stem rust},
#'    \item \code{Virus},
#'    \item \code{Powdery mildew},
#'    \item \code{Blackleg},
#'    \item \code{Sclerotinia stem rot},
#'    \item \code{Virus},
#'    \item \code{Ascochyta blight},
#'    \item \code{Botrytis grey mould},
#'    \item \code{Fusarium wilt},
#'    \item \code{Phytoplasma},
#'    \item \code{Phytophthora root rot},
#'    \item \code{Bacterial stalk rot and bacterial top rot},
#'    \item \code{Charcoal rot},
#'    \item \code{Common rust},
#'    \item \code{Commonboil smut},
#'    \item \code{Crazy top},
#'    \item \code{Damping off},
#'    \item \code{Diplodia cob rot},
#'    \item \code{Downy mildew},
#'    \item \code{Dwarf mosaic virus},
#'    \item \code{Fusarium ear rot},
#'    \item \code{Fusarium stalk rot},
#'    \item \code{Head smut},
#'    \item \code{Pythium stalk rot},
#'    \item \code{Turcica leaf blight},
#'    \item \code{Maydis leaf blight},
#'    \item \code{Southern rust},
#'    \item \code{Alternaria leaf spot},
#'    \item \code{Bacterial blight},
#'    \item \code{Damping off},
#'    \item \code{Fusarium wilt},
#'    \item \code{Gummy pod},
#'    \item \code{Halo blight},
#'    \item \code{Powdery mildew},
#'    \item \code{Puffy pod},
#'    \item \code{Rhizoctonia rot},
#'    \item \code{Root lesion nematode},
#'    \item \code{Sclerotinia stem rot},
#'    \item \code{Sclerotium stem rot},
#'    \item \code{Tan spot},
#'    \item \code{TSV},
#'    \item \code{Fusarium root rot},
#'    \item \code{Neocosmospora root rot},
#'    \item \code{Net blotch},
#'    \item \code{Kernel shrivel syndrome},
#'    \item \code{Root lesion nematode},
#'    \item \code{Rust},
#'    \item \code{Sclerotium base rot},
#'    \item \code{Bacterial top and stalk rot},
#'    \item \code{Damping off},
#'    \item \code{Ergot},
#'    \item \code{Fusarium head blight},
#'    \item \code{Fusarium stalk rot},
#'    \item \code{Grain mould},
#'    \item \code{Head smut},
#'    \item \code{Johnsongrass mosaic virus},
#'    \item \code{Leaf blight},
#'    \item \code{Root lesion nematode},
#'    \item \code{Sclerotium base rot},
#'    \item \code{Tar spot},
#'    \item \code{Bacterial blight bacterial pustule},
#'    \item \code{Damping off},
#'    \item \code{Peanut mottle virus},
#'    \item \code{Phomopsis seed decay},
#'    \item \code{Phytophthora root stem and root rot},
#'    \item \code{Pod stem cankerblight},
#'    \item \code{Purple seed stain},
#'    \item \code{Rhizoctonia rot},
#'    \item \code{Root lesion nematode},
#'    \item \code{Sclerotinia rot},
#'    \item \code{Soybean mosaic virus},
#'    \item \code{Apical chlorosis},
#'    \item \code{Botrytis head rot grey mould},
#'    \item \code{Rhizopus head rot},
#'    \item \code{Sclerotinia rot},
#'    \item \code{Sclerotium base rot},
#'    \item \code{Stem cankerblight},
#'    \item \code{Verticillium wilt},
#'    \item \code{Crown rot},
#'    \item \code{Common root rot},
#'    \item \code{Leafbrown rust},
#'    \item \code{Root lesion nematode},
#'    \item \code{Septoria nodorum blotch},
#'    \item \code{Stemblack rust},
#'    \item \code{Stripeyellow rust},
#'    \item \code{Yellow spot} or
#'    \item \code{White grain}
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
  target_ld <- location_description
  target_s <- season

  if (!is.null(crop)) {
    target_c <- .simple_cap(target_c)

    if (target_c %notin% c(
      "Barley",
      "Canola",
      "Chickpea",
      "Maize",
      "Mungbean",
      "Peanut",
      "Sorghum",
      "Soybean",
      "Sunflower",
      "Wheat"
    )) {
      stop(call. = FALSE,
           "The `crop` you have specified is not valid")
    }
  }
  if (!is.null(location_description)) {
    target_ld <- .simple_cap(target_ld)

    if (target_ld %notin% c("Farm field",
                            "Commercial trial",
                            "Research trial",
                            "Roadside")) {
      stop(call. = FALSE,
           "The `location_description` you have entered is not valid.")
    }
  }

  if (!is.null(season)) {
    target_s <- .simple_cap(target_s)

    if (target_s %notin% c("Winter 2018",
                           "Summer 2018/19",
                           "Winter 2019",
                           "Summer 2019/20")) {
      stop(call. = FALSE,
           "The `season` you have entered is not valid.")
    }
  }

  if (ncol(fd) == 31) {
    target_d <- disease
    if (!is.null(disease)) {
      target_d <- tolower(target_d)

      if (target_d %notin% c(
        "fusarium head blightscab",
        "net form net blotch",
        "spot form net blotch",
        "powdery mildew",
        "stem rust",
        "virus",
        "powdery mildew",
        "blackleg",
        "sclerotinia stem rot",
        "ascochyta blight",
        "botrytis grey mould",
        "fusarium wilt",
        "phytoplasma",
        "phytophthora root rot",
        "bacterial stalk rot and bacterial top rot",
        "charcoal rot",
        "common rust",
        "commonboil smut",
        "crazy top",
        "damping off",
        "diplodia cob rot",
        "downy mildew",
        "dwarf mosaic virus",
        "fusarium ear rot",
        "fusarium stalk rot",
        "head smut",
        "pythium stalk rot",
        "turcica leaf blight",
        "maydis leaf blight",
        "southern rust",
        "alternaria leaf spot",
        "bacterial blight",
        "fusarium wilt",
        "gummy pod",
        "halo blight",
        "powdery mildew",
        "puffy pod",
        "rhizoctonia rot",
        "root lesion nematode",
        "sclerotinia stem rot",
        "sclerotium stem rot",
        "tan spot",
        "tsv",
        "fusarium root rot",
        "neocosmospora root rot",
        "net blotch",
        "peanut kernel shrivel syndrome",
        "root lesion nematode",
        "rust",
        "sclerotium base rot",
        "bacterial top and stalk rot",
        "damping off",
        "ergot",
        "fusarium head blight",
        "fusarium stalk rot",
        "grain mould",
        "head smut",
        "johnsongrass mosaic virus",
        "leaf blight",
        "root lesion nematode",
        "sclerotium base rot",
        "tar spot",
        "bacterial blight bacterial pustule",
        "peanut mottle virus",
        "phomopsis seed decay",
        "phytophthora root stem and root rot",
        "pod stem cankerblight",
        "purple seed stain",
        "rhizoctonia rot",
        "root lesion nematode",
        "sclerotinia rot",
        "soybean mosaic virus",
        "apical chlorosis",
        "botrytis head rot grey mould",
        "rhizopus head rot",
        "sclerotinia rot",
        "sclerotium base rot",
        "stem cankerblight",
        "verticillium wilt",
        "crown rot",
        "common root rot",
        "leafbrown rust",
        "root lesion nematode",
        "septoria nodorum blotch",
        "stemblack rust",
        "stripeyellow rust",
        "yellow spot",
        "white grain"
      )) {
        stop(call. = FALSE,
             "The `disease` you have specified is not valid")
      }
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

  fd <-
    fd %>%
    dplyr::filter(crop %in% target_c |
                    location_description %in% target_ld |
                    season %in% target_s)
  return(fd)
}
