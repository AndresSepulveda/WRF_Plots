%% Serie de tiempo desde wrfout

%directorio 
dir='/home/chris/Documentos/Toolbox_WRF_matlab';

addpath([dir]);
addpath([dir,'/funciones']);
addpath([dir,'/scripts']);
addpath([dir,'/funciones/m_map']);

% Nombre wrfout

d01='wrfout_d01_2019-01-01_00:00:00';
tname='Esto es una serie de algo';% titulo de la figura
plotname='rqrevev';% nombre output

dt=30;%intervalo de salida wrfout minutos

%posicion grilla a evaluar

xx=[-71]; % longitud
yy=[-36]; % latitud

myVar='U10';%variable a evaluar

%% No modificar

XLAT=ncread(d01,'XLAT');%latitud (sur negativo)
XLONG=ncread(d01,'XLONG');%longitud (oeste negativo)

XLAT=double(XLAT);
XLAT=squeeze(XLAT(:,:,1));

XLONG=double(XLONG);
XLONG=squeeze(XLONG(:,:,1));

lat=XLAT(1,:)';
lon=XLONG(:,1);

x=lon; % x vector arbitrario
y=lat; % x vector arbitrario

clear minimox positionx minimoy positiony mas_cercanox mas_cercanoy
for i=1:length(xx)
[minimox(i),positionx(i)]=min(abs(x-xx(i)));
[minimoy(i),positiony(i)]=min(abs(y-yy(i)));
mas_cercanox(i)=x(positionx(i));
mas_cercanoy(i)=y(positiony(i));
end

data=ncread(d01,myVar,[positionx positiony 1 ],[1 1 Inf]);
aux=ncinfo(d01,myVar);%,[positionx positiony 1 ],[1 1 Inf]);
[~,~,description,units,~,~]=aux.Attributes.Value;

% for i=1:100
%     data=[data 200+rand*10];
% end
% data=data';

h=figure;
plot([0:length(data)-1]*(dt/60),data,'k','linewidth',2);
title(tname)
xlabel('Horas')
ylabel([description,' [',units,']'])
axis tight

saveas(h,[pwd,'/../figuras/',plotname],'png');
close all


