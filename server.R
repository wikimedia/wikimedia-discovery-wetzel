source("utils.R")

existing_date <- Sys.Date() - 1

# Actual server code.
shinyServer(function(input, output, session) {

  if (Sys.Date() != existing_date) {
    # Create a Progress object
    progress <- shiny::Progress$new()
    progress$set(message = "Downloading EL actions data", value = 0)
    read_actions()
    progress$set(message = "Downloading EL user counts", value = 0.2)
    read_users()
    progress$set(message = "Downloading tile usage data", value = 0.4)
    suppressWarnings(read_tiles())
    progress$set(message = "Downloading geography data", value = 0.8)
    read_countries()
    progress$set(message = "Finished downloading datasets", value = 1)
    existing_date <<- Sys.Date()
    progress$close()
  }

  output$tiles_summary_series <- renderDygraph({
    temp <- polloi::data_select(input$tile_summary_automata_check, new_tiles_automata, new_tiles_no_automata)[, list(
      `total tiles` = sum(total),
      `total users` = sum(users),
      `average tiles per user` = sum(total)/sum(users)
    ), by = "date"]
    switch(input$tiles_summary_variable,
           Users = { temp %<>% dplyr::select(-`total tiles`) },
           Tiles = { temp %<>% dplyr::select(-`total users`) })
    temp %<>% polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_tiles_summary_series))
    polloi::make_dygraph(temp, "Date", input$tiles_summary_variable, "Tile usage") %>%
      dySeries(name = grep('average tiles per user', names(temp), value = TRUE), axis = 'y2') %>%
      dyAxis(name = 'y', drawGrid = FALSE, logscale = input$tiles_summary_logscale) %>%
      dyAxis(name = 'y2', independentTicks = TRUE, drawGrid = FALSE) %>%
      dyLegend(labelsDiv = "tiles_summary_series_legend", show = "always") %>%
      dyRangeSelector(retainDateWindow = TRUE) %>%
      dyEvent(as.Date("2015-09-17"), "A (announcement)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-01-08"), "B (enwiki launch)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-01-12"), "C (cache clear)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-11-09"), "D (pkget)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  })

  output$tiles_style_series <- renderDygraph({
    polloi::data_select(
      input$tile_style_automata_check,
      new_tiles_automata,
      new_tiles_no_automata
    )[, j = list(`total tiles` = sum(total)),
        by = c("date", "style")] %>%
      tidyr::spread(style, `total tiles`, fill = 0) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_tiles_style_series)) %>%
      polloi::make_dygraph("Date", "Tiles", "Total tiles by style", legend_name = "Style") %>%
      dyAxis("y", logscale = input$tiles_style_logscale) %>%
      dyLegend(labelsDiv = "tiles_style_series_legend", show = "always") %>%
      dyRangeSelector %>%
      dyEvent(as.Date("2015-09-17"), "A (announcement)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-01-08"), "B (enwiki launch)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-01-12"), "C (cache clear)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-11-09"), "D (pkget)", labelLoc = "top") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  })

  output$tiles_users_series <- renderDygraph({
    polloi::data_select(
      input$tile_users_automata_check,
      new_tiles_automata,
      new_tiles_no_automata
    )[, j = list(`total users` = sum(users)),
        by = c("date", "style")] %>%
      tidyr::spread(style, `total users`, fill = 0) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_tiles_users_series)) %>%
      polloi::make_dygraph("Date", "Users", "Total users by style") %>%
      dyAxis("y", logscale = input$tiles_users_logscale) %>%
      dyLegend(labelsDiv = "tiles_users_series_legend", show = "always") %>%
      dyRangeSelector %>%
      dyEvent(as.Date("2015-09-17"), "A (announcement)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-01-08"), "B (enwiki launch)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-01-12"), "C (cache clear)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-11-08"), "D (pkget)", labelLoc = "top") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  })

  output$zoom_level_selector_container <- renderUI({
    selectInput("zoom_level_selector", "Zoom level",
                multiple = TRUE, selected = "0", selectize = FALSE, size = 19,
                choices = as.character(sort(unique(new_tiles_no_automata$zoom))))
  })

  output$tiles_zoom_series <- renderDygraph({
    polloi::data_select(
      input$tile_zoom_automata_check,
      new_tiles_automata,
      new_tiles_no_automata
    )[zoom %in% as.numeric(input$zoom_level_selector),
      j = list(`total tiles` = sum(total)),
      by = c("date", "zoom")] %>%
      tidyr::spread(zoom, `total tiles`, fill = 0) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_tiles_zoom_series)) %>%
      polloi::make_dygraph("Date", "Tiles", "Total tiles by zoom level") %>%
      dyAxis("y", logscale = input$tiles_zoom_logscale) %>%
      dyLegend(labelsDiv = "tiles_zoom_series_legend", show = "always") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  })

  output$users_per_platform <- renderDygraph({
    user_data %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_users_per_platform)) %>%
      polloi::make_dygraph("Date", "Events", "Unique users by platform, by day") %>%
      dyAxis("y", logscale = input$users_per_platform_logscale) %>%
      dyLegend(labelsDiv = "users_per_platform_legend", show = "always") %>%
      dyRangeSelector %>%
      dyEvent(as.Date("2016-04-15"), "A (Maps EL bug)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-06-17"), "A (Maps EL patch)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  })

  output$geohack_feature_usage <- renderDygraph({
    usage_data$GeoHack %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_geohack_feature_usage)) %>%
      polloi::make_dygraph("Date", "Events", "Feature usage for GeoHack") %>%
      dyRangeSelector %>%
      dyAxis("y", logscale = input$geohack_feature_usage_logscale) %>%
      dyEvent(as.Date("2016-04-15"), "A (Maps EL bug)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-06-17"), "A (Maps EL patch)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  })

  output$wikiminiatlas_feature_usage <- renderDygraph({
    usage_data$WikiMiniAtlas %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_wikiminiatlas_feature_usage)) %>%
      polloi::make_dygraph("Date", "Events", "Feature usage for WikiMiniAtlas") %>%
      dyRangeSelector %>%
      dyAxis("y", logscale = input$wikiminiatlas_feature_usage_logscale) %>%
      dyEvent(as.Date("2016-04-15"), "A (Maps EL bug)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-06-17"), "A (Maps EL patch)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  })

  output$wikivoyage_feature_usage <- renderDygraph({
    usage_data$Wikivoyage %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_wikivoyage_feature_usage)) %>%
      polloi::make_dygraph("Date", "Events", "Feature usage for Wikivoyage") %>%
      dyRangeSelector %>%
      dyAxis("y", logscale = input$wikivoyage_feature_usage_logscale) %>%
      dyEvent(as.Date("2016-04-15"), "A (Maps EL bug)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-06-17"), "A (Maps EL patch)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  })

  output$wiwosm_feature_usage <- renderDygraph({
    usage_data$WIWOSM %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_wiwosm_feature_usage)) %>%
      polloi::make_dygraph("Date", "Events", "Feature usage for WIWOSM") %>%
      dyRangeSelector %>%
      dyAxis("y", logscale = input$wiwosm_feature_usage_logscale) %>%
      dyEvent(as.Date("2016-04-15"), "A (Maps EL bug)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-06-17"), "A (Maps EL patch)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  })


  output$users_by_country <- renderDygraph({
    country_data %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_users_by_country)) %>%
      polloi::make_dygraph("Date", "Users (%)", "Geographic breakdown of maps users") %>%
      dyRangeSelector(fillColor = "", strokeColor = "") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
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
