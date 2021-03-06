# West Yorkshire preliminary analysis

load("WYall.RData")

# Compare bike crashes with others + generalise results

bikes <- vtWY$Acc_Index[ vtWY$Vehicle_Type == 1]
acB <- acWY[ acWY$Accident_Index %in% bikes, ]
caB <- caWY[ caWY$Acc_Index %in% bikes, ]

plot(acWY)
plot(acB, col="red", add=T)

acWY$cyclist <- "No cyclist"
acWY$cyclist[acWY$Accident_Index %in% bikes] <- "Cyclist"

## Convert data into correct form

### Road class of accident
head(acWY$X1st_Road_Class)
class(acWY$X1st_Road_Class)
unique(acWY$X1st_Road_Class)
which(acWY$X1st_Road_Class == 5)
acWY$Road_class <- factor( acWY$X1st_Road_Class, levels = 1:6,
                        labels = c("Motorway", "A", "A", "B", "U", "U"))
head(acWY$Road_class)
qplot(Road_class, data=acWY@data) 
p <- ggplot(aes(Road_class), data = acWY@data) + geom_bar()
p + facet_grid(~ cyclist, scales="free")

### Timing of accident
summary(acWY$Time)
class(acWY$Time)
acWY$time <- as.character(acWY$Time)
summary(acWY$time)
head(acWY$time)
acWY$time <- paste0(acWY$time,":00")
# acWY$time <- as.POSIXct(acWY$time, format = "%H:%M") # works but...
library(chron)
summary(chron(times = acWY$time))
acWY$time <- chron(times = acWY$time) 
ggplot(aes(time, ..density..,), data = acWY@data) + geom_histogram() + geom_density() + 
  facet_grid(~ cyclist) + scale_x_chron(format="%H")
ggsave("figures/cyclist-timings.png")

library(ggmap)
ggplot() +  geom_point(aes(y = Latitude, x = Longitude, color=Road_class), 
                       data = acWY@data)

ggmap(get_map("Leeds", zoom=16)) +
  geom_point(aes(x = acB$Latitude, y = acB$Longitude))

theme_set(theme_bw(16))
qmap("Leeds", zoom=16, color = "bw") +
geom_point(aes(x = Longitude, y = Latitude, color=Accident_Severity), 
             data = acWY@data)
ggsave("figures/city-centre-all.png")

geocode("Leeds")

ggplot()






