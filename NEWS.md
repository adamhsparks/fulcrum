# fulcrum 0.2.1.9000

# 0.2.1

## Minor Changes

- Uses `geom_bin2d` in place of `geom_hex` due to issues displaying a single point or two with hexes

- Adds a "state" column to the data returned from `get_fulcrum()`

# 0.2.0

## Major Changes

- Adds `map_fulcrum()` function

# 0.1.3

## Minor changes

- Return `sf` object from `get_fulcrum()` that is projected in Australia Albers

# 0.1.2

## Minor Changes

- Add federation level data outline for mapping

- Add state level data for labelling and mapping

- Project both sets of data to Albers


# 0.1.1

## Bug Fixes

- Fixes bugs in prior release so that it now passes checks

# 0.1.0

## Major Changes

- Adds new functionality, `disease_boxplot()` to generate boxplots of survey results for reporting

# 0.0.2-1

## Bug Fixes

- Adds `sf` to Suggests
