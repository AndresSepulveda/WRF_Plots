import numpy as np
import pandas as pd
import wrf 
from matplotlib import pyplot as plt
from netCDF4 import Dataset

nc_file = Dataset("wrfout_d01_2021-09-22_00:00:00")

# Extrae la temperatura a 2 metros del nivel del suelo
t2 = wrf.getvar(nc_file, "T2", timeidx=wrf.ALL_TIMES)

lat = -37.0
lon = -72.0
(x, y) = wrf.ll_to_xy(nc_file, lat, lon)
# Latitud y longitud exactas del par (x, y)
wrf.xy_to_ll(nc_file, x, y)

t2_biobio = t2[:, y, x]
t2_biobio.to_pandas()

df = pd.DataFrame(t2_biobio.to_pandas(), columns=['T2'])
df['T2_degC'] = df['T2'] - 273.15

plt.figure(figsize=(10,10))
df['T2_degC'].plot()
plt.title('Temperatura a 2m del suelo')

#plt.show()
plt.savefig('T2m_BioBio.png')
