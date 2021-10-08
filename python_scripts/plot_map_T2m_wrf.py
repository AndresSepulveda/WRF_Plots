import numpy as np
import pandas as pd
import wrf 
from matplotlib import pyplot as plt
from mpl_toolkits.basemap import Basemap
from matplotlib.cm import get_cmap
from netCDF4 import Dataset

nc_file = Dataset("wrfout_d01_2021-09-22_00:00:00")

# Extrae la temperatura a 2 metros del nivel del suelo
t2 = wrf.getvar(nc_file, "T2", timeidx=wrf.ALL_TIMES)
t2_degC = t2.copy()
t2_degC.values = t2.values - 273.15

# Nos quedamos con las latitudes y longitudes
lats, lons = wrf.latlon_coords(t2_degC)

# Creamos el basemap
bm = wrf.get_basemap(t2_degC)

# Creamos la figura
plt.figure(figsize=(12,12))

# Se agregan los vectores de datos geograficos
bm.drawcoastlines(linewidth=0.25)
bm.drawstates(linewidth=0.25)
bm.drawcountries(linewidth=1)

# Definimos la grilla x, y para graficar 
x, y = bm(wrf.to_np(lons), wrf.to_np(lats))

# Se grafica la variable
bm.contourf(x, y, t2_degC[8], 10, cmap=get_cmap("jet"))

# Se agrega la escala de colores
plt.colorbar()

plt.title("Temperatura a 2m a las 14hs del 22/02/2021")

#plt.show()
plt.savefig('Mapa_T2m_BioBio.png')
