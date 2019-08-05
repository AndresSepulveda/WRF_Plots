close all
clear all
more off

KC_d=csvread('KC_2018.csv');
KC=load('KC_t2u10v10wswd.txt');

ws_d=KC_d(:,6);
ws_m=KC(2:8760,4);
wd_d=KC_d(:,5);
wd_m=KC(2:8760,5);

figure(1)

direction = wd_m;
speed     = ws_m;
Options = {'anglenorth',0,... 
           'angleeast',90,... 
           'labels',{'N (0°)','S (180°)','E (90°)','W (270°)'},... 
           'freqlabelangle',45};
h=WindRose(direction,speed,Options);
saveas(h,'WR_m','png');

figure(2)
direction = wd_d;% Directions are in the first column
speed = ws_d;% Speeds are in the second column
Options = {'anglenorth',0,... 
           'angleeast',90,... 
           'labels',{'N (0°)','S (180°)','E (90°)','W (270°)'},... 
           'freqlabelangle',45};
h=WindRose(direction,speed,Options);
saveas(h,'WR_d','png');
