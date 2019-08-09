#etude de la sortie de janvier 2019 avec les sous domaines
setwd(dir="Escritorio/Practica_Tibo/Mez_Chile/Sous_domaine")
install.packages("ncdf4")
install.packages("chron")
install.packages("RColorBrewer")
install.packages("lattice")
install.packages("dplyr")
library(dplyr)
library(ncdf4) # package for netcdf manipulation
library(chron)
library(RColorBrewer)
library(lattice)

###Antofogasta
Obs1_3=read.csv("1_3.csv")  
Obs4_6=read.csv("4_6.csv")  
Obs7_9=read.csv("7_9.csv")  
Obs10_12=read.csv("10_12.csv")  
Obs13_15=read.csv("13_15.csv")  
Obs16_18=read.csv("16_18.csv")  
Obs19_21=read.csv("19_21.csv")  
Obs22_24=read.csv("22_24.csv")  
Obs25_27=read.csv("25_27.csv")  
Obs28_30=read.csv("28_30.csv")  
Obs31=read.csv("31.csv")  

Obs_mois=bind_rows(Obs1_3,Obs4_6,Obs7_9,Obs10_12,Obs13_15,Obs16_18,Obs19_21,Obs22_24,Obs25_27,Obs28_30)  #reunion des donnees sur un ficgier de 31 jours#reunion des donnees sur un ficgier de 31 jours
Obs_mois_coupe=Obs_mois[1:669,]
#extraction des données 
nc_data_mois_dom1 <- nc_open("Sdom1_mois.nc")
nc_data_mois_dom2 <- nc_open("Sdom2_mois.nc")

#extraction des tempés
T_mois_dom1 <- ncvar_get(nc_data_mois_dom1, "T2")-273
T_mois_dom2 <- ncvar_get(nc_data_mois_dom2, "T2")-273


#Couper le domaine 2 dans le domaine 1

T_dom1_mois_coupe <-T_mois_dom1[29:58,29:57,]

#transforñer les matrices 3+3 en vecteurs pour tracer les histogrannes en densité
lt_dom1_mois_coupe=c()
for (u in c(1:30)) {
  for (v in c(1:29)) {
    for (t in c(1:223)) {
      lt_dom1_mois_coupe=c(lt_dom1_mois_coupe,T_dom1_mois_coupe[u,v,t])
    }
  }
}

lt_mois_dom2=c()
for (u in c(1:90)) {
  for (v in c(1:87)) {
    for (t in c(1:669)) {
      lt_mois_dom2=c(lt_mois_dom2,T_mois_dom2[u,v,t])
    }
  }
}
par (mfrow=c(1,2))
hist(lt_dom1_mois_coupe, probability = TRUE)
hist(lt_mois_dom2, probability = TRUE)


#tracé les profils de température temporelle pour un point de grille choisi
i=32   #choix du point de grille horizontal a comparer ici Antofogasta
j=33   #choix du oint de grille vertcal a comparer  puis trouver la station correspondante sur Vismet
lt_mois=c()
listt1_mois=c()
listt2_mois=c()
listobs=c()
for (t in c(1:223)) {  #liste de temps disponibles
  lt_mois=c(lt_mois,3*t)
  listt1_mois=c(listt1_mois,T_mois_dom1[i,j,t])           # extraire les températures des deux domaines
  listt2_mois=c(listt2_mois,T_mois_dom2[1+((i-29)*3),1+((j-29)*3),3*t-1])
  listobs=c(listobs,Obs_mois_coupe[3*t-1,]$Valor)
}
par (mfrow=c(1,1))
plot(lt_mois,listt2_mois,type = "l",col="red",xlab="temps en heure" , ylab="Temp en K", ylim = c(16,25),main = "rojo=dom1 , azul=dom2 ")  #tracer les deux profils pour essayer de le comparer avec des obs
lines(lt_mois,listt1_mois,type = "l",col="blue")
lines(c(1:720),Obs_mois$Valor,type="l",col="green")

