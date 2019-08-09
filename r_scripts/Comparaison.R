setwd(dir="Escritorio/Practica_Tibo/Comparaison_datos_modele/Moi")   #lieu du dossier

Obs_st1=read.csv("KC_2018.csv",header = TRUE)
Obs_st2=read.csv("NL_2018.csv",header = TRUE)
Mod_st1=read.table("KC_t2u10v10wswd.txt",header = TRUE)
Mod_st2=read.table("NL_t2u10v10wswd.txt",header = TRUE)


par(mfrow=c(1,1)) 
plot(Obs_st1$Win.Direction,Mod_st1$X1.8343800e.02, main="scatterplot_st1",xlab ="Dir_wind_obs",ylab="Dir_wind_mod")
lines(c(0:360),c(0:360),type="l",col="red")


par(mfrow=c(1,1)) 
plot(Obs_st1$Wind.Speed..m.s.,Mod_st1$X1.2181777e.00, main="scatterplot_st1",xlab ="Sp_wind_obs",ylab="Sp_wind_mod",xlim = c(0,12),ylim = c(0,12))
lines(c(0:12),c(0:12),type="l",col="red")

par(mfrow=c(1,1)) 
plot(Obs_st2$Win.Direction,Mod_st2$X1.8343800e.02, main="scatterplot_st2",xlab ="Dir_wind_obs",ylab="Dir_wind_mod")
lines(c(0:360),c(0:360),type="l",col="red")

par(mfrow=c(1,1)) 
plot(Obs_st2$Wind.Speed..m.s.,Mod_st2$X1.2181777e.00, main="scatterplot_st1",xlab ="Sp_wind_obs",ylab="Sp_wind_mod",xlim = c(0,12),ylim = c(0,12))
lines(c(0:12),c(0:12),type="l",col="red")

par(mfrow=c(1,1)) 
qqplot(Obs_st1$Win.Direction,Mod_st1$X1.8343800e.02,main="qqplot_st1",xlab ="Dir_wind_obs",ylab="Dir_wind_mod")
lines(c(0:360),c(0:360),type="l",col="red")

par(mfrow=c(1,1)) 
qqplot(Obs_st1$Wind.Speed..m.s.,Mod_st1$X1.2181777e.00,main="qqplot_st1",xlab ="SP_wind_obs",ylab="SP_wind_mod",xlim = c(0,12),ylim = c(0,12))
lines(c(0:12),c(0:12),type="l",col="red")

par(mfrow=c(1,1)) 
qqplot(Obs_st2$Win.Direction,Mod_st2$X1.8343800e.02,main="qqplot_st2",xlab ="Dir_wind_obs",ylab="Dir_wind_mod")
lines(c(0:360),c(0:360),type="l",col="red")

par(mfrow=c(1,1)) 
qqplot(Obs_st2$Wind.Speed..m.s.,Mod_st2$X1.2181777e.00,main="qqplot_st2",xlab ="SP_wind_obs",ylab="SP_wind_mod",xlim = c(0,12),ylim = c(0,12))
lines(c(0:12),c(0:12),type="l",col="red")


par(mfrow=c(2,2)) 
hist(Obs_st1$Wind.Speed..m.s. , xlab ="mediciones", ylab = "Frequence" , main ="Magnitud_viento_st1",xlim=c(0,12),breaks=c(0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10,10.5,11,11.5,12,12.5,13,13.5,14))
hist(Mod_st1$X1.2181777e.00 , xlab ="modelo", ylab = "Frequence" , main ="Magnitud_viento_st1",xlim=c(0,12),breaks=c(0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10,10.5,11,11.5,12,12.5,13,13.5,14))
hist(Obs_st1$Win.Direction , xlab ="mediciones", ylab = "Frequence" , main ="Dir_viento_st1",xlim=c(0,360),breaks=c(0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,360))
hist(Mod_st1$X1.8343800e.02, xlab ="modelo", ylab = "Frequence" , main ="Dir_viento_st1",xlim=c(0,360),breaks=c(0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,360))

par(mfrow=c(2,2)) 
hist(Obs_st2$Wind.Speed..m.s. , xlab ="mediciones", ylab = "Frequence" , main ="Magnitud_viento_st2",xlim=c(0,12),breaks=c(0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10,10.5,11,11.5,12,12.5,13,13.5,14))
hist(Mod_st2$X1.2181777e.00 , xlab ="modelo", ylab = "Frequence", main ="Magnitud_viento_st2",xlim=c(0,12),breaks=c(0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10,10.5,11,11.5,12,12.5,13,13.5,14))
hist(Obs_st2$Win.Direction , xlab ="mediciones", ylab = "Frequence" , main ="Dir_viento_st2",xlim=c(0,360),breaks=c(0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,360))
hist(Mod_st2$X1.8343800e.02, xlab ="modelo", ylab = "Frequence" , main ="Dir_viento_st2",xlim=c(0,360),breaks=c(0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,360))


############################################################### Cycle diurne
##### modele station 1
mh1=c()
mh2=c()
mh3=c()
mh4=c()
mh5=c()
mh6=c()
mh7=c()
mh8=c()
mh9=c()
mh10=c()
mh11=c()
mh12=c()
mh13=c()
mh14=c()
mh15=c()
mh16=c()
mh17=c()
mh18=c()
mh19=c()
mh20=c()
mh21=c()
mh22=c()
mh23=c()
mh0=c()

