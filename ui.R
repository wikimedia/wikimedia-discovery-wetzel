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
    menuItem(text = "Platform usage", tabName = "platform_usage"),
    menuItem(text = "Feature usage",
             menuSubItem(text = "GeoHack", tabName = "geohack"),
             menuSubItem(text = "WikiMiniAtlas", tabName = "wikiminiatlas"),
             menuSubItem(text = "Wikivoyage", tabName = "wikivoyage"),
             menuSubItem(text = "WIWOSM", tabName = "wiwosm"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "platform_usage",
            dygraphOutput("users_per_platform"),
            includeMarkdown("./assets/content/unique_users.md")),
    tabItem(tabName = "geohack",
            dygraphOutput("geohack_feature_usage"),
            includeMarkdown("./assets/content/geohack_usage.md")),
    tabItem(tabName = "wikiminiatlas",
            dygraphOutput("wikiminiatlas_feature_usage"),
            includeMarkdown("./assets/content/wikiminiatlas_usage.md")),
    tabItem(tabName = "wikivoyage",
            dygraphOutput("wikivoyage_feature_usage"),
            includeMarkdown("./assets/content/wikivoyage_usage.md")),
    tabItem(tabName = "wiwosm",
            dygraphOutput("wiwosm_feature_usage"),
            includeMarkdown("./assets/content/wiwosm_usage.md"))
  )
)

dashboardPage(header, sidebar, body, skin = "green")