par (mfrow=c(1,3))
plot(listt1_mois,listt2_mois,xlab="tempé domaine 1" , ylab="Tempé domaine 2",xlim=c(16,22), ylim = c(16,22) , main = "scatterplot dom1_dom2")  
lines(c(16:22),c(16:22),type="l",col="red")
plot(listobs , listt2_mois , xlab="obs" , ylab="Tempé domaine 2",xlim=c(16,25), ylim = c(16,25) , main = "scatterplot obs_dom2")  
lines(c(1:30),c(1:30),type="l",col="red")
plot(listobs,listt1_mois, xlab="tempé obs" , ylab="Tempé domaine 1",xlim=c(16,25), ylim = c(16,25),main = "scatterplot obs dom1")  
lines(c(16:25),c(16:25),type="l",col="red")


par (mfrow=c(1,3))
qqplot(listt2_mois,listt1_mois, xlab="tempé dom2" , ylab="Tempé dom1",xlim=c(16,21), ylim = c(16,21),main = "qqplot dom1 dom2")
lines(c(0:130),c(0:130),type="l",col="red")
qqplot(listobs,listt1_mois, xlab="tempé obs" ,xlim=c(16,25), ylim = c(16,25), ylab="Tempé dom1",main = "qqplot obs dom1")
lines(c(0:130),c(0:130),type="l",col="red")
qqplot(listobs,listt2_mois, xlab="tempé obs" ,xlim=c(16,25), ylim = c(16,25), ylab="Tempé dom2",main = "qqplot obs dom1")
lines(c(0:130),c(0:130),type="l",col="red")


#############################################################################################################
# Seuil Tmax
faussealerte_max_dom1=0        #définition des quatres phénomenes
Bonprevireussi_max_dom1=0
Nondetection_max_dom1=0
Bonprevinonphenomene_max_dom1=0
Seuil_max=22   #Seuil de Tmax a modifier
for (i in c(0:29)) {
  if ((max(Obs_mois_coupe[(24*i):(24*(i+1)),]$Valor) > Seuil_max & max(listt1_mois[(24*i):(24*(i+1))]) > Seuil_max) ==TRUE) Bonprevireussi_max_dom1=Bonprevireussi_max_dom1+1      #classement de la situation en comparant le modele et l'obs chaque jour
  if ((max(Obs_mois_coupe[(24*i):(24*(i+1)),]$Valor) > Seuil_max & max(listt1_mois[(24*i):(24*(i+1))]) < Seuil_max) ==TRUE) Nondetection_max_dom1=Nondetection_max_dom1+1
  if ((max(Obs_mois_coupe[(24*i):(24*(i+1)),]$Valor) < Seuil_max & max(listt1_mois[(24*i):(24*(i+1))]) > Seuil_max) ==TRUE) faussealerte_max_dom1=faussealerte_max_dom1+1
  if ((max(Obs_mois_coupe[(24*i):(24*(i+1)),]$Valor) < Seuil_max & max(listt1_mois[(24*i):(24*(i+1))]) < Seuil_max) ==TRUE) Bonprevinonphenomene_max_dom1=Bonprevinonphenomene_max_dom1+1
}

# Seuil Tmax
faussealerte_max_dom2=0        #définition des quatres phénomenes
Bonprevireussi_max_dom2=0
Nondetection_max_dom2=0
Bonprevinonphenomene_max_dom2=0
Seuil_max=22   #Seuil de Tmax a modifier
for (i in c(0:29)) {
  if ((max(Obs_mois_coupe[(24*i):(24*(i+1)),]$Valor) > Seuil_max & max(listt2_mois[(24*i):(24*(i+1))]) > Seuil_max) ==TRUE) Bonprevireussi_max_dom2=Bonprevireussi_max_dom2+1      #classement de la situation en comparant le modele et l'obs chaque jour
  if ((max(Obs_mois_coupe[(24*i):(24*(i+1)),]$Valor) > Seuil_max & max(listt2_mois[(24*i):(24*(i+1))]) < Seuil_max) ==TRUE) Nondetection_max_dom2=Nondetection_max_dom2+1
  if ((max(Obs_mois_coupe[(24*i):(24*(i+1)),]$Valor) < Seuil_max & max(listt2_mois[(24*i):(24*(i+1))]) > Seuil_max) ==TRUE) faussealerte_max_dom2=faussealerte_max_dom2+1
  if ((max(Obs_mois_coupe[(24*i):(24*(i+1)),]$Valor) < Seuil_max & max(listt2_mois[(24*i):(24*(i+1))]) < Seuil_max) ==TRUE) Bonprevinonphenomene_max_dom2=Bonprevinonphenomene_max_dom2+1
}

###############################################################################################################