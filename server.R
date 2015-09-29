# Version 0.0.1
source("utils.R")

existing_date <- (Sys.Date()-1)

# Actual server code.
shinyServer(function(input, output) {
  
  if(Sys.Date() != existing_date){
    read_actions()
    read_users()
    suppressWarnings(read_tiles())
    existing_date <<- Sys.Date()
  }
  
  output$users_per_platform <- renderDygraph(polloi::make_dygraph(
    polloi::smoother(user_data,
                     smooth_level = polloi::smooth_switch(input$smoothing_global,
                       input$smoothing_users_per_platform)),
    "Date", "Events", "Unique users by platform, by day"
  ))
  
  output$geohack_feature_usage <- renderDygraph(polloi::make_dygraph(
    polloi::smoother(usage_data$GeoHack,
                     smooth_level = polloi::smooth_switch(input$smoothing_global,
                       input$smoothing_geohack_feature_usage)),
    "Date", "Events", "Feature usage for GeoHack"
  ))
  
  output$wikiminiatlas_feature_usage <- renderDygraph(polloi::make_dygraph(
    polloi::smoother(usage_data$WikiMiniAtlas,
                     smooth_level = polloi::smooth_switch(input$smoothing_global,
                       input$smoothing_wikiminiatlas_feature_usage)),
    "Date", "Events", "Feature usage for WikiMiniAtlas"
  ))
  
  output$wikivoyage_feature_usage <- renderDygraph(polloi::make_dygraph(
    polloi::smoother(usage_data$Wikivoyage,
                     smooth_level = polloi::smooth_switch(input$smoothing_global,
                       input$smoothing_wikivoyage_feature_usage)),
    "Date", "Events", "Feature usage for Wikivoyage"
  ))
  
  output$wiwosm_feature_usage <- renderDygraph(polloi::make_dygraph(
    polloi::smoother(usage_data$WIWOSM,
                     smooth_level = polloi::smooth_switch(input$smoothing_global,
                       input$smoothing_tiles_summary_series)),
    "Date", "Events", "Feature usage for WIWOSM"
  ))
  
  output$tiles_summary_series <- renderDygraph({
    temp <- ddply(tiles_data, .(date), summarize,
          `total tiles` = sum(total),
          `total users` = sum(users),
          `average tiles per user` = `total tiles` / `total users`)
    switch(input$tiles_summary_variable,
           Users = { temp %<>% dplyr::select(-`total tiles`) },
           Tiles = { temp %<>% dplyr::select(-`total users`) })
    temp %<>% polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global,
      input$smoothing_tiles_summary_series))
    polloi::make_dygraph(temp, "Date", "Tiles", "Tile usage") %>%
      dySeries(name = grep('average tiles per user', names(temp), value = TRUE), axis = 'y2') %>%
      dyAxis(name = 'y', drawGrid = FALSE) %>%
      dyAxis(name = 'y2', independentTicks = TRUE, drawGrid = FALSE) %>%
      dyAnnotation(as.Date("2015-09-17"), text = "Announcement",
                   tooltip = "Maps launch announcement",
                   width = 100, height = 25, attachAtBottom = TRUE)
  })
  output$tiles_style_series <- renderDygraph({
    ddply(tiles_data, .(date, style), summarize, `total tiles` = sum(total)) %>%
      tidyr::spread(style, `total tiles`) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global,
        input$smoothing_tiles_style_series)) %>%
      polloi::make_dygraph("Date", "Tiles", "Total tiles by style", legend_name = "Style") %>%
      dyAnnotation(as.Date("2015-09-17"), text = "Announcement",
                   tooltip = "Maps launch announcement",
                   width = 100, height = 25, attachAtBottom = TRUE)
  })
  output$tiles_users_series <- renderDygraph({
    ddply(tiles_data, .(date, style), summarize, `total users` = sum(users)) %>%
      tidyr::spread(style, `total users`) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global,
        input$smoothing_tiles_users_series)) %>%
      polloi::make_dygraph("Date", "Users", "Total users by style") %>%
      dyAnnotation(as.Date("2015-09-17"), text = "Announcement",
                   tooltip = "Maps launch announcement",
                   width = 100, height = 25, attachAtBottom = TRUE)
  })
  output$zoom_level_selector_container <- renderUI({
    selectInput("zoom_level_selector", "Zoom level",
                multiple = TRUE, selected = "0", selectize = FALSE, size = 19,
                choices = as.character(sort(unique(tiles_data$zoom))))
  })
  output$tiles_zoom_series <- renderDygraph({
    tiles_data %>%
      subset(zoom %in% as.numeric(input$zoom_level_selector)) %>%
      ddply(.(date, zoom), summarize, `total tiles` = sum(total)) %>%
      tidyr::spread(zoom, `total tiles`) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global,
        input$smoothing_tiles_zoom_series)) %>%
      polloi::make_dygraph("Date", "Tiles", "Total tiles by zoom level")
  })
  
})
