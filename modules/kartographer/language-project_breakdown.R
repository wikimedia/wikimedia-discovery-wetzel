output$language_selector_container <- renderUI({
  req(input$project_selector)
  temp_language <- available_languages
  if ("Maplink" %in% input$prevalence_langproj_feature) {
    temp_language <- temp_language[temp_language$maplink, ]
  }
  if ("Mapframe" %in% input$prevalence_langproj_feature) {
    temp_language <- temp_language[temp_language$mapframe, ]
  }

  if (input$language_order == "alphabet") {
    languages_to_display <- sort(temp_language$language)
  } else {
    languages_to_display <- temp_language$language[order(temp_language$articles, decreasing = TRUE)]
  }

  # e.g. if user sorts projects alphabetically and the selected project is "10th Anniversary of Wikipeda"
  #      then automatically select the language "(None)" to avoid giving user an error. This also works if
  #      the user selects a project that is not multilingual, so this automatically chooses the "(None)"
  #      option for the user.
  if (any(input$project_selector %in% projects_db$project[!projects_db$multilingual])) {
    if (any(input$project_selector %in% projects_db$project[projects_db$multilingual])) {
      if (!is.null(input$language_selector)) {
        selected_language <- union("(None)", input$language_selector)
      } else {
        selected_language <- c("(None)", languages_to_display[[1]])
      }
    } else {
      selected_language <- "(None)"
    }
  } else {
    if (!is.null(input$language_selector)) {
      selected_language <- input$language_selector
    } else {
      selected_language <- languages_to_display[[1]]
    }
  }

  return(selectInput(
    "language_selector", "Language",
    multiple = TRUE, selectize = FALSE, size = 19,
    choices = languages_to_display, selected = selected_language
  ))
})

output$project_selector_container <- renderUI({
  temp_project <- available_projects
  if ("Maplink" %in% input$prevalence_langproj_feature) {
    temp_project <- temp_project[temp_project$maplink, ]
  }
  if ("Mapframe" %in% input$prevalence_langproj_feature) {
    temp_project <- temp_project[temp_project$mapframe, ]
  }

  if (input$project_order == "alphabet") {
    projects_to_display <- sort(temp_project$project)
  } else {
    projects_to_display <- temp_project$project[order(temp_project$articles, decreasing = TRUE)]
  }

  if (!is.null(input$project_selector)) {
    selected_project <- input$project_selector
  } else {
    selected_project <- projects_to_display[1]
  }

  return(selectInput(
    "project_selector", "Project",
    multiple = TRUE, selectize = FALSE, size = 19,
    choices = projects_to_display, selected = selected_project
  ))
})

