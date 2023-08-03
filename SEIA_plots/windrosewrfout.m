% @Author: Christian Segura
% @Mail : chsegura@udec.cl

% @Last Modified by:   Christian Segura
% @Last Modified time: 2019-09-05 

function rosewindwrfout(dirdata,filename,xx,yy)

%% Rosa de vientos wrfout

%directorio 
dir='/home/matlab/WRF/Toolbox_WRF_matlab';

addpath([dir]);
addpath([dir,'/funciones']);
addpath([dir,'/scripts']);
addpath(['/home/matlab/croco_tools/UTILITIES/m_map1.4h']);

% Nombre wrfout

d01=[dirdata,filename,'.nc'];
plotname=['rosewindwrfout_',filename];% nombre output

dt=60;%intervalo de salida wrfout minutos

%posicion grilla a evaluar

%%xx=[-71]; % longitud
%%yy=[-36]; % latitud


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

display('Diferencia en la posicion:')
diff=gpsdistance(yy,xx,mas_cercanoy,mas_cercanox)

myVar='U10';
data=ncread(d01,myVar,[positionx positiony 1 ],[1 1 Inf]);
% for i=1:100
%     data=[data 200+rand*10];
% end
u=data;

myVar='V10';

data=ncread(d01,myVar,[positionx positiony 1 ],[1 1 Inf]);
% for i=1:100
%     data=[data 200+rand*10];
% end
v=data;

[ws,wd] = uv_to_wswd(u,v); %velocidad viento(ws) y direccion (wd)

direction = wd;% Directions are in the first column
speed = ws;% Speeds are in the second column
% Define options for the wind rose 
Options = {'anglenorth',0,... 'The angle in the north is 0 deg (this is the reference from our data, but can be any other)
           'angleeast',90,... 'The angle in the east is 90 deg
           'labels',{'N (0°)','S (180°)','E (90°)','W (270°)'},... 'If you change the reference angles, do not forget to change the labels.
           'freqlabelangle',45};
% Launch the windrose with necessary output arguments.
% [figure_handle,count,speeds,directions,Table] = WindRose(direction,speed,Options);
h=WindRose(direction,speed,Options);
saveas(h,[plotname],'png');
close all
return
