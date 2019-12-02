%% Explorador eólico

% Este script genera figuras análogas a las que produce el explorador
% eólico (http://walker.dgf.uchile.cl/Explorador/Eolico2/) para un punto de
% grilla en una simulación anual de wrf con una resolución temporal de una
% hora. El directorio 'explorador eólico' cuenta con 3 carpetas: 1) data
% 2) funciones y 3) output. En 1) se encuentran las simulaciones (pueden
% ser linkeadas), en 2) algunas funciones y archivos utilizados en el
% script y en 3) la carpeta de salida con las figuras y tablas generadas.

% Contacto : chsegura@udec.cl
% Ultima modificación : 29/11/2019

% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% nfolder : nombre de la carpeta para las figuras y tablas
% fname   : nombre del archivo wrfout
% a       : hora de inicio simulación (año,mes,dia,hora,minutos,segundos)
% yy      : latitud de interés
% xx      : longitud de interés
% alti    : altura de interés
% alt     : alturas para perfiles verticales
% 
% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% table1  : características del sitio
% table2  : estadística básica
% fig_01  : ubicación del sitio seleccionado
% fig_02  : ciclo anual
% fig_03  : ciclo diario
% fig_04  : ciclo mensual
% fig_05  : ciclo diario del año completo
% fig_06  : ciclo diario según estación del año
% fig_07  : series de tiempo
% fig_08  : distribución de frecuencia para el año completo
% fig_09  : distribución de frecuencia según estación del año
% fig_10  : rosa de viento para el año completo
% fig_11  : rosa de viento según la estación del año
% fig_12  : perfil vertical medio
% fig_13  : ciclo diario del perfil vertical considerando el año completo
% fig_14  : ciclo diario del perfil vertical según la estación del año

%% input

nfolder='1934_wrfout2';% name folder output
fname='wrfout_d02_1934-01-19_00:00:00';% file name
a=datenum(2016,12,15,0,0,0);% hora de inicio simulación
yy=-36;% latitud de interés
xx=-73;% longitud de interés
alti=95;% altura de interés
alt=[5 16 26 37 47 57 68 78 95 125 168 224];% alturas para perfiles

%% path, archivos y directorios (reemplazar m_map)

% m_map
dir='/path_to_m_map';
addpath([dir,'/m_map']);% m_map

% ETOPO
ETOPO=false;% si no se tiene el archivo ETOPO cambiar a 'false' y se usa la topografía en wrfout 
COASTLINE=false; % si no se tiene el archivo línea de costa en m_map cambiar a 'false' 

dir=pwd;% directorio  eolic_exp
dirdata=[pwd,'/data/'];% directorio data
dirfunc=[pwd,'/funciones/'];% directorio funciones
addpath(dirfunc);

outfold=[dir,'/output/',nfolder];
mkdir(outfold)

file=[dirdata fname];

info=ncinfo(file);
% inicio=info.Variables(51).Attributes(4).Value;
% a=datenum(datetime(str2num(inicio(15:18)),str2num(inicio(20:21))...
%    ,str2num(inicio(23:24)),str2num(inicio(26:27)),str2num(inicio(29:30)),str2num(inicio(32:33))));

myVar='XTIME';% minutos desde iniciada la simulación
data=ncread(file,myVar);

ts_hour=double(data./60);
ts_hour=floor(ts_hour);

clear hrs out
for t=1:length(ts_hour)
hrs=ts_hour(t);% horas a partir de la fecha de referencia
out{t}=datevec(a+(hrs/24));% vector [año mes día hora]
end

for i=1:length(out)
    D(i,1)=out{i}(1);
    D(i,2)=out{i}(2);
    D(i,3)=out{i}(3);
    D(i,4)=out{i}(4);
    D(i,5)=out{i}(5);
    D(i,6)=out{i}(6);
end

% util 
aux=0:23;
for t=1:length(0:23)
horas(t)=datenum([num2str(aux(t)),'00'],'HHMM');% 24 horas 00:00 to 23:00
end
clear aux

cmap=colormap_cpt('sst.cpt');% color map
meses=[{'JAN'},{'FEB'},{'MAR'},{'APR'},{'MAY'},{'JUN'},{'JUL'},{'AGO'},{'SEP'},{'OCT'},{'NOV'},{'DEC'},{'ALL'}]';

%% Características del sitio

XLAT=ncread(file,'XLAT');% latitud (sur negativo)
XLONG=ncread(file,'XLONG');% longitud (oeste negativo)

XLAT=double(XLAT);
XLAT=squeeze(XLAT(:,:,1));

XLONG=double(XLONG);
XLONG=squeeze(XLONG(:,:,1));

lat=XLAT(1,:)';
lon=XLONG(:,1);

x=lon;
y=lat;

clear minimox positionx minimoy positiony mas_cercanox mas_cercanoy
for i=1:length(xx)
[minimox(i),positionx(i)]=min(abs(x-xx(i)));
[minimoy(i),positiony(i)]=min(abs(y-yy(i)));
mas_cercanox(i)=x(positionx(i));
mas_cercanoy(i)=y(positiony(i));
end
clear XLONG XLAT x y minimox minimoy 

myVar='HGT';
data=ncread(file,myVar,[positionx positiony 1],[1 1 1]);
HGT=double(data);% elevación

zq=HGT+alti;% valor a interpolar

