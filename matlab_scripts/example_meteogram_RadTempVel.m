%% Ejemplo uso de meteogram_wrfout.m

% set(0, 'defaultfigurecolor', [1 1 1])

addpath('util/')

nfile = '../wrfout_d04_2020-12-05_00:00:00';% nombre archivo wrfout
name = 'Algún lugar';% nombre del lugar a evaluar

rlon = -69.5149;% longitud del lugar
rlat = -44.6579;% latitud del lugar

inicio = ncreadatt(nfile, '/', 'START_DATE');% inicio de la simulacion
inicio = datenum(inicio, 'yyyy-mm-dd_HH:MM:SS');

myVar = 'XTIME';% minutos desde iniciada la simulación
data = ncread(nfile, myVar);

valid_time = datenum(inicio + minutes(data));% fechas para cada paso de tiempo

% evaluamos desde t1 a t2 (formato datenum)
t1 = inicio;% usamos el inicio de la simulacion 
t2 = valid_time(end);% cortamos al 5to dia (paso de tiempo horario)

[H] = meteogram_wrfout(nfile, name, inicio, rlon, rlat, t1, t2);
