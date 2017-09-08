#server

library(shiny)
library(leaflet)
library(tidyjson)
library(dplyr)
library(utils)
library(curl)
library(rgdal)
library(ggplot2)

# He'd like to have a map with totals on bottom such that the user could filter 
# the map & see aggregate values change. A few of the filters of interest were 
# property values, income levels, smart phone usage from census data, disability stats from status.
# Aggregate groupings included neighborhood (the level below super neighborhood),
# damage type, and flood depth cut-offs.

#api.call <- 'https://tnris-flood.carto.com/api/v2/sql?q=select%20latitude,longitude,flow,sigstage,timestamp%20from%20%22tnris-flood%22.nws_ahps_gauges_texas%20where%20sigstage%20IS%20NOT%20NULL%20and%20latitude%20between%2022%20and%2031%20and%20longitude%20between%20-97%20and%20-91'

fema <- read.csv('data/Harvey_FEMA_HCAD_DamageV2.txt')
#hcad <- read.csv('FEMA_Damage_HCAD_Overlay.csv')

fema.f <- select(fema,DMG_LEVEL,IN_DEPTH,city,zip,LONGITUDE,LATITUDE,HCAD_NUM,ASSESSED_V)

#pal <- colorFactor(c("yellow","yellow","yellow","red","orange","green","grey"),domain = c("action","flood","low","major","moderate","no flooding","not defined"))
#pal.fema <- colorFactor(c("yellow", "black", "red", "orange"), domain = c('AFF', 'DES', 'MAJ', 'MIN'))

filterFema <- function(depth.cutoff,value.cutoff)
{
  filter(fema.f, IN_DEPTH >= depth.cutoff[1], IN_DEPTH <= depth.cutoff[2], ASSESSED_V >= value.cutoff[1], ASSESSED_V <= value.cutoff[2])
}

makeLeafletMap <- function(depth.cutoff, value.cutoff)
{
  data.f <- filterFema(depth.cutoff, value.cutoff)
  
  leaflet() %>%
  setView(lat = 29.76, lng = -95.36, zoom = 10) %>%
  addProviderTiles(providers$Stamen.TonerLite, options = providerTileOptions(noWrap = TRUE)) %>%
  addCircles(data = data.f,
  color = data.f$DMG_LEVEL,
  fillOpacity = 0.7, radius = 10)
}

makeScatterPlot <- function(depth.cutoff, value.cutoff)
{
  data.f <- filterFema(depth.cutoff, value.cutoff)
  ggplot(data = data.f, mapping = aes(x = LONGITUDE, y = LATITUDE, color = IN_DEPTH, radius = ASSESSED_V/100000)) + geom_point(alpha = 0.4)
}

makeValueDensityPlot <- function(depth.cutoff,value.cutoff)
{
  data.f <- filterFema(depth.cutoff, value.cutoff)
  ggplot(data = data.f, mapping = aes(x=ASSESSED_V)) + geom_density()
}

makeDepthDensityPlot <- function(depth.cutoff,value.cutoff)
{
  data.f <- filterFema(depth.cutoff, value.cutoff)
  ggplot(data = data.f, mapping = aes(x=IN_DEPTH, color = DMG_LEVEL)) + geom_density()
}

makeSummaryValues <- function(depth.cutoff,value.cutoff)
{
  data.f <- filterFema(depth.cutoff, value.cutoff)
  total.damage.value <- sum(data.f$ASSESSED_V)
}

shinyServer <- function(input, output) 
{
  # output$harvey.plot <- renderPlot({
  #   makeScatterPlot(input$fdepth, input$pvalue)
  # })
  # 
  
  output$harvey.map <- renderLeaflet({
    makeLeafletMap(input$fdepth, input$pvalue)
  })
  
  output$value.plot <- renderPlot({
    makeValueDensityPlot(input$fdepth, input$pvalue)
  })
  
  output$depth.plot <- renderPlot({
    makeDepthDensityPlot(input$fdepth, input$pvalue)
  })
  
  output$total.dmg <- renderText({
    paste0("Total Damage: $",makeSummaryValues(input$fdepth, input$pvalue))
  })
}