myVar='PH';% 
data=ncread(file,myVar,[positionx positiony 1 1 ],[1 1 Inf Inf]);
PH=double(data);
PH=squeeze(PH);

myVar='PHB';% 
data=ncread(file,myVar,[positionx positiony 1 1 ],[1 1 Inf Inf]);
PHB=double(data);
PHB=squeeze(PHB);

Z=(PH+PHB)./9.81;% altura 
Z=Z(1:end-1,:);
clear PH PHB

myVar='P';% 
data=ncread(file,myVar,[positionx positiony 1 1 ],[1 1 Inf Inf]);
P=double(data);
P=squeeze(P);

myVar='PB';% 
data=ncread(file,myVar,[positionx positiony 1 1 ],[1 1 Inf Inf]);
PB=double(data);
PB=squeeze(PB);

PT=(P+PB);
clear P PB

for t=1:size(Z,2)
PTq(t) = interp1(Z(:,t),PT(:,t),zq);
end
clear PT

myVar='T';% perturbación temperatura potencial
data=ncread(file,myVar,[positionx positiony 1 1 ],[1 1 Inf Inf]);
T=double(data)+300;% (theta+t0)
T=squeeze(T);

for t=1:size(Z,2)
Tq(t) = interp1(Z(:,t),T(:,t),zq);
end
clear T

TEMP=Tq.*((PTq./100000).^(2/7));% temperatura kelvin

R=287;
Rair=PTq./TEMP./R;% densidad del aire

latitud=yy;% dregrees
longitud=xx;% degrees 
elevacion=HGT;% msnm
altura=alt;% m
densidad=mean(Rair,2);% kg/m^3 densidad media del aire

T=table(latitud,longitud,elevacion,altura,densidad);
writetable(T,[outfold,'/table1.txt'],'Delimiter',' ');  

%
if ETOPO
[z, refvec] = etopo('etopo1_ice_c_i2.bin', 1, [min(lat) max(lat)], [min(lon) max(lon)]);
latlim=linspace(min(lat),max(lat),size(z,1));
lonlim=linspace(min(lon),max(lon),size(z,2));
else
    z=ncread(file,'HGT');
    z=double(z(:,:,1))';
    latlim=lat;
    lonlim=lon;
end

cmap2=colormap_cpt('arctic');

h=figure;
m_proj('mercator','long',[longitud-1 longitud+1],'lat',[latitud-1 latitud+1]);

m_pcolor(lonlim,latlim,z);
hold on
if COASTLINE
m_gshhs_i('color','k');
else
m_coast('color','k');
end
m_plot(longitud,latitud,'vk','MarkerSize',10,'MarkerFaceColor','r')
m_grid('linest','none','box','fancy','tickdir','out');
barra=colorbar('eastoutside','FontWeight','bold','Linewidth',1);
ylabel(barra,'Height [m] ');
colormap(cmap2)
caxis([-6000 4700]);

saveas(h,[outfold,'/fig_01','.png'])
close(h)

%% Estadística Básica (a XXX metros de altura)

% meses | medio | mínimo | máximo | variabilidad (std de los valores medios)

myVar='U';% 
data=ncread(file,myVar,[positionx positiony 1 1 ],[1 1 Inf Inf]);
U=double(data);
U=squeeze(U);

myVar='V';% 
data=ncread(file,myVar,[positionx positiony 1 1 ],[1 1 Inf Inf]);
V=double(data);
V=squeeze(V);

WND=(U.^2+V.^2).^(1/2);
% clear U V

medio=NaN(13,31);
minimo=NaN(13,31);
maximo=NaN(13,31);
variabilidad=NaN(13,31);

dias=unique(D(:,3));
for t=1:size(Z,2)
WNDq(t) = interp1(Z(:,t),WND(:,t),zq);
Uq(t) = interp1(Z(:,t),U(:,t),zq);
Vq(t) = interp1(Z(:,t),V(:,t),zq);
end
maxwnd=floor(max(WNDq)/5)*5+5;
% clear WND

for i=1:12
    for j=dias'   
    idx=(D(:,2)==i & D(:,3)==j);
        if length(WNDq(idx))>0
        medio(i,j)=nanmean(WNDq(idx));
        minimo(i,j)=min(WNDq(idx));
        maximo(i,j)=max(WNDq(idx));
        variabilidad(i,j)=nanstd(WNDq(idx));
        end
    end
end

for j=dias'   
    idx=(D(:,3)==j);
    if length(WNDq(idx))>0
        medio(13,j)=nanmean(WNDq(idx));
        minimo(13,j)=min(WNDq(idx));
        maximo(13,j)=max(WNDq(idx));
        variabilidad(13,j)=nanstd(WNDq(idx));
    end
end

medio_std=nanstd(medio,[],2);
medio=nanmean(medio,2);
minimo_std=nanstd(minimo,[],2);
minimo=nanmean(minimo,2);
maximo_std=nanstd(maximo,[],2);
maximo=nanmean(maximo,2);
variabilidad_std=nanstd(variabilidad,[],2);
variabilidad=nanmean(variabilidad,2);

T=table(meses,medio,medio_std,minimo,minimo_std,maximo,maximo_std,variabilidad,variabilidad_std);
writetable(T,[outfold,'/table2.txt'],'Delimiter',' ');  

%% Ciclos Medios

% ciclo anual
aux=NaN(12,1);
for i=1:12
    idx=(D(:,2)==i);
        if length(WNDq(idx))>0
