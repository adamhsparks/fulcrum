[![Build Status](https://travis-ci.org/adamhsparks/fulcrum.svg?branch=master)](https://travis-ci.org/adamhsparks/fulcrum)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/adamhsparks/fulcrum?branch=master&svg=true)](https://ci.appveyor.com/project/adamhsparks/fulcrum)
[![Coverage status](https://codecov.io/gh/adamhsparks/fulcrum/branch/master/graph/badge.svg)](https://codecov.io/github/adamhsparks/fulcrum?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![DOI](https://zenodo.org/badge/161579332.svg)](https://zenodo.org/badge/latestdoi/161579332)

# fulcrum

The goal of `fulcrum` is to allow easy querying and cleaning of USQ/DAFQ paddock survey data for generating reports.

## Installation

You can install `fulcrum` from [GitHub](https://github.com/adamhsparks/fulcrum) with:

``` r
if (!require("remotes")) {
  install.packages("remotes", repos = "http://cran.rstudio.com/")
  library("remotes")
}

install_github("adamhsparks/fulcrum")
```

Please note that the 'fulcrum' project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.

