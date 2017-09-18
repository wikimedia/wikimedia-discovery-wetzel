output$overall_prevalence_series <- renderDygraph({
  prevalence %>%
    polloi::reorder_columns() %>%
    polloi::make_dygraph("Date", "Prevalence (%)", "Maplink and Mapframe prevalence on Wikimedia projects") %>%
    dyLegend(labelsDiv = "overall_prevalence_series_legend", show = "always") %>%
    dyRangeSelector(retainDateWindow = TRUE, fillColor = "", strokeColor = "")
})
