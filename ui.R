library(shiny)
library(shinydashboard)
library(dygraphs)
options(scipen = 500)

header <- dashboardHeader(title = "Wikimedia Maps", disable = FALSE)

sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css")
  ),
  sidebarMenu(
    menuItem(text = "Tiles",
             menuSubItem(text = "Summary", tabName = "tiles_summary"),
             menuSubItem(text = "Tiles by style", tabName = "tiles_total_by_style"),
             menuSubItem(text = "Users by style", tabName = "tiles_users_by_style"),
             menuSubItem(text = "Tiles by zoom level", tabName = "tiles_total_by_zoom")),
    menuItem(text = "Platform usage", tabName = "platform_usage"),
    menuItem(text = "Feature usage",
             menuSubItem(text = "GeoHack", tabName = "geohack"),
             menuSubItem(text = "WikiMiniAtlas", tabName = "wikiminiatlas"),
             menuSubItem(text = "Wikivoyage", tabName = "wikivoyage"),
             menuSubItem(text = "WIWOSM", tabName = "wiwosm")),
    selectInput(inputId = "smoothing_global", label = "Smoothing (Global Setting)", selectize = TRUE, selected = "day",
                choices = c("No Smoothing" = "day", "Weekly Median" = "week", "Monthly Median" = "month"))
  )
)

# Standardised input selector for smoothing
smooth_select <- function(input_id, label = "Smoothing") {
  return(selectInput(inputId = input_id, label = label, selectize = TRUE,
                     selected = "global", choices = c("Use Global Setting" = "global",
    "No Smoothing" = "day", "Weekly Median" = "week", "Monthly Median" = "month")))
}

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "platform_usage",
            smooth_select("smoothing_users_per_platform"),
            dygraphOutput("users_per_platform"),
            includeMarkdown("./tab_documentation/unique_users.md")),
    tabItem(tabName = "geohack",
            smooth_select("smoothing_geohack_feature_usage"),
            dygraphOutput("geohack_feature_usage"),
            includeMarkdown("./tab_documentation/geohack_usage.md")),
    tabItem(tabName = "wikiminiatlas",
            smooth_select("smoothing_wikiminiatlas_feature_usage"),
            dygraphOutput("wikiminiatlas_feature_usage"),
            includeMarkdown("./tab_documentation/wikiminiatlas_usage.md")),
    tabItem(tabName = "wikivoyage",
            smooth_select("smoothing_wikivoyage_feature_usage"),
            dygraphOutput("wikivoyage_feature_usage"),
            includeMarkdown("./tab_documentation/wikivoyage_usage.md")),
    tabItem(tabName = "wiwosm",
            smooth_select("smoothing_wiwosm_feature_usage"),
            dygraphOutput("wiwosm_feature_usage"),
            includeMarkdown("./tab_documentation/wiwosm_usage.md")),
    tabItem(tabName = "tiles_summary",
            fluidRow(column(smooth_select("smoothing_tiles_summary_series"), width = 6),
                     column(selectInput("tiles_summary_variable", "Total", c("Users", "Tiles")), width = 6)),
            dygraphOutput("tiles_summary_series"),
            includeMarkdown("./tab_documentation/tiles_summary.md")),
    tabItem(tabName = "tiles_total_by_style",
            smooth_select("smoothing_tiles_style_series"),
            dygraphOutput("tiles_style_series"),
            includeMarkdown("./tab_documentation/tiles_total_by_style.md")),
    tabItem(tabName = "tiles_users_by_style",
            smooth_select("smoothing_tiles_users_series"),
            dygraphOutput("tiles_users_series"),
            includeMarkdown("./tab_documentation/tiles_users_by_style.md")),
    tabItem(tabName = "tiles_total_by_zoom",
            smooth_select("smoothing_tiles_zoom_series"),
            fluidRow(column(uiOutput("zoom_level_selector_container"), width = 3),
                     column(dygraphOutput("tiles_zoom_series"), width = 8)),
            includeMarkdown("./tab_documentation/tiles_total_by_zoom.md"))
  )
)

dashboardPage(header, sidebar, body, skin = "green",
              title = "Maps Usage Dashboard | Discovery | Engineering | Wikimedia Foundation")
