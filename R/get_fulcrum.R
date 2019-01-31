#' Fetches Data from Fulcrum.app and Formats Them for Use in Reporting
#'
#' Fetch and clean Fulcrum data from USQ/DAFQ in-paddock surveys of crop
#' disease incidence and oher related notes for reporting.
#' @param fulcrum_url A url provided by \url{https://www.fulcrumapp.com/} for sharing a
#' 'CSV' format fill of Fulcrum data
#' @return A \code{\link[sf]{sf}} object of Fulcrum survey data projected into
#' Australia Albers for mapping
#' @examples
#'
#' \dontrun{
#' # using a URL set in the .Renviron, get data from Fulcrum
#' x <- get_fulcrum()
#' }
#'
#' \dontrun{
#' # specify a url to get data from Fulcrum
#' x <- get_fulcrum(fulcrum_url = "https://web.fulcrumapp.com/shares/########.csv")
#' }
#'
#' @author Sparks, Adam H. \email{adam.sparks@@usq.edu.au}
#' @export get_fulcrum
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
get_fulcrum <- function(fulcrum_url = NULL) {
  # get URL using system environment if not otherwise provided -----------------
  if (is.null(fulcrum_url)) {
    url <- Sys.getenv("FULCRUM_DATA_URL")
  }

  # fetch data from fulcrumapp.com ---------------------------------------------
  fd <- .fetch_data(.url = url)

  # crop metadata --------------------------------------------------------------
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
    fd %>% dplyr::select(
      .data$fulcrum_id,
      .data$immediate_previous_crop:.data$crop_3rd_previous_season
    )

  # disease observations -------------------------------------------------------
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

  # geographic locations -------------------------------------------------------
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
    dplyr::mutate(nearest_town = tools::toTitleCase(.data$nearest_town)) %>%
    dplyr::mutate(
      state = dplyr::case_when(
        .data$region == "Central Queensland" ~ "Queensland",
        .data$region == "Southern Queensland" ~ "Queensland",
        .data$region == "Northern New South Wales" ~ "New South Wales"
      )
    )

# observer and observation metadata ------------------------------------------
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

# paddock information --------------------------------------------------------
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
    dplyr::left_join(previous_crop, by = "fulcrum_id") %>%
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
    dplyr::mutate(incidence = as.integer(.data$incidence)) %>%
    dplyr::mutate(lon = .data$longitude) %>%
    dplyr::mutate(lat = .data$latitude) %>%
    sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
    sf::st_transform(crs = 3577)
)
}

# Functions for internal use in this function only -----------------------------