output$prevalence_langproj_plot <- renderDygraph({
  req(input$prevalence_langproj_feature, input$language_selector, input$project_selector)

  if (length(input$prevalence_langproj_feature) == 1) {
    if ("Maplink" %in% input$prevalence_langproj_feature) {
      feature_prevalence <- maplink_prevalence %>%
        dplyr::mutate(feature_articles = maplink_articles)
    } else {
      feature_prevalence <- mapframe_prevalence %>%
        dplyr::mutate(feature_articles = mapframe_articles)
    }
    if (length(input$language_selector) == 1 && input$language_selector[1] == "(None)") {
      feature_prevalence <- feature_prevalence %>%
      {
        if (input$prevalence_langproj_aggregation %in% c("Average", "Median")) {
          if (input$prevalence_langproj_aggregation == "Average") {
            aggregation_function <- mean
          } else {
            aggregation_function <- median
          }
          dplyr::group_by(., date, key = project, language) %>%
            dplyr::summarize(value = round(100 * sum(feature_articles, na.rm = TRUE) / sum(total_articles, na.rm = TRUE), 2)) %>%
            dplyr::summarize(value = aggregation_function(value, na.rm = TRUE))
        } else {
          dplyr::group_by(., date, key = project) %>%
            dplyr::summarize(value = round(100 * sum(feature_articles, na.rm = TRUE) / sum(total_articles, na.rm = TRUE), 2))
        }
      } %>%
        dplyr::ungroup() %>%
        tidyr::spread(key, value)
    } else {
      feature_prevalence <- feature_prevalence %>%
        dplyr::mutate(
          label = paste0(dplyr::if_else(is.na(language), "", paste0(language, " ")), project),
          language = dplyr::if_else(is.na(language), "(None)", language)
        ) %>%
        dplyr::filter(language %in% input$language_selector, project %in% input$project_selector) %>%
        dplyr::group_by(date, key = label) %>%
        dplyr::summarize(value = round(100 * sum(feature_articles, na.rm = TRUE) / sum(total_articles, na.rm = TRUE), 2)) %>%
        dplyr::ungroup() %>%
        tidyr::spread(key, value)
    }
  } else {
    feature_prevalence <- dplyr::full_join(
      maplink_prevalence,
      mapframe_prevalence,
      by = c("date", "wiki", "project", "language")
    ) %>%
      dplyr::filter(project %in% input$project_selector)
    if (length(input$language_selector) == 1 && input$language_selector[1] == "(None)") {
      feature_prevalence <- feature_prevalence %>%
      {
        if (input$prevalence_langproj_aggregation %in% c("Average", "Median")) {
          if (input$prevalence_langproj_aggregation == "Average") {
            aggregation_function <- mean
          } else {
            aggregation_function <- median
          }
          dplyr::group_by(., date, label = project, language) %>%
            dplyr::summarize(
              Maplink = round(100 * sum(maplink_articles, na.rm = TRUE) / sum(total_articles.x, na.rm = TRUE), 2),
              Mapframe = round(100 * sum(mapframe_articles, na.rm = TRUE) / sum(total_articles.y, na.rm = TRUE), 2)
            ) %>%
            dplyr::summarize(
              Maplink = aggregation_function(Maplink, na.rm = TRUE),
              Mapframe = aggregation_function(Mapframe, na.rm = TRUE)
            )
        } else {
          # input$prevalence_langproj_aggregation == "Overall"
          dplyr::group_by(., date, label = project) %>%
            dplyr::summarize(
              Maplink = round(100 * sum(maplink_articles, na.rm = TRUE) / sum(total_articles.x, na.rm = TRUE), 2),
              Mapframe = round(100 * sum(mapframe_articles, na.rm = TRUE) / sum(total_articles.y, na.rm = TRUE), 2)
            )
        }
      } %>%
        dplyr::ungroup() %>%
        tidyr::gather(feature, prevalence, -c(date, label)) %>%
        dplyr::transmute(
          date = date, value = prevalence,
          key = paste0(feature, " (", label, ")")
        ) %>%
        tidyr::spread(key, value)
    } else {
      feature_prevalence <- feature_prevalence %>%
        dplyr::mutate(
          label = paste0(dplyr::if_else(is.na(language), "", paste0(language, " ")), project),
          language = dplyr::if_else(is.na(language), "(None)", language)
        ) %>%
        dplyr::filter(language %in% input$language_selector, project %in% input$project_selector)
      if (nrow(feature_prevalence) > 0) {
        feature_prevalence <- feature_prevalence %>%
          dplyr::group_by(date, label) %>%
          dplyr::summarize(
            Maplink = round(100 * sum(maplink_articles, na.rm = TRUE) / sum(total_articles.x, na.rm = TRUE), 2),
            Mapframe = round(100 * sum(mapframe_articles, na.rm = TRUE) / sum(total_articles.y, na.rm = TRUE), 2)
          ) %>%
          dplyr::ungroup() %>%
          tidyr::gather(feature, prevalence, -c(date, label)) %>%
          dplyr::transmute(
            date = date, value = prevalence,
            key = paste0(feature, " (", label, ")")
          ) %>%
          tidyr::spread(key, value)
      } else {
        return(invisible(NULL))
      }
    }
  }
  feature_prevalence %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_prevalence_langproj), rename = FALSE) %>%
    polloi::reorder_columns() %>%
    polloi::make_dygraph(
      "Date", "Prevalence (%)",
      paste(paste(input$prevalence_langproj_feature, collapse = " and "), "prevalence")
    ) %>%
    dyLegend(show = "always", width = 400, labelsDiv = "prevalence_langproj_legend") %>%
    dyRangeSelector(retainDateWindow = TRUE, fillColor = "", strokeColor = "")
})
