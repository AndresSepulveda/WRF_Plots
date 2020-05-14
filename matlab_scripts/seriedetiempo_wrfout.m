% @Author: Christian Segura
% @Mail : chsegura@udec.cl

% @Last Modified by:   Christian Segura
% @Last Modified time: 2019-09-05 
%
% Adaptado por: Andres Sepulveda
% 2020-05-14
%
function seriedetiempo_wrfout(filename,xx,yy)

nc=netcdf(filename,'r');

XLAT =nc{'XLAT'}(:,:,:); %latitud (sur negativo)
XLONG=nc{'XLONG'}(:,:,:); %longitud (oeste negativo)

XLAT=double(XLAT);
XLAT=squeeze(XLAT(:,:,1));

XLONG=double(XLONG);
XLONG=squeeze(XLONG(:,1,:));

lat=XLAT(1,:)';
lon=XLONG(1,:);

x=lon; % x vector arbitrario
y=lat; % x vector arbitrario

difx=abs(x-xx);
dify=abs(y-yy);

minx=min(abs(x-xx));
miny=min(abs(y-yy));

indxx=find(difx == minx);
indxy=find(dify == miny);

lon(indxx)
lat(indxy)

myVar='T2';% temperatura a 2 metros
data=nc{myVar}(:,indxy,indxx);
T2=double(data)-273.15;% grados Celcius
T2=squeeze(T2);

%%plot(T2,'-or','linewidth',2,'MarkerFaceColor','r')
%%grid on
%%ylabel('T 2m [°C]')
%%xlabel('Horas desde inicio simulación')

min(T2)
max(T2)
%%keyboard

save -ascii T2.txt T2

return

