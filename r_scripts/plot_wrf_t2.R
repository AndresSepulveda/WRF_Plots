dev.off()
library(ncdf4)
library(rgdal)
library(fields)

setwd("C:/Users/dgeo/WRF")

inp <-nc_open('wrfout_d01_2019-09-08.nc')
xlon <- ncvar_get(inp,varid ='XLONG')
xlat <- ncvar_get(inp,varid ='XLAT')
t2 <- ncvar_get(inp,varid='T2')
nc_close(inp)

lon <-  xlon[,1,1]
lat <-  xlon[1,,1]
t2.uno <- t2[,,1]
image.plot(lon,lat,t2.uno,
           main = "T2M",
           xlab = "Longitude",
           ylab = "Latitude",
           legend.lab = "°K",
           legend.line = 2.5)
