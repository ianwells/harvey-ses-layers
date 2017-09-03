#server

library(shiny)
library(leaflet)
library(tidyjson)
library(dplyr)
library(utils)
library(curl)
library(rgdal)


api.call <- 'https://tnris-flood.carto.com/api/v2/sql?q=select%20latitude,longitude,flow,sigstage,timestamp%20from%20%22tnris-flood%22.nws_ahps_gauges_texas%20where%20sigstage%20IS%20NOT%20NULL%20and%20latitude%20between%2022%20and%2031%20and%20longitude%20between%20-97%20and%20-91'

getFloodData <- function()
{
  flood <- jsonlite::fromJSON(api.call, simplifyDataFrame = TRUE)
  
  flood$rows
}

pal <- colorFactor(c("yellow","yellow","yellow","red","orange","green","grey"),domain = c("action","flood","low","major","moderate","no flooding","not defined"))

shinyServer <- function(input, output, session) {
  
  flood <- getFloodData()
  flood$sigstage <- as.factor(flood$sigstage)
  
  ses <- readOGR("acs2015_5yr_B19013_15000US482014304001/acs2015_5yr_B19013_15000US482014304001.shp",
                           layer = "acs2015_5yr_B19013_15000US482014304001", GDAL1_integer64_policy = TRUE)
  
  ses1 <- readOGR("acs2015_5yr_B19013_15000US480717102003/acs2015_5yr_B19013_15000US480717102003.shp",
                 layer = "acs2015_5yr_B19013_15000US480717102003", GDAL1_integer64_policy = TRUE)
  
  ses2 <- readOGR("acs2015_5yr_B19013_15000US481677251002/acs2015_5yr_B19013_15000US481677251002.shp",
                 layer = "acs2015_5yr_B19013_15000US481677251002", GDAL1_integer64_policy = TRUE)
  
  ses3 <- readOGR("acs2015_5yr_B19013_15000US482917008002/acs2015_5yr_B19013_15000US482917008002.shp",
                 layer = "acs2015_5yr_B19013_15000US482917008002", GDAL1_integer64_policy = TRUE)
  
  ses4 <- readOGR("acs2015_5yr_B19013_15000US482450105004/acs2015_5yr_B19013_15000US482450105004.shp",
                  layer = "acs2015_5yr_B19013_15000US482450105004", GDAL1_integer64_policy = TRUE)
  
  ses5 <- readOGR("acs2015_5yr_B19013_15000US481576711004/acs2015_5yr_B19013_15000US481576711004.shp",
                  layer = "acs2015_5yr_B19013_15000US481576711004", GDAL1_integer64_policy = TRUE)
  
  ses6 <- readOGR("acs2015_5yr_B19013_15000US481990305024/acs2015_5yr_B19013_15000US481990305024.shp",
                  layer = "acs2015_5yr_B19013_15000US481990305024", GDAL1_integer64_policy = TRUE)
  
  medianhhipal <- colorQuantile("Blues", ses$B19013001, n = 9)
  
  output$harvey.map <- renderLeaflet({
    leaflet() %>%
      setView(lat = 29.76, lng = -95.36, zoom = 10) %>%
      
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
     ) %>%
      addPolygons(data = ses, color = ~medianhhipal(B19013001), weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.4
     ) %>%
      
      addPolygons(data = ses1, color = ~medianhhipal(B19013001), weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.4
      ) %>%
      
      addPolygons(data = ses2, color = ~medianhhipal(B19013001), weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.4
      ) %>%
      
      addPolygons(data = ses3, color = ~medianhhipal(B19013001), weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.4
      ) %>%
      
      addPolygons(data = ses4, color = ~medianhhipal(B19013001), weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.4
      ) %>%
      
      addPolygons(data = ses5, color = ~medianhhipal(B19013001), weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.4
      ) %>%
      
      addPolygons(data = ses6, color = ~medianhhipal(B19013001), weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.4
      ) %>%
      
      addCircleMarkers(data = flood, color = ~pal(sigstage), fillOpacity = 0.9)
  })
}
