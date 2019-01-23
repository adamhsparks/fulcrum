#' Fetches Data from Fulcrum.app and Formats Them for Use in Reporting
#'
#' Fetch and clean Fulcrum data from USQ/DAFQ in-paddock surveys of crop
#' disease incidence and oher related notes for reporting.
#' @param url A url provided by \url{https://www.fulcrumapp.com/} for sharing a
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
#' x <- get_fulcrum(url = "https://web.fulcrumapp.com/shares/########.csv")
#' }
#'
#' @author Sparks, Adam H. \email{adam.sparks@@usq.edu.au}
#' @export get_fulcrum
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
get_fulcrum <- function(url = NULL) {
  # get URL using system environment if not otherwise provided -----------------
  if (is.null(url)) {
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
    sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
    sf::st_transform(crs = 3577)
)
}

# Functions for internal use in this function only -----------------------------

#' Read Fulcrum Data from Fulcrum Site
#' @param .url A url of a shared 'CSV' file of Fulcrum data
#' @note The \code{.url} may either be provided by the user or taken from the
#' .Renviron/.bashrc/bash_profile files
#' @noRd
.fetch_data <- function(.url) {
  # CRAN note avoidance (even though it's never going to CRAN) -----------------
  "fulcrum_id" <- #nocov start
    "created_at" <-
    "updated_at" <-
    "created_by" <-
    "updated_by" <-
    "system_created_at" <-
    "system_updated_at" <-
    "version" <-
    "status" <-
    "project" <-
    "assigned_to" <-
    "latitude" <-
    "longitude" <-
    "geometry" <-
    "season" <-
    "paddockproperty" <-
    "location_description" <-
    "location_description_other" <-
    "landform" <-
    "nearest_town" <-
    "region" <-
    "grower" <-
    "growers_phone_number" <-
    "agronomist" <-
    "agronomists_phone_number" <-
    "crop" <-
    "cultivar" <-
    "canola_growth_stage_" <-
    "chickpea_growth_stage_" <-
    "maize_growth_stage_" <-
    "mungbean_growth_stage_" <-
    "peanut_growth_stage_" <-
    "sorghum_growth_stage_" <-
    "soybean_growth_stage_" <-
    "sunflower_growth_stage_" <-
    "winter_cereal_growth_stage_" <-
    "total_plant_count" <-
    "barley_fusarium_head_blightscab" <-
    "barley_net_form_net_blotch" <-
    "barley_spot_form_net_blotch" <-
    "barley_powdery_mildew" <-
    "barley_stem_rust" <-
    "barley_virus" <-
    "barley_other" <-
    "describe_barley_other" <-
    "canola_powdery_mildew" <-
    "canola_blackleg" <-
    "canola_sclerotinia_stem_rot" <-
    "virus_of_canola" <-
    "canola_other" <-
    "describe_canola_other" <-
    "chickpea_ascochyta_blight" <-
    "chickpea_botrytis_grey_mould" <-
    "chickpea_fusarium_wilt" <-
    "chickpea_phytoplasma" <-
    "chickpea_phytophthora_root_rot" <-
    "chickpea_virus" <-
    "chickpea_other" <-
    "describe_chickpea_other" <-
    "maize_bacterial_stalk_rot_and_bacterial_top_rot" <-
    "maize_charcoal_rot" <-
    "maize_common_rust" <-
    "maize_commonboil_smut" <-
    "maize_crazy_top" <-
    "maize_damping_off" <-
    "maize_diplodia_cob_rot" <-
    "maize_downy_mildew" <-
    "maize_dwarf_mosaic_virus" <-
    "maize_fusarium_ear_rot" <-
    "maize_fusarium_stalk_rot" <-
    "maize_head_smut" <-
    "maize_pythium_stalk_rot" <-
    "maize_turcica_leaf_blight" <-
    "maize_maydis_leaf_blight" <-
    "maize_southern_rust" <-
    "maize_virus" <-
    "maize_other" <-
    "describe_maize_other" <-
    "mungbean_alternaria_leaf_spot" <-
    "mungbean_bacterial_blight" <-
    "mungbean_charcoal_rot" <-
    "mungbean_damping_off" <-
    "mungbean_fusarium_wilt" <-
    "mungbean_gummy_pod" <-
    "mungbean_halo_blight" <-
    "mungbean_phytoplasma" <-
    "mungbean_powdery_mildew" <-
    "mungbean_puffy_pod" <-
    "mungbean_rhizoctonia_rot" <-
    "mungbean_root_lesion_nematode" <-
    "mungbean_sclerotinia_stem_rot" <-
    "mungbean_sclerotium_stem_rot" <-
    "mungbean_tan_spot" <-
    "mungbean_tsv" <-
    "mungbean_virus" <-
    "mungbean_other" <-
    "describe_mungbean_other" <-
    "peanut_fusarium_root_rot" <-
    "peanut_neocosmospora_root_rot" <-
    "peanut_net_blotch" <-
    "peanut_kernel_shrivel_syndrome" <-
    "peanut_root_lesion_nematode" <-
    "peanut_rust" <-
    "peanut_sclerotium_base_rot" <-
    "peanut_tsv" <-
    "peanut_virus" <-
    "peanut_other" <-
    "describe_peanut_other" <-
    "sorghum_bacterial_top_and_stalk_rot" <-
    "sorghum_charcoal_rot" <-
    "sorghum_damping_off" <-
    "sorghum_ergot" <-
    "sorghum_fusarium_head_blight" <-
    "sorghum_fusarium_stalk_rot" <-
    "sorghum_grain_mould" <-
    "sorghum_head_smut" <-
    "sorghum_johnsongrass_mosaic_virus" <-
    "sorghum_leaf_blight" <-
    "sorghum_root_lesion_nematode" <-
    "sorghum_rust" <-
    "sorghum_sclerotium_base_rot" <-
    "sorghum_tar_spot" <-
    "sorghum_other" <-
    "describe_sorghum_other" <-
    "soybean_bacterial_blight_bacterial_pustule" <-
    "soybean_charcoal_rot" <-
    "soybean_damping_off" <-
    "soybean_peanut_mottle_virus" <-
    "soybean_phomopsis_seed_decay" <-
    "soybean_phytophthora_root_stem_and_root_rot" <-
    "soybean_phytoplasma" <-
    "soybean_pod_stem_cankerblight" <-
    "soybean_powdery_mildew" <-
    "soybean_purple_seed_stain" <-
    "soybean_rhizoctonia_rot" <-
    "soybean_root_lesion_nematode" <-
    "soybean_rust" <-
    "soybean_sclerotinia_rot" <-
    "soybean_mosaic_virus" <-
    "soybean_virus" <-
    "soybean_other" <-
    "describe_soybean_other" <-
    "sunflower_apical_chlorosis" <-
    "sunflower_botrytis_head_rot_grey_mould" <-
    "sunflower_charcoal_rot" <-
    "sunflower_powdery_mildew" <-
    "sunflower_rhizopus_head_rot" <-
    "sunflower_rust" <-
    "sunflower_sclerotinia_rot" <-
    "sunflower_sclerotium_base_rot" <-
    "sunflower_stem_cankerblight" <-
    "sunflower_tsv" <-
    "sunflower_verticillium_wilt" <-
    "sunflower_other" <-
    "describe_sunflower_other" <-
    "wheat_fusarium_head_blightscab" <-
    "wheat_crown_rot" <-
    "wheat_common_root_rot" <-
    "wheat_leafbrown_rust" <-
    "wheat_root_lesion_nematode" <-
    "wheat_septoria_nodorum_blotch" <-
    "wheat_stemblack_rust" <-
    "wheat_stripeyellow_rust" <-
    "wheat_yellow_spot" <-
    "wheat_white_grain" <-
    "wheat_other" <-
    "describe_wheat_other" <-
    "notes" <-
    "photos" <-
    "photos_caption" <-
    "photos_url" <-
    "gps_altitude" <-
    "gps_horizontal_accuracy" <-
    "gps_vertical_accuracy" <-
    "gps_speed" <-
    "gps_course" <-
    "crop_gs" <-
    "growth_stage" <-
    "incidence" <-
    "disease" <-
    "disease.x" <-
    "disease.y" <-
    "." <- NULL #nocov end

  readr::read_csv(
    .url,
    na = c(""),
    col_types = readr::cols(
      fulcrum_id = readr::col_character(),
      created_at = readr::col_character(),
      updated_at = readr::col_character(),
      created_by = readr::col_character(),
      updated_by = readr::col_character(),
      system_created_at = readr::col_character(),
      system_updated_at = readr::col_character(),
      version = readr::col_integer(),
      status = readr::col_character(),
      project = readr::col_character(),
      assigned_to = readr::col_character(),
      latitude = readr::col_double(),
      longitude = readr::col_double(),
      geometry = readr::col_character(),
      season = readr::col_character(),
      paddockproperty = readr::col_character(),
      location_description = readr::col_character(),
      location_description_other = readr::col_logical(),
      landform = readr::col_character(),
      nearest_town = readr::col_character(),
      region = readr::col_character(),
      grower = readr::col_character(),
      growers_phone_number = readr::col_character(),
      agronomist = readr::col_character(),
      agronomists_phone_number = readr::col_character(),
      crop = readr::col_character(),
      cultivar = readr::col_character(),
      canola_growth_stage_ = readr::col_character(),
      chickpea_growth_stage_ = readr::col_character(),
      maize_growth_stage_ = readr::col_character(),
      mungbean_growth_stage_ = readr::col_character(),
      peanut_growth_stage_ = readr::col_character(),
      sorghum_growth_stage_ = readr::col_character(),
      soybean_growth_stage_ = readr::col_character(),
      sunflower_growth_stage_ = readr::col_character(),
      winter_cereal_growth_stage_ = readr::col_character(),
      total_plant_count = readr::col_integer(),
      barley_fusarium_head_blightscab = readr::col_integer(),
      barley_net_form_net_blotch = readr::col_integer(),
      barley_spot_form_net_blotch = readr::col_integer(),
      barley_powdery_mildew = readr::col_integer(),
      barley_stem_rust = readr::col_integer(),
      barley_virus = readr::col_integer(),
      barley_other = readr::col_integer(),
      describe_barley_other = readr::col_character(),
      canola_powdery_mildew = readr::col_integer(),
      canola_blackleg = readr::col_integer(),
      canola_sclerotinia_stem_rot = readr::col_integer(),
      virus_of_canola = readr::col_integer(),
      canola_other = readr::col_integer(),
      describe_canola_other = readr::col_character(),
      chickpea_ascochyta_blight = readr::col_integer(),
      chickpea_botrytis_grey_mould = readr::col_integer(),
      chickpea_fusarium_wilt = readr::col_integer(),
      chickpea_phytoplasma = readr::col_integer(),
      chickpea_phytophthora_root_rot = readr::col_integer(),
      chickpea_virus = readr::col_integer(),
      chickpea_other = readr::col_integer(),
      describe_chickpea_other = readr::col_character(),
      maize_bacterial_stalk_rot_and_bacterial_top_rot = readr::col_integer(),
      maize_charcoal_rot = readr::col_integer(),
      maize_common_rust = readr::col_integer(),
      maize_commonboil_smut = readr::col_integer(),
      maize_crazy_top = readr::col_integer(),
      maize_damping_off = readr::col_integer(),
      maize_diplodia_cob_rot = readr::col_integer(),
      maize_downy_mildew = readr::col_integer(),
      maize_dwarf_mosaic_virus = readr::col_integer(),
      maize_fusarium_ear_rot = readr::col_integer(),
      maize_fusarium_stalk_rot = readr::col_integer(),
      maize_head_smut = readr::col_integer(),
      maize_pythium_stalk_rot = readr::col_integer(),
      maize_turcica_leaf_blight = readr::col_integer(),
      maize_maydis_leaf_blight = readr::col_integer(),
      maize_southern_rust = readr::col_integer(),
      maize_virus = readr::col_integer(),
      maize_other = readr::col_integer(),
      describe_maize_other = readr::col_character(),
      mungbean_alternaria_leaf_spot = readr::col_integer(),
      mungbean_bacterial_blight = readr::col_integer(),
      mungbean_charcoal_rot = readr::col_integer(),
      mungbean_damping_off = readr::col_integer(),
      mungbean_fusarium_wilt = readr::col_integer(),
      mungbean_gummy_pod = readr::col_integer(),
      mungbean_halo_blight = readr::col_integer(),
      mungbean_phytoplasma = readr::col_integer(),
      mungbean_powdery_mildew = readr::col_integer(),
      mungbean_puffy_pod = readr::col_integer(),
      mungbean_rhizoctonia_rot = readr::col_integer(),
      mungbean_root_lesion_nematode = readr::col_integer(),
      mungbean_sclerotinia_stem_rot = readr::col_integer(),
      mungbean_sclerotium_stem_rot = readr::col_integer(),
      mungbean_tan_spot = readr::col_integer(),
      mungbean_tsv = readr::col_integer(),
      mungbean_virus = readr::col_integer(),
      mungbean_other = readr::col_integer(),
      describe_mungbean_other = readr::col_character(),
      peanut_fusarium_root_rot = readr::col_integer(),
      peanut_neocosmospora_root_rot = readr::col_integer(),
      peanut_net_blotch = readr::col_integer(),
      peanut_kernel_shrivel_syndrome = readr::col_integer(),
      peanut_root_lesion_nematode = readr::col_integer(),
      peanut_rust = readr::col_integer(),
      peanut_sclerotium_base_rot = readr::col_integer(),
      peanut_tsv = readr::col_integer(),
      peanut_virus = readr::col_integer(),
      peanut_other = readr::col_integer(),
      describe_peanut_other = readr::col_character(),
      sorghum_bacterial_top_and_stalk_rot = readr::col_integer(),
      sorghum_charcoal_rot = readr::col_integer(),
      sorghum_damping_off = readr::col_integer(),
      sorghum_ergot = readr::col_integer(),
      sorghum_fusarium_head_blight = readr::col_integer(),
      sorghum_fusarium_stalk_rot = readr::col_integer(),
      sorghum_grain_mould = readr::col_integer(),
      sorghum_head_smut = readr::col_integer(),
      sorghum_johnsongrass_mosaic_virus = readr::col_integer(),
      sorghum_leaf_blight = readr::col_integer(),
      sorghum_root_lesion_nematode = readr::col_integer(),
      sorghum_rust = readr::col_integer(),
      sorghum_sclerotium_base_rot = readr::col_integer(),
      sorghum_tar_spot = readr::col_integer(),
      sorghum_other = readr::col_integer(),
      describe_sorghum_other = readr::col_character(),
      soybean_bacterial_blight_bacterial_pustule = readr::col_integer(),
      soybean_charcoal_rot = readr::col_integer(),
      soybean_damping_off = readr::col_integer(),
      soybean_peanut_mottle_virus = readr::col_integer(),
      soybean_phomopsis_seed_decay = readr::col_integer(),
      soybean_phytophthora_root_stem_and_root_rot = readr::col_integer(),
      soybean_phytoplasma = readr::col_integer(),
      soybean_pod_stem_cankerblight = readr::col_integer(),
      soybean_powdery_mildew = readr::col_integer(),
      soybean_purple_seed_stain = readr::col_integer(),
      soybean_rhizoctonia_rot = readr::col_integer(),
      soybean_root_lesion_nematode = readr::col_integer(),
      soybean_rust = readr::col_integer(),
      soybean_sclerotinia_rot = readr::col_integer(),
      soybean_mosaic_virus = readr::col_integer(),
      soybean_virus = readr::col_integer(),
      soybean_other = readr::col_integer(),
      describe_soybean_other = readr::col_character(),
      sunflower_apical_chlorosis = readr::col_integer(),
      sunflower_botrytis_head_rot_grey_mould = readr::col_integer(),
      sunflower_charcoal_rot = readr::col_integer(),
      sunflower_powdery_mildew = readr::col_integer(),
      sunflower_rhizopus_head_rot = readr::col_integer(),
      sunflower_rust = readr::col_integer(),
      sunflower_sclerotinia_rot = readr::col_integer(),
      sunflower_sclerotium_base_rot = readr::col_integer(),
      sunflower_stem_cankerblight = readr::col_integer(),
      sunflower_tsv = readr::col_integer(),
      sunflower_verticillium_wilt = readr::col_integer(),
      sunflower_other = readr::col_integer(),
      describe_sunflower_other = readr::col_character(),
      wheat_fusarium_head_blightscab = readr::col_integer(),
      wheat_crown_rot = readr::col_integer(),
      wheat_common_root_rot = readr::col_integer(),
      wheat_leafbrown_rust = readr::col_integer(),
      wheat_root_lesion_nematode = readr::col_integer(),
      wheat_septoria_nodorum_blotch = readr::col_integer(),
      wheat_stemblack_rust = readr::col_integer(),
      wheat_stripeyellow_rust = readr::col_integer(),
      wheat_yellow_spot = readr::col_integer(),
      wheat_white_grain = readr::col_integer(),
      wheat_other = readr::col_integer(),
      describe_wheat_other = readr::col_character(),
      notes = readr::col_character(),
      photos = readr::col_character(),
      photos_caption = readr::col_character(),
      photos_url = readr::col_character(),
      gps_altitude = readr::col_double(),
      gps_horizontal_accuracy = readr::col_double(),
      gps_vertical_accuracy = readr::col_double(),
      gps_speed = readr::col_double(),
      gps_course = readr::col_character()
    )
  )
}

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