#' Creates Disease Incidence Data Frame
#' @param .fd Data frame containing Fulcrum data
#' @importFrom rlang .data
#' @noRd
.create_di_df <- function(.fd) {
  .fd %>%
    dplyr::select("fulcrum_id",
                  "barley_fusarium_head_blightscab":"describe_wheat_other") %>%
    tidyr::gather(key = "disease",
                  value = "incidence",
                  -"fulcrum_id") %>%
    dplyr::mutate(
      disease =
        dplyr::recode(
          .data$disease,
          barley_fusarium_head_blightscab = "fusarium head blight",
          barley_net_form_net_blotch = "net form net blotch",
          barley_spot_form_net_blotch = "spot form net blotch",
          barley_powdery_mildew = "powdery mildew",
          barley_stem_rust = "stem (black) rust",
          barley_virus = "virus",
          canola_powdery_mildew = "powdery mildew",
          canola_blackleg = "blackleg",
          canola_sclerotinia_stem_rot = "stem rot",
          virus_of_canola = "virus",
          chickpea_ascochyta_blight = "aschochyta blight",
          chickpea_botrytis_grey_mould = "botrytis grey mould",
          chickpea_fusarium_wilt = "fusarium wilt",
          chickpea_phytoplasma = "phytoplasma",
          chickpea_phytophthora_root_rot = "phytopthora root rot",
          chickpea_virus = "virus",
          maize_bacterial_stalk_rot_and_bacterial_top_rot =
            "bacterial stalk and top rot",
          maize_charcoal_rot = "charcoal rot",
          maize_common_rust = "common rust",
          maize_commonboil_smut = "boil smut",
          maize_crazy_top = "crazy top",
          maize_damping_off = "damping off",
          maize_diplodia_cob_rot = "diplodia cob rot",
          maize_downy_mildew = "downy mildew",
          maize_fusarium_ear_rot = "fusarium ear rot",
          maize_fusarium_stalk_rot = "fusarium stalk rot",
          maize_head_smut = "head smut",
          maize_pythium_stalk_rot = "pythium stalk rot",
          maize_turcica_leaf_blight = "turica leaf blight",
          maize_maydis_leaf_blight = "maydis leaf blight",
          maize_southern_rust = "southern rust",
          maize_virus = "virus",
          mungbean_alternaria_leaf_spot = "alternaria leaf spot",
          mungbean_bacterial_blight = "bacterial leaf blight",
          mungbean_charcoal_rot = "charcoal rot",
          mungbean_damping_off = "damping off",
          mungbean_fusarium_wilt = "fusarium wilt",
          mungbean_gummy_pod = "gummy pod",
          mungbean_halo_blight = "halo blight",
          mungbean_phytoplasma = "phytoplasma",
          mungbean_powdery_mildew = "powdery mildew",
          mungbean_puffy_pod = "puffy pod",
          mungbean_rhizoctonia_rot = "rhizoctonia rot",
          mungbean_root_lesion_nematode = "root lesion nematode",
          mungbean_sclerotinia_stem_rot = "sclerotinia stem rot",
          mungbean_sclerotium_stem_rot = "sclerotium stem rot",
          mungbean_tan_spot = "tan spot",
          mungbean_tsv = "Tobacco Streak Virus",
          mungbean_virus = "virus",
          peanut_fusarium_root_rot = "fusarium root rot",
          peanut_neocosmospora_root_rot = "neocosmospora root rot",
          peanut_net_blotch = "net blotch",
          peanut_kernel_shrivel_syndrome = "peanut kernel shrivel syndrome",
          peanut_root_lesion_nematode = "root lesion nematode",
          peanut_rust = "rust",
          peanut_sclerotium_base_rot = "sclerotium base rot",
          peanut_tsv = "Tobacco Streak Virus",
          peanut_virus = "virus",
          sorghum_bacterial_top_and_stalk_rot = "bacterial top and stalk rot",
          sorghum_charcoal_rot = "charcoal rot",
          sorghum_damping_off = "damping off",
          sorghum_ergot = "ergot",
          sorghum_fusarium_head_blight = "fusarium head blight",
          sorghum_fusarium_stalk_rot = "fusarium stalk rot",
          sorghum_grain_mould = "grain mould",
          sorghum_head_smut = "head smut",
          sorghum_johnsongrass_mosaic_virus = "Johnsongrass Mosaic Virus",
          sorghum_leaf_blight = "leaf blight",
          sorghum_root_lesion_nematode = "root lesion nematode",
          sorghum_rust = "rust",
          sorghum_sclerotium_base_rot = "sclerotium base rot",
          sorghum_tar_spot = "tar spot",
          soybean_bacterial_blight_bacterial_pustule =
            "bacterial blight pustule",
          soybean_charcoal_rot = "charcoal rot",
          soybean_damping_off = "damping off",
          soybean_peanut_mottle_virus = "Peanut Mottle Virus",
          soybean_phomopsis_seed_decay = "phomopsis seed decay",
          soybean_phytophthora_root_stem_and_root_rot =
            "phytophthora root and stem rot",
          soybean_phytoplasma = "phytoplasma",
          soybean_pod_stem_cankerblight = "pod and stem canker/blight",
          soybean_powdery_mildew = "powdery mildew",
          soybean_purple_seed_stain = "purple seed stain",
          soybean_rhizoctonia_rot = "rhizoctonia rot",
          soybean_root_lesion_nematode = "root lesion nematode",
          soybean_rust = "rust",
          soybean_sclerotinia_rot = "sclerotinia rot",
          soybean_mosaic_virus = "Soybean Mosaic Virus",
          soybean_virus = "virus",
          sunflower_apical_chlorosis = "apical chlorosis",
          sunflower_botrytis_head_rot_grey_mould =
            "botrytis head rot or grey mould",
          sunflower_charcoal_rot = "charcoal rot",
          sunflower_powdery_mildew = "powdery mildew",
          sunflower_rhizopus_head_rot = "rhizopus head rot",
          sunflower_rust = "rust",
          sunflower_sclerotinia_rot = "sclerotinia rot",
          sunflower_sclerotium_base_rot = "sclerotium base rot",
          sunflower_stem_cankerblight = "stem canker and blight",
          sunflower_tsv = "Tobacco Streak Virus",
          sunflower_verticillium_wilt = "verticillium wilt",
          wheat_fusarium_head_blightscab = "fusarium head blight",
          wheat_crown_rot = "crown rot",
          wheat_common_root_rot = "common root rot",
          wheat_leafbrown_rust = "leaf (brown) rust",
          wheat_root_lesion_nematode = "root lesion nematode",
          wheat_septoria_nodorum_blotch = "septoria nodorum blotch",
          wheat_stemblack_rust = "stem (black) rust",
          wheat_stripeyellow_rust = "stripe (yellow) rust",
          wheat_yellow_spot = "yellow spot",
          wheat_white_grain = "white grain"
        )
    )
}

#' Capitalises Only the First Letter
#' @param .sc Text to be cleaned to "Upper and lower case only" format.
#' @noRd
.simple_cap <- function(sc) {
  sub("(.)", ("\\U\\1"), tolower(sc), perl = TRUE)
}
