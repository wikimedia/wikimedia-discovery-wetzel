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
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-08-14"), "E (pkget)", labelLoc = "bottom")
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
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-08-14"), "E (pkget)", labelLoc = "bottom")
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
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-08-14"), "E (pkget)", labelLoc = "bottom")
})

output$zoom_level_selector_container <- renderUI({
  selectInput("zoom_level_selector", "Zoom level",
              multiple = TRUE, selected = "0", selectize = FALSE, size = 19,
              choices = as.character(sort(unique(new_tiles_no_automata$zoom))))
})

output$tiles_zoom_series <- renderDygraph({
  req(input$zoom_level_selector)
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
