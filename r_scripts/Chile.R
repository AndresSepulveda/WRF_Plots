  # utilisation de dataresc sur les données chiliennes
  install.packages("devtools")
  install.packages("readr")
  install.packages("ggplot")
  install.packages("ggplot2")
  library (dataresqc) # pour l'installer c'est dans la console
  library (readr)
  library (ggplot2)
  setwd(dir="/home/dgeo3/Escritorio/Practica_Tibo/dataresq_Chile_BA/data/")
  
  #lecture des donnees
  files = list.files(pattern="*.tsv")
  data_list = lapply(files, read_tsv)
  donnees <- do.call(rbind, data_list)
  summary(donnees)
  
  #traitement avec dataresq
  plot_weekly_cycle(list.files("data", pattern="rr.tsv", full.names=T))
  climatic_outliers(file.choose(), bplot=T)                       # choisir le fichier
  plot_daily(file.choose(), len=10)
  plot_decimals(file.choose())
  qc(list.files("data", full.names=T))