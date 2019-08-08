% Indicaciones:
% Suponer un  orden de las series de la siguiente forma:
% Mes dia dato_real pronostico_24hrs pronostico_48hrs
% ejemplo corresponde a una estacion con la configuracion que mencioné
% anteriormente para la fecha 3 julio al 27 de noviembre.

clear all 
clc

datos=load('ejemplo.txt');

% Correlaciones
[corr24,corr48]=correlacion(datos);

% Error Medio (BIAS)
[EM_24,EM_48]=error_medio(datos); % aqui se puede plotear el error medio haciendo 
% visibles las variales BIAS_24 y BIAS_48 en la funcion "error_medio"

% Mean Absolut Error
[MAE24,MAE48,SS_pers24,SS_pers48]=mae_pers(datos); % aqui se obtienes los errores 
% medios absolutos y el Skill Score del pronóstico mediante el mismo MAE
% comprandolo con la persistencia.

[HR_24,HR_48,FAR_24,FAR_48,tab24,tab48]=HR_FAR_um(datos); % aqui se obtiene el valor 
% del "Hit Rate" y el "False Alarm Rate" para los pronosticos a 24 y 48
% horas  y las tablas de contingecia del pronóstico es decir la catidad de hits,
% false alarm, miss y correct rejection para los distintos umbrales 
%(1,2,3,5,10,13,15,20,30 mm). Esta misma función arroja un plot
% que muestra la porcion de falses alarms versus la cantidad de hits y
% sirve como una forma de estimar el Skill del pronóstico.

%las tablas se encuentean de la siguente manera:
% tab24=[tabla24_umbra1 tabla24_umbral2 tabla24_umbral3....]
% tab48=[tabla48_umbra1 tabla48_umbral2 tabla48_umbral3....]

% Likelihood ratio

LHR=HR_24./HR_48;
for i=1:9
eval(['LHR' num2str(i) '=LHR(' num2str(i) ');'])
end
% asi obtenemos la porcion de hits sobre la porcion de false alarms para
% cada umbral.

%Luguo para trabaja con varias estaciones, lo que hice fué hacer vectores
%de cada estadístico, pro ejemplo un vector de MAE24 que contiene el valor
%del MAE a 24 horas para cada estación las plotie en un mapa.