for (i in 24*c(1:30)) {
  mh1=c(mh1,Mod_st1[i,]$X1.2181777e.00 )
  mh2=c(mh2,Mod_st1[i+1,]$X1.2181777e.00 )
  mh3=c(mh3,Mod_st1[i+2,]$X1.2181777e.00 )
  mh4=c(mh4,Mod_st1[i+3,]$X1.2181777e.00 )
  mh5=c(mh5,Mod_st1[i+4,]$X1.2181777e.00 )
  mh6=c(mh6,Mod_st1[i+5,]$X1.2181777e.00 )
  mh7=c(mh7,Mod_st1[i+6,]$X1.2181777e.00 )
  mh8=c(mh8,Mod_st1[i+7,]$X1.2181777e.00 )
  mh9=c(mh9,Mod_st1[i+8,]$X1.2181777e.00 )
  mh10=c(mh10,Mod_st1[i+9,]$X1.2181777e.00 )
  mh11=c(mh11,Mod_st1[i+10,]$X1.2181777e.00 )
  mh12=c(mh12,Mod_st1[i+11,]$X1.2181777e.00 )
  mh13=c(mh13,Mod_st1[i+12,]$X1.2181777e.00 )
  mh14=c(mh14,Mod_st1[i+13,]$X1.2181777e.00 )
  mh15=c(mh15,Mod_st1[i+14,]$X1.2181777e.00 )
  mh16=c(mh16,Mod_st1[i+15,]$X1.2181777e.00 )
  mh17=c(mh17,Mod_st1[i+16,]$X1.2181777e.00 )
  mh18=c(mh18,Mod_st1[i+17,]$X1.2181777e.00 )
  mh19=c(mh19,Mod_st1[i+18,]$X1.2181777e.00 )
  mh20=c(mh20,Mod_st1[i+19,]$X1.2181777e.00 )
  mh21=c(mh21,Mod_st1[i+20,]$X1.2181777e.00 )
  mh22=c(mh22,Mod_st1[i+21,]$X1.2181777e.00 )
  mh23=c(mh23,Mod_st1[i+22,]$X1.2181777e.00 )
  mh0=c(mh0,Mod_st1[i+23,]$X1.2181777e.00 )
}
Mn1=mean(mh1)
Mn2=mean(mh2)
Mn3=mean(mh3)
Mn4=mean(mh4)
Mn5=mean(mh5)
Mn6=mean(mh6)
Mn7=mean(mh7)
Mn8=mean(mh8)
Mn9=mean(mh9)
Mn10=mean(mh10)
Mn11=mean(mh11)
Mn12=mean(mh12)
Mn13=mean(mh13)
Mn14=mean(mh14)
Mn15=mean(mh15)
Mn16=mean(mh16)
Mn17=mean(mh17)
Mn18=mean(mh18)
Mn19=mean(mh19)
Mn20=mean(mh20)
Mn21=mean(mh21)
Mn22=mean(mh22)
Mn23=mean(mh23)
Mn0=mean(mh0)
Moy_mod_st1 <- data.frame(rbind(Mn0,Mn1,Mn2,Mn3,Mn4,Mn5,Mn6,Mn7,Mn8,Mn9,Mn10,Mn11,Mn12,Mn13,Mn14,Mn15,Mn16,Mn17,Mn18,Mn19,Mn20,Mn21,Mn22,Mn23))


###########   observation station 1


oh1=c()
oh2=c()
oh3=c()
oh4=c()
oh5=c()
oh6=c()
oh7=c()
oh8=c()
oh9=c()
oh10=c()
oh11=c()
oh12=c()
oh13=c()
oh14=c()
oh15=c()
oh16=c()
oh17=c()
oh18=c()
oh19=c()
oh20=c()
oh21=c()
oh22=c()
oh22=c()
oh23=c()
oh0=c()

for (i in 24*c(1:30)) {
  oh1=c(oh0,Obs_st1[i,]$Wind.Speed..m.s. )
  oh2=c(oh2,Obs_st1[i+1,]$Wind.Speed..m.s. )
  oh3=c(oh3,Obs_st1[i+2,]$Wind.Speed..m.s. )
  oh4=c(oh4,Obs_st1[i+3,]$Wind.Speed..m.s. )
  oh5=c(oh5,Obs_st1[i+4,]$Wind.Speed..m.s. )
  oh6=c(oh6,Obs_st1[i+5,]$Wind.Speed..m.s. )
  oh7=c(oh7,Obs_st1[i+6,]$Wind.Speed..m.s. )
  oh8=c(oh8,Obs_st1[i+7,]$Wind.Speed..m.s. )
  oh9=c(oh9,Obs_st1[i+8,]$Wind.Speed..m.s. )
  oh10=c(oh10,Obs_st1[i+9,]$Wind.Speed..m.s. )
  oh11=c(oh11,Obs_st1[i+10,]$Wind.Speed..m.s. )
  oh12=c(oh12,Obs_st1[i+11,]$Wind.Speed..m.s. )
  oh13=c(oh13,Obs_st1[i+12,]$Wind.Speed..m.s. )
  oh14=c(oh14,Obs_st1[i+13,]$Wind.Speed..m.s. )
  oh15=c(oh15,Obs_st1[i+14,]$Wind.Speed..m.s. )
  oh16=c(oh16,Obs_st1[i+15,]$Wind.Speed..m.s. )
  oh17=c(oh17,Obs_st1[i+16,]$Wind.Speed..m.s. )
  oh18=c(oh18,Obs_st1[i+17,]$Wind.Speed..m.s. )
  oh19=c(oh19,Obs_st1[i+18,]$Wind.Speed..m.s. )
  oh20=c(oh20,Obs_st1[i+19,]$Wind.Speed..m.s. )
  oh21=c(oh21,Obs_st1[i+20,]$Wind.Speed..m.s. )
  oh22=c(oh22,Obs_st1[i+21,]$Wind.Speed..m.s. )
  oh23=c(oh23,Obs_st1[i+22,]$Wind.Speed..m.s. )
  oh0=c(oh0,Obs_st1[i+23,]$Wind.Speed..m.s. )
}

