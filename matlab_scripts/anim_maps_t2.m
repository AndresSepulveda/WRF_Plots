%filenm='d02.nc';
filenm='d01.nc';

nc=netcdf(filenm,'r');

T2=nc{'T2'}(:,:,:);
XLONG=nc{'XLONG'}(:,:,:);
XLAT=nc{'XLAT'}(:,:,:);

close(nc)



tini=1
tend=12



for i=tini:tend
	f=figure('visible','off')
	T2AUX=squeeze(T2(i,:,:))-273.15;
	pcolor(squeeze(XLONG(1,:,:)),squeeze(XLAT(1,:,:)),T2AUX)
	shading interp
		xlabel('Longitud')
		ylabel('Latitud')
	title(['T2(',num2str(i),')'])
	colorbar
	caxis([-5 40])
	if i < 10
		print('-dgif',['Mapas_T2_d01_0',num2str(i),'.gif'])
	else
		print('-dgif',['Mapas_T2_d01_',num2str(i),'.gif'])
	end
end

%
%  convert -delay 50 -loop 10 Mapas_T2_d01_*gif anim.gif
%





