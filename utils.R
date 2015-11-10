# Dependencies
library(plyr)
library(magrittr)
library(reshape2)
library(polloi)

# Read in action data and write it into the global scope with sufficient formatting to be trivially
# used in dygraphs.
read_actions <- function() {
  # Read in data, split and rename it, and write it o
  data <- polloi::read_dataset("maps/actions_per_tool.tsv") %>%
    dplyr::rename(date = timestamp)
  data <- split(data[, c(1, 3, 4)], data$feature)
  usage_data <<- lapply(data, reshape2::dcast, formula = date ~ variable, fun.aggregate = sum)
  return(invisible())
}

# Read in user count
read_users <- function() {
  data <- polloi::read_dataset("maps/users_per_feature.tsv") %>%
    dplyr::rename(date = timestamp)
  interim <- reshape2::dcast(data, formula = date ~ variable, fun.aggregate = sum)
  interim[is.na(interim)] <- 0
  user_data <<- interim
  return(invisible())
}

read_tiles <- function() {
  interim <- polloi::read_dataset("maps/tile_aggregates.tsv", col_types = "Dcidcciidiii")
  tiles_data <<- interim
  return(invisible())
}