oMn1=mean(oh1[!is.na(oh1)])
oMn2=mean(oh2[!is.na(oh2)])
oMn3=mean(oh3[!is.na(oh3)])
oMn4=mean(oh4[!is.na(oh4)])
oMn5=mean(oh5[!is.na(oh5)])
oMn6=mean(oh6[!is.na(oh6)])
oMn7=mean(oh7[!is.na(oh7)])
oMn8=mean(oh8[!is.na(oh8)])
oMn9=mean(oh9[!is.na(oh9)])
oMn10=mean(oh10[!is.na(oh10)])
oMn11=mean(oh11[!is.na(oh11)])
oMn12=mean(oh12[!is.na(oh12)])
oMn13=mean(oh13[!is.na(oh13)])
oMn14=mean(oh14[!is.na(oh14)])
oMn15=mean(oh15[!is.na(oh15)])
oMn16=mean(oh16[!is.na(oh16)])
oMn17=mean(oh17[!is.na(oh17)])
oMn18=mean(oh18[!is.na(oh18)])
oMn19=mean(oh19[!is.na(oh19)])
oMn20=mean(oh20[!is.na(oh20)])
oMn21=mean(oh21[!is.na(oh21)])
oMn22=mean(oh22[!is.na(oh22)])
oMn23=mean(oh23[!is.na(oh23)])
oMn0=mean(oh0[!is.na(oh0)])
Moy_obs_st1 <- data.frame(rbind(oMn0,oMn1,oMn2,oMn3,oMn4,oMn5,oMn6,oMn7,oMn8,oMn9,oMn10,oMn11,oMn12,oMn13,oMn14,oMn15,oMn16,oMn17,oMn18,oMn19,oMn20,oMn21,oMn22,oMn23))

par(mfrow=c(1,1)) 
plot(c(0:23),c(Mn0,Mn1,Mn2,Mn3,Mn4,Mn5,Mn6,Mn7,Mn8,Mn9,Mn10,Mn11,Mn12,Mn13,Mn14,Mn15,Mn16,Mn17,Mn18,Mn19,Mn20,Mn21,Mn22,Mn23), main ="st1" ,type = "l",col="red",xlab="hora",ylab="prom_mag_viento",xlim=c(0,24),ylim = c(1,5))
lines(c(0:23),c(oMn0,oMn1,oMn2,oMn3,oMn4,oMn5,oMn6,oMn7,oMn8,oMn9,oMn10,oMn11,oMn12,oMn13,oMn14,oMn15,oMn16,oMn17,oMn18,oMn19,oMn20,oMn21,oMn22,oMn23),type = "l",col="blue",xlab="hora",ylab="prom_mag_viento")


###########################################################   modele station 2



dmh1=c()
dmh2=c()
dmh3=c()
dmh4=c()
dmh5=c()
dmh6=c()
dmh7=c()
dmh8=c()
dmh9=c()
dmh10=c()
dmh11=c()
dmh12=c()
dmh13=c()
dmh14=c()
dmh15=c()
dmh16=c()
dmh17=c()
dmh18=c()
dmh19=c()
dmh20=c()
dmh21=c()
dmh22=c()
dmh23=c()
dmh0=c()

