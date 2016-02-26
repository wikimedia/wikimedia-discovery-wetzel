library(shiny)
library(shinydashboard)
library(dygraphs)
library(shinyURL)

header <- dashboardHeader(title = "Wikimedia Maps", dropdownMenuOutput("message_menu"), disable = FALSE)

sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css"),
    tags$script(src = "custom.js")
  ),
  sidebarMenu(
    menuItem(text = "Tiles",
             menuSubItem(text = "Summary", tabName = "tiles_summary"),
             menuSubItem(text = "Tiles by style", tabName = "tiles_total_by_style"),
             menuSubItem(text = "Users by style", tabName = "tiles_users_by_style"),
             menuSubItem(text = "Tiles by zoom level", tabName = "tiles_total_by_zoom")),
    menuItem(text = "Platform usage", tabName = "platform_usage"),
    menuItem(text = "Feature usage",
             menuSubItem(text = "GeoHack", tabName = "geohack_usage"),
             menuSubItem(text = "WikiMiniAtlas", tabName = "wikiminiatlas_usage"),
             menuSubItem(text = "Wikivoyage", tabName = "wikivoyage_usage"),
             menuSubItem(text = "WIWOSM", tabName = "wiwosm_usage")),
    menuItem(text = "Geographic breakdown", tabName = "geo_breakdown"),
    menuItem(text = "Global Settings",
             selectInput(inputId = "smoothing_global", label = "Smoothing", selectize = TRUE, selected = "day",
                         choices = c("No Smoothing" = "day", "Weekly Median" = "week", "Monthly Median" = "month")),
             selectInput(inputId = "timeframe_global", label = "Time Frame", selectize = TRUE, selected = "",
                         choices = c("All available data" = "all", "Last 7 days" = "week", "Last 30 days" = "month",
                                     "Last 90 days" = "quarter", "Custom" = "custom")),
             conditionalPanel("input.timeframe_global == 'custom'",
                              dateRangeInput("daterange_global", label = "Custom Date Range",
                                             start = Sys.Date()-11, end = Sys.Date()-1, min = "2015-04-14")),
             icon = icon("cog", lib = "glyphicon")),
    menuItem(text = "Sharing Options",
             shinyURL.ui(tinyURL = FALSE),
             p("Dashboard settings stored in URL.", style = "padding-bottom: 10px;"),
             icon = icon("share-alt", lib = "glyphicon"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "tiles_summary",
            fluidRow(
              column(selectInput("tiles_summary_variable", "Total", c("Users", "Tiles")), width = 2),
              column(polloi::smooth_select("smoothing_tiles_summary_series"), width = 3),
              column(polloi::timeframe_select("tiles_summary_series_timeframe"), width = 3),
              column(polloi::timeframe_daterange("tiles_summary_series_timeframe"), width = 4)),
            polloi::automata_select("tile_summary_automata_check"),
            dygraphOutput("tiles_summary_series"),
            div(id = "tiles_summary_series_legend", style = "text-align: right;"),
            includeMarkdown("./tab_documentation/tiles_summary.md")),
    tabItem(tabName = "tiles_total_by_style",
            fluidRow(
              column(polloi::smooth_select("smoothing_tiles_style_series"), width = 4),
              column(polloi::timeframe_select("tiles_style_series_timeframe"), width = 4),
              column(polloi::timeframe_daterange("tiles_style_series_timeframe"), width = 4)),
            polloi::automata_select("tile_style_automata_check"),
            dygraphOutput("tiles_style_series"),
            div(id = "tiles_style_series_legend", style = "text-align: right;"),
            includeMarkdown("./tab_documentation/tiles_total_by_style.md")),
    tabItem(tabName = "tiles_users_by_style",
            fluidRow(
              column(polloi::smooth_select("smoothing_tiles_users_series"), width = 4),
              column(polloi::timeframe_select("tiles_users_series_timeframe"), width = 4),
              column(polloi::timeframe_daterange("tiles_users_series_timeframe"), width = 4)),
            polloi::automata_select("tile_users_automata_check"),
            dygraphOutput("tiles_users_series"),
            div(id = "tiles_users_series_legend", style = "text-align: right;"),
            includeMarkdown("./tab_documentation/tiles_users_by_style.md")),
    tabItem(tabName = "tiles_total_by_zoom",
            fluidRow(
              column(polloi::smooth_select("smoothing_tiles_zoom_series"), width = 4),
              column(polloi::timeframe_select("tiles_zoom_series_timeframe"), width = 4),
              column(polloi::timeframe_daterange("tiles_zoom_series_timeframe"), width = 4)),
            fluidRow(column(uiOutput("zoom_level_selector_container"), width = 3),
                     column(dygraphOutput("tiles_zoom_series"), width = 8)),
            polloi::automata_select("tile_zoom_automata_check"),
            div(id = "tiles_zoom_series_legend", style = "text-align: right;"),
            includeMarkdown("./tab_documentation/tiles_total_by_zoom.md")),
    tabItem(tabName = "platform_usage",
            fluidRow(
              column(polloi::smooth_select("smoothing_users_per_platform"), width = 4),
              column(polloi::timeframe_select("users_per_platform_timeframe"), width = 4),
              column(polloi::timeframe_daterange("users_per_platform_timeframe"), width = 4)),
            dygraphOutput("users_per_platform"),
            div(id = "users_per_platform_legend", style = "text-align: right;"),
            includeMarkdown("./tab_documentation/unique_users.md")),
    tabItem(tabName = "geohack_usage",
            fluidRow(
              column(polloi::smooth_select("smoothing_geohack_feature_usage"), width = 4),
              column(polloi::timeframe_select("geohack_feature_usage_timeframe"), width = 4),
              column(polloi::timeframe_daterange("geohack_feature_usage_timeframe"), width = 4)),
            dygraphOutput("geohack_feature_usage"),
            includeMarkdown("./tab_documentation/geohack_usage.md")),
    tabItem(tabName = "wikiminiatlas_usage",
            fluidRow(
              column(polloi::smooth_select("smoothing_wikiminiatlas_feature_usage"), width = 4),
              column(polloi::timeframe_select("wikiminiatlas_feature_usage_timeframe"), width = 4),
              column(polloi::timeframe_daterange("wikiminiatlas_feature_usage_timeframe"), width = 4)),
            dygraphOutput("wikiminiatlas_feature_usage"),
            includeMarkdown("./tab_documentation/wikiminiatlas_usage.md")),
    tabItem(tabName = "wikivoyage_usage",
            fluidRow(
              column(polloi::smooth_select("smoothing_wikivoyage_feature_usage"), width = 4),
              column(polloi::timeframe_select("wikivoyage_feature_usage_timeframe"), width = 4),
              column(polloi::timeframe_daterange("wikivoyage_feature_usage_timeframe"), width = 4)),
            dygraphOutput("wikivoyage_feature_usage"),
            includeMarkdown("./tab_documentation/wikivoyage_usage.md")),
    tabItem(tabName = "wiwosm_usage",
            fluidRow(
              column(polloi::smooth_select("smoothing_wiwosm_feature_usage"), width = 4),
              column(polloi::timeframe_select("wiwosm_feature_usage_timeframe"), width = 4),
              column(polloi::timeframe_daterange("wiwosm_feature_usage_timeframe"), width = 4)),
            dygraphOutput("wiwosm_feature_usage"),
            includeMarkdown("./tab_documentation/wiwosm_usage.md")),
    tabItem(tabName = "geo_breakdown",
            dygraphOutput("users_by_country"),
            includeMarkdown("./tab_documentation/geo_breakdown.md"))
  )
)

dashboardPage(header, sidebar, body, skin = "green",
              title = "Maps Usage Dashboard | Discovery | Engineering | Wikimedia Foundation")
