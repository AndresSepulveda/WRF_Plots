close all
clear all
more off

KC_d=csvread('KC_2018.csv');
KC=load('KC_extract_t2u10v10wswd.txt');

ws_d=KC_d(2:8760,6);
ws_m=KC(2:8760,8);
wd_d=KC_d(2:8760,5);
wd_m=KC(2:8760,9);

 year=KC(2:8760,1);
month=KC(2:8760,2);
  day=KC(2:8760,3);
 hour=KC(2:8760,4);

horas=0:23;
magnitud=0:14;

freq_mat=meshgrid(magnitud,horas)';

whos freq_mat

for i=1:14
	for j=1:24
		indx=find(hour==(j-1) & ws_m >= (i-1) &  ws_m < i); 	
		freq_mat(i,j)=length(indx);
	end
end

for j=1:24
	sumcol=sum(freq_mat(:,j));
	freq_mat(:,j)=(freq_mat(:,j)/sumcol)*100;
end

figure(1)

subplot(2,1,1)
pcolor(freq_mat)
xlabel('Hora')
ylabel('Magnitud')
title('Modelo KC 2018')
colorbar
caxis([0 40])

for i=1:14
	for j=1:24
		indx=find(hour==(j-1) & ws_d >= (i-1) &  ws_d < i); 	
		freq_mat(i,j)=length(indx);
	end
end

whos freq_mat


for j=1:24
	sumcol=sum(freq_mat(:,j));
	freq_mat(:,j)=(freq_mat(:,j)/sumcol)*100;
end

subplot(2,1,2)
pcolor(freq_mat)
xlabel('Hora')
ylabel('Magnitud')
title('Datos KC 2018')
colorbar
caxis([0 40])

print('-dpng','CicloDiario_Magnitud.png')


%
% Direccion
%

horas=0:23;
direccion=0:30:360;

freq_mat=meshgrid(direccion,horas)';

whos freq_mat

for i=1:length(direccion)-1
	for j=1:length(horas)
		indx=find(hour==(j-1) & wd_m >= direccion(i) &  wd_m < direccion(i+1)); 	
		freq_mat(i,j)=length(indx);
	end
end

for j=1:length(horas)
	sumcol=sum(freq_mat(:,j));
	freq_mat(:,j)=(freq_mat(:,j)/sumcol)*100;
end

figure(2)

subplot(2,1,1)
pcolor(freq_mat)
xlabel('Hora')
ylabel('Direccion')
set(gca,'YTick',[1 4 7 10 13])
set(gca,'YTickLabel',{'0','90','180','270','360'})
title('Modelo KC 2018')
colorbar
caxis([0 40])

for i=1:length(direccion)-1
	for j=1:length(horas)
				indx=find(hour==(j-1) & wd_d >= direccion(i) &  wd_d < direccion(i+1)); 
		freq_mat(i,j)=length(indx);
	end
end

whos freq_mat


for j=1:length(horas)
	sumcol=sum(freq_mat(:,j));
	freq_mat(:,j)=(freq_mat(:,j)/sumcol)*100;
end

subplot(2,1,2)
pcolor(freq_mat)
xlabel('Hora')
ylabel('Direccion')
set(gca,'YTick',[1 4 7 10 13])
set(gca,'YTickLabel',{'0','90','180','270','360'})
title('Datos KC 2018')
colorbar
caxis([0 40])

print('-dpng','CicloDiario_Direccion.png')
