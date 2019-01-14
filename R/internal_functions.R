#' Creates Disease Incidence Data Frame
#' @param .fd Data frame containing Fulcrum data
#' @noRd
.create_di_df <- function(.fd) {
  fd %>%
    dplyr::select(fulcrum_id,
                  barley_fusarium_head_blightscab:describe_wheat_other) %>%
    tidyr::gather(key = disease,
                  value = incidence,
                  -fulcrum_id) %>%
    mutate(disease = replace(barley_fusarium_head_blightscab,
                             `fusarium head blight`)) %>%
    mutate(disease = replace(barley_net_form_spot_blotch,
                             `net form spot blotch`)) %>%
    mutate(disease = replace(barley_powdery_mildew, `powdery mildew`)) %>%
    mutate(disease = replace(barley_stem_rust, `stem (black) rust`)) %>%
    mutate(disease = replace(barley_virus, virus)) %>%
    mutate(disease = replace(canola_powdery_mildew, `powdery mildew`)) %>%
    mutate(disease = replace(canola_blackleg, blackleg)) %>%
    mutate(disease = replace(canola_sclerotinia_stem_rot, `stem rot`)) %>%
    mutate(disease = replace(virus_of_canola, virus)) %>%
    mutate(disease = replace(chickpea_ascochyta_blight,
                             `aschochyta blight`)) %>%
    mutate(disease = replace(chickpea_botrytis_grey_mould,
                             `botrytis grey mould`)) %>%
    mutate(disease = replace(chickpea_fusarium_wilt, `fusarium wilt`)) %>%
    mutate(disease = replace(chickpea_phytoplasma, phytoplasma)) %>%
    mutate(disease = replace(chickpea_phytophthora_root_rot,
                             `phytopthora root rot`)) %>%
    mutate(disease = replace(chickpea_virus, virus)) %>%
    mutate(
      disease = replace(
        maize_bacterial_stalk_rot_and_bacterial_top_rot,
        `bacterial stalk and top rot`
      )
    ) %>%
    mutate(disease = replace(maize_charcoal_rot, `charcoal rot`)) %>%
    mutate(disease = replace(maize_common_rust, `common rust`)) %>%
    mutate(disease = replace(maize_commonboil_smut, `boil smut`)) %>%
    mutate(disease = replace(maize_crazy_top, `crazy top`)) %>%
    mutate(disease = replace(maize_damping_off, `damping off`)) %>%
    mutate(disease = replace(maize_diplodia_cob_rot, `diplodia cob rot`)) %>%
    mutate(disease = replace(maize_downy_mildew, `downy mildew`)) %>%
    mutate(disease = replace(maize_fusarium_ear_rot, `fusarium ear rot`)) %>%
    mutate(disease = replace(maize_fusarium_stalk_rot,
                             `fusarium stalk rot`)) %>%
    mutate(disease = replace(maize_head_smut, `head smut`)) %>%
    mutate(disease = replace(maize_pythium_stalk_rot, `pythium stalk rot`)) %>%
    mutate(disease = replace(maize_turcica_leaf_blight,
                             `turica leaf blight`)) %>%
    mutate(disease = replace(maize_maydis_leaf_blight,
                             `maydis leaf blight`)) %>%
    mutate(disease = replace(maize_southern_rust, `southern rust`)) %>%
    mutate(disease = replace(maize_virus, virus)) %>%
    mutate(disease = replace(mungbean_alternaria_leaf_spot,
                             `alternaria leaf spot`)) %>%
    mutate(disease = replace(mungbean_bacterial_blight,
                             `bacterial leaf blight`)) %>%
    mutate(disease = replace(mungbean_charcoal_rot, `charcoal rot`)) %>%
    mutate(disease = replace(mungbean_damping_off, `damping off`)) %>%
    mutate(disease = replace(mungbean_fusarium_wilt, `fusarium wilt`)) %>%
    mutate(disease = replace(mungbean_gummy_pod, `gummy pod`)) %>%
    mutate(
      disease = replace(mungbean_halo_blight, `halo blight`) %>%
        mutate(disease = replace(mungbean_phytoplasma, phytoplasma)) %>%
        mutate(disease = replace(
          mungbean_powdery_mildew, `powdery mildew`
        )) %>%
        mutate(disease = replace(mungbean_puffy_pod, `puffy pod`)) %>%
        mutate(disease = replace(
          mungbean_rhizoctonia_rot, `rhizoctonia rot`
        )) %>%
        mutate(
          disease = replace(mungbean_root_lesion_nematode,
                            `root lesion nematode`)
        ) %>%
        mutate(
          disease = replace(mungbean_sclerotinia_stem_rot,
                            `sclerotinia stem rot`)
        ) %>%
        mutate(
          disease = replace(mungbean_sclerotium_stem_rot, `sclerotium stem rot`)
        ) %>%
        mutate(disease = replace(mungbean_tan_spot, `tan spot`)) %>%
        mutate(disease = replace(mungbean_tsv, `Tobacco Streak Virus`)) %>%
        mutate(disease = replace(mungbean_virus, virus)) %>%
        mutate(disease = replace(
          peanut_fusarium_root_rot, `fusarium root rot`
        )) %>%
        mutate(
          disease = replace(peanut_neocosmospora_root_rot,
                            `neocosmospora root rot`)
        ) %>%
        mutate(disease = replace(peanut_net_blotch, `net blotch`)) %>%
        mutate(
          disease = replace(
            peanut_kernel_shrivel_syndrome,
            `peanut kernel shrivel syndrome`
          )
        ) %>%
        mutate(
          disease = replace(peanut_root_lesion_nematode,
                            `root lesion nematode`)
        ) %>%
        mutate(disease = replace(peanut_rust, rust)) %>%
        mutate(disease = replace(
          peanut_sclerotium_base_rot, `sclerotium base rot`
        )) %>%
        mutate(disease = replace(peanut_tsv, `Tobacco Streak Virus`)) %>%
        mutate(disease = replace(peanut_virus, virus)) %>%
        mutate(
          disease = replace(
            sorghum_bacterial_top_and_stalk_rot,
            `bacterial top and stalk rot`
          )
        ) %>%
        mutate(disease = replace(sorghum_charcoal_rot, `charcoal rot`)) %>%
        mutate(disease = replace(sorghum_damping_off, `damping off`)) %>%
        mutate(disease = replace(sorghum_ergot, ergot)) %>%
        mutate(
          disease = replace(sorghum_fusarium_head_blight,
                            `fusarium head blight`)
        ) %>%
        mutate(disease = replace(
          sorghum_fusarium_stalk_rot, `fusarium stalk rot`
        )) %>%
        mutate(disease = replace(sorghum_grain_mould, `grain mould`)) %>%
        mutate(disease = replace(sorghum_head_smut, `head smut`)) %>%
        mutate(
          disease = replace(
            sorghum_johnsongrass_mosaic_virus,
            `Johnsongrass Mosaic Virus`
          )
        ) %>%
        mutate(disease = replace(sorghum_leaf_blight, `leaf blight`)) %>%
        mutate(
          disease = replace(sorghum_root_lesion_nematode,
                            `root lesion nematode`)
        ) %>%
        mutate(disease = replace(sorghum_rust, rust)) %>%
        mutate(
          disease = replace(sorghum_sclerotium_base_rot, `sclerotium base rot`)
        ) %>%
        mutate(disease = replace(sorghum_tar_spot, `tar spot`)) %>%
        mutate(
          disease = replace(
            soybean_bacterial_blight_bacterial_pustule,
            `bacterial blight pustule`
          )
        ) %>%
        mutate(disease = replace(soybean_charcoal_rot, `charcoal rot`)) %>%
        mutate(disease = replace(soybean_damping_off, `damping off`)) %>%
        mutate(
          disease = replace(soybean_peanut_mottle_virus, `Peanut Mottle Virus`)
        ) %>%
        mutate(
          disease = replace(soybean_phomopsis_seed_decay,
                            `phomopsis seed decay`)
        ) %>%
        mutate(
          disease = replace(
            soybean_phytophthora_root_stem_and_root_rot,
            `phytophthora root and stem rot`
          )
        ) %>%
        mutate(disease = replace(soybean_phytoplasma, phytoplasma)) %>%
        mutate(
          disease = replace(soybean_pod_stem_cankerblight,
                            `pod and stem canker/blight`)
        ) %>%
        mutate(disease = replace(
          soybean_powdery_mildew, `powdery mildew`
        )) %>%
        mutate(disease = replace(
          soybean_purple_seed_stain, `purple seed stain`
        )) %>%
        mutate(disease = replace(
          soybean_rhizoctonia_rot, `rhizoctonia rot`
        )) %>%
        mutate(
          disease = replace(soybean_root_lesion_nematode,
                            `root lesion nematode`)
        ) %>%
        mutate(disease = replace(soybean_rust, rust)) %>%
        mutate(disease = replace(
          soybean_sclerotinia_rot, `sclerotinia rot`
        )) %>%
        mutate(disease = replace(
          soybean_mosaic_virus, `Soybean Mosaic Virus`
        )) %>%
        mutate(disease = replace(soybean_virus, virus)) %>%
        mutate(disease = replace(
          sunflower_apical_chlorosis, `apical chlorosis`
        )) %>%
        mutate(
          disease = replace(
            sunflower_botrytis_head_rot_grey_mould,
            `botrytis head rot or grey mould`
          )
        ) %>%
        mutate(disease = replace(sunflower_charcoal_rot, `charcoal rot`)) %>%
        mutate(disease = replace(
          sunflower_powdery_mildew, `powdery mildew`
        )) %>%
        mutate(disease = replace(
          sunflower_rhizopus_head_rot, `rhizopus head rot`
        )) %>%
        mutate(disease = replace(sunflower_rust, rust)) %>%
        mutate(disease = replace(
          sunflower_sclerotinia_rot, `sclerotinia rot`
        )) %>%
        mutate(sunflower_sclerotium_base_rot, `sclerotium base rot`)
    ) %>%
    mutate(disease = replace(sunflower_stem_cankerblight,
                             `stem canker and blight`)) %>%
    mutate(disease = replace(sunflower_tsv, `Tobacco Streak Virus`)) %>%
    mutate(disease = replace(sunflower_verticillium_wilt,
                             `verticillium wilt`)) %>%
    mutate(disease = replace(wheat_fusarium_head_blightscab,
                             `fusarium head blight`)) %>%
    mutate(disease = replace(wheat_crown_rot, `crown rot`)) %>%
    mutate(disease = replace(wheat_common_root_rot, `common root rot`)) %>%
    mutate(disease = replace(wheat_leafbrown_rust, `leaf (brown) rust`)) %>%
    mutate(disease = replace(wheat_root_lesion_nematode,
                             `root lesion nematode`)) %>%
    mutate(disease = replace(wheat_septoria_nodorum_blotch,
                             `septoria nodorum blotch`)) %>%
    mutate(disease = replace(wheat_stemblack_rust, `stem (black) rust`)) %>%
    mutate(disease = replace(wheat_stripeyellow_rust,
                             `stripe (yellow) rust`)) %>%
    mutate(disease = replace(wheat_yellow_spot, `yellow spot`)) %>%
    mutate(disease = replace(wheat_white_grain, `white grain`))
}