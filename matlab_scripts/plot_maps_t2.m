%filenm='d02.nc';
filenm='d01.nc';

nc=netcdf(filenm,'r');

T2=nc{'T2'}(:,:,:);
XLONG=nc{'XLONG'}(:,:,:);
XLAT=nc{'XLAT'}(:,:,:);

close(nc)



tini=1
tend=12


f=figure('visible','off')

for i=tini:tend
	subplot(3,4,i)
	T2AUX=squeeze(T2(i,:,:))-273.15;
	pcolor(squeeze(XLONG(1,:,:)),squeeze(XLAT(1,:,:)),T2AUX)
	shading interp
	if i == 11
		xlabel('Longitud')
	end
	if i == 8
		ylabel('Latitud')
	end
	title(['T2(',num2str(i),')'])
	colorbar
	caxis([-5 40])
end

print('-dpng','Mapas_T2_d01.png')





