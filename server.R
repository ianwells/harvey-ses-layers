#server

library(shiny)
library(leaflet)
library(tidyjson)
library(dplyr)
library(utils)

api.call <- 'https://tnris-flood.carto.com/api/v2/sql?q=select%20latitude,longitude,flow,sigstage,timestamp%20from%20%22tnris-flood%22.nws_ahps_gauges_texas%20where%20sigstage%20IS%20NOT%20NULL'

getFloodData <- function()
{
  flood <- jsonlite::fromJSON(api.call, simplifyDataFrame = TRUE)
  
  flood$rows
}

getColor <- function(flood)
{
  sapply(flood$sigstage, function(sig) {
  if(sig == 'no flooding') {
    "green"
  } else if(sig == 'low') {
    "yellow"
  } else if(sig == 'moderate') {
    "orange"
  } else if(sig == 'major') {
    "red"
  } else {
    "grey"
  }
  })
}

pal <- colorFactor(c("yellow","yellow","yellow","red","orange","green","grey"),domain = c("action","flood","low","major","moderate","no flooding","not defined"))

shinyServer <- function(input, output, session) {
  
  flood <- getFloodData()
  flood$sigstage <- as.factor(flood$sigstage)
  
  output$harvey.map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addCircleMarkers(data = flood, color = ~pal(sigstage))
  })
}
