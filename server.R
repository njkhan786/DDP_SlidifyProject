library(dplyr)
library(ggplot2)
library(scales)
library(stringr)
library(ggthemes)
library(shiny)
library(ggmap)
plotType <- function(x, type) {
    switch(type,
           Fatalities = ggplot() +
               geom_polygon( data=states_map, aes(x=long, y=lat, 
                                                   group = group),colour="black",
                                                   fill="white" ) +
               geom_jitter( data=x, position=position_jitter(width=0.1, height=0.1),
                            aes(x=Long, y=Lat, size = Fatalities)) + 
               scale_size(name="Fatalities") +
               theme(legend.position = "bottom") +
               ggtitle("Fatalities by Weather Events"),   
           Injuries = ggplot() +
               
               geom_polygon( data=states_map, aes(x=long, y=lat, 
                                                  group = group),colour="black",
                             fill="white" ) +
               geom_jitter( data=x, position=position_jitter(width=0.1, height=0.1),
                            aes(x=Long, y=Lat, size = Injuries)) + 
               scale_size(name="Injuries") +
               theme(legend.position = "bottom") +
               ggtitle("Injuries by Weather Events"),   
           Property.Damage = ggplot() +
               geom_polygon( data=states_map, aes(x=long, y=lat, 
                                                  group = group),colour="black",
                             fill="white" ) +
               geom_jitter( data=x, position=position_jitter(width=0.1, height=0.1),
                            aes(x=Long, y=Lat, size = Property.Damage)) + 
               scale_size(name="Property Damage (mill $)") +
               theme(legend.position = "bottom") +
               ggtitle("Property Damage by Weather Events"),   
           Crop.Damage = ggplot() +
               geom_polygon( data=states_map, aes(x=long, y=lat, 
                                                  group = group),colour="black",
                             fill="white" ) +
               geom_jitter( data=x, position=position_jitter(width=0.1, height=0.1),
                            aes(x=Long, y=Lat, size = Crop.Damage)) + 
               scale_size(name="Crop Damage (mill $)") +
               theme(legend.position = "bottom") +
               ggtitle("Crop Damage by Weather Events"))
}
states_map <-map_data("state")
stormdata <- read.csv("./data/stormdata.csv",as.is=TRUE)
evetype <- stormdata$EventType
uevetype <- unique(evetype)

shinyServer(function(input, output) {
    # Drop-down selection box for which data set
    output$choose_EventType <- renderUI({
        selectInput("Event", "Choose a Weather Event", as.list(uevetype))
    })
    output$odmgType <- renderPrint({input$dmgType})
    output$eventPlot <- renderPlot({
        if (input$goButton > 0){
            df3<- filter(stormdata,toupper(EventType) == toupper(input$Event))
            switch(input$dmgType,
                   Fatalities = df3 <- filter(df3,Fatalities > 0 ),
                   Injuries = df3 <- filter(df3,Injuries > 0 ),
                   Property.Damage = df3 <- filter(df3,Property.Damage > 0 ),
                   Crop.Damage = df3 <- filter(df3,Crop.Damage > 0 ) 
            )
            plotType(df3,input$dmgType)}
    })
    output$oid1 <- renderPrint({
    if (input$goButton > 0){
        df3<- filter(stormdata,toupper(EventType) == toupper(input$Event))
        switch(input$dmgType,
               Fatalities = sum(df3$Fatalities),
               Injuries = sum(df3$Injuries),
               Property.Damage = sum(df3$Property.Damage),
               Crop.Damage = sum(df3$Crop.Damage) )
    }
    })
})