# Réaliser le tableau des scores sur Arica sur un mois
install.packages("dplyr")
library("dplyr")
setwd(dir="Escritorio/Practica_Tibo/Mez_Chile/Score")
modele=read.table("T2_Arica_Mez.txt",header = TRUE,sep="\t")
modele$T2..K.=modele$T2..K.-273
# Les donnees du vismet sont separées tous les 3 jours
Obs1=read.csv("1.csv")  
Obs2_3=read.csv("2_3.csv")  
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

Obs_mois=bind_rows(Obs1,Obs2_3,Obs4_6,Obs7_9,Obs10_12,Obs13_15,Obs16_18,Obs19_21,Obs22_24,Obs25_27,Obs28_30,Obs31)  #reunion des donnees sur un ficgier de 31 jours

#extraction des données finies


  # Seuil Tmax
  faussealerte_max=0        #définition des quatres phénomenes
  Bonprevireussi_max=0
  Nondetection_max=0
  Bonprevinonphenomene_max=0
  Seuil_max=22   #Seuil de Tmax a modifier
  for (i in c(0:29)) {
    if ((max(Obs_mois[(24*i):(24*(i+1)),]$Valor) > Seuil_max & max(modele[(24*i):(24*(i+1)),]$T2..K.) > Seuil_max) ==TRUE) Bonprevireussi_max=Bonprevireussi_max+1      #classement de la situation en comparant le modele et l'obs chaque jour
    if ((max(Obs_mois[(24*i):(24*(i+1)),]$Valor) > Seuil_max & max(modele[(24*i):(24*(i+1)),]$T2..K.) < Seuil_max) ==TRUE) Nondetection_max=Nondetection_max+1
    if ((max(Obs_mois[(24*i):(24*(i+1)),]$Valor) < Seuil_max & max(modele[(24*i):(24*(i+1)),]$T2..K.) > Seuil_max) ==TRUE) faussealerte_max=faussealerte_max+1
    if ((max(Obs_mois[(24*i):(24*(i+1)),]$Valor) < Seuil_max & max(modele[(24*i):(24*(i+1)),]$T2..K.) < Seuil_max) ==TRUE) Bonprevinonphenomene_max=Bonprevinonphenomene_max+1
  }
  
  
  
  #Seuil Tmim
  faussealerte_min=0          #meme code pour tmin en differentiant la classif
  Bonprevireussi_min=0
  Nondetection_min=0
  Bonprevinonphenomene_min=0
  Seuil_min=19  #Seuil de Tmin a modifier
  for (i in c(0:29)) {
    if ((min(Obs_mois[(24*i):(24*(i+1)),]$Valor) > Seuil_min & min(modele[(24*i):(24*(i+1)),]$T2..K.) > Seuil_min) ==TRUE) Bonprevinonphenomene_min=Bonprevinonphenomene_min+1
    if ((min(Obs_mois[(24*i):(24*(i+1)),]$Valor) > Seuil_min & min(modele[(24*i):(24*(i+1)),]$T2..K.) < Seuil_min) ==TRUE) faussealerte_min=faussealerte_min+1
    if ((min(Obs_mois[(24*i):(24*(i+1)),]$Valor) < Seuil_min & min(modele[(24*i):(24*(i+1)),]$T2..K.) > Seuil_min) ==TRUE) Nondetection_min=Nondetection_min+1
    if ((min(Obs_mois[(24*i):(24*(i+1)),]$Valor) < Seuil_min & min(modele[(24*i):(24*(i+1)),]$T2..K.) < Seuil_min) ==TRUE) Bonprevireussi_min=Bonprevireussi_min+1
  }
  
  
  Fausse_alerte_pt_max=round((faussealerte_max/30)*100,digits = 1)            #calcul des huit pourcentages avec un chiffre apres la virgule
  Fausse_alerte_pt_min=round((faussealerte_min/30)*100,digits = 1)
  Bon_previ_reussi_pt_max=round((Bonprevireussi_max/30)*100,digits = 1)
  Bon_previ_reussi_pt_min=round((Bonprevireussi_min/30)*100,digits = 1)
  Non_detection_pt_max=round((Nondetection_max/30)*100,digits = 1)
  Non_detection_pt_min=round((Nondetection_min/30)*100,digits = 1)
  Bon_previ_non_phenomene_pt_max=round((Bonprevinonphenomene_max/30)*100,digits = 1)
  Bon_previ_non_phenomene_pt_min=round((Bonprevinonphenomene_min/30)*100,digits = 1)
  
  Score = data.frame(Fausse_alerte=c(Fausse_alerte_pt_max,Fausse_alerte_pt_min),Bonne_prévi_réussie=c(Bon_previ_reussi_pt_max,Bon_previ_reussi_pt_min), Bonne_prévi_non_phenomene=c(Bon_previ_non_phenomene_pt_max,Bon_previ_non_phenomene_pt_min),Non_detection=c(Non_detection_pt_max,Non_detection_pt_min),row.names = c("Tmax","Tmin"))
  print(Score)    #Affichage des résultats sous forme de tableau
  
  
  
  # Calcul des scores sur les maxima
  a=Bonprevireussi_max
  b=faussealerte_max
  c=Nondetection_max
  d=Bonprevinonphenomene_max
  Taux_resussiye=(a+d)/30
  Biais=(a+b)/(a+c)
  a=