source("utils.R")

existing_date <- Sys.Date() - 1

# Actual server code.
shinyServer(function(input, output) {
  
  if(Sys.Date() != existing_date){
    read_actions()
    read_users()
    suppressWarnings(read_tiles())
    existing_date <<- Sys.Date()
  }
  
  # Wrap time_frame_range to provide global settings
  time_frame_range <- function(input_local_timeframe, input_local_daterange) {
    return(polloi::time_frame_range(input_local_timeframe, input_local_daterange, input$timeframe_global, input$daterange_global))
  }
  
  output$tiles_summary_series <- renderDygraph({
    temp <- polloi::data_select(input$tile_summary_automata_check, new_tiles_automata, new_tiles_no_automata) %>%
    ddply(.(date), summarize,
          `total tiles` = sum(total),
          `total users` = sum(users),
          `average tiles per user` = `total tiles` / `total users`)
    switch(input$tiles_summary_variable,
           Users = { temp %<>% dplyr::select(-`total tiles`) },
           Tiles = { temp %<>% dplyr::select(-`total users`) })
    temp %<>% polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_tiles_summary_series)) %>%
      polloi::subset_by_date_range(time_frame_range(input$tiles_summary_series_timeframe, input$tiles_summary_series_timeframe_daterange))
    polloi::make_dygraph(temp, "Date", input$tiles_summary_variable, "Tile usage") %>%
      dySeries(name = grep('average tiles per user', names(temp), value = TRUE), axis = 'y2') %>%
      dyAxis(name = 'y', drawGrid = FALSE) %>%
      dyAxis(name = 'y2', independentTicks = TRUE, drawGrid = FALSE) %>%
      dyLegend(labelsDiv = "tiles_summary_series_legend", show = "always") %>%
      dyAnnotation(as.Date("2015-09-17"), text = "A",
                   tooltip = "Maps launch announcement",
                   width = 10, height = 20, attachAtBottom = FALSE, series = grep('total', names(temp), value = TRUE)) %>%
      dyAnnotation(as.Date("2016-01-08"), text = "B",
                   tooltip = "Maps launched on en.wikipedia.org",
                   width = 10, height = 20, attachAtBottom = FALSE, series = grep('total', names(temp), value = TRUE)) %>%
      dyAnnotation(as.Date("2016-01-12"), text = "C",
                   tooltip = "Maps launch on en.wikipedia.org reverted on the 9th; caches begin to clear",
                   width = 10, height = 20, attachAtBottom = FALSE, series = grep('total', names(temp), value = TRUE))
  })
  
  output$tiles_style_series <- renderDygraph({
    polloi::data_select(input$tile_style_automata_check, new_tiles_automata, new_tiles_no_automata) %>%
    ddply(.(date, style), summarize, `total tiles` = sum(total)) %>%
      tidyr::spread(style, `total tiles`) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_tiles_style_series)) %>%
      polloi::subset_by_date_range(time_frame_range(input$tiles_style_series_timeframe, input$tiles_style_series_timeframe_daterange)) %>%
      polloi::make_dygraph("Date", "Tiles", "Total tiles by style", legend_name = "Style") %>%
      dyLegend(labelsDiv = "tiles_style_series_legend", show = "always") %>%
      dyAnnotation(as.Date("2015-09-17"), text = "Announcement",
                   tooltip = "Maps launch announcement",
                   width = 100, height = 25, attachAtBottom = TRUE)
  })
  
  output$tiles_users_series <- renderDygraph({
    polloi::data_select(input$tile_users_automata_check, new_tiles_automata, new_tiles_no_automata) %>%
      ddply(.(date, style), summarize, `total users` = sum(users)) %>%
      tidyr::spread(style, `total users`) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_tiles_users_series)) %>%
      polloi::subset_by_date_range(time_frame_range(input$tiles_users_series_timeframe, input$tiles_users_series_timeframe_daterange)) %>%
      polloi::make_dygraph("Date", "Users", "Total users by style") %>%
      dyLegend(labelsDiv = "tiles_users_series_legend", show = "always") %>%
      dyAnnotation(as.Date("2015-09-17"), text = "Announcement",
                   tooltip = "Maps launch announcement",
                   width = 100, height = 25, attachAtBottom = TRUE)
  })
  
  output$zoom_level_selector_container <- renderUI({
    selectInput("zoom_level_selector", "Zoom level",
                multiple = TRUE, selected = "0", selectize = FALSE, size = 19,
                choices = as.character(sort(unique(new_tiles_no_automata$zoom))))
  })
  
  output$tiles_zoom_series <- renderDygraph({
    polloi::data_select(input$tile_zoom_automata_check, new_tiles_automata, new_tiles_no_automata) %>%
      subset(zoom %in% as.numeric(input$zoom_level_selector)) %>%
      ddply(.(date, zoom), summarize, `total tiles` = sum(total)) %>%
      tidyr::spread(zoom, `total tiles`) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_tiles_zoom_series)) %>%
      polloi::subset_by_date_range(time_frame_range(input$tiles_zoom_series_timeframe, input$tiles_zoom_series_timeframe_daterange)) %>%
      polloi::make_dygraph("Date", "Tiles", "Total tiles by zoom level") %>%
      dyLegend(labelsDiv = "tiles_zoom_series_legend", show = "always")
  })
  
  output$users_per_platform <- renderDygraph({
    user_data %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_users_per_platform)) %>%
      polloi::subset_by_date_range(time_frame_range(input$users_per_platform_timeframe, input$users_per_platform_timeframe_daterange)) %>%
      polloi::make_dygraph("Date", "Events", "Unique users by platform, by day") %>%
      dyLegend(labelsDiv = "users_per_platform_legend", show = "always")
  })
  
  output$geohack_feature_usage <- renderDygraph({
    usage_data$GeoHack %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_geohack_feature_usage)) %>%
      polloi::subset_by_date_range(time_frame_range(input$geohack_feature_usage_timeframe, input$geohack_feature_usage_timeframe_daterange)) %>%
      polloi::make_dygraph("Date", "Events", "Feature usage for GeoHack")
  })
  
  output$wikiminiatlas_feature_usage <- renderDygraph({
    usage_data$WikiMiniAtlas %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_wikiminiatlas_feature_usage)) %>%
      polloi::subset_by_date_range(time_frame_range(input$wikiminiatlas_feature_usage_timeframe, input$wikiminiatlas_feature_usage_timeframe_daterange)) %>%
      polloi::make_dygraph("Date", "Events", "Feature usage for WikiMiniAtlas")
  })
  
  output$wikivoyage_feature_usage <- renderDygraph({
    usage_data$Wikivoyage %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_wikivoyage_feature_usage)) %>%
      polloi::subset_by_date_range(time_frame_range(input$wikivoyage_feature_usage_timeframe, input$wikivoyage_feature_usage_timeframe_daterange)) %>%
      polloi::make_dygraph("Date", "Events", "Feature usage for Wikivoyage")
  })
  
  output$wiwosm_feature_usage <- renderDygraph({
    usage_data$WIWOSM %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_wiwosm_feature_usage)) %>%
      polloi::subset_by_date_range(time_frame_range(input$wiwosm_feature_usage_timeframe, input$wiwosm_feature_usage_timeframe_daterange)) %>%
      polloi::make_dygraph("Date", "Events", "Feature usage for WIWOSM")
  })
  
  # Check datasets for missing data and notify user which datasets are missing data (if any)
  output$message_menu <- renderMenu({
    notifications <- list(
      polloi::check_yesterday(usage_data[[1]], "action data"),
      polloi::check_past_week(usage_data[[1]], "action data"),
      polloi::check_yesterday(user_data, "user counts"),
      polloi::check_past_week(user_data, "user counts"),
      polloi::check_yesterday(new_tiles_automata, "tile usage data"),
      polloi::check_past_week(new_tiles_automata, "tile usage data"))
    notifications <- notifications[!sapply(notifications, is.null)]
    return(dropdownMenu(type = "notifications", .list = notifications, badgeStatus = "warning"))
  })
  
})