for (i in 24*c(1:30)) {
  dmh1=c(dmh1,Mod_st2[i,]$X1.2181777e.00 )
  dmh2=c(dmh2,Mod_st2[i+1,]$X1.2181777e.00 )
  dmh3=c(dmh3,Mod_st2[i+2,]$X1.2181777e.00 )
  dmh4=c(dmh4,Mod_st2[i+3,]$X1.2181777e.00 )
  dmh5=c(dmh5,Mod_st2[i+4,]$X1.2181777e.00 )
  dmh6=c(dmh6,Mod_st2[i+5,]$X1.2181777e.00 )
  dmh7=c(dmh7,Mod_st2[i+6,]$X1.2181777e.00 )
  dmh8=c(dmh8,Mod_st2[i+7,]$X1.2181777e.00 )
  dmh9=c(dmh9,Mod_st2[i+8,]$X1.2181777e.00 )
  dmh10=c(dmh10,Mod_st2[i+9,]$X1.2181777e.00 )
  dmh11=c(dmh11,Mod_st2[i+10,]$X1.2181777e.00 )
  dmh12=c(dmh12,Mod_st2[i+11,]$X1.2181777e.00 )
  dmh13=c(dmh13,Mod_st2[i+12,]$X1.2181777e.00 )
  dmh14=c(dmh14,Mod_st2[i+13,]$X1.2181777e.00 )
  dmh15=c(dmh15,Mod_st2[i+14,]$X1.2181777e.00 )
  dmh16=c(dmh16,Mod_st2[i+15,]$X1.2181777e.00 )
  dmh17=c(dmh17,Mod_st2[i+16,]$X1.2181777e.00 )
  dmh18=c(dmh18,Mod_st2[i+17,]$X1.2181777e.00 )
  dmh19=c(dmh19,Mod_st2[i+18,]$X1.2181777e.00 )
  dmh20=c(dmh20,Mod_st2[i+19,]$X1.2181777e.00 )
  dmh21=c(dmh21,Mod_st2[i+20,]$X1.2181777e.00 )
  dmh22=c(dmh22,Mod_st2[i+21,]$X1.2181777e.00 )
  dmh23=c(dmh23,Mod_st2[i+22,]$X1.2181777e.00 )
  dmh0=c(dmh0,Mod_st2[i+23,]$X1.2181777e.00 )
}
dMn1=mean(dmh1)
dMn2=mean(dmh2)
dMn3=mean(dmh3)
dMn4=mean(dmh4)
dMn5=mean(dmh5)
dMn6=mean(dmh6)
dMn7=mean(dmh7)
dMn8=mean(dmh8)
dMn9=mean(dmh9)
dMn10=mean(dmh10)
dMn11=mean(dmh11)
dMn12=mean(dmh12)
dMn13=mean(dmh13)
dMn14=mean(dmh14)
dMn15=mean(dmh15)
dMn16=mean(dmh16)
dMn17=mean(dmh17)
dMn18=mean(dmh18)
dMn19=mean(dmh19)
dMn20=mean(dmh20)
dMn21=mean(dmh21)
dMn22=mean(dmh22)
dMn23=mean(dmh23)
dMn0=mean(dmh0)

Moy_mod_st2 <- data.frame(rbind(dMn0,dMn1,dMn2,dMn3,dMn4,dMn5,dMn6,dMn7,dMn8,dMn9,dMn10,dMn11,dMn12,dMn13,dMn14,dMn15,dMn16,dMn17,dMn18,dMn19,dMn20,dMn21,dMn22,dMn23))

###########################observation station deux

doh1=c()
doh2=c()
doh3=c()
doh4=c()
doh5=c()
doh6=c()
doh7=c()
doh8=c()
doh9=c()
doh10=c()
doh11=c()
doh12=c()
doh13=c()
doh14=c()
doh15=c()
doh16=c()
doh17=c()
doh18=c()
doh19=c()
doh20=c()
doh21=c()
doh22=c()
doh22=c()
doh23=c()
doh0=c()

for (i in 24*c(1:30)) {
  doh1=c(doh1,Obs_st2[i,]$Wind.Speed..m.s. )
  doh2=c(doh2,Obs_st2[i+1,]$Wind.Speed..m.s. )
  doh3=c(doh3,Obs_st2[i+2,]$Wind.Speed..m.s. )
  doh4=c(doh4,Obs_st2[i+3,]$Wind.Speed..m.s. )
  doh5=c(doh5,Obs_st2[i+4,]$Wind.Speed..m.s. )
  doh6=c(doh6,Obs_st2[i+5,]$Wind.Speed..m.s. )
  doh7=c(doh7,Obs_st2[i+6,]$Wind.Speed..m.s. )
  doh8=c(doh8,Obs_st2[i+7,]$Wind.Speed..m.s. )
  doh9=c(doh9,Obs_st2[i+8,]$Wind.Speed..m.s. )
  doh10=c(doh10,Obs_st2[i+9,]$Wind.Speed..m.s. )
  doh11=c(doh11,Obs_st2[i+10,]$Wind.Speed..m.s. )
  doh12=c(doh12,Obs_st2[i+11,]$Wind.Speed..m.s. )
  doh13=c(doh13,Obs_st2[i+12,]$Wind.Speed..m.s. )
  doh14=c(doh14,Obs_st2[i+13,]$Wind.Speed..m.s. )
  doh15=c(doh15,Obs_st2[i+14,]$Wind.Speed..m.s. )
  doh16=c(doh16,Obs_st2[i+15,]$Wind.Speed..m.s. )
  doh17=c(doh17,Obs_st2[i+16,]$Wind.Speed..m.s. )
  doh18=c(doh18,Obs_st2[i+17,]$Wind.Speed..m.s. )
  doh19=c(doh19,Obs_st2[i+18,]$Wind.Speed..m.s. )
  doh20=c(doh20,Obs_st2[i+19,]$Wind.Speed..m.s. )
  doh21=c(doh21,Obs_st2[i+20,]$Wind.Speed..m.s. )
  doh22=c(doh22,Obs_st2[i+21,]$Wind.Speed..m.s. )
  doh23=c(doh23,Obs_st2[i+22,]$Wind.Speed..m.s. )
  doh0=c(doh0,Obs_st2[i+23,]$Wind.Speed..m.s. )
}

