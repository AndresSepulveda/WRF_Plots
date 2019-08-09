setwd(dir="Escritorio/Practica_Tibo/carte_vent")
install.packages("ncdf4")
install.packages("CircStats")
install.packages("circular")
install.packages("MASS")
install.packages("boot")
install.packages("plotKMl")
library(plotkml)
library(CircStats)
library(circular)
library(ncdf4) # package for netcdf manipulation

nc_data__dom1 <- nc_open("Sdom1_mois.nc")
nc_data__dom2 <- nc_open("Sdom2_mois.nc")

U_dom1 <- ncvar_get(nc_data__dom1, "U")
U_dom2 <- ncvar_get(nc_data__dom2, "U")
V_dom1 <- ncvar_get(nc_data__dom1, "V")
V_dom2 <- ncvar_get(nc_data__dom2, "V")
H_dom1 <- ncvar_get(nc_data__dom1, "HGT")
H_dom2 <- ncvar_get(nc_data__dom2, "HGT")

direction=U_dom1[1:99,1:101,,]   #initialisation de la taillede la matrice 4*4
Vitesse=sqrt((U_dom1[1:99,1:101,,]**2)+(V_dom1[1:99,1:101,,]**2))
for (i in c(1:99)) {
  for (j in c(1:101)) {
    for (z in c(1:34)) {
      for (t in c(1:223)) {
        if ((V_dom1[i,j,z,t]>=0 & U_dom1[i,j,z,t] >= 0)==TRUE)  direction[i,j,z,t]=acos(abs(U_dom1[i,j,z,t])/(sqrt(U_dom1[i,j,z,t]**2+V_dom1[i,j,z,t]**2)))*(360/6.28)
        if ((V_dom1[i,j,z,t]<0 & U_dom1[i,j,z,t] < 0)==TRUE)  direction[i,j,z,t]=acos(abs(U_dom1[i,j,z,t])/(sqrt(U_dom1[i,j,z,t]**2+V_dom1[i,j,z,t]**2)))*(360/6.28)+180
        if ((V_dom1[i,j,z,t]>=0 & U_dom1[i,j,z,t] < 0)==TRUE)  direction[i,j,z,t]=acos(abs(U_dom1[i,j,z,t])/(sqrt(U_dom1[i,j,z,t]**2+V_dom1[i,j,z,t]**2)))*(360/6.28)+90
        if ((V_dom1[i,j,z,t]<0 & U_dom1[i,j,z,t] >= 0)==TRUE)  direction[i,j,z,t]=acos(abs(U_dom1[i,j,z,t])/(sqrt(U_dom1[i,j,z,t]**2+V_dom1[i,j,z,t]**2)))*(360/6.28)+270
      }
    }
  }
}
Grill_hor=1
Grill_vert=1
Alt=1
plot(c(1:223),direction[Grill_hor,Grill_vert,Alt,],ylim=c(0,360),xlab = "heure",ylab = "direction")
test=direction[Grill_hor,Grill_vert,Alt,]
windrose(Vitesse[Grill_hor,Grill_vert,Alt,],direction[Grill_hor,Grill_vert,Alt,],units = "degrees")
writeOGR(lieu,"C:\\Users\\Morgane\\Desktop\\lieu.kml", "KML") 