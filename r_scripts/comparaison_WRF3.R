#comparer le modele et les obs
setwd(dir="Escritorio/Practica_Tibo/datos_temperatura_tslist/Sim03")   #lieu du dossier
modele=read.table("t2_Arica_sim03.txt",header = TRUE,sep="\t")    #donnees du modele
obs=read.csv("AricaT.csv")                                        #donnees du Vismet


modele$T2..K.=modele$T2..K.-273                                   #transformer les kelvins
modelec =modele #creation des modeles et obs corriges
obsc=obs
plot (modele$Time,modele$T2..K., col="blue", type="l", xlab = "time(h)" , ylab="T(°C)")
lines (obs$Fecha,obs$Valor, col="red",type="l")   #affichage des donnees obs et modeles

#separation en jours
j1m=modele[1:24,]       #separation des donnees en jour et en modele ou obs
j2m=modele[25:48,]
j3m=modele[49:72,]
j1o=obs[1:24,]
j2o=obs[25:48,]
j3o=obs[49:72,]

#calcul des amplitudes
ampm1= (max(modele[0:24,]$T2..K.)-min(modele[0:24,]$T2..K.)) # calcul des añplitudes en fonction du jour et du modele ou obs
ampo1=(max(obs[0:24,]$Valor)-min(obs[0:24,]$Valor))
ampm2= (max(modele[24:48,]$T2..K.)-min(modele[24:48,]$T2..K.))
ampo2= (max(obs[24:48,]$Valor)-min(obs[24:48,]$Valor))
ampm3= (max(modele[48:72,]$T2..K.)-min(modele[48:72,]$T2..K.))
ampo3= (max(obs[48:72,]$Valor)-min(obs[48:72,]$Valor))
       
#calcul du dephasage en temperature
deptmx1= (max(obs[0:24,]$Valor)-max(modele[0:24,]$T2..K.))  # calcul des dephasages en Tempe selon min et max
deptmn1= (min(obs[0:24,]$Valor)-min(modele[0:24,]$T2..K.))
deptmx2= (max(obs[24:48,]$Valor)-max(modele[24:48,]$T2..K.))
deptmn2= (min(obs[24:48,]$Valor)-min(modele[24:48,]$T2..K.))
deptmx3= (max(obs[48:72,]$Valor)-max(modele[48:72,]$T2..K.))
deptmn3= (min(obs[48:72,]$Valor)-min(modele[48:72,]$T2..K.))

#calcul du déphasage en temps1
i=1
j=1
maxio=max(j1o$Valor)
maxim=max(j1m$T2..K.)
while (j1o[i,]$Valor!=maxio) {     #boucle pour trouver la position du max
  i=i+1
}
while (j1m[j,]$T2..K.!=maxim) {
  j=j+1
}
dephasage1= abs(j-i)

#calcul du déphasage en temps2
i1=1
j1=1
maxio1=max(j2o$Valor)
maxim1=max(j2m$T2..K.)
while (j2o[i1,]$Valor!=maxio1) {
  i1=i1+1
}
while (j2m[j1,]$T2..K.!=maxim1) {
  j1=j1+1
}
dephasage2=abs(i1-j1)

#calcul du déphasage en temps3
i2=1
j2=1
maxio2=max(j3o$Valor)
maxim2=max(j3m$T2..K.)
while (j3o[i2,]$Valor!=maxio2) {
  i2=i2+1
}
while (j3m[j2,]$T2..K.!=maxim2) {
  j2=j2+1
}
dephasage3=abs(i2-j2)


#correctiom
modelec[1:24,]$Time=modelec[1:24,]$Time-dephasage1         #enlever le dephasage de chaque jour
modelec[25:48,]$Time=modelec[25:48,]$Time-dephasage2
modelec[49:73,]$Time=modelec[49:73,]$Time-dephasage3


modelec[1:24,]$T2..K.=modelec[1:24,]$T2..K.+((deptmn1+deptmx1)/2)  #enlever le dephasage en tempe a chaque jour
modelec[25:48,]$T2..K.=modelec[25:48,]$T2..K.+((deptmn2+deptmx2)/2)
modelec[49:73,]$T2..K.=modelec[49:73,]$T2..K.+((deptmn3+deptmx3)/2)
modelec = modelec [max(c(dephasage1,dephasage2,dephasage3))+1:66,] #couper les donnees pour voir les memes dimensions
obsc = obsc [0:66,]

plot (modelec$Time,modelec$T2..K., col="blue", type="l", xlab = "time(h)" , ylab="T(°C)")
lines (obsc$Fecha,obsc$Valor, col="red",type="l")    #tracer les graphiques corrigees

ecart3=modelec
ecart3$T2..K.=ecart3$T2..K.-obsc$Valor 
write.table(ecart3, "ecart_Sim03.txt", row.names=FALSE, dec=".", na=" ")  #calcul des ecarts entre modeles et obs corrigees
ecarta3=ecart                            # erreur en valeur absolue
ecarta3$T2..K.=abs(ecarta3$T2..K.)
print (colSums(ecarta3))

plot(ecart3$Time,ecart3$T2..K.,col="green", type="l", xlab = "time(h)" , ylab="ecart T(°C)") #tracer cet ecart
hist(ecart3$T2..K.,main="histogramme des ecarts modele corrigee et obs")  #tracer l histogramme des ecarts
qqplot(ecart3$Time,ecart3$T2..K.,xlab = "time(h)" , ylab="ecart T(°C)") # le fameux qqplot
plot(modelec$T2..K.,obsc$Valor, main="scatterplot",xlab ="T du modele corrigee",ylab="T des obs",xlim = c(12,19),ylim = c(12,19))
lines(c(12,13,14,15,16,17,18,19),c(12,13,14,15,16,17,18,19),type="l") # tracer le scatterplot et la regression lineaire


obs_mod=cbind(modelec$Time,obsc$Valor,modelec$T2..K.)  # mettre les donnes du modele et de l obs dans un meme tableau pour la regression lineaire
obs_mod_c <- as.data.frame(obs_mod)
reg_lin =lm(V2~V3,data = obs_mod_c)                 
print(reg_lin)  #faire et afficher la reg lin 