doMn1=mean(doh1[!is.na(doh1)])
doMn2=mean(doh2[!is.na(doh2)])
doMn3=mean(doh3[!is.na(doh3)])
doMn4=mean(doh4[!is.na(doh4)])
doMn5=mean(doh5[!is.na(doh5)])
doMn6=mean(doh6[!is.na(doh6)])
doMn7=mean(doh7[!is.na(doh7)])
doMn8=mean(doh8[!is.na(doh8)])
doMn9=mean(doh9[!is.na(doh9)])
doMn10=mean(doh10[!is.na(doh10)])
doMn11=mean(doh11[!is.na(doh11)])
doMn12=mean(doh12[!is.na(doh12)])
doMn13=mean(doh13[!is.na(doh13)])
doMn14=mean(doh14[!is.na(doh14)])
doMn15=mean(doh15[!is.na(doh15)])
doMn16=mean(doh16[!is.na(doh16)])
doMn17=mean(doh17[!is.na(doh17)])
doMn18=mean(doh18[!is.na(doh18)])
doMn19=mean(doh19[!is.na(doh19)])
doMn20=mean(doh20[!is.na(doh20)])
doMn21=mean(doh21[!is.na(doh21)])
doMn22=mean(doh22[!is.na(doh22)])
doMn23=mean(doh23[!is.na(doh23)])
doMn0=mean(doh0[!is.na(doh0)])

Moy_obs_st2 <- data.frame(rbind(doMn0,doMn1,doMn2,doMn3,doMn4,doMn5,doMn6,doMn7,doMn8,doMn9,doMn10,doMn11,doMn12,doMn13,doMn14,doMn15,doMn16,doMn17,doMn18,doMn19,doMn20,doMn21,doMn22,doMn23))

par(mfrow=c(1,1)) 
plot(c(0:23),c(dMn0,dMn1,dMn2,dMn3,dMn4,dMn5,dMn6,dMn7,dMn8,dMn9,dMn10,dMn11,dMn12,dMn13,dMn14,dMn15,dMn16,dMn17,dMn18,dMn19,dMn20,dMn21,dMn22,dMn23), main ="st2" ,type = "l",col="red",xlab="hora",ylab="prom_mag_viento",xlim=c(0,24),ylim = c(3,6))
lines(c(0:23),c(doMn0,doMn1,doMn2,doMn3,doMn4,doMn5,doMn6,doMn7,doMn8,doMn9,doMn10,doMn11,doMn12,doMn13,doMn14,doMn15,doMn16,doMn17,doMn18,doMn19,doMn20,doMn21,doMn22,doMn23),type = "l",col="blue",xlab="hora",ylab="prom_mag_viento")
############################### calcul deviation standard station1

sm1=0
so1=0
sm2=0
so2=0
for (i in c(1:24)) {
  sm1=sm1+abs((Moy_mod_st1[i,1]-mean(Moy_mod_st1[,1]))**2)
  so1=so1+abs((Moy_obs_st1[i,1]-mean(Moy_obs_st1[,1]))**2)
  sm2=sm2+abs((Moy_mod_st2[i,1]-mean(Moy_mod_st2[,1]))**2)
  so2=so2+abs((Moy_obs_st2[i,1]-mean(Moy_obs_st2[,1]))**2)
}
sm1=sqrt((sm1/24))
so1=sqrt((so1/24))
sm2=sqrt((sm2/24))
so2=sqrt((so2/24))


par(mfrow=c(1,1)) 
plot(c(0:23),c(Mn0,Mn1,Mn2,Mn3,Mn4,Mn5,Mn6,Mn7,Mn8,Mn9,Mn10,Mn11,Mn12,Mn13,Mn14,Mn15,Mn16,Mn17,Mn18,Mn19,Mn20,Mn21,Mn22,Mn23), main ="st1" ,type = "l",col="red",xlab="hora",ylab="prom_mag_viento",xlim=c(0,24),ylim = c(1,5))
lines(c(0:23),c(Mn0,Mn1,Mn2,Mn3,Mn4,Mn5,Mn6,Mn7,Mn8,Mn9,Mn10,Mn11,Mn12,Mn13,Mn14,Mn15,Mn16,Mn17,Mn18,Mn19,Mn20,Mn21,Mn22,Mn23)+sm1,type = "l",lty=2,col="red",xlab="hora",ylab="prom_mag_viento")
lines(c(0:23),c(Mn0,Mn1,Mn2,Mn3,Mn4,Mn5,Mn6,Mn7,Mn8,Mn9,Mn10,Mn11,Mn12,Mn13,Mn14,Mn15,Mn16,Mn17,Mn18,Mn19,Mn20,Mn21,Mn22,Mn23)-sm1,type = "l",lty=2,col="red",xlab="hora",ylab="prom_mag_viento")
lines(c(0:23),c(oMn0,oMn1,oMn2,oMn3,oMn4,oMn5,oMn6,oMn7,oMn8,oMn9,oMn10,oMn11,oMn12,oMn13,oMn14,oMn15,oMn16,oMn17,oMn18,oMn19,oMn20,oMn21,oMn22,oMn23),type = "l",col="blue",xlab="hora",ylab="prom_mag_viento")
lines(c(0:23),c(oMn0,oMn1,oMn2,oMn3,oMn4,oMn5,oMn6,oMn7,oMn8,oMn9,oMn10,oMn11,oMn12,oMn13,oMn14,oMn15,oMn16,oMn17,oMn18,oMn19,oMn20,oMn21,oMn22,oMn23)+so1,type = "l",lty=2,col="blue",xlab="hora",ylab="prom_mag_viento")
lines(c(0:23),c(oMn0,oMn1,oMn2,oMn3,oMn4,oMn5,oMn6,oMn7,oMn8,oMn9,oMn10,oMn11,oMn12,oMn13,oMn14,oMn15,oMn16,oMn17,oMn18,oMn19,oMn20,oMn21,oMn22,oMn23)-so1,type = "l",lty=2,col="blue",xlab="hora",ylab="prom_mag_viento")

