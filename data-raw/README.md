Untitled
================

## GitHub Documents

This is an R Markdown format used for publishing markdown documents to
GitHub. When you click the **Knit** button all R code chunks are run and
a markdown file (.md) suitable for publishing to GitHub is generated.

## Including Code

You can include R code in the document as follows:

``` r
test <- data.table::fread("daq00186_surveys.csv")
test
```

    ##                              fulcrum_id               created_at
    ## 1: d440bd00-5630-4942-8f59-ee9189a97166 2018-12-13 18:08:34 AEST
    ##                  updated_at             created_by             updated_by
    ## 1: 2018-12-13 18:09:43 AEST adam.sparks@usq.edu.au adam.sparks@usq.edu.au
    ##           system_created_at        system_updated_at version status
    ## 1: 2018-12-13 18:09:46 AEST 2018-12-13 18:09:46 AEST       1     NA
    ##    project assigned_to  latitude longitude
    ## 1:      NA          NA -27.56781  151.9634
    ##                                      geometry paddockproperty
    ## 1: POINT (151.963439639799 -27.5678080832842)            Test
    ##    location_description nearest_town      state state_other grower
    ## 1:                   NA           NA Queensland          NA Sparky
    ##    growers_phone_number agronomist agronomists_phone_number   crop
    ## 1:                   NA         NA                       NA Barley
    ##    canola_growth_stage_ chickpea_growth_stage_ maize_growth_stage_
    ## 1:                   NA                     NA                  NA
    ##    mungbean_growth_stage_ peanut_growth_stage_ sorghum_growth_stage_
    ## 1:                     NA                   NA                    NA
    ##    soybean_growth_stage_ sunflower_growth_stage_
    ## 1:                    NA                      NA
    ##    winter_cereal_growth_stage_ total_plant_count
    ## 1:    34 - 4th node detectable                 3
    ##    barley_fusarium_head_blightscab barley_net_form_spot_blotch
    ## 1:                               4                           5
    ##    barley_spot_form_net_blotch barley_powdery_mildew barley_stem_rust
    ## 1:                           0                     0                0
    ##    barley_virus barley_other describe_barley_other canola_powdery_mildew
    ## 1:            0            0                    NA                    NA
    ##    canola_blackleg canola_sclerotinia_stem_rot virus_of_canola
    ## 1:              NA                          NA              NA
    ##    canola_other describe_canola_other chickpea_ascochyta_blight
    ## 1:           NA                    NA                        NA
    ##    chickpea_botrytis_grey_mould chickpea_fusarium_wilt
    ## 1:                           NA                     NA
    ##    chickpea_phytoplasma chickpea_phytophthora_root_rot chickpea_virus
    ## 1:                   NA                             NA             NA
    ##    chickpea_other describe_chickpea_other
    ## 1:             NA                      NA
    ##    maize_bacterial_stalk_rot_and_bacterial_top_rot maize_charcoal_rot
    ## 1:                                              NA                 NA
    ##    maize_common_rust maize_commonboil_smut maize_crazy_top
    ## 1:                NA                    NA              NA
    ##    maize_damping_off maize_diplodia_cob_rot maize_downy_mildew
    ## 1:                NA                     NA                 NA
    ##    maize_dwarf_mosaic_virus maize_fusarium_ear_rot
    ## 1:                       NA                     NA
    ##    maize_fusarium_stalk_rot maize_head_smut maize_pythium_stalk_rot
    ## 1:                       NA              NA                      NA
    ##    maize_turcica_leaf_blight maize_maydis_leaf_blight maize_southern_rust
    ## 1:                        NA                       NA                  NA
    ##    maize_virus maize_other describe_maize_other
    ## 1:          NA          NA                   NA
    ##    mungbean_alternaria_leaf_spot mungbean_bacterial_blight
    ## 1:                            NA                        NA
    ##    mungbean_charcoal_rot mungbean_damping_off mungbean_fusarium_wilt
    ## 1:                    NA                   NA                     NA
    ##    mungbean_gummy_pod mungbean_halo_blight mungbean_phytoplasma
    ## 1:                 NA                   NA                   NA
    ##    mungbean_powdery_mildew mungbean_puffy_pod mungbean_rhizoctonia_rot
    ## 1:                      NA                 NA                       NA
    ##    mungbean_root_lesion_nematode mungbean_sclerotinia_stem_rot
    ## 1:                            NA                            NA
    ##    mungbean_sclerotium_stem_rot mungbean_tan_spot mungbean_tsv
    ## 1:                           NA                NA           NA
    ##    mungbean_virus mungbean_other describe_mungbean_other
    ## 1:             NA             NA                      NA
    ##    peanut_fusarium_root_rot peanut_neocosmospora_root_rot
    ## 1:                       NA                            NA
    ##    peanut_net_blotch peanut_kernel_shrivel_syndrome
    ## 1:                NA                             NA
    ##    peanut_root_lesion_nematode peanut_rust peanut_sclerotium_base_rot
    ## 1:                          NA          NA                         NA
    ##    peanut_tsv peanut_virus peanut_other describe_peanut_other
    ## 1:         NA           NA           NA                    NA
    ##    sorghum_bacterial_top_and_stalk_rot sorghum_charcoal_rot
    ## 1:                                  NA                   NA
    ##    sorghum_damping_off sorghum_ergot sorghum_fusarium_head_blight
    ## 1:                  NA            NA                           NA
    ##    sorghum_fusarium_stalk_rot sorghum_grain_mould sorghum_head_smut
    ## 1:                         NA                  NA                NA
    ##    sorghum_johnsongrass_mosaic_virus sorghum_leaf_blight
    ## 1:                                NA                  NA
    ##    sorghum_root_lesion_nematode sorghum_rust sorghum_sclerotium_base_rot
    ## 1:                           NA           NA                          NA
    ##    sorghum_tar_spot sorghum_other describe_sorghum_other
    ## 1:               NA            NA                     NA
    ##    soybean_bacterial_blight_bacterial_pustule soybean_charcoal_rot
    ## 1:                                         NA                   NA
    ##    soybean_damping_off soybean_peanut_mottle_virus
    ## 1:                  NA                          NA
    ##    soybean_phomopsis_seed_decay
    ## 1:                           NA
    ##    soybean_phytophthora_root_stem_and_root_rot soybean_phytoplasma
    ## 1:                                          NA                  NA
    ##    soybean_pod_stem_cankerblight soybean_powdery_mildew
    ## 1:                            NA                     NA
    ##    soybean_purple_seed_stain soybean_rhizoctonia_rot
    ## 1:                        NA                      NA
    ##    soybean_root_lesion_nematode soybean_rust soybean_sclerotinia_rot
    ## 1:                           NA           NA                      NA
    ##    soybean_mosaic_virus soybean_virus soybean_other describe_soybean_other
    ## 1:                   NA            NA            NA                     NA
    ##    sunflower_apical_chlorosis sunflower_botrytis_head_rot_grey_mould
    ## 1:                         NA                                     NA
    ##    sunflower_charcoal_rot sunflower_powdery_mildew
    ## 1:                     NA                       NA
    ##    sunflower_rhizopus_head_rot sunflower_rust sunflower_sclerotinia_rot
    ## 1:                          NA             NA                        NA
    ##    sunflower_sclerotium_base_rot sunflower_stem_cankerblight sunflower_tsv
    ## 1:                            NA                          NA            NA
    ##    sunflower_verticillium_wilt sunflower_other describe_sunflower_other
    ## 1:                          NA              NA                       NA
    ##    wheat_fusarium_head_blightscab wheat_crown_rot wheat_common_root_rot
    ## 1:                             NA              NA                    NA
    ##    wheat_leafbrown_rust wheat_root_lesion_nematode
    ## 1:                   NA                         NA
    ##    wheat_septoria_nodorum_blotch wheat_stemblack_rust
    ## 1:                            NA                   NA
    ##    wheat_stripeyellow_rust wheat_yellow_spot wheat_white_grain wheat_other
    ## 1:                      NA                NA                NA          NA
    ##    describe_wheat_other notes photos photos_caption photos_url
    ## 1:                   NA    NA     NA             NA         NA
    ##    gps_altitude gps_horizontal_accuracy gps_vertical_accuracy gps_speed
    ## 1:      555.479                      30                    16         0
    ##    gps_course
    ## 1:         -1

## Including Plots

You can also embed plots, for example:

![](README_files/figure-gfm/pressure-1.png)<!-- -->

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.
