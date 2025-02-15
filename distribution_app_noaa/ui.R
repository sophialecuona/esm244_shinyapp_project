#........................dashboardHeader.........................
header <- dashboardHeader(
  # add title ----
  title = tags$a(tags$img(src="bren_leaf.png", height = '40', width = '80'),
                                  'Economically Important Species Distribution', target="_blank", style = "color: #ffffff;"),
  titleWidth = 600

) # END dashboardHeader

#........................dashboardSidebar........................
sidebar <- dashboardSidebar(

  # sidebarMenu ----
  sidebarMenu(

    menuItem(text = "Overview", tabName = "overview", icon = icon("star")),
    menuItem(text = "Distribution", tabName = "dashboard", icon = icon("fish")),
    menuItem(text = "Revenue", tabName = "revenue", icon = icon("usd")),
    menuItem(text = "CPUE", tabName = "cpue", icon = icon("fire"))

  )# END sidebarMenu
) # END dashboardSidebar

#..........................dashboardBody.........................
body <- dashboardBody(

  # tabItems ----
  tabItems(

    # welcome tabItem ----
    tabItem(tabName = "overview",

            # left-hand column ----
            column(width = 6,

                   # background info box ----
                   box(width = NULL,

                       title = tagList(icon("water"), strong("Species Distribution over Space and Time")),
                       includeMarkdown("text/intro.md"),
                       tags$img(src = "cali_map.png",
                                alt = "California Coast.",
                                style = "max-width: 100%;",
                                alt = "Map of the California coast from NOAA DisMap."),
                       tags$h6(tags$em("Image Source:", tags$a(href = "https://apps-st.fisheries.noaa.gov/dismap/DisMAP.html", "NOAA DisMap")),
                               style = "text-align: center;")

                   ), # END background info box

            ), # END left-hand column

            # right-hand column ----
            column(width = 4,

                   # first fluidRow ----
                   fluidRow(

                     # data source box ----
                     box(width = NULL,

                         title = tagList(icon("table"), strong("Data Citations")),
                         includeMarkdown("text/data_citation.md"),
                         tags$img(src = "dismap.png",
                                  alt = "NOAA DisMAP.",
                                  style = "max-width: 50%;"),
                         tags$h6(tags$em("Image Source:", tags$a(href = "https://apps-st.fisheries.noaa.gov/dismap/", "NOAA DisMAP")),
                                 style = "text-align: left;")
                     ) # END data source box

                   ), # END first fluidRow

                   # second fluidRow ----
                   fluidRow(

                     # disclaimer box ----
                     box(width = NULL,

                         title = tagList(icon("triangle-exclamation"), strong("Disclaimer")),
                         includeMarkdown("text/disclaimer.md"),
                         tags$img(src= 'bren_logo.png', height = '60', width ='280')

                     ) # END disclaimer box

                   ) # END second fluidRow

            ) # END right-hand column

    ), # END welcome tabItem

    # dashboard tabItem ----
    tabItem(tabName = "dashboard",

            # fluidRow ----
            fluidRow(

              # input box ----
              box(width = 4, height = 500,

                  title = tags$strong("Species:"),

                  # sliderInputs ----
                  sliderInput(inputId = "depth_slider_input", label = "Depth (*meters* below SL):",
                              min = min(full_dung_squid_urch1$depth), max = max(full_dung_squid_urch1$depth),
                              value = c(min(full_dung_squid_urch1$depth), max(full_dung_squid_urch1$depth))),
                  # selectInput ----
                  checkboxGroupInput(inputId = "species_select_input",
                              label = "Select Species:",
                              choices = c("dungeness", "squid", "urchin"),
                              selected = "dungeness"),
                  # sliderInputs ----
                  sliderInput(inputId = "year_slider_input", label = "Years surveyed:",
                              min = min(full_dung_squid_urch1$year), max = max(full_dung_squid_urch1$year),
                              value = c(min(full_dung_squid_urch1$year), max(full_dung_squid_urch1$year)),
                              sep = "")

              ), # END input box

              box(width = 8, height = 500,

                  title = tags$strong("Distribution of Dungeness, Market Squid, and Urchin along the California Coast"),

                  # leaflet output ----
                  leafletOutput(outputId = "coast_map_output") |>
                    withSpinner(type = 1, color = "darkblue")

              ), # END leaflet box

              # input box ----
              box(width = 4, height = 350,

                  title = tags$strong("Dungeness Crab (2003 - 2022)"),
                  tags$img(src= 'dung_distribution.gif', height = '280', width ='280')

              ),# END input box ---

              # input box ----
              box(width = 4, height = 350,

                  title = tags$strong("Squid Distribution (2003 - 2022)"),
                  tags$img(src= 'squid_distribution.gif', height = '280', width ='280')

              ), # END input box ---

              # input box ----
              box(width = 4, height = 350,

                  title = tags$strong("Urchin Distribution (2003 - 2022)"),
                  tags$img(src= 'urchin_distribution.gif', height = '280', width ='280')

              )# END input box ---

            ) # END fluidRow

    ), # END dashboard tabItem

    # revenue tabItem ----
    tabItem(tabName = "revenue",
            fluidRow(
              column(
                width = 12,
                height = 300,
                box(
                  title = tags$strong("Select Species:"),
                  radioButtons(
                    inputId = "species_choice_input",
                    label = "Select Species:",
                    choices = c("Dungeness crab", "Market squid", "Red sea urchin"),
                    selected = "Dungeness crab"
                  )
                )
              ),
              column(
                width = 12,
                height = 500,
                box(
                  title = tags$strong("Revenue Plot"),
                  plotOutput(outputId = "species_revenue_plot")
                )
              ) # END plot box
            ), # END fluidRow

            fluidRow(
              column(
                width = 12,
                height = 400,
                box(
                  title = tags$strong("Coefficients Table"),
                  tableOutput(outputId = "coefficients_table")
                )
              ) # END coefficients table box
            ) # END fluidRow
    ), # END revenue tabItem

    # cpue tabItem ----
    tabItem(tabName = "cpue",

            # fluidRow ----
            fluidRow(

              # input box ----
              box(width = 4, height = 500,

                  title = tags$strong("Adjust depth ranges:"),

                  # sliderInputs ----
                  selectInput("species_dropdown", "Select Species:",
                              choices = unique(dismap_all_df$species),
                              selected = unique(dismap_all_df$species)[1])
              ), # END input box

              box(width = 8, height = 500,

                  title = tags$strong("WCPUE by Temperature"),

                  # cpue output ----
                  plotOutput(outputId = "cpue_plot")

              ) # END box

            ) # END fluidRow

    ) # END cpue tabItem

  ) # END tabItems

 ) # END dashboardBody

#..................combine all in dashboardPage..................
dashboardPage(header, sidebar, body)
