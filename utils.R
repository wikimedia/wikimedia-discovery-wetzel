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

read_countries <- function() {
  country_data <<- polloi::read_dataset("discovery/metrics/maps/users_by_country.tsv", col_types = "Dcd") %>%
    dplyr::filter(!is.na(country), !is.na(users)) %>%
    dplyr::mutate(users = users * 100) %>%
    tidyr::spread(country, users, fill = 0)
  return(invisible())
}

read_prevalence <- function() {
  projects_db <<- readr::read_csv(system.file("extdata/projects.csv", package = "polloi"), col_types = "cclc")[, c("project", "multilingual")]
  lang_proj <- polloi::get_langproj()
  maplinks <- polloi::read_dataset("discovery/metrics/maps/maplink_prevalence.tsv", col_types = "Dcii-")
  mapframes <- polloi::read_dataset("discovery/metrics/maps/mapframe_prevalence.tsv", col_types = "Dcii-")
  maplink_prevalence <<- maplinks %>%
    dplyr::left_join(lang_proj, by = c("wiki" = "wikiid")) %>%
    dplyr::filter(!is.na(project))
  mapframe_prevalence <<- mapframes %>%
    dplyr::left_join(lang_proj, by = c("wiki" = "wikiid")) %>%
    dplyr::filter(!is.na(project))
  available_languages_maplink <- maplink_prevalence %>%
    dplyr::mutate(language = dplyr::if_else(is.na(language), "(None)", language)) %>%
    dplyr::group_by(language) %>%
    dplyr::top_n(1, date) %>%
    dplyr::summarize(articles = sum(total_articles), maplink = TRUE) %>%
    dplyr::ungroup() %>%
    dplyr::select(c(language, articles, maplink))
  available_languages_mapframe <- mapframe_prevalence %>%
    dplyr::mutate(language = dplyr::if_else(is.na(language), "(None)", language)) %>%
    dplyr::group_by(language) %>%
    dplyr::top_n(1, date) %>%
    dplyr::summarize(articles = sum(total_articles), mapframe = TRUE) %>%
    dplyr::ungroup() %>%
    dplyr::select(c(language, articles, mapframe))
  available_languages <<- dplyr::full_join(
    available_languages_maplink,
    available_languages_mapframe,
    by = "language"
  ) %>%
    dplyr::mutate(
      articles = pmax(articles.x, articles.y, na.rm = TRUE),
      maplink = dplyr::if_else(is.na(maplink), FALSE, maplink),
      mapframe = dplyr::if_else(is.na(mapframe), FALSE, mapframe)
    ) %>%
    dplyr::select(-c(articles.x, articles.y))
  available_projects_maplink <- maplink_prevalence %>%
    dplyr::group_by(project) %>%
    dplyr::top_n(1, date) %>%
    dplyr::summarize(articles = sum(total_articles), maplink = TRUE) %>%
    dplyr::ungroup() %>%
    dplyr::select(c(project, articles, maplink))
  available_projects_mapframe <- mapframe_prevalence %>%
    dplyr::group_by(project) %>%
    dplyr::top_n(1, date) %>%
    dplyr::summarize(articles = sum(total_articles), mapframe = TRUE) %>%
    dplyr::ungroup() %>%
    dplyr::select(c(project, articles, mapframe))
  available_projects <<- dplyr::full_join(
    available_projects_maplink,
    available_projects_mapframe,
    by = "project"
  ) %>%
    dplyr::mutate(
      articles = pmax(articles.x, articles.y, na.rm = TRUE),
      maplink = dplyr::if_else(is.na(maplink), FALSE, maplink),
      mapframe = dplyr::if_else(is.na(mapframe), FALSE, mapframe)
    ) %>%
    dplyr::select(-c(articles.x, articles.y))
  prevalence <<- dplyr::inner_join(
    maplinks, mapframes,
    by = c("date", "wiki")
  ) %>%
    dplyr::left_join(lang_proj, by = c("wiki" = "wikiid")) %>%
    dplyr::filter(!is.na(project)) %>%
    dplyr::select(-wiki) %>%
    dplyr::group_by(date, project) %>%
    dplyr::summarize(
      Maplink = round(100 * sum(maplink_articles) / sum(total_articles.x), 2),
      Mapframe = round(100 * sum(mapframe_articles) / sum(total_articles.y), 2)
    ) %>%
    dplyr::ungroup() %>%
    tidyr::gather(feature, prevalence, -c(date, project)) %>%
    dplyr::transmute(
      date = date, prevalence = prevalence,
      group = paste0(feature, " (", project, ")")
    ) %>%
    tidyr::spread(group, prevalence)
  return(invisible())
}
