# Dependencies
library(magrittr)

# Read in action data and write it into the global scope with sufficient formatting to be trivially
# used in dygraphs.
read_actions <- function() {
  # Read in data, split and rename it, and write it o
  usage_data <<- polloi::read_dataset("discovery/metrics/maps/actions_per_tool.tsv", col_types = "Dcci") %>%
    dplyr::filter(!is.na(feature), !is.na(action), !is.na(events)) %>%
    { split(.[, c(1, 3, 4)], .$feature) } %>%
    lapply(tidyr::spread_, key = "action", value = "events", fill = 0)
  return(invisible())
}

# Read in user count
read_users <- function() {
  user_data <<- polloi::read_dataset("discovery/metrics/maps/users_per_feature.tsv", col_types = "Dci") %>%
    dplyr::filter(!is.na(feature), !is.na(users)) %>%
    tidyr::spread(feature, users, fill = 0)
  return(invisible())
}

read_tiles <- function() {
  new_tiles_automata <<- polloi::read_dataset("discovery/metrics/maps/tile_aggregates_with_automata.tsv", col_types = "Dcidcciidiii") %>%
    dplyr::filter(!is.na(total), !is.na(users)) %>%
    data.table::as.data.table()
  new_tiles_no_automata <<- polloi::read_dataset("discovery/metrics/maps/tile_aggregates_no_automata.tsv", col_types = "Dcidcciidiii") %>%
    dplyr::filter(!is.na(total), !is.na(users)) %>%
    data.table::as.data.table()
  return(invisible())
}

read_countries <- function(){
  country_data <<- polloi::read_dataset("discovery/metrics/maps/users_by_country.tsv", col_types = "Dcd") %>%
    dplyr::filter(!is.na(country), !is.na(users)) %>%
    dplyr::mutate(users = users * 100) %>%
    tidyr::spread(country, users, fill = 0)
  return(invisible())
}
