library(shiny)
shinyUI(pageWithSidebar(
    
    headerPanel("The Human and Economic Loss Caused by various Weather Events in U.S. "),
    
    sidebarPanel(
        helpText("Create map for 48 U.S. states showing human and economic damage caused by
                 various strong/extreme weather events recorded between 1950 and 2011."),
        uiOutput("choose_EventType"),
        radioButtons("dmgType", "Choose a Damage Type:",
                     c("Fatalities" = "Fatalities",
                       "Injuries" = "Injuries",
                       "Property Damage" = "Property.Damage",
                       "Crop Damage" = "Crop.Damage"),
                     selected=NULL),
        actionButton("goButton","Display Map",icon("refresh"))
    ),
    
    mainPanel(
        h4('Estimated Total (Property/Damage in million $) : '),
        verbatimTextOutput("oid1"),
        plotOutput('eventPlot')
    )
)) 