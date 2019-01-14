#' Fetches Data from Fulcrum.app and Formats Them for Use in Reporting
#'
#' Fetch and clean Fulcrum data from USQ/DAFQ in-paddock surveys of crop
#' disease incidence and oher related notes for reporting.
#' @param url A url provided by \url{https://www.fulcrumapp.com/} for sharing a
#' 'CSV' format fill of Fulcrum data
#' @return A tidy data frame \code{tibble} object of Fulcrum survey data
#' @examples
#'
#' \dontrun{
#' # using a URL set in the .Renviron, get data from Fulcrum
#' fd <- get_fulcrum()
#' }
#'
#' \dontrun{
#' # specify a url to get data from Fulcrum
#' fd <- get_fulcrum(url = "https://web.fulcrumapp.com/shares/########.csv")
#' }
#'
#' @author Sparks, Adam H. \email{adam.sparks@@usq.edu.au}
#' @export get_fulcrum
#' @importFrom magrittr "%>%"
get_fulcrum <- function(url = NULL) {
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
    "barley_net_form_spot_blotch" <-
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

  # get URL using system environment if not otherwise provided -----------------
  if (is.null(url)) {
    url <- Sys.getenv("FULCRUM_DATA_URL")
  }

  # fetch data from fulcrumapp.com ---------------------------------------------
  fd <-
    readr::read_csv(
      url,
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
        barley_net_form_spot_blotch = readr::col_integer(),
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

  # create a tibble for crop metadata ------------------------------------------
  # crop
  # cultivar
  # growth_stage
  crop_meta <-
    fd  %>% dplyr::select(fulcrum_id, crop:winter_cereal_growth_stage_) %>%
    tidyr::gather(key = crop_gs,
                  value = growth_stage,
                  c(-fulcrum_id, -crop, -cultivar)) %>%
    dplyr::select(-crop_gs) %>%
    tidyr::drop_na(growth_stage)

  # create tibble for disease observations -------------------------------------
  # disease
  # incidence in paddock
  disease_incidence <- .create_di_df(.fd = fd)

  # if there is something not described, move description from incidence field
  # to disease field
  #
  # filter only
  other_disease <-
    disease_incidence %>%
    dplyr::filter(grepl("other", disease) &
                    !grepl("describe", disease)) %>%
    tidyr::drop_na(incidence)

  describe_other <-
    disease_incidence %>%
    dplyr::filter(grepl("describe", disease)) %>%
    dplyr::select(-disease) %>%
    dplyr::rename(disease = incidence) %>%
    dplyr::distinct()

  other_disease <-
    dplyr::left_join(describe_other, other_disease, by = "fulcrum_id") %>%
    dplyr::mutate(disease = ifelse(!is.na(disease.x), disease.x, disease.y)) %>%
    dplyr::select(-disease.x, -disease.y)

  # remove any "other" diseases requiring description from original and add
  # `other_disease` for final `disease_incidence` tibble
  disease_incidence <-
    dplyr::filter(disease_incidence, !grepl("other", disease)) %>%
    dplyr::left_join(disease_incidence,
                     other_disease,
                     by = c("fulcrum_id", "disease", "incidence")) %>%
    tidyr::drop_na(incidence)

  # create a tibble for geocoded locations -------------------------------------
  # lon
  # lat
  # nearest town
  # region
  xy <- fd %>%
    dplyr::select(fulcrum_id, latitude, longitude, nearest_town, region) %>%
    dplyr::mutate(nearest_town = tolower(nearest_town)) %>%
    dplyr::mutate(nearest_town = tools::toTitleCase(nearest_town))

  # create a tibble for observer and observation metadata ----------------------
  # when created
  # when modified
  # who created
  # who modified
  # version (1 is original)
  # what season does the observation cover
  # how many plants were checked
  observation_meta <- fd %>%
    dplyr::select(fulcrum_id, created_at:version, season, total_plant_count)

  # create a tibble for paddock information ------------------------------------
  # USQ paddock identifcation number
  # Type of location (farm field, commercial trial, etc.)
  # landform (irrigated or dryland)
  # grower's name
  # grower's contact info
  # agronomist's name
  # agronomist's contact info
  # any freeform notes taken
  paddock_meta <- fd %>%
    dplyr::select(
      fulcrum_id,
      paddockproperty:location_description,
      landform,
      grower:agronomists_phone_number,
      notes
    ) %>%
    dplyr::mutate(grower = tolower(grower)) %>%
    dplyr::mutate(grower = tools::toTitleCase(grower)) %>%
    dplyr::mutate(grower = tolower(agronomist)) %>%
    dplyr::mutate(grower = tools::toTitleCase(agronomist))

  out <-
    dplyr::left_join(observation_meta, paddock_meta, by = "fulcrum_id") %>%
    dplyr::left_join(., xy, by = "fulcrum_id") %>%
    dplyr::left_join(., crop_meta, by = "fulcrum_id") %>%
    dplyr::left_join(., disease_incidence, by = "fulcrum_id")

}
