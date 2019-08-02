close all
clear all
more off

nl_d=csvread('NL_2018.csv');
nl=load('NL_t2u10v10wswd.txt');

ws_d=nl_d(2:8760,6);
ws_m=nl(2:8760,4);
wd_d=nl_d(2:8760,5);
wd_m=nl(2:8760,5);

whos 
figure(1)
qqplot(wd_d,wd_m)
xlabel('Mediciones')
ylabel('Modelo WRF')
title('NL - Direccion [grados]')
hold on
plot([0 360],[0 360])
axis([0 360 0 360])

hold off


figure(2)
qqplot(ws_d,ws_m)
xlabel('Mediciones')
ylabel('Modelo WRF')
title('NL - Magnitud Viento [m/s]')
axis([0 14 0 14])
hold on
plot([0 14],[0,14])
hold off

corr(ws_m,ws_d)

figure(3)
x=ws_d;
y=ws_m;
[p S]=polyfit(x,y,1);
[y_fit,delta] = polyval(p,x,S);
plot(x,y,'bo')
xlabel('Mediciones')
ylabel('Modelo WRF')
hold on
plot(x,y_fit,'r-')
plot(x,y_fit+2*delta,'m--',x,y_fit-2*delta,'m--')
title('Linear Fit of Data with 95% Prediction Interval')
legend('Data','Linear Fit','95% Prediction Interval')
plot([0 14],[0,14])
axis([0 14 0 14])

figure(4)
subplot(2,2,1)
hist(ws_d,100,100)
xlabel('Mediciones')
ylabel('%')
title('NL - Magnitud Viento [m/s]')
axis([0 14 0 4])
subplot(2,2,2)
hist(ws_m,100,100)
xlabel('Modelo')
ylabel('%')
title('NL - Magnitud Viento [m/s]')
axis([0 14 0 4])
subplot(2,2,3)
hist(wd_d,100,100)
xlabel('Mediciones')
ylabel('%')
title('NL - Direccion Viento [grados]')
axis([0 360 0 7])
subplot(2,2,4)
hist(wd_m,100,100)
xlabel('Modelo')
ylabel('%')
title('NL - Direccion Viento [grados]')
axis([0 360 0 7])
