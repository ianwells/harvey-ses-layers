#ui

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Harvey-SES-Layers"),
  h5("Mapping Flood Conditions and Socio-Economic Data In Houston"),
  leafletOutput("harvey.map")
  
))


