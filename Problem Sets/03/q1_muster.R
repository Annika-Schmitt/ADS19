require(tidyverse)
require(leaflet)
require(raster)


#a)
euElections = read_csv2("https://www.bundeswahlleiter.de/dam/jcr/5441f564-1f29-4971-9ae2-b8860c1724d1/ew19_kerg2.csv", 
                        skip = 9)

euElections %>%
  filter(Gebietsart == 'Land', Gruppenart == "Partei") -> euElections

#euElections$Gruppenname = iconv(euElections$Gruppenname, from = 'latin1', to = 'ascii', sub="")

# b)
parteien = c("CDU", "CSU", "SPD", "AfD", "DIE LINKE", "GRÜNE", "FDP")

euElections %>%
  filter(Gruppenname %in% parteien) %>%
  ggplot(aes(x=Gruppenname, y=Prozent)) + geom_col() + 
  facet_wrap(.~Gebietsname) + theme_bw() +
  theme(axis.text.x = element_text(angle = 90))

euElections %>%
  filter(Gruppenname %in% parteien) %>%
  ggplot(aes(x=Gebietsname, y=Prozent, fill=Gruppenname)) + 
  geom_col() + theme_bw() +
  theme(axis.text.x = element_text(angle = 90))


# c)
euElections %>%
  filter(Gruppenname %in% parteien) %>%
  ggplot(aes(x=Gruppenname, y=Prozent)) + geom_boxplot() + 
  theme_bw()

# d)
euElections %>%
  group_by(Gebietsname) %>%
  filter(Prozent == max(Prozent)) -> euWinners

germany <- getData("GADM", country="Germany", level=1)

germany@data

germany@data <- germany@data %>%
  left_join(euWinners, by=c("NAME_1"="Gebietsname"))

pal = colorFactor(palette = c("black", "grey", "red", "green", "blue"),
                  levels = c("CDU", "CSU", "SPD", "GRÜNE", "AfD"))

leaflet() %>%
  addTiles() %>%
  addPolygons(data=germany,
              fillColor = ~pal(Gruppenname), fillOpacity = 0.5,
              color = "black")

# e)
euElections = read_csv2("https://www.bundeswahlleiter.de/dam/jcr/5441f564-1f29-4971-9ae2-b8860c1724d1/ew19_kerg2.csv", 
                        skip = 9)

euElections %>%
  filter(Gebietsart == 'Kreis', Gruppenart == "Partei") -> euElections

euElections %>%
  group_by(Gebietsname) %>%
  filter(Prozent == max(Prozent)) -> euWinners

germany <- getData("GADM", country="Germany", level=2)

germany@data <- germany@data %>%
  left_join(euWinners, by=c("CC_2"="Gebietsnummer"))

leaflet() %>%
  addTiles() %>%
  addPolygons(data=germany,
              fillColor = ~pal(Gruppenname), fillOpacity = ~Prozent/50,
              color = "black",
              weight = 2)