######## deviation standard


par(mfrow=c(1,1)) 
plot(c(0:23),c(dMn0,dMn1,dMn2,dMn3,dMn4,dMn5,dMn6,dMn7,dMn8,dMn9,dMn10,dMn11,dMn12,dMn13,dMn14,dMn15,dMn16,dMn17,dMn18,dMn19,dMn20,dMn21,dMn22,dMn23), main ="st2" ,type = "l",col="red",xlab="hora",ylab="prom_mag_viento",xlim=c(0,24),ylim = c(2,8))
lines(c(0:23),c(dMn0,dMn1,dMn2,dMn3,dMn4,dMn5,dMn6,dMn7,dMn8,dMn9,dMn10,dMn11,dMn12,dMn13,dMn14,dMn15,dMn16,dMn17,dMn18,dMn19,dMn20,dMn21,dMn22,dMn23)+sm2,type = "l",lty=2,col="red",xlab="hora",ylab="prom_mag_viento")
lines(c(0:23),c(dMn0,dMn1,dMn2,dMn3,dMn4,dMn5,dMn6,dMn7,dMn8,dMn9,dMn10,dMn11,dMn12,dMn13,dMn14,dMn15,dMn16,dMn17,dMn18,dMn19,dMn20,dMn21,dMn22,dMn23)-sm2,type = "l",lty=2,col="red",xlab="hora",ylab="prom_mag_viento")
lines(c(0:23),c(doMn0,doMn1,doMn2,doMn3,doMn4,doMn5,doMn6,doMn7,doMn8,doMn9,doMn10,doMn11,doMn12,doMn13,doMn14,doMn15,doMn16,doMn17,doMn18,doMn19,doMn20,doMn21,doMn22,doMn23),type = "l",col="blue",xlab="hora",ylab="prom_mag_viento")
lines(c(0:23),c(doMn0,doMn1,doMn2,doMn3,doMn4,doMn5,doMn6,doMn7,doMn8,doMn9,doMn10,doMn11,doMn12,doMn13,doMn14,doMn15,doMn16,doMn17,doMn18,doMn19,doMn20,doMn21,doMn22,doMn23)+so2,type = "l",lty=2,col="blue",xlab="hora",ylab="prom_mag_viento")
lines(c(0:23),c(doMn0,doMn1,doMn2,doMn3,doMn4,doMn5,doMn6,doMn7,doMn8,doMn9,doMn10,doMn11,doMn12,doMn13,doMn14,doMn15,doMn16,doMn17,doMn18,doMn19,doMn20,doMn21,doMn22,doMn23)-so2,type = "l",lty=2,col="blue",xlab="hora",ylab="prom_mag_viento")

############ cycle mensuel
#### modele station 1

janm1=Mod_st1[1:744,]
febm1=Mod_st1[745:1416,]
marm1=Mod_st1[1417:2160,]
avrm1=Mod_st1[2161:2880,]
maim1=Mod_st1[2881:3624,]
juinm1=Mod_st1[3625:4344,]
juilm1=Mod_st1[4345:5088,]
aoum1=Mod_st1[5089:5832,]
sepm1=Mod_st1[5833:6552,]
octm1=Mod_st1[6553:7296,]
novm1=Mod_st1[7297:8016,]
decm1=Mod_st1[8017:8759,]

Mjanm1=mean(janm1$X1.2181777e.00)
Mfebm1=mean(febm1$X1.2181777e.00)
Mmarm1=mean(marm1$X1.2181777e.00)
Mavrm1=mean(avrm1$X1.2181777e.00)
Mmaim1=mean(maim1$X1.2181777e.00)
Mjuinm1=mean(juinm1$X1.2181777e.00)
Mjuilm1=mean((juilm1$X1.2181777e.00))
Maoum1=mean(aoum1$X1.2181777e.00)
Msepm1=mean(sepm1$X1.2181777e.00)
Moctm1=mean(octm1$X1.2181777e.00)
Mnovm1=mean(novm1$X1.2181777e.00)
Mdecm1=mean(decm1$X1.2181777e.00)

Moy_mois_mod_st1= data.frame(rbind(Mjanm1,Mfebm1,Mmarm1,Mavrm1,Mmaim1,Mjuinm1,Mjuilm1,Maoum1,Msepm1,Moctm1,Mnovm1,Mdecm1))


###obs station 1

