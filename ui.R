#ui

library(shiny)
library(leaflet)

nabes = c("BAYTOWN","BELLAIRE","CHANNELVIEW","CROSBY","CYPRESS","DAYTON",
          "DEERPARK","FRIENDSWOOD","GALENA PARK","HIGHLANDS","HOCKLEY","HOUSTON","HUFFMAN",
          "HUMBLE","KATY","KINGWOOD","LA PORTE","LEAGUE CITY","NASSAU BAY","NEW CANEY",
          "NONE","PASADENA","PEARLAND","PORTER","SEABROOK","SOUTH HOUSTON","SPRING",
          "STAFFORD","TOMBALL","WEBSTER")

shinyUI(fluidPage(
  
  titlePanel(
    h2("Harvey Damage Explorer"),
    h5("Mapping Modeled Flood Damage, Property Values, and Socio-Economic Data In Harris County")
  ),
  #plotOutput("harvey.plot"),
  leafletOutput("harvey.map"),
  
  fluidRow(
    column(6,plotOutput("depth.plot")),
    column(6,plotOutput("value.plot"))
    ),
  span(textOutput("total.dmg"), style = "color:red"),
  
  wellPanel(id = "controls",
    selectInput("nabes", "Select Neighborhoods (autocomplete on name):",multiple = TRUE,
                        nabes),
    sliderInput('fdepth', 'Flood Depth', 0, 48, c(2,24)),
    sliderInput('pvalue', 'Property Value ($k)', 0, 5000, c(100,1000))
    #sliderInput('income', 'Median Income ($k)', 0, 200, 0),
    
  )
  
))


