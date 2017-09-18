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
