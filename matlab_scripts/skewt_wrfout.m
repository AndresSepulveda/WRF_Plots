% @Author: Christian Segura
% @Mail : chsegura@udec.cl
% @Other : Main source from tskew.m by Steven K. Krueger 

% @Last Modified by:   Christian Segura
% @Last Modified time: 2019-09-05 

function skewt_wrfout(dirdata,filename,xx,yy,t1)

% posicion grilla a evaluar
% xx=[-71]; % longitud
% yy=[-36]; % latitud

% fecha a evaluar
% t1={'03-Jan-1979 11:12:00'}

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
plotname=['skewt',filename];% nombre output
tname='skewt';% titulo de la figura

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

clear lat lon mas_cercanox mas_cercanoy minimox minimoy x XLAT XLONG xx y yy 

%% Recoleccion data 

myVar='XTIME';% minutos desde iniciada la simulación
data=ncread(d01,myVar);
out1 = minutes(diff(datetime([inicio;t1])));

idx=(floor(data)>=out1);

auxnum=find(idx==1);
auxs=auxnum(1);
ts_hour=double(data(auxs)./60);

clear auxnum idx out1 

% myVar='PH';% 
% data=ncread(d01,myVar,[positionx positiony 1 auxs ],[1 1 Inf 1]);
% PH=double(data);
% PH=squeeze(PH);
% 
% myVar='PHB';% 
% data=ncread(d01,myVar,[positionx positiony 1 auxs ],[1 1 Inf 1]);
% PHB=double(data);
% PHB=squeeze(PHB);

myVar='P';% 
data=ncread(d01,myVar,[positionx positiony 1 auxs ],[1 1 Inf 1]);
P=double(data);
P=squeeze(P);

myVar='PB';% 
data=ncread(d01,myVar,[positionx positiony 1 auxs ],[1 1 Inf 1]);
PB=double(data);
PB=squeeze(PB);

PT=(P+PB);% presion total en Pa

myVar='T';% perturbacion temperatura potencial
data=ncread(d01,myVar,[positionx positiony 1 auxs ],[1 1 Inf 1]);
T=double(data)+300;% (theta+t0)
T=squeeze(T);% temperatura potencial

TEMP=T.*((PT./100000).^(2/7));% temperatura kelvin
TEMPC=TEMP-273.15;% temperatura celcius

myVar='QVAPOR';% 
data=ncread(d01,myVar,[positionx positiony 1 auxs ],[1 1 Inf 1]);
QVAPOR=double(data);
QVAPOR=squeeze(QVAPOR);

es = 6.112.*exp(17.67.*(TEMP-273.15)./(TEMP-29.65));
e = QVAPOR .* PT./100./(QVAPOR + 0.622);
RH = e./es;% humedad relativa 0-1

pz=PT./100;
tz=TEMPC;
rhz=RH;

%%
ez=6.112.*exp(17.67.*tz./(243.5+tz));
qz=rhz.*0.622.*ez./(pz-ez);
chi=log(pz.*qz./(6.112.*(0.622+qz)));
tdz=243.5.*chi./(17.67-chi);
%
p=[1050:-25:100];
pplot=transpose(p);
t0=[-48:2:50];
[ps1,ps2]=size(p);
ps=max(ps1,ps2);
[ts1,ts2]=size(t0);
ts=max(ts1,ts2);
for i=1:ts,
   for j=1:ps,
      tem(i,j)=t0(i)+30.*log(0.001.*p(j));
      thet(i,j)=(273.15+tem(i,j)).*(1000./p(j)).^.287;
      es=6.112.*exp(17.67.*tem(i,j)./(243.5+tem(i,j)));
      q(i,j)=622.*es./(p(j)-es);
      thetaea(i,j)=thet(i,j).*exp(2.5.*q(i,j)./(tem(i,j)+273.15));
   end
end
p=transpose(p);
t0=transpose(t0);
temp=transpose(tem);
theta=transpose(thet);
thetae=transpose(thetaea);
qs=transpose(sqrt(q));
h=contour(t0,pplot,temp,16,'k');
hold on
set(gca,'ytick',[1000:100:100])
set(gca,'yscale','log','ydir','reverse')
set(gca,'fontweight','bold')
set(gca,'ytick',[100:100:1000])
set(gca,'ygrid','on')
hold on
h=contour(t0,pplot,theta,24,'b');
h=contour(t0,pplot,qs,24,'g');
h=contour(t0,pplot,thetae,24,'r');
%tsound=30.+43.5.*log(0.001.*p);
%tsoundm=tsound-30.*log(0.001.*p);
tzm=tz-30.*log(0.001.*pz);
tdzm=tdz-30.*log(0.001.*pz);
h=plot(tzm,pz,'r',tdzm,pz,'b--');
set(h,'linewidth',2)
hold off
xlabel('Temperatura (°C)','fontweight','bold')
ylabel('Presión (hPa)','fontweight','bold')
ylim([100 1000])
title(tname)
legend(h,'T parcela','T punto de rocío')

saveas(h,[pwd,'/../figuras/',plotname],'png');
close all

return
