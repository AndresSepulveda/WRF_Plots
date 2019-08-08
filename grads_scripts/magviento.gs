'reinit'
*dom=3
'open salida_wrf.ctl'
var='mag(u,v)'
'set display color white'
'set mpdset hires'
'clear'
'set grads off'
result=1nim
frame = 1
'q file'
rec=sublin(result,5)
_endtime=subwrd(rec,12)
runscript = 1

* start at time 1
dis_t = 1

* movie loop
while(runscript)
'set t ' dis_t
'q dims'
rec=sublin(result,5)
_analysis=subwrd(rec,6)

say 'Time is ' _analysis

'clear'
'set grads off'
'set z 15'
* hace el shaded
'set gxout shaded'
* barra de color
'set clevs 5 10 15 20 25 30 35 40 45 50 55'

'd ' var
'set strsiz .2'
'set string 1 l 4'
'draw title  ' _analysis

'cbar'
*hace el contour
'set gxout contour'
'set cthick 5'
'set cint 5.0'
'set ccolor 1'
'set black 0 0'
'd ' var
* Guarda las imagenes
if(ans)
if( frame < 10 )
'printim movie00'frame'.gif gif '
else 
if ( frame < 100 )
'printim movie0'frame'.gif gif '
else
'printim movie'frame'.gif gif '
endif
endif
frame=frame+1
endif
*pull dummy
if ( dis_t=_endtime )
 runscript=0
endif 
dis_t = dis_t + 1

endwhile


