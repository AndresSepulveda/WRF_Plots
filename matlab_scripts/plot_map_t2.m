%filenm='d02.nc';
filenm='d01.nc';

nc=netcdf(filenm,'r');

T2=nc{'T2'}(:,:,:);
XLONG=nc{'XLONG'}(:,:,:);
XLAT=nc{'XLAT'}(:,:,:);

close(nc)

tini=1
tend=15

T2INI=squeeze(T2(tini,:,:));
T2END=squeeze(T2(tend,:,:));
T2DIF=T2END-T2INI;

f=figure('visible','off')
pcolor(squeeze(XLONG(1,:,:)),squeeze(XLAT(1,:,:)),T2INI)
shading interp
print('-dpng','Mapa_T2_d01_INI.png')

f=figure('visible','off')
pcolor(squeeze(XLONG(1,:,:)),squeeze(XLAT(1,:,:)),T2END)
shading interp
print('-dpng','Mapa_T2_d01_END.png')

f=figure('visible','off')
pcolor(squeeze(XLONG(1,:,:)),squeeze(XLAT(1,:,:)),T2DIF)
shading interp
print('-dpng','Mapa_T2_d01_DIF.png')





