# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

generate_dots <- function(file_path, columns = c(), per_dot = 100) {
  library('tidyverse')
  library('sf')
  library('lwgeom')
  # read in the data, select only what's needed, and divide variables
  # by the per_dot factor. Include a total of the new per_dot.

  # TODO make mutate dynamic from col names
  all_columns <- columns %>% append('geometry')
  tracts <- st_read(file_path) %>%
    as.data.frame %>%
    select(all_columns) %>%
    mutate(
      total = rowSums(.[, columns]) / per_dot
    ) %>%
    st_sf

  # randomly distribute dots from the tracts and join back in
  # Notice:
  # When sampling polygons, the returned sampling size may differ from the requested size,
  # as the bounding box is sampled, and sampled points intersecting the polygon are returned.
  dots <- tracts %>%
    st_sample(tracts$total) %>%
    st_sf %>%
    st_join(tracts)

  flatten1 <- function(x) {
    y <- list()
    rapply(x, function(x) y <<- c(y,x))
    y
  }

  # create a new column called category and generate a list of elements
  # for each variable. Then, randomly sample from that list.
  # Distribution or weighting is reflected in the number of elements
  dots <- dots %>%
    rowwise %>%
    mutate(
      category =
        list(
          flatten1(
            lapply(
              columns,
              function(current, row) {
                return(rep(current, as.integer(row[[current]]/10)))
              },
              .data
            )
          )
        )
    ) %>%
    mutate(
      category = sample(category, 1)
    ) %>%
    ungroup

  return(dots)
}
