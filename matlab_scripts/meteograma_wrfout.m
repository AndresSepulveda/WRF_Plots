% @Author: Christian Segura
% @Mail : chsegura@udec.cl

% @Last Modified by:   Christian Segura
% @Last Modified time: 2019-09-05 

function meteograma_wrfout(dirdata,filename,xx,yy,t1,t2)

% posicion grilla a evaluar
% xx=[-71]; % longitud
% yy=[-36]; % latitud

% fechas a evaluar
% t1={'03-Jan-1979 11:12:00'}; t2={'07-Jan-1979 12:12:00'};

%directorio 
% dir='/home/chris/Documentos/Toolbox_WRF_matlab';
dir='/home/matlab/WRF/Toolbox_WRF_matlab';

addpath([dir]);
addpath([dir,'/funciones']);
addpath([dir,'/scripts']);
% addpath([dir,'/funciones/m_map']);
addpath(['/home/matlab/croco_tools/UTILITIES/m_map1.4h']);

inicio='01-Jan-1979 00:00:00';%Hora de inicio simulacion, por ej. '01-Jan-1979 00:00:00'

d01=[dirdata,filename,'.nc'];
plotname=['Meteograma',filename];% nombre output
tname='Meteograma';% titulo de la figura

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

%% Recoleccion data 

myVar='XTIME';% minutos desde iniciada la simulación
data=ncread(d01,myVar);
out1 = minutes(diff(datetime([inicio;t1])));
out2 = minutes(diff(datetime([inicio;t2])));

idx=(floor(data)>=out1 & floor(data)<=out2);
ts_hour=double(data(idx)./60);

auxnum=find(idx==1);
auxs=auxnum(1);
auxe=auxnum(end);
auxdif=auxe-auxs+1;

myVar='T2';% temperatura a 2 metros
data=ncread(d01,myVar,[positionx positiony auxs ],[1 1 auxdif]);
T2=double(data)-273.15;% grados celcius
T2=squeeze(T2);

myVar='RAINC';% precipitacion esquema cumulos
data=ncread(d01,myVar,[positionx positiony auxs ],[1 1 auxdif]);
RAINC=double(data);
RAINC=squeeze(RAINC);

myVar='RAINNC';% precipitacion convectiva
data=ncread(d01,myVar,[positionx positiony auxs ],[1 1 auxdif]);
RAINNC=double(data);
RAINNC=squeeze(RAINNC);

%%

myVar='PH';% 
data=ncread(d01,myVar,[positionx positiony 1 auxs ],[1 1 Inf auxdif]);
PH=double(data);
PH=squeeze(PH);

myVar='PHB';% 
data=ncread(d01,myVar,[positionx positiony 1 auxs ],[1 1 Inf auxdif]);
PHB=double(data);
PHB=squeeze(PHB);

myVar='P';% 
data=ncread(d01,myVar,[positionx positiony 1 auxs ],[1 1 Inf auxdif]);
P=double(data);
P=squeeze(P);

myVar='PB';% 
data=ncread(d01,myVar,[positionx positiony 1 auxs ],[1 1 Inf auxdif]);
PB=double(data);
PB=squeeze(PB);

PT=(P+PB)';

Z=(PH+PHB)./9.81;% altura 
Z=squeeze(Z)';
Z(:,1)=[];

myVar='T';% perturbacion temperatura potencial
data=ncread(d01,myVar,[positionx positiony 1 auxs ],[1 1 Inf auxdif]);
T=double(data)+300;% (theta+t0)
T=squeeze(T)';

TEMP=T.*((PT./100000).^(2/7));
TEMPC=TEMP-273.15;% temperatura celcius

myVar='QVAPOR';% 
data=ncread(d01,myVar,[positionx positiony 1 auxs ],[1 1 Inf auxdif]);
QVAPOR=double(data);
QVAPOR=squeeze(QVAPOR)';

es = 6.112.*exp(17.67.*(TEMP-273.15)./(TEMP-29.65));
e = QVAPOR .* PT./100./(QVAPOR + 0.622);
RH = e./es;

zq=500:500:10000;
for i=1:size(T,1)
TEMPCn(i,:) = interp1(Z(i,:),TEMPC(i,:),zq);
RHn(i,:) = interp1(Z(i,:),RH(i,:),zq);
end

a = datenum(inicio);%'19-Dec-2009 23:00:00' Fecha de referencia

clear hrs out
for t=1:length(ts_hour)
hrs=ts_hour(t);%horas a partir de la fecha de referencia
out{t}=datevec(a+(hrs/24));%vector [año mes dia hora]
end

for i=1:length(out)
    D(i,1)=out{i}(1);
    D(i,2)=out{i}(2);
    D(i,3)=out{i}(3);
    D(i,4)=out{i}(4);
    D(i,5)=out{i}(5);
    D(i,6)=out{i}(6);
end
    
dt = datetime(D(:,1),D(:,2),D(:,3),D(:,4),D(:,5),D(:,6));
tt = timetable(dt,T2,RAINC,RAINNC,TEMPCn,RHn);
TT2 = retime(tt,'hourly','spline');

anios=year(TT2.dt(1:end));
meses=month(TT2.dt(1:end));
horas=hour(TT2.dt(1:end));
% minutos=minute(TT2.dt(1:end));
%temp=TT2.temp(1:end);
%q=TT2.q(1:end);
RAINC=TT2.RAINC(1:end);
RAINNC=TT2.RAINNC(1:end);
T2=TT2.T2(1:end);
%psfc=TT2.psfc(1:end);
%rain=TT2.rain(1:end);
% ws=TT2.ws(1:end);
%wd=TT2.wd(1:end);
TEMPCn=TT2.TEMPCn;
RHn=TT2.RHn;

% TRAIN=RAINC+RAINNC;

CRAINNC=zeros(size(RAINC));
CRAINC=zeros(size(RAINC));
% CTRAIN=zeros(size(RAINC));

for i=1:length(RAINC)-1
CRAINNC(i+1)=RAINNC(i+1)-RAINNC(i);
CRAINC(i+1)=RAINC(i+1)-RAINC(i);
% CTRAIN(i+1)=CTRAIN(i+1)-CTRAIN(i);
end

[X Y]=meshgrid(1:size(TEMPCn,1),zq);

cmap=colormap_cpt('temp-c');
h=figure;
subplot(4,2,[1 2 3 4])
pcolor(X,Y,RHn'.*100)
shading interp
hold on
barra=colorbar('northoutside','FontWeight','bold','Linewidth',1);
ylabel(barra,' HR [%] ');
colormap(flipud(cmap(1:1:end,:)));
caxis([0 100])

[C,h]=contour(X,Y,TEMPCn','k');
clabel(C,h)
hold on
% contourf(X,Y,T(1:20,:)',0,'k','linewidth',2);
ylabel('Z [m]')
% xlabel('Horas desde inicio simulación')

subplot(4,2,[5 6])
plot([0:length(horas)-1],T2,'-or','linewidth',2,'MarkerFaceColor','r')
grid on
ylabel('T 2m [°C]')
% xlabel('Horas desde inicio simulación')
xlim([auxs,auxe])

hold on
subplot(4,2,[7 8])
aux=bar([0:length(horas)-1],[CRAINNC CRAINC],'stacked');
grid on
set(aux,{'FaceColor'},{'b';'cyan'});
ylabel('PP total [mm/hr]')
xlabel('Horas desde inicio simulación')
legend(aux,'RAINNC','RAINC')
xlim([auxs,auxe])

saveas(h,[pwd,'/../figuras/',plotname],'png');
close all

return

