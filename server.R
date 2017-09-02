#server

library(shiny)
library(leaflet)
library(tidyjson)
library(dplyr)
library(utils)
library(rgdal)


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
  
  ses <- readOGR("acs2015_5yr_B19013_15000US482014304001/acs2015_5yr_B19013_15000US482014304001.shp",
                           layer = "acs2015_5yr_B19013_15000US482014304001", GDAL1_integer64_policy = TRUE)
  
  medianhhipal <- colorQuantile("RdYlGn", ses$B19013001, n=11)
  
  output$harvey.map <- renderLeaflet({
    leaflet(ses) %>%
      setView(lat = 29.76, lng = -95.36, zoom = 10) %>%
      
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
     ) %>%
      addPolygons(color = ~pal(B19013001), weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.2
     ) %>%
      addCircleMarkers(data = flood, color = ~pal(sigstage))
  })
}
