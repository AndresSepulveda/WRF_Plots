clear all
close all
more off

nc=netcdf('./cut_vars/all_mag.nc','r');
  times=nc{'Times'}(:,:);
  t2=nc{'T2'}(:,:,:);
close(nc)

nf=netcdf('./cut_vars/onefull.nc','r');
%  albedo=nf{'ALBEDO'}(:,:,:); 
  landmask=nf{'LANDMASK'}(:,:,:);
  lat=squeeze(nf{'XLAT'}(1,:,:));
  lon=squeeze(nf{'XLONG'}(1,:,:));
  hgt=squeeze(nf{'HGT'}(1,:,:));
close(nf)

n=size(times,1);

for i = 1:n
  yr(i)=str2num(squeeze(times(i,1:4)));
  mn(i)=str2num(squeeze(times(i,6:7)));
  dy(i)=str2num(squeeze(times(i,9:10)));
  hh(i)=str2num(squeeze(times(i,12:13)));
  mi(i)=str2num(squeeze(times(i,15:16)));
  se(i)=str2num(squeeze(times(i,18:19)));
end

fecha=datenum(yr,mn,dy,hh,mi,se);

st1_lt=30; % -51.183
st1_ln=21; % -72.96

st2_lt=27; % -51.73
st2_ln=22; % -72.46

st3_lt=21; % -53.116
st3_ln=26; % -70.86

st4_lt=22; % -52.86
st4_ln=29; % -69.916

%%keyboard

subplot(4,1,1)
plot(fecha,t2(:,st1_lt,st1_ln)-273.15)
datetick('x',12)
lat(st1_lt,st1_ln)
lon(st1_lt,st1_ln)

subplot(4,1,2)
plot(fecha,t2(:,st2_lt,st2_ln)-273.15)
datetick('x',12)
lat(st2_lt,st2_ln)
lon(st2_lt,st2_ln)

subplot(4,1,3)
plot(fecha,t2(:,st3_lt,st3_ln)-273.15)
datetick('x',12)
lat(st3_lt,st3_ln)
lon(st3_lt,st3_ln)

subplot(4,1,4)
plot(fecha,t2(:,st4_lt,st4_ln)-273.15)
datetick('x',12)
lat(st4_lt,st4_ln)
lon(st4_lt,st4_ln)


