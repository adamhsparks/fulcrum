#' Fetches Data from Fulcrum.app and Formats it for Use in Reporting
#'
#' Fetch and clean Fulcrum data from USQ/DAFQ in-paddock surveys of crop
#' disease incidence and oher related notes for reporting.
#'
#' @return A tidy data frame \code{tibble} object of Fulcrum survey data
#' @examples
#' \donttest{
#' fd <- get_fulcrum()
#' }
#' @export get_fulcrum
#'
get_fulcrum <- function() {
  FULCRUM_DATA_URL <- Sys.getenv("FULCRUM_DATA_URL")

  fd <-
    readr::read_csv(
      FULCRUM_DATA_URL,
      na = c(""),
      col_types = readr::cols(
        fulcrum_id = readr::col_character(),
        created_at = readr::col_character(),
        updated_at = readr::col_character(),
        created_by = readr::col_character(),
        updated_by = readr::col_character(),
        system_created_at = readr::col_character(),
        system_updated_at = readr::col_character(),
        version = readr::col_double(),
        status = readr::col_logical(),
        project = readr::col_logical(),
        assigned_to = readr::col_logical(),
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
        canola_growth_stage_ = readr::col_logical(),
        chickpea_growth_stage_ = readr::col_logical(),
        maize_growth_stage_ = readr::col_logical(),
        mungbean_growth_stage_ = readr::col_logical(),
        peanut_growth_stage_ = readr::col_logical(),
        sorghum_growth_stage_ = readr::col_logical(),
        soybean_growth_stage_ = readr::col_logical(),
        sunflower_growth_stage_ = readr::col_character(),
        winter_cereal_growth_stage_ = readr::col_character(),
        total_plant_count = readr::col_double(),
        barley_fusarium_head_blightscab = readr::col_double(),
        barley_net_form_spot_blotch = readr::col_double(),
        barley_spot_form_net_blotch = readr::col_double(),
        barley_powdery_mildew = readr::col_double(),
        barley_stem_rust = readr::col_double(),
        barley_virus = readr::col_double(),
        barley_other = readr::col_double(),
        describe_barley_other = readr::col_logical(),
        canola_powdery_mildew = readr::col_logical(),
        canola_blackleg = readr::col_logical(),
        canola_sclerotinia_stem_rot = readr::col_logical(),
        virus_of_canola = readr::col_logical(),
        canola_other = readr::col_logical(),
        describe_canola_other = readr::col_logical(),
        chickpea_ascochyta_blight = readr::col_logical(),
        chickpea_botrytis_grey_mould = readr::col_logical(),
        chickpea_fusarium_wilt = readr::col_logical(),
        chickpea_phytoplasma = readr::col_logical(),
        chickpea_phytophthora_root_rot = readr::col_logical(),
        chickpea_virus = readr::col_logical(),
        chickpea_other = readr::col_logical(),
        describe_chickpea_other = readr::col_logical(),
        maize_bacterial_stalk_rot_and_bacterial_top_rot = readr::col_logical(),
        maize_charcoal_rot = readr::col_logical(),
        maize_common_rust = readr::col_logical(),
        maize_commonboil_smut = readr::col_logical(),
        maize_crazy_top = readr::col_logical(),
        maize_damping_off = readr::col_logical(),
        maize_diplodia_cob_rot = readr::col_logical(),
        maize_downy_mildew = readr::col_logical(),
        maize_dwarf_mosaic_virus = readr::col_logical(),
        maize_fusarium_ear_rot = readr::col_logical(),
        maize_fusarium_stalk_rot = readr::col_logical(),
        maize_head_smut = readr::col_logical(),
        maize_pythium_stalk_rot = readr::col_logical(),
        maize_turcica_leaf_blight = readr::col_logical(),
        maize_maydis_leaf_blight = readr::col_logical(),
        maize_southern_rust = readr::col_logical(),
        maize_virus = readr::col_logical(),
        maize_other = readr::col_logical(),
        describe_maize_other = readr::col_logical(),
        mungbean_alternaria_leaf_spot = readr::col_logical(),
        mungbean_bacterial_blight = readr::col_logical(),
        mungbean_charcoal_rot = readr::col_logical(),
        mungbean_damping_off = readr::col_logical(),
        mungbean_fusarium_wilt = readr::col_logical(),
        mungbean_gummy_pod = readr::col_logical(),
        mungbean_halo_blight = readr::col_logical(),
        mungbean_phytoplasma = readr::col_logical(),
        mungbean_powdery_mildew = readr::col_logical(),
        mungbean_puffy_pod = readr::col_logical(),
        mungbean_rhizoctonia_rot = readr::col_logical(),
        mungbean_root_lesion_nematode = readr::col_logical(),
        mungbean_sclerotinia_stem_rot = readr::col_logical(),
        mungbean_sclerotium_stem_rot = readr::col_logical(),
        mungbean_tan_spot = readr::col_logical(),
        mungbean_tsv = readr::col_logical(),
        mungbean_virus = readr::col_logical(),
        mungbean_other = readr::col_logical(),
        describe_mungbean_other = readr::col_logical(),
        peanut_fusarium_root_rot = readr::col_logical(),
        peanut_neocosmospora_root_rot = readr::col_logical(),
        peanut_net_blotch = readr::col_logical(),
        peanut_kernel_shrivel_syndrome = readr::col_logical(),
        peanut_root_lesion_nematode = readr::col_logical(),
        peanut_rust = readr::col_logical(),
        peanut_sclerotium_base_rot = readr::col_logical(),
        peanut_tsv = readr::col_logical(),
        peanut_virus = readr::col_logical(),
        peanut_other = readr::col_logical(),
        describe_peanut_other = readr::col_logical(),
        sorghum_bacterial_top_and_stalk_rot = readr::col_logical(),
        sorghum_charcoal_rot = readr::col_logical(),
        sorghum_damping_off = readr::col_logical(),
        sorghum_ergot = readr::col_logical(),
        sorghum_fusarium_head_blight = readr::col_logical(),
        sorghum_fusarium_stalk_rot = readr::col_logical(),
        sorghum_grain_mould = readr::col_logical(),
        sorghum_head_smut = readr::col_logical(),
        sorghum_johnsongrass_mosaic_virus = readr::col_logical(),
        sorghum_leaf_blight = readr::col_logical(),
        sorghum_root_lesion_nematode = readr::col_logical(),
        sorghum_rust = readr::col_logical(),
        sorghum_sclerotium_base_rot = readr::col_logical(),
        sorghum_tar_spot = readr::col_logical(),
        sorghum_other = readr::col_logical(),
        describe_sorghum_other = readr::col_logical(),
        soybean_bacterial_blight_bacterial_pustule = readr::col_logical(),
        soybean_charcoal_rot = readr::col_logical(),
        soybean_damping_off = readr::col_logical(),
        soybean_peanut_mottle_virus = readr::col_logical(),
        soybean_phomopsis_seed_decay = readr::col_logical(),
        soybean_phytophthora_root_stem_and_root_rot = readr::col_logical(),
        soybean_phytoplasma = readr::col_logical(),
        soybean_pod_stem_cankerblight = readr::col_logical(),
        soybean_powdery_mildew = readr::col_logical(),
        soybean_purple_seed_stain = readr::col_logical(),
        soybean_rhizoctonia_rot = readr::col_logical(),
        soybean_root_lesion_nematode = readr::col_logical(),
        soybean_rust = readr::col_logical(),
        soybean_sclerotinia_rot = readr::col_logical(),
        soybean_mosaic_virus = readr::col_logical(),
        soybean_virus = readr::col_logical(),
        soybean_other = readr::col_logical(),
        describe_soybean_other = readr::col_logical(),
        sunflower_apical_chlorosis = readr::col_double(),
        sunflower_botrytis_head_rot_grey_mould = readr::col_double(),
        sunflower_charcoal_rot = readr::col_double(),
        sunflower_powdery_mildew = readr::col_double(),
        sunflower_rhizopus_head_rot = readr::col_double(),
        sunflower_rust = readr::col_double(),
        sunflower_sclerotinia_rot = readr::col_double(),
        sunflower_sclerotium_base_rot = readr::col_double(),
        sunflower_stem_cankerblight = readr::col_double(),
        sunflower_tsv = readr::col_double(),
        sunflower_verticillium_wilt = readr::col_double(),
        sunflower_other = readr::col_double(),
        describe_sunflower_other = readr::col_logical(),
        wheat_fusarium_head_blightscab = readr::col_logical(),
        wheat_crown_rot = readr::col_logical(),
        wheat_common_root_rot = readr::col_logical(),
        wheat_leafbrown_rust = readr::col_logical(),
        wheat_root_lesion_nematode = readr::col_logical(),
        wheat_septoria_nodorum_blotch = readr::col_logical(),
        wheat_stemblack_rust = readr::col_logical(),
        wheat_stripeyellow_rust = readr::col_logical(),
        wheat_yellow_spot = readr::col_logical(),
        wheat_white_grain = readr::col_logical(),
        wheat_other = readr::col_logical(),
        describe_wheat_other = readr::col_logical(),
        notes = readr::col_character(),
        photos = readr::col_character(),
        photos_caption = readr::col_character(),
        photos_url = readr::col_character(),
        gps_altitude = readr::col_logical(),
        gps_horizontal_accuracy = readr::col_logical(),
        gps_vertical_accuracy = readr::col_logical(),
        gps_speed = readr::col_logical(),
        gps_course = readr::col_logical()
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
  disease_incidence <-
    fd %>%
    dplyr::select(fulcrum_id,
                  barley_fusarium_head_blightscab:describe_wheat_other) %>%
    tidyr::gather(key = disease,
                  value = incidence,
                  -fulcrum_id)

  # if there is something not described, move description from incidence field
  # to disease field
  #
  # filter only
  other_disease <-
    disease_incidence %>%
    dplyr::filter(grepl("other", disease) & !grepl("describe", disease)) %>%
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
    dplyr::left_join(disease_incidence, other_disease, by = c("fulcrum_id", "disease", "incidence")) %>%
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

  out <- dplyr::left_join(observation_meta, paddock_meta, by = "fulcrum_id") %>%
    dplyr::left_join(., xy, by = "fulcrum_id") %>%
    dplyr::left_join(., crop_meta, by = "fulcrum_id") %>%
    dplyr::left_join(., disease_incidence, by = "fulcrum_id") %>%
    View()
}
