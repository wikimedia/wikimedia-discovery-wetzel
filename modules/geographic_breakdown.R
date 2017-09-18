output$users_by_country <- renderDygraph({
  country_data %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_users_by_country)) %>%
    polloi::make_dygraph("Date", "Users (%)", "Geographic breakdown of maps users") %>%
    dyRangeSelector(fillColor = "", strokeColor = "") %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})
