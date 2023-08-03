function extract_u10v10T2_wrfout(dirdata,filename,xx,yy)

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

tiempo=ncread(d01,'Times');
  year=squeeze(floor(str2num(tiempo(1:4,:)')));
 month=squeeze(floor(str2num(tiempo(6:7,:)')));
   day=squeeze(floor(str2num(tiempo(9:10,:)')));
  hour=squeeze(floor(str2num(tiempo(12:13,:)')));

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

myVar='U10';
data=squeeze(ncread(d01,myVar,[positionx positiony 1 ],[1 1 Inf]));
u=data;

myVar='V10';
data=squeeze(ncread(d01,myVar,[positionx positiony 1 ],[1 1 Inf]));
v=data;

myVar='T2';
data=squeeze(ncread(d01,myVar,[positionx positiony 1 ],[1 1 Inf]));
t2=data;

[ws,wd] = uv_to_wswd(u,v); %velocidad viento(ws) y direccion (wd)

outfile=[double(t2) double(u) double(v) ws wd];

whos year month day hour t2 u v ws wd outfile
outfile=[year month day hour double(t2) double(u) double(v) ws wd];

%filename=['extract_',num2str(xx),num2str(yy),'_t2u10v10wswd.txt'];
save 'extract_t2u10v10wswd.txt' outfile -ascii 

return
