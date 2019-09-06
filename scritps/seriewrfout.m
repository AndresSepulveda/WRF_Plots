% @Author: Christian Segura
% @Mail : chsegura@udec.cl

% @Last Modified by:   Christian Segura
% @Last Modified time: 2019-09-05 

function seriewrfout(dirdata,filename,var,xx,yy)

%
% Serie de tiempo desde wrfout
%
 
dir='/home/matlab/WRF/Toolbox_WRF_matlab';

addpath([dir]);
addpath([dir,'/funciones']);
addpath([dir,'/scripts']);
addpath(['/home/matlab/croco_tools/UTILITIES/m_map1.4h']);

%
% Nombre wrfout
%

d01=[dirdata,filename,'.nc'];

tname=[var,'_',filename];            %'T2 - 2018';% titulo de la figura
plotname=['seriewrfout_',filename];  %'T2_2018';% nombre output

dt=60;%intervalo de salida wrfout minutos

%posicion grilla a evaluar

%xx=[-71]; % longitud
%yy=[-36]; % latitud

myVar=var;%variable a evaluar

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

mas_cercanox 
mas_cercanoy 
positionx 
positiony
display('Diferencia en la posicion:')
diff=gpsdistance(yy,xx,mas_cercanoy,mas_cercanox)

data=squeeze(ncread(d01,myVar,[positionx positiony 1 ],[1 1 Inf]));
aux=ncinfo(d01,myVar);%,[positionx positiony 1 ],[1 1 Inf]);
[~,~,description,units,~,~]=aux.Attributes.Value;


h=figure;
plot([0:length(data)-1]*(dt/60),data,'k','linewidth',2);
title([tname, ' Lat: ',num2str(yy), ' Lon: ',num2str(xx)])
xlabel('Horas')
ylabel([description,' [',units,']'])
axis tight

saveas(h,[plotname],'png');
close all

return