aux(i)=nanmean(WNDq(idx));
        end
end
h=figure('Position', [100, 100, 960, 310]);
plot(1:12,aux,'linewidth',1.5,'Color',[0 0.3 0.9])
hold on
grid on
xlim([1 12])
set(gca,'xtick',1:12,...
 'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
ylabel('Velocity [m/s]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
ylim([0 maxwnd])

saveas(h,[outfold,'/fig_02','.png'])
close(h)

% ciclo diario
aux=NaN(24,1);
for i=1:24
    idx=(D(:,4)==i-1);
        if length(WNDq(idx))>0
aux(i)=nanmean(WNDq(idx));
        end
end
h=figure('Position', [100, 100, 960, 310]);
plot(horas,aux,'linewidth',1.5,'Color',[0 0.3 0.9])
hold on
grid on
xlim([horas(1) horas(end)])
set(gca,'XTick',horas(1:3:end))
datetick('x','HH:MM','keeplimits','keepticks')
ylabel('Velocity [m/s]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
ylim([0 maxwnd])

saveas(h,[outfold,'/fig_03','.png'])
close(h)

%% Ciclo Mensual 

aux=NaN(12,24);
for i=1:12
    for j=1:24   
    idx=(D(:,2)==i & D(:,4)==j-1);
        if length(WNDq(idx))>0
        aux(i,j)=nanmean(WNDq(idx));
        end
    end
end

h=figure('Position', [100, 100, 600, 860]);
imagesc(1:12,1:24,aux')
hold on
set(gca,'xtick',1:12,...
 'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
set(gca,'Ydir','normal')
set(gca,'YTick',1:24,'YTickLabel',datestr(horas,'HH:MM'))
set(gca,'TickDir','out');
barra=colorbar('Eastoutside','FontWeight','bold','Linewidth',1);
ylabel(barra,'Velocity [m/s] ','FontWeight','bold','FontSize',12);
colormap(cmap)
caxis([0 maxwnd]);

for i = 1 : size(aux,2)
  for j = 1 : size(aux,1)
    text(j - 0.3 , i - 0 ,sprintf('%g',round(aux(j,i)',1)),'FontSize',8,'FontWeight','bold');
  end
end

saveas(h,[outfold,'/fig_04','.png'])
close(h)

%% Ciclo diario del año completo

aux=NaN(366,24);
for i=1:24
    idx=(D(:,4)==i-1);
        if length(WNDq(idx))>0
            aux2=WNDq(idx)';
aux(1:length(aux2),i)=aux2;
clear aux2
        end
end

h=figure('Position', [100, 100, 960, 310]);
boxplot(aux,horas)
hold on
plot(horas,nanmean(aux,1),'ok','MarkerFaceColor','k','MarkerSize',4)
ylabel('Velocity [m/s]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
set(gca,'XTick',1:3:24,'xticklabel',datestr(horas(1:3:end),'HH:MM'))
ylim([0 maxwnd])
grid on
title('Yearly','FontWeight','b','FontSize',12)

saveas(h,[outfold,'/fig_05','.png'])
close(h)

%% Ciclo diario según estación del año

h=figure('Position', [100, 100, 770, 900]);
aux=NaN(366,24);
for i=1:24
    idx=(D(:,4)==i-1 & (D(:,2)==12 | D(:,2)==1 | D(:,2)==2 ));
        if length(WNDq(idx))>0
            aux2=WNDq(idx)';
aux(1:length(aux2),i)=aux2;
clear aux2
        end
end
subplot(4,1,1)
boxplot(aux,horas)
hold on
plot(horas,nanmean(aux,1),'ok','MarkerFaceColor','k','MarkerSize',4)
ylabel('Velocity [m/s]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
set(gca,'XTick',1:3:24,'xticklabel',datestr(horas(1:3:end),'HH:MM'))
ylim([0 maxwnd])
grid on
title('Summer (DJF)','FontWeight','b','FontSize',12)

aux=NaN(366,24);
for i=1:24
    idx=(D(:,4)==i-1 & (D(:,2)==3 | D(:,2)==4 | D(:,2)==5 ));
        if length(WNDq(idx))>0
            aux2=WNDq(idx)';
aux(1:length(aux2),i)=aux2;
clear aux2
        end
end
subplot(4,1,2)
boxplot(aux,horas)
hold on
plot(horas,nanmean(aux,1),'ok','MarkerFaceColor','k','MarkerSize',4)
ylabel('Velocity [m/s]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
set(gca,'XTick',1:3:24,'xticklabel',datestr(horas(1:3:end),'HH:MM'))
ylim([0 maxwnd])
grid on
title('Autumn (MAM)','FontWeight','b','FontSize',12)

aux=NaN(366,24);
for i=1:24
    idx=(D(:,4)==i-1 & (D(:,2)==6 | D(:,2)==7 | D(:,2)==8 ));
        if length(WNDq(idx))>0
            aux2=WNDq(idx)';
aux(1:length(aux2),i)=aux2;
clear aux2
        end
end
subplot(4,1,3)
boxplot(aux,horas)
hold on
plot(horas,nanmean(aux,1),'ok','MarkerFaceColor','k','MarkerSize',4)
ylabel('Velocity [m/s]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
set(gca,'XTick',1:3:24,'xticklabel',datestr(horas(1:3:end),'HH:MM'))
ylim([0 maxwnd])
grid on
title('Winter (JJA)','FontWeight','b','FontSize',12)

aux=NaN(366,24);
for i=1:24
    idx=(D(:,4)==i-1 & (D(:,2)==9 | D(:,2)==10 | D(:,2)==11 ));
        if length(WNDq(idx))>0
            aux2=WNDq(idx)';
aux(1:length(aux2),i)=aux2;
clear aux2
        end
end
subplot(4,1,4)
boxplot(aux,horas)
hold on
plot(horas,nanmean(aux,1),'ok','MarkerFaceColor','k','MarkerSize',4)
ylabel('Velocity [m/s]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
set(gca,'XTick',1:3:24,'xticklabel',datestr(horas(1:3:end),'HH:MM'))
ylim([0 maxwnd])
grid on
title('Spring (SON)','FontWeight','b','FontSize',12)

saveas(h,[outfold,'/fig_06','.png'])
close(h)

%% Serie de tiempo

t=1;
auy=NaN(31*24,2);
for i=1:31
    for j=1:24
    auy(t,:)=[i j-1];
    t=t+1;
    end
end

h=figure('Position', [100, 100, 1700, 910]);
for mes=1:12
idx=((D(:,2)==mes));
aux2=WNDq(idx)';

fechas=datenum(D(idx,:));
subplot(4,3,mes)
if length(WNDq(idx)>0)
idx2=(auy(:,1)==day(datestr(fechas(1)))&auy(:,2)==hour(datestr(fechas(1))));
idx3=(auy(:,1)==day(datestr(fechas(end)))&auy(:,2)==hour(datestr(fechas(end))));
plot([find(idx2==1):find(idx3==1)],WNDq(idx),'linewidth',1.5,'Color',[0 0.3 0.9])
hold on
ylim([0 maxwnd])
xlim([1 size(auy,1)])
for t=24:24:size(fechas)
    idx2=(auy(:,1)==day(datestr(fechas(t-24+1)))&auy(:,2)==hour(datestr(fechas(t-24+1))));
    idx3=(auy(:,1)==day(datestr(fechas(t)))&auy(:,2)==hour(datestr(fechas(t))));
    plot([find(idx2==1) find(idx3==1)],[mean(aux2(t-24+1:t)) mean(aux2(t-24+1:t))],'linewidth',1.5,'Color','r')
end
end
set(gca,'Xtick',[1:48:size(auy,1)],'XTickLabel',[1-1+24:48:size(auy,1)-1+24]/24);
set(gca,'TickDir','out');
grid on
title(meses{mes},'FontWeight','b','FontSize',12)
end

for i=[1 4 7 10]
subplot(4,3,i)
ylabel('Velocity [m/s]','FontWeight','b','FontSize',12)
end

saveas(h,[outfold,'/fig_07','.png'])
close(h)

%% Distribución de frecuencia para el año completo

h=figure('Position', [100, 100, 960, 310]);
histogram(WNDq, 30, 'Normalization','probability','FaceColor',[0.5 0 1]);
hold on
ylim([0 0.15])
ytix = get(gca, 'YTick');
set(gca, 'YTick',[0:0.01:0.15],'YTickLabel',[0:0.01:0.15]*100)
ylabel('Frequency [%]','FontWeight','b','FontSize',12)
xlabel('Velocity [m/s]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
xlim([0 maxwnd])
set(gca, 'XTick',[0:maxwnd])
grid on
title('Yearly','FontWeight','b','FontSize',12)

saveas(h,[outfold,'/fig_08','.png'])
close(h)

%% Distribución de frecuencia según la estación del año

h=figure('Position', [100, 100, 770, 900]);
aux=NaN;
idx=(D(:,2)==12 | D(:,2)==1 | D(:,2)==2);
if length(WNDq(idx))>0
aux=WNDq(idx)';
end
subplot(4,1,1)
histogram(aux, 30, 'Normalization','probability','FaceColor',[0.5 0 1]);
hold on
ylim([0 0.15])
ytix = get(gca, 'YTick');
set(gca, 'YTick',[0:0.03:0.15],'YTickLabel',[0:0.03:0.15]*100)
ylabel('Frequency [%]','FontWeight','b','FontSize',12)
% xlabel('Velocity [m/s]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
xlim([0 maxwnd])
set(gca, 'XTick',[0:maxwnd])
grid on
title('Summer (DJF)','FontWeight','b','FontSize',12)

aux=NaN;
idx=(D(:,2)==3 | D(:,2)==4 | D(:,2)==5);
if length(WNDq(idx))>0
aux=WNDq(idx)';
end
subplot(4,1,2)
histogram(aux, 30, 'Normalization','probability','FaceColor',[0.5 0 1]);
hold on
ylim([0 0.15])
ytix = get(gca, 'YTick');
set(gca, 'YTick',[0:0.03:0.15],'YTickLabel',[0:0.03:0.15]*100)
ylabel('Frequency [%]','FontWeight','b','FontSize',12)
% xlabel('Velocity [m/s]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
xlim([0 maxwnd])
set(gca, 'XTick',[0:maxwnd])
grid on
title('Autumn (MAM)','FontWeight','b','FontSize',12)

aux=NaN;
idx=(D(:,2)==6 | D(:,2)==7 | D(:,2)==8);
if length(WNDq(idx))>0
aux=WNDq(idx)';
end
subplot(4,1,3)
histogram(aux, 30, 'Normalization','probability','FaceColor',[0.5 0 1]);
hold on
ylim([0 0.15])
ytix = get(gca, 'YTick');
set(gca, 'YTick',[0:0.03:0.15],'YTickLabel',[0:0.03:0.15]*100)
ylabel('Frequency [%]','FontWeight','b','FontSize',12)
% xlabel('Velocity [m/s]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
xlim([0 maxwnd])
set(gca, 'XTick',[0:maxwnd])
grid on
title('Winter (JJA)','FontWeight','b','FontSize',12)

aux=NaN;
idx=(D(:,2)==9 | D(:,2)==10 | D(:,2)==11);
if length(WNDq(idx))>0
aux=WNDq(idx)';
end
subplot(4,1,4)
histogram(aux, 30, 'Normalization','probability','FaceColor',[0.5 0 1]);
hold on
ylim([0 0.15])
ytix = get(gca, 'YTick');
set(gca, 'YTick',[0:0.03:0.15],'YTickLabel',[0:0.03:0.15]*100)
ylabel('Frequency [%]','FontWeight','b','FontSize',12)
xlabel('Velocity [m/s]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
xlim([0 maxwnd])
set(gca, 'XTick',[0:maxwnd])
grid on
title('Spring (SON)','FontWeight','b','FontSize',12)

saveas(h,[outfold,'/fig_09','.png'])
close(h)

%% Rosa del viento para el año completo

[wind_speed,wind_direction] = uv_to_wswd(Uq,Vq);% velocidad viento(ws) y dirección (wd)

ncolor=maxwnd;% numero de colores coincide con magnitud del viento 
auxcmap=[cmap(round(linspace(1,size(cmap,1),ncolor)),:)];

h=figure('Position', [100, 100, 600, 500]);
pax = polaraxes;
for n=ncolor:-1:1
polarhistogram(deg2rad(wind_direction(wind_speed<n)),deg2rad(0:10:360),'FaceColor',[auxcmap(n,:)])
hold on
end
pax.ThetaDir = 'clockwise';
pax.ThetaZeroLocation = 'top';
title([],'FontWeight','b','FontSize',12)
barra=colorbar('Eastoutside','FontWeight','bold','Linewidth',1);
ylabel(barra,'Velocity [m/s] ','FontWeight','bold','FontSize',12);
colormap([cmap(round(linspace(1,size(cmap,1),ncolor)),:)])
caxis([0 ncolor])

thetaticks(0:30:360)
thetaticklabels({'North',[],[],'East',[],[],'South',[],[],'West',[],[]})
rtickformat('percentage')

saveas(h,[outfold,'/fig_10','.png'])
close(h)

%% Rosa del viento según la estación de año

h=figure('Position', [100, 100, 1000, 950]);
aux=NaN;
aux2=NaN;
idx=(D(:,2)==12 | D(:,2)==1 | D(:,2)==2);
if length(WNDq(idx))>0
aux=Uq(idx)';
aux2=Vq(idx)';
end
[wind_speed,wind_direction] = uv_to_wswd(aux,aux2);% velocidad viento(ws) y direccion (wd)
ax(1)=subplot(2,2,1,polaraxes);
for n=ncolor:-1:1
polarhistogram(deg2rad(wind_direction(wind_speed<n)),deg2rad(0:10:360),'FaceColor',[auxcmap(n,:)])
hold on
end
ax(1).ThetaDir = 'clockwise';
ax(1).ThetaZeroLocation = 'top';
title([],'FontWeight','b','FontSize',12)
% barra=colorbar('Eastoutside','FontWeight','bold','Linewidth',1);
% ylabel(barra,'Velocity [m/s] ','FontWeight','bold','FontSize',12);
colormap([cmap(round(linspace(1,size(cmap,1),ncolor)),:)])
caxis([0 ncolor])
thetaticks(0:30:360)
thetaticklabels({'North',[],[],'East',[],[],'South',[],[],'West',[],[]})
rtickformat('percentage')
title('Summer (DJF)','FontWeight','b','FontSize',12)

aux=NaN;
aux2=NaN;
idx=(D(:,2)==3 | D(:,2)==4 | D(:,2)==5);
if length(WNDq(idx))>0
aux=Uq(idx)';
aux2=Vq(idx)';
end
[wind_speed,wind_direction] = uv_to_wswd(aux,aux2);% velocidad viento(ws) y direccion (wd)
ax(2)=subplot(2,2,2,polaraxes);
for n=ncolor:-1:1
polarhistogram(deg2rad(wind_direction(wind_speed<n)),deg2rad(0:10:360),'FaceColor',[auxcmap(n,:)])
hold on
end
ax(2).ThetaDir = 'clockwise';
ax(2).ThetaZeroLocation = 'top';
title([],'FontWeight','b','FontSize',12)
% barra=colorbar('Eastoutside','FontWeight','bold','Linewidth',1);
% ylabel(barra,'Velocity [m/s] ','FontWeight','bold','FontSize',12);
colormap([cmap(round(linspace(1,size(cmap,1),ncolor)),:)])
caxis([0 ncolor])
thetaticks(0:30:360)
thetaticklabels({'North',[],[],'East',[],[],'South',[],[],'West',[],[]})
rtickformat('percentage')
title('Autumn (MAM)','FontWeight','b','FontSize',12)

aux=NaN;
aux2=NaN;
idx=(D(:,2)==6 | D(:,2)==7 | D(:,2)==8);
if length(WNDq(idx))>0
aux=Uq(idx)';
aux2=Vq(idx)';
end
[wind_speed,wind_direction] = uv_to_wswd(aux,aux2);% velocidad viento(ws) y direccion (wd)
ax(3)=subplot(2,2,3,polaraxes);
for n=ncolor:-1:1
polarhistogram(deg2rad(wind_direction(wind_speed<n)),deg2rad(0:10:360),'FaceColor',[auxcmap(n,:)])
hold on
end
ax(3).ThetaDir = 'clockwise';
ax(3).ThetaZeroLocation = 'top';
title([],'FontWeight','b','FontSize',12)
% barra=colorbar('Eastoutside','FontWeight','bold','Linewidth',1);
% ylabel(barra,'Velocity [m/s] ','FontWeight','bold','FontSize',12);
colormap([cmap(round(linspace(1,size(cmap,1),ncolor)),:)])
caxis([0 ncolor])
thetaticks(0:30:360)
thetaticklabels({'North',[],[],'East',[],[],'South',[],[],'West',[],[]})
rtickformat('percentage')
title('Winter (JJA)','FontWeight','b','FontSize',12)

aux=NaN;
aux2=NaN;
idx=(D(:,2)==9 | D(:,2)==10 | D(:,2)==11);
if length(WNDq(idx))>0
aux=Uq(idx)';
aux2=Vq(idx)';
end
[wind_speed,wind_direction] = uv_to_wswd(aux,aux2);% velocidad viento(ws) y direccion (wd)
ax(4)=subplot(2,2,4,polaraxes);
for n=ncolor:-1:1
polarhistogram(deg2rad(wind_direction(wind_speed<n)),deg2rad(0:10:360),'FaceColor',[auxcmap(n,:)])
hold on
end
ax(4).ThetaDir = 'clockwise';
ax(4).ThetaZeroLocation = 'top';
title([],'FontWeight','b','FontSize',12)
% barra=colorbar('Eastoutside','FontWeight','bold','Linewidth',1);
% ylabel(barra,'Velocity [m/s] ','FontWeight','bold','FontSize',12);
colormap([cmap(round(linspace(1,size(cmap,1),ncolor)),:)])
caxis([0 ncolor])
thetaticks(0:30:360)
thetaticklabels({'North',[],[],'East',[],[],'South',[],[],'West',[],[]})
rtickformat('percentage')
title('Spring (SON)','FontWeight','b','FontSize',12)

pos3=ax(3).Position;
pos4=ax(4).Position;

barra=colorbar('Southoutside','FontWeight','bold','Linewidth',1);
ylabel(barra,'Velocity [m/s] ','FontWeight','bold','FontSize',12);

bpos=barra.Position;
barra.Position=[pos3(1) pos3(2)-0.07 pos4(1)+pos4(3)-pos3(1) bpos(4)];

saveas(h,[outfold,'/fig_11','.png'])
close(h)

%% Perfil vertical medio

zq=HGT+alt;% perfil a interpolar

clear WNDq2
for t=1:size(Z,2)
WNDq2(:,t) = interp1(Z(:,t),WND(:,t),zq);
end

h=figure('Position', [100, 100, 860, 910]);
subplot(2,2,1)
idx=((D(:,2)==12 | D(:,2)==1 | D(:,2)==2 ));
if length(WNDq2(1,idx))>0
aux2=WNDq2(:,idx);
else
    aux2=NaN(size(alt));
end
plot(nanmean(aux2,2),alt,'-o','linewidth',1.5,'Color',[0 0.7 0.4],'MarkerSize',5,'MarkerFaceColor',[0 0.7 0.4])
hold on
idx=((D(:,4)==21|D(:,4)==22|D(:,4)==23|D(:,4)==0|D(:,4)==1|D(:,4)==2|D(:,4)==3|D(:,4)==4|D(:,4)==5|D(:,4)==6|D(:,4)==7|D(:,4)==8) & (D(:,2)==12 | D(:,2)==1 | D(:,2)==2 ));
if length(WNDq2(1,idx))>0
aux2=WNDq2(:,idx);else
    aux2=NaN(size(alt));
end
plot(nanmean(aux2,2),alt,'-o','linewidth',1.5,'Color',[0.3 0.1 0.9],'MarkerSize',5,'MarkerFaceColor',[0.3 0.1 0.9])
idx=((D(:,4)==9|D(:,4)==10|D(:,4)==11|D(:,4)==12|D(:,4)==13|D(:,4)==14|D(:,4)==15|D(:,4)==16|D(:,4)==17|D(:,4)==18|D(:,4)==19|D(:,4)==20|D(:,4)==8) & (D(:,2)==12 | D(:,2)==1 | D(:,2)==2 ));
if length(WNDq2(1,idx))>0
aux2=WNDq2(:,idx);
else
    aux2=NaN(size(alt));
end
plot(nanmean(aux2,2),alt,'-o','linewidth',1.5,'Color',[1 0.6 0],'MarkerSize',5,'MarkerFaceColor',[1 0.6 0])
% xlabel('Velocity [m/s]','FontWeight','b','FontSize',12)
ylabel('Height [m]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
xlim([0 maxwnd])
set(gca,'YTick',alt)
grid on
title('Summer (DJF)','FontWeight','b','FontSize',12)
legend('24 Hours','Nighttime (20:00-08:00)','Daytime (08:00-20:00)')
%
subplot(2,2,2)
idx=((D(:,2)==3 | D(:,2)==4 | D(:,2)==5 ));
if length(WNDq2(1,idx))>0
aux2=WNDq2(:,idx);
else
    aux2=NaN(size(alt));
end
plot(nanmean(aux2,2),alt,'-o','linewidth',1.5,'Color',[0 0.7 0.4],'MarkerSize',5,'MarkerFaceColor',[0 0.7 0.4])
hold on
idx=((D(:,4)==21|D(:,4)==22|D(:,4)==23|D(:,4)==0|D(:,4)==1|D(:,4)==2|D(:,4)==3|D(:,4)==4|D(:,4)==5|D(:,4)==6|D(:,4)==7|D(:,4)==8) & (D(:,2)==3 | D(:,2)==4 | D(:,2)==5 ));
if length(WNDq2(1,idx))>0
aux2=WNDq2(:,idx);
else
    aux2=NaN(size(alt));
end
plot(nanmean(aux2,2),alt,'-o','linewidth',1.5,'Color',[0.3 0.1 0.9],'MarkerSize',5,'MarkerFaceColor',[0.3 0.1 0.9])
idx=((D(:,4)==9|D(:,4)==10|D(:,4)==11|D(:,4)==12|D(:,4)==13|D(:,4)==14|D(:,4)==15|D(:,4)==16|D(:,4)==17|D(:,4)==18|D(:,4)==19|D(:,4)==20|D(:,4)==8) & (D(:,2)==3 | D(:,2)==4 | D(:,2)==5 ));
if length(WNDq2(1,idx))>0
aux2=WNDq2(:,idx);
else
    aux2=NaN(size(alt));
end
plot(nanmean(aux2,2),alt,'-o','linewidth',1.5,'Color',[1 0.6 0],'MarkerSize',5,'MarkerFaceColor',[1 0.6 0])
% xlabel('Velocity [m/s]','FontWeight','b','FontSize',12)
% ylabel('Height [m]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
xlim([0 maxwnd])
set(gca,'YTick',alt)
grid on
title('Autumn (MAM)','FontWeight','b','FontSize',12)
%
subplot(2,2,3)
idx=((D(:,2)==6 | D(:,2)==7 | D(:,2)==8 ));
if length(WNDq2(1,idx))>0
aux2=WNDq2(:,idx);
else
    aux2=NaN(size(alt));
end
plot(nanmean(aux2,2),alt,'-o','linewidth',1.5,'Color',[0 0.7 0.4],'MarkerSize',5,'MarkerFaceColor',[0 0.7 0.4])
hold on
idx=((D(:,4)==21|D(:,4)==22|D(:,4)==23|D(:,4)==0|D(:,4)==1|D(:,4)==2|D(:,4)==3|D(:,4)==4|D(:,4)==5|D(:,4)==6|D(:,4)==7|D(:,4)==8) & (D(:,2)==6 | D(:,2)==7 | D(:,2)==8 ));
if length(WNDq2(1,idx))>0
aux2=WNDq2(:,idx);
else
    aux2=NaN(size(alt));
end
plot(nanmean(aux2,2),alt,'-o','linewidth',1.5,'Color',[0.3 0.1 0.9],'MarkerSize',5,'MarkerFaceColor',[0.3 0.1 0.9])
idx=((D(:,4)==9|D(:,4)==10|D(:,4)==11|D(:,4)==12|D(:,4)==13|D(:,4)==14|D(:,4)==15|D(:,4)==16|D(:,4)==17|D(:,4)==18|D(:,4)==19|D(:,4)==20|D(:,4)==8) & (D(:,2)==6 | D(:,2)==7 | D(:,2)==8 ));
if length(WNDq2(1,idx))>0
aux2=WNDq2(:,idx);
else
    aux2=NaN(size(alt));
end
plot(nanmean(aux2,2),alt,'-o','linewidth',1.5,'Color',[1 0.6 0],'MarkerSize',5,'MarkerFaceColor',[1 0.6 0])
xlabel('Velocity [m/s]','FontWeight','b','FontSize',12)
ylabel('Height [m]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
xlim([0 maxwnd])
set(gca,'YTick',alt)
grid on
title('Winter (JJA)','FontWeight','b','FontSize',12)
%
subplot(2,2,4)
idx=((D(:,2)==9 | D(:,2)==10 | D(:,2)==11 ));
if length(WNDq2(1,idx))>0
aux2=WNDq2(:,idx);
else
    aux2=NaN(size(alt));
end
plot(nanmean(aux2,2),alt,'-o','linewidth',1.5,'Color',[0 0.7 0.4],'MarkerSize',5,'MarkerFaceColor',[0 0.7 0.4])
hold on
idx=((D(:,4)==21|D(:,4)==22|D(:,4)==23|D(:,4)==0|D(:,4)==1|D(:,4)==2|D(:,4)==3|D(:,4)==4|D(:,4)==5|D(:,4)==6|D(:,4)==7|D(:,4)==8) & (D(:,2)==9 | D(:,2)==10 | D(:,2)==11 ));
if length(WNDq2(1,idx))>0
aux2=WNDq2(:,idx);
else
    aux2=NaN(size(alt));
end
plot(nanmean(aux2,2),alt,'-o','linewidth',1.5,'Color',[0.3 0.1 0.9],'MarkerSize',5,'MarkerFaceColor',[0.3 0.1 0.9])
idx=((D(:,4)==9|D(:,4)==10|D(:,4)==11|D(:,4)==12|D(:,4)==13|D(:,4)==14|D(:,4)==15|D(:,4)==16|D(:,4)==17|D(:,4)==18|D(:,4)==19|D(:,4)==20|D(:,4)==8) & (D(:,2)==9 | D(:,2)==10 | D(:,2)==11 ));
if length(WNDq2(1,idx))>0
aux2=WNDq2(:,idx);
else
    aux2=NaN(size(alt));
end
plot(nanmean(aux2,2),alt,'-o','linewidth',1.5,'Color',[1 0.6 0],'MarkerSize',5,'MarkerFaceColor',[1 0.6 0])
xlabel('Velocity [m/s]','FontWeight','b','FontSize',12)
% ylabel('Height [m]','FontWeight','b','FontSize',12)
set(gca,'TickDir','out');
xlim([0 maxwnd])
set(gca,'YTick',alt)
grid on
title('Spring (SON)','FontWeight','b','FontSize',12)

saveas(h,[outfold,'/fig_12','.png'])
close(h)

%% Ciclo diario del perfil vertical considerando el año completo

aux2=NaN(length(alt),24);
for t=1:24
idx=(D(:,4)==t-1);
if length(WNDq2(1,idx))>0
aux2(:,t)=nanmean(WNDq2(:,idx),2);
end
end
contornos=[1:maxwnd];

h=figure('Position', [100, 100, 960, 310]);
contourf(horas,alt,aux2,contornos)
set(gca,'XTick',horas(1:3:end))
datetick('x','HH:MM','keeplimits','keepticks')
set(gca,'TickDir','out');
set(gca,'YTick',alt)
barra=colorbar('Eastoutside','FontWeight','bold','Linewidth',1);
ylabel(barra,'Velocity [m/s] ','FontWeight','bold','FontSize',12);
colormap(cmap)
caxis([0 maxwnd]);
title('Yearly','FontWeight','bold','FontSize',12);

saveas(h,[outfold,'/fig_13','.png'])
close(h)

%% Ciclo diario del perfil vertical según la estación del año

h=figure('Position', [100, 100, 770, 900]);
subplot(4,1,1)
aux2=NaN(length(alt),24);
for t=1:24
idx=(D(:,4)==t-1 & (D(:,2)==12 | D(:,2)==1 | D(:,2)==2 ));
if length(WNDq2(1,idx))>0
aux2(:,t)=nanmean(WNDq2(:,idx),2);
end
end
contourf(horas,alt,aux2,contornos)
set(gca,'XTick',horas(1:3:end))
datetick('x','HH:MM','keeplimits','keepticks')
set(gca,'TickDir','out');
set(gca,'YTick',alt)
colormap(cmap)
caxis([0 maxwnd]);
title('Summer (DJF)','FontWeight','bold','FontSize',12);

subplot(4,1,2)
aux2=NaN(length(alt),24);
for t=1:24
idx=(D(:,4)==t-1 & (D(:,2)==3 | D(:,2)==4 | D(:,2)==5 ));
if length(WNDq2(1,idx))>0
aux2(:,t)=nanmean(WNDq2(:,idx),2);
end
end
contourf(horas,alt,aux2,contornos)
set(gca,'XTick',horas(1:3:end))
datetick('x','HH:MM','keeplimits','keepticks')
set(gca,'TickDir','out');
set(gca,'YTick',alt)
colormap(cmap)
caxis([0 maxwnd]);
title('Autumn (MAM)','FontWeight','bold','FontSize',12);

subplot(4,1,3)
aux2=NaN(length(alt),24);
for t=1:24
idx=(D(:,4)==t-1 & (D(:,2)==6 | D(:,2)==7| D(:,2)==8 ));
if length(WNDq2(1,idx))>0
aux2(:,t)=nanmean(WNDq2(:,idx),2);
end
end
contourf(horas,alt,aux2,contornos)
set(gca,'XTick',horas(1:3:end))
datetick('x','HH:MM','keeplimits','keepticks')
set(gca,'TickDir','out');
set(gca,'YTick',alt)
colormap(cmap)
caxis([0 maxwnd]);
title('Winter (JJA)','FontWeight','bold','FontSize',12);

subplot(4,1,4)
aux2=NaN(length(alt),24);
for t=1:24
idx=(D(:,4)==t-1 & (D(:,2)==9 | D(:,2)==10 | D(:,2)==11 ));
if length(WNDq2(1,idx))>0
aux2(:,t)=nanmean(WNDq2(:,idx),2);
end
end
contourf(horas,alt,aux2,contornos)
set(gca,'XTick',horas(1:3:end))
datetick('x','HH:MM','keeplimits','keepticks')
set(gca,'TickDir','out');
set(gca,'YTick',alt)
colormap(cmap)
caxis([0 maxwnd]);
title('Spring (SON)','FontWeight','bold','FontSize',12);

barra=colorbar('Southoutside','FontWeight','bold','Linewidth',1);
ylabel(barra,'Velocity [m/s] ','FontWeight','bold','FontSize',12);

pos=get(barra,'Position');
barra.Position=[pos(1) pos(2)-0.1 pos(3) pos(4)+0.01];

saveas(h,[outfold,'/fig_14','.png'])
close(h)
