library(shiny)
library(shinydashboard)
library(dygraphs)

function(request) {
  dashboardPage(

    dashboardHeader(title = "Wikimedia Maps", dropdownMenuOutput("message_menu"), disable = FALSE),

    dashboardSidebar(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css"),
        tags$script(src = "custom.js")
      ),
      sidebarMenu(id = "tabs",
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
                                       choices = c("No Smoothing" = "day", "Weekly Median" = "week", "Monthly Median" = "month", "Splines" = "gam")),
                           icon = icon("cog", lib = "glyphicon"))
      ),
      div(icon("info-sign", lib = "glyphicon"), HTML("<strong>Tip</strong>: you can drag on the graphs with your mouse to zoom in on a particular date range."), style = "padding: 10px; color: white;"),
      div(bookmarkButton(), style = "text-align: center;")
    ),

    dashboardBody(
      tabItems(
        tabItem(tabName = "tiles_summary",
                fluidRow(
                  column(selectInput("tiles_summary_variable", "Total", c("Users", "Tiles"), selected = "Tiles"), width = 4),
                  column(polloi::smooth_select("smoothing_tiles_summary_series"), width = 4),
                  column(
                    HTML("<label class = \"control-label\" style = \"margin-bottom:-30px;\">Scaling</label>"),
                    checkboxInput("tiles_summary_logscale", "Use Log scale", FALSE),
                    width = 4
                  )
                ),
                polloi::automata_select("tile_summary_automata_check"),
                dygraphOutput("tiles_summary_series"),
                div(id = "tiles_summary_series_legend", style = "text-align: right;"),
                includeMarkdown("./tab_documentation/tiles_summary.md")),
        tabItem(tabName = "tiles_total_by_style",
                fluidRow(
                  column(polloi::smooth_select("smoothing_tiles_style_series"), width = 4),
                  column(
                    HTML("<label class = \"control-label\" style = \"margin-bottom:-30px;\">Scaling</label>"),
                    checkboxInput("tiles_style_logscale", "Use Log scale", FALSE),
                    width = 4
                  )
                ),
                polloi::automata_select("tile_style_automata_check"),
                dygraphOutput("tiles_style_series"),
                div(id = "tiles_style_series_legend", style = "text-align: right;"),
                includeMarkdown("./tab_documentation/tiles_total_by_style.md")),
        tabItem(tabName = "tiles_users_by_style",
                fluidRow(
                  column(polloi::smooth_select("smoothing_tiles_users_series"), width = 4),
                  column(
                    HTML("<label class = \"control-label\" style = \"margin-bottom:-30px;\">Scaling</label>"),
                    checkboxInput("tiles_users_logscale", "Use Log scale", FALSE),
                    width = 4
                  )
                ),
                polloi::automata_select("tile_users_automata_check"),
                dygraphOutput("tiles_users_series"),
                div(id = "tiles_users_series_legend", style = "text-align: right;"),
                includeMarkdown("./tab_documentation/tiles_users_by_style.md")),
        tabItem(tabName = "tiles_total_by_zoom",
                fluidRow(
                  column(polloi::smooth_select("smoothing_tiles_zoom_series"), width = 4),
                  column(
                    HTML("<label class = \"control-label\" style = \"margin-bottom:-30px;\">Scaling</label>"),
                    checkboxInput("tiles_zoom_logscale", "Use Log scale", FALSE),
                    width = 4
                  )
                ),
                fluidRow(column(uiOutput("zoom_level_selector_container"), width = 3),
                         column(dygraphOutput("tiles_zoom_series"), width = 8)),
                polloi::automata_select("tile_zoom_automata_check"),
                div(id = "tiles_zoom_series_legend", style = "text-align: right;"),
                includeMarkdown("./tab_documentation/tiles_total_by_zoom.md")),
        tabItem(tabName = "platform_usage",
                fluidRow(
                  column(polloi::smooth_select("smoothing_users_per_platform"), width = 3),
                  column(checkboxInput("users_per_platform_logscale", "Use Log scale", FALSE), width = 3)
                ),
                dygraphOutput("users_per_platform"),
                div(id = "users_per_platform_legend", style = "text-align: right;"),
                includeMarkdown("./tab_documentation/unique_users.md")),
        tabItem(tabName = "geohack_usage",
                fluidRow(
                  column(polloi::smooth_select("smoothing_geohack_feature_usage"), width = 4),
                  column(checkboxInput("geohack_feature_usage_logscale", "Use Log scale", FALSE), width = 4)
                ),
                dygraphOutput("geohack_feature_usage"),
                includeMarkdown("./tab_documentation/geohack_usage.md")),
        tabItem(tabName = "wikiminiatlas_usage",
                fluidRow(
                  column(polloi::smooth_select("smoothing_wikiminiatlas_feature_usage"), width = 4),
                  column(checkboxInput("wikiminiatlas_feature_usage_logscale", "Use Log scale", FALSE), width = 4)
                ),
                dygraphOutput("wikiminiatlas_feature_usage"),
                includeMarkdown("./tab_documentation/wikiminiatlas_usage.md")),
        tabItem(tabName = "wikivoyage_usage",
                fluidRow(
                  column(polloi::smooth_select("smoothing_wikivoyage_feature_usage"), width = 4),
                  column(checkboxInput("wikivoyage_feature_usage_logscale", "Use Log scale", FALSE), width = 4)
                ),
                dygraphOutput("wikivoyage_feature_usage"),
                includeMarkdown("./tab_documentation/wikivoyage_usage.md")),
        tabItem(tabName = "wiwosm_usage",
                fluidRow(
                  column(polloi::smooth_select("smoothing_wiwosm_feature_usage"), width = 4),
                  column(checkboxInput("wiwosm_feature_usage_logscale", "Use Log scale", FALSE), width = 4)
                ),
                dygraphOutput("wiwosm_feature_usage"),
                includeMarkdown("./tab_documentation/wiwosm_usage.md")),
        tabItem(tabName = "geo_breakdown",
                polloi::smooth_select("smoothing_users_by_country"),
                dygraphOutput("users_by_country"),
                includeMarkdown("./tab_documentation/geo_breakdown.md"))
      )
    ),

    skin = "green", title = "Maps Usage Dashboard | Discovery | Audiences | Wikimedia Foundation")
}
