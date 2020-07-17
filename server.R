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
    progress$set(message = "Downloading prevalence data", value = 0.3)
    read_prevalence()
    progress$set(message = "Downloading tile usage data", value = 0.4)
    suppressWarnings(read_tiles())
    progress$set(message = "Downloading geography data", value = 0.8)
    read_countries()
    progress$set(message = "Finished downloading datasets", value = 1)
    existing_date <<- Sys.Date()
    progress$close()
  }

  # Kartotherian usage (tile requests):
  source("modules/kartotherian.R", local = TRUE)
  # Kartographer usage (maplink & mapframe):
  source("modules/kartographer/overall_prevalence.R", local = TRUE)
  source("modules/kartographer/language-project_breakdown.R", local = TRUE)
  # Feature usage and geo-breakdown:
  source("modules/feature_usage.R", local = TRUE)
  source("modules/geographic_breakdown.R", local = TRUE)

  # Check datasets for missing data and notify user which datasets are missing data (if any)
  output$message_menu <- renderMenu({
    notifications <- list(
      polloi::check_yesterday(usage_data[[1]], "action data"),
      polloi::check_past_week(usage_data[[1]], "action data"),
      polloi::check_yesterday(user_data, "user counts"),
      polloi::check_past_week(user_data, "user counts"),
      polloi::check_yesterday(new_tiles_automata, "tile usage data"),
      polloi::check_past_week(new_tiles_automata, "tile usage data"),
      polloi::check_yesterday(maplink_prevalence, "maplink prevalence data"),
      polloi::check_past_week(maplink_prevalence, "maplink prevalence data"),
      polloi::check_yesterday(mapframe_prevalence, "mapframe prevalence data"),
      polloi::check_past_week(mapframe_prevalence, "mapframe prevalence data"))
    notifications <- notifications[!sapply(notifications, is.null)]
    return(dropdownMenu(type = "notifications", .list = notifications, badgeStatus = "warning"))
  })

})
