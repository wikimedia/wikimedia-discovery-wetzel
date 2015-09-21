# Version 0.0.1
source("utils.R")

existing_date <- (Sys.Date()-1)

# Read in action data and write it into the global scope with sufficient formatting to be trivially
# used in dygraphs.
read_actions <- function(){
  
  # Read in data, split and rename it, and write it o
  data <- polloi::read_dataset("maps/actions_per_tool.tsv")
  data <- split(data[,c(1,3,4)], data$feature)
  usage_data <<- lapply(data, reshape2::dcast, formula = timestamp ~ variable, fun.aggregate = sum)
  return(invisible())
}

# Read in user count
read_users <- function(){
  data <- polloi::read_dataset("maps/users_per_feature.tsv")
  interim <- reshape2::dcast(data, formula = timestamp ~ variable, fun.aggregate = sum)
  interim[is.na(interim)] <- 0
  user_data <<- interim
  return(invisible())
}

# Actual server code.
shinyServer(function(input, output) {
  
  if(Sys.Date() != existing_date){
    read_actions()
    read_users()
    existing_date <<- Sys.Date()
  }
  
  output$users_per_platform <- renderDygraph(polloi::make_dygraph(
    user_data, "Date", "Events",
    "Unique users by platform, by day"
  ))
  
  output$geohack_feature_usage <- renderDygraph(polloi::make_dygraph(
    usage_data$GeoHack, "Date", "Events",
    "Feature usage for GeoHack"
  ))
  
  output$wikiminiatlas_feature_usage <- renderDygraph(polloi::make_dygraph(
    usage_data$WikiMiniAtlas, "Date", "Events",
    "Feature usage for WikiMiniAtlas"
  ))
  
  output$wikivoyage_feature_usage <- renderDygraph(polloi::make_dygraph(
    usage_data$Wikivoyage, "Date", "Events",
    "Feature usage for Wikivoyage"
  ))
  
  output$wiwosm_feature_usage <- renderDygraph(polloi::make_dygraph(
    usage_data$WIWOSM, "Date", "Events",
    "Feature usage for WIWOSM"
  ))
})
