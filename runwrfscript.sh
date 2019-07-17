#!/bin/csh -l


#Mapa de dominios
#matlab -nodisplay -nosplash -nodesktop -r "run('/home/chris/Documentos/Toolbox_WRF_matlab/scripts/dominios.m');exit;" | tail -n +11

#Mapa de relieve
#matlab -nodisplay -nosplash -nodesktop -r "run('/home/chris/Documentos/Toolbox_WRF_matlab/scripts/relieve.m');exit;" | tail -n +11

#Rosa de vientos desde wrfout
#matlab -nodisplay -nosplash -nodesktop -r "run('/home/chris/Documentos/Toolbox_WRF_matlab/scripts/rosewindwrfout.m');exit;" | tail -n +11

#Serie de tiempo desde wrfout
#matlab -nodisplay -nosplash -nodesktop -r "run('/home/chris/Documentos/Toolbox_WRF_matlab/scripts/seriewrfout.m');exit;" | tail -n +11

#Plots tslist
matlab -nodisplay -nosplash -nodesktop -r "run('/home/chris/Documentos/Toolbox_WRF_matlab/scripts/plotstslist.m');exit;" | tail -n +11


exit 0




