Create Qld and NSW State Map Base
================

## Load Libraries

``` r
library(rnaturalearth)
library(sf)
```

    ## Linking to GEOS 3.7.1, GDAL 2.3.2, PROJ 5.2.0

# Get the Data to Create Our Map

### Add a Shapefile of Australia

This is our base layer, Australia, of the map from
(Naturalearth.com)\[<https://naturalearth.com/>\]

``` r
oz_sf <- ne_states(geounit = "australia",
                      returnclass = "sf")

plot(oz_sf)
```

    ## Warning: plotting the first 9 out of 83 attributes; use max.plot = 83 to
    ## plot all

![](README_files/figure-gfm/australia-1.png)<!-- -->

However, for the data that this package is intended for use with, only
New South Wales and Queensland are necessary.

``` r
oz_sf <- st_crop(x = oz_sf,
                 xmin = 138.0002,
                 ymin = -37.51029,
                 xmax = 153.6306,
                 ymax = -9.240167)
```

    ## although coordinates are longitude/latitude, st_intersection assumes that they are planar

    ## Warning: attribute variables are assumed to be spatially constant
    ## throughout all geometries

``` r
oz_sf <- oz_sf[oz_sf$abbrev != "J.B.T.", ]

plot(oz_sf)
```

    ## Warning: plotting the first 10 out of 83 attributes; use max.plot = 83 to
    ## plot all

![](README_files/figure-gfm/crop_shape-1.png)<!-- -->

## Save Data for Use as Base Map

``` r
usethis::use_data(oz_sf)
```

    ## ✔ Setting active project to '/Users/asparks/Development/fulcrum'
    ## ✔ Creating 'data/'
    ## ✔ Saving 'oz_sf' to 'data/oz_sf.rda'
