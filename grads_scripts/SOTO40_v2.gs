#
# Andres Sepulveda (DGEO), Sebastian Morales (DIRECTEMAR) 24-01-2013
# Agradecimientos: Ken Takahashi (IGP), Andres Arriagada (DGEO)
#
'open d05.ctl'
'set timelab off'
 'set LAT -36.86 -36.51'
 'set LON -73.3 -72.9'

t = 24
while (t <= 49)
 'clear'
 'set t 't
# 'set parea 0.5 10.2 1.0 8.0'
 'set mpdset off'
 'set grads off'
 'set gxout shaded'
 'set clevs 5 10 15 20 25 30 35 40 45'
 'set ccols 4 11 13 3 10 7 12 8 2'
 'set clab off'

 'define aux=smth9(smth9(mag(u10*1.94,v10*1.94)))'
# 'd maskout(aux,-landmask)'
 'd aux'
 'set gxout vector'
 'set cthick 3'
 'set arrscl .5 10'
# 'set clopts -1 6 0.9'
# 'd skip(maskout(u10*1.94,-landmask),6);maskout(v10*1.94,-landmask)'
 'd skip(u10*1.94,4);v10*1.94'
 'set shpopts 15'
 'set line 1 1 4'
 'draw shp /atmos/WRF/ARWpost/shapes/cl_regiones_wgs842.shp'
 'set strsiz 0.14'
 'set string 1 l 5'
 'draw string 5.9 3.0 Talcahuano'
 'q time'
 fe3=subwrd(result,3)
 fe4=substr(fe3,4,9)
 ho4=substr(fe3,1,3)
 'draw title Wind 10M [kn] 'fe4' 'ho4''
 'run cbarn 1 1 9.5 4.5'
 'draw string 8.5 0.35 SOTO40 DGEO/WRF'
 'draw string 8.1 0.15 Universidad de Concepcion'
 if (t<10);t='0't;endif
 'printim ' t'.gif gif x800 y600 white'
 t = t + 1
endwhile
# gifsicle --delay 60 -l ??.gif > SOTO40.gif


