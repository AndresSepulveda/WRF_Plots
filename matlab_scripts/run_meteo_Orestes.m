%% Ejemplo uso de meteogram_wrfout.m

% set(0, 'defaultfigurecolor', [1 1 1])

addpath('util/')

nfile = '/data2/wrf/Orestes/d01.nc';% nombre archivo wrfout
name = 'Orestes-D01';% nombre del lugar a evaluar

rlon = -73.4352;% longitud del lugar
rlat = -45.0235;% latitud del lugar

inicio = ncreadatt(nfile, '/', 'START_DATE');% inicio de la simulacion
inicio = datenum(inicio, 'yyyy-mm-dd_HH:MM:SS');

myVar = 'XTIME';% minutos desde iniciada la simulación
data = ncread(nfile, myVar);

valid_time = datenum(inicio + minutes(data));% fechas para cada paso de tiempo

% evaluamos desde t1 a t2 (formato datenum)
t1 = inicio;% usamos el inicio de la simulacion 
t2 = valid_time(end);% cortamos al 5to dia (paso de tiempo horario)

[H] = meteogram_wrfout_v2(nfile, name, inicio, rlon, rlat, t1, t2, name);

nfile = '/data2/wrf/Orestes/d02.nc';% nombre archivo wrfout
name = 'Orestes-D02';% nombre del lugar a evaluar
[H] = meteogram_wrfout_v2(nfile, name, inicio, rlon, rlat, t1, t2, name);

nfile = '/data2/wrf/Orestes/d03.nc';% nombre archivo wrfout
name = 'Orestes-D03';% nombre del lugar a evaluar
[H] = meteogram_wrfout_v2(nfile, name, inicio, rlon, rlat, t1, t2, name);

nfile = '/data2/wrf/Orestes/d04.nc';% nombre archivo wrfout
name = 'Orestes-D04';% nombre del lugar a evaluar
[H] = meteogram_wrfout_v2(nfile, name, inicio, rlon, rlat, t1, t2, name);
