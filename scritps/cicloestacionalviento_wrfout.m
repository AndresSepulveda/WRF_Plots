function cicloestacionalviento_wrfout(dirdata,filename,xx,yy)

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

myVar = ws;
myVar2 = u;
myVar3 = v;


matriz=NaN(12,24);
matriz2=NaN(12,24);
matriz3=NaN(12,24);


for i=1:12
    for j=1:24
        idx=(meses==i & horas==j-1);
if length(myVar(idx))>0
        matriz(i,j)=nanmean(myVar(idx));
        matriz2(i,j)=nanmean(myVar2(idx));
        matriz3(i,j)=nanmean(myVar3(idx));
end
    end
end

[X Y]=meshgrid(1:24,1:12);

h=figure;
cmap=colormap_cpt('temp-c');
pcolor(X,Y,matriz);
%contourf(X,Y,matriz);
%contourf(matriz)
hold on
shading interp;
quiver(X,Y,matriz2,matriz3,'color','k')
title(tnameSC)
xlabel('Horas')
ylabel('Meses')
barra=colorbar('eastoutside','FontWeight','bold','Linewidth',1);
ylabel(barra,' Intensidad del viento [m/s] ');
colormap(cmap);
% axis equal
 set(gca,'ytick',1:12,...
 'yticklabel',{'E','F','M','A','M','J','J','A','S','O','N','D'})
saveas(h,[pwd,'/../figuras/',plotnameSC],'png');
close all

return
