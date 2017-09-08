library(ggplot2)
library(ggmap)
library(dplyr)
library(knitr)
library(lubridate)
library(reshape)
library(CausalImpact)
library(rddtools)
library(forecast)
select <- dplyr::select

flood.max <- read.csv('riverine-gage.csv')

fema <- read.csv('fema-damage-model.csv')

hcad <- read.csv('FEMA_Damage_HCAD_Overlay.csv')

head(hcad)

hcad <- filter(hcad, !is.na(hcad$HCAD_NUM))


hcad.s <- select(hcad, DMG_LEVEL,IN_DEPTH,LONGITUDE,LATITUDE,HCAD_NUM,zip)
write.csv(hcad.s,file = 'hcad-fema.csv',col.names = TRUE, row.names = FALSE)

head(fema)

head(flood.max)


ggmap(get_map(location = "houston", zoom = 10)) +
geom_point(data = flood.max, aes(x = LONGDD, y = LATDD, size = GageMax, alpha = 0.2)) + 
  geom_point(data = hcad, aes(x = LONGITUDE, y = LATITUDE, size = 0.2, color = IN_DEPTH, alpha = 0.2)) 



#krig



  

  geom_density2d(data = flood.max, 
aes(x = LONGDD, y = LATDD), size = 0.2) + 
  stat_density2d(data = flood.max), 
aes(x = LONGDD, y = LATDD, fill = ..level.., alpha = 0.01), size = 0.01, 
bins = 16, geom = "polygon") +
  scale_alpha(range = c(0, 0.3), guide = FALSE)

