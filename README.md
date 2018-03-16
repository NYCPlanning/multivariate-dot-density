# labs-multivariate-dot-density
R script for creating multivariate dot density data.

![Image](https://github.com/NYCPlanning/labs-multivariate-dot-density/blob/master/screenshot.png?raw=true)

## Installation
```R
install.packages('devtools')
install_github('nycplanning/multivariate-dot-density')
```

## Function
```R
generate_dots(
  "data/tracts/region_censustract_v0/region_censustract_v0.shp", # path to spatial data file, could be shape or geojson
  c('EmOff15', 'EmIns15', 'EmInd15', 'EmSer15', 'EmOth15'), # exactly case-sensitive names of columns used for multivariate
  100 # per-dot population factor
)
```

This will assume the presence of a single polygon `geometry` column on the input dataset. The second integer determines the number of dots for each population. 

## About
The [DCP Metro Mapper](https://github.com/NYCPlanning/labs-regional-viz) includes a number of multivariate dot density maps. The challenge with multivariate dot density is the need for performing additional data manipulation before and especially after random dots are distributed. Doing this alone in SQL requires specific knowledge about which database version you're using, and doing data manipulation in desktop GIS is clunky and error-prone. This script streamlines the process into a single function.