jano1=Obs_st1[1:744,]$Wind.Speed..m.s
febo1=Obs_st1[745:1416,]$Wind.Speed..m.s
maro1=Obs_st1[1417:2160,]$Wind.Speed..m.s
avro1=Obs_st1[2161:2880,]$Wind.Speed..m.s
maio1=Obs_st1[2881:3624,]$Wind.Speed..m.s
juino1=Obs_st1[3625:4344,]$Wind.Speed..m.s
juilo1=Obs_st1[4345:5088,]$Wind.Speed..m.s
aouo1=Obs_st1[5089:5832,]$Wind.Speed..m.s
sepo1=Obs_st1[5833:6552,]$Wind.Speed..m.s
octo1=Obs_st1[6553:7296,]$Wind.Speed..m.s
novo1=Obs_st1[7297:8016,]$Wind.Speed..m.s
deco1=Obs_st1[8017:8759,]$Wind.Speed..m.s

Mjano1=mean(jano1[!is.na(jano1)])
Mfebo1=mean(febo1[!is.na(febo1)])
Mmaro1=mean(maro1[!is.na(maro1)])
Mavro1=mean(avro1[!is.na(avro1)])
Mmaio1=mean(maio1[!is.na(maio1)])
Mjuino1=mean(juino1[!is.na(juino1)])
Mjuilo1=mean(juilo1[!is.na(juilo1)])
Maouo1=mean(aouo1[!is.na(aouo1)])
Msepo1=mean(sepo1[!is.na(sepo1)])
Mocto1=mean(octo1[!is.na(octo1)])
Mnovo1=mean(novo1[!is.na(novo1)])
Mdeco1=mean(deco1[!is.na(deco1)])

Moy_mois_obs_st1= data.frame(rbind(Mjano1,Mfebo1,Mmaro1,Mavro1,Mmaio1,Mjuino1,Mjuilo1,Maouo1,Msepo1,Mocto1,Mnovo1,Mdeco1))


####modele station2

janm2=Mod_st2[1:744,]
febm2=Mod_st2[745:1416,]
marm2=Mod_st2[1417:2160,]
avrm2=Mod_st2[2161:2880,]
maim2=Mod_st2[2881:3624,]
juinm2=Mod_st2[3625:4344,]
juilm2=Mod_st2[4345:5088,]
aoum2=Mod_st2[5089:5832,]
sepm2=Mod_st2[5833:6552,]
octm2=Mod_st2[6553:7296,]
novm2=Mod_st2[7297:8016,]
decm2=Mod_st2[8017:8759,]

Mjanm2=mean(janm1$X1.2181777e.00)
Mfebm2=mean(febm2$X1.2181777e.00)
Mmarm2=mean(marm2$X1.2181777e.00)
Mavrm2=mean(avrm2$X1.2181777e.00)
Mmaim2=mean(maim2$X1.2181777e.00)
Mjuinm2=mean(juinm2$X1.2181777e.00)
Mjuilm2=mean(juilm2$X1.2181777e.00)
Maoum2=mean(aoum2$X1.2181777e.00)
Msepm2=mean(sepm2$X1.2181777e.00)
Moctm2=mean(octm2$X1.2181777e.00)
Mnovm2=mean(novm2$X1.2181777e.00)
Mdecm2=mean(decm2$X1.2181777e.00)

Moy_mois_mod_st2= data.frame(rbind(Mjanm2,Mfebm2,Mmarm2,Mavrm2,Mmaim2,Mjuinm2,Mjuilm2,Maoum2,Msepm2,Moctm2,Mnovm2,Mdecm2))


###obs station 2

jano2=Obs_st2[1:744,]$Wind.Speed..m.s
febo2=Obs_st2[745:1416,]$Wind.Speed..m.s
maro2=Obs_st2[1417:2160,]$Wind.Speed..m.s
avro2=Obs_st2[2161:2880,]$Wind.Speed..m.s
maio2=Obs_st2[2881:3624,]$Wind.Speed..m.s
juino2=Obs_st2[3625:4344,]$Wind.Speed..m.s
juilo2=Obs_st2[4345:5088,]$Wind.Speed..m.s
aouo2=Obs_st2[5089:5832,]$Wind.Speed..m.s
sepo2=Obs_st2[5833:6552,]$Wind.Speed..m.s
octo2=Obs_st2[6553:7296,]$Wind.Speed..m.s
novo2=Obs_st2[7297:8016,]$Wind.Speed..m.s
deco2=Obs_st2[8017:8759,]$Wind.Speed..m.s

Mjano2=mean(jano2[!is.na(jano2)])
Mfebo2=mean(febo2[!is.na(febo2)])
Mmaro2=mean(maro2[!is.na(maro2)])
Mavro2=mean(avro2[!is.na(avro2)])
Mmaio2=mean(maio2[!is.na(maio2)])
Mjuino2=mean(juino2[!is.na(juino2)])
Mjuilo2=mean(juilo2[!is.na(juilo2)])
Maouo2=mean(aouo2[!is.na(aouo2)])
Msepo2=mean(sepo2[!is.na(sepo2)])
Mocto2=mean(octo2[!is.na(octo2)])
Mnovo2=mean(novo2[!is.na(novo2)])
Mdeco2=mean(deco2[!is.na(deco2)])

Moy_mois_obs_st2= data.frame(rbind(Mjano2,Mfebo2,Mmaro2,Mavro2,Mmaio2,Mjuino2,Mjuilo2,Maouo2,Msepo2,Mocto2,Mnovo2,Mdeco2))



####tracé
sm_mois_1=0
so_mois_1=0
sm_mois_2=0
so_mois_2=0
for (i in c(1:12)) {
  sm_mois_1=sm1+abs((Moy_mois_mod_st1[i,1]-mean(Moy_mois_mod_st1[,1]))**2)
  so_mois_1=so1+abs((Moy_mois_obs_st1[i,1]-mean(Moy_mois_obs_st1[,1]))**2)
  sm_mois_2=sm2+abs((Moy_mois_mod_st2[i,1]-mean(Moy_mois_mod_st2[,1]))**2)
  so_mois_2=so2+abs((Moy_mois_obs_st2[i,1]-mean(Moy_mois_obs_st2[,1]))**2)
}
sm_mois_1=sqrt((sm_mois_1/12))
so_mois_1=sqrt((so_mois_1/12))
sm_mois_2=sqrt((sm_mois_2/12))
so_mois_2=sqrt((so_mois_2/12))



par(mfrow=c(1,2))
plot(c(1:12),c(Mjanm1,Mfebm1,Mmarm1,Mavrm1,Mmaim1,Mjuinm1,Mjuilm1,Maoum1,Msepm1,Moctm1,Mnovm1,Mdecm1), main ="Mensuel_st1" ,type = "l",col="red",xlab="mois",ylab="prom_mag_viento",xlim=c(0,12),ylim = c(1,5))
lines(c(1:12),c(Mjanm1,Mfebm1,Mmarm1,Mavrm1,Mmaim1,Mjuinm1,Mjuilm1,Maoum1,Msepm1,Moctm1,Mnovm1,Mdecm1)+sm_mois_1,type = "l",lty=2,col="red",xlab="hora",ylab="prom_mag_viento")
lines(c(1:12),c(Mjanm1,Mfebm1,Mmarm1,Mavrm1,Mmaim1,Mjuinm1,Mjuilm1,Maoum1,Msepm1,Moctm1,Mnovm1,Mdecm1)-sm_mois_1,type = "l",lty=2,col="red",xlab="hora",ylab="prom_mag_viento")
lines(c(1:12),c(Mjano1,Mfebo1,Mmaro1,Mavro1,Mmaio1,Mjuino1,Mjuilo1,Maouo1,Msepo1,Mocto1,Mnovo1,Mdeco1),type = "l",col="blue",xlab="hora",ylab="prom_mag_viento")
lines(c(1:12),c(Mjano1,Mfebo1,Mmaro1,Mavro1,Mmaio1,Mjuino1,Mjuilo1,Maouo1,Msepo1,Mocto1,Mnovo1,Mdeco1)+so_mois_1,type = "l",lty=2,col="blue",xlab="hora",ylab="prom_mag_viento")
lines(c(1:12),c(Mjano1,Mfebo1,Mmaro1,Mavro1,Mmaio1,Mjuino1,Mjuilo1,Maouo1,Msepo1,Mocto1,Mnovo1,Mdeco1)-so_mois_1,type = "l",lty=2,col="blue",xlab="hora",ylab="prom_mag_viento")

plot(c(1:12),c(Mjanm2,Mfebm2,Mmarm2,Mavrm2,Mmaim2,Mjuinm2,Mjuilm2,Maoum2,Msepm2,Moctm2,Mnovm2,Mdecm2), main ="Mensuel_st2" ,type = "l",col="red",xlab="mois",ylab="prom_mag_viento",xlim=c(0,12),ylim = c(2,5))
lines(c(1:12),c(Mjanm2,Mfebm2,Mmarm2,Mavrm2,Mmaim2,Mjuinm2,Mjuilm2,Maoum2,Msepm2,Moctm2,Mnovm2,Mdecm2)+sm_mois_2,type = "l",lty=2,col="red",xlab="hora",ylab="prom_mag_viento")
lines(c(1:12),c(Mjanm2,Mfebm2,Mmarm2,Mavrm2,Mmaim2,Mjuinm2,Mjuilm2,Maoum2,Msepm2,Moctm2,Mnovm2,Mdecm2)-sm_mois_2,type = "l",lty=2,col="red",xlab="hora",ylab="prom_mag_viento")
lines(c(1:12),c(Mjano2,Mfebo2,Mmaro2,Mavro2,Mmaio2,Mjuino2,Mjuilo2,Maouo2,Msepo2,Mocto2,Mnovo2,Mdeco2),type = "l",col="blue",xlab="hora",ylab="prom_mag_viento")
lines(c(1:12),c(Mjano2,Mfebo2,Mmaro2,Mavro2,Mmaio2,Mjuino2,Mjuilo2,Maouo2,Msepo2,Mocto2,Mnovo2,Mdeco2)+so_mois_2,type = "l",lty=2,col="blue",xlab="hora",ylab="prom_mag_viento")
lines(c(1:12),c(Mjano2,Mfebo2,Mmaro2,Mavro2,Mmaio2,Mjuino2,Mjuilo2,Maouo2,Msepo2,Mocto2,Mnovo2,Mdeco2)-so_mois_2,type = "l",lty=2,col="blue",xlab="hora",ylab="prom_mag_viento")
