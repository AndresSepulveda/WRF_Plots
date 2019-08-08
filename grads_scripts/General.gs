'reinit'
'open salida_wrf.ctl'
'set mpdset hires'
'set z 1'
'set t 1'

'set gxout shaded'
'rgbset'
'set clevs 0 2 4 6 8 10 12 14 16 18 20 22 24 26'
'set ccols 53 55 57 43 45 47 34 35 37 23 24 25 26 27 29'
'd t2-273'
'cbarn'

'set gxout contour'
'set ccolor 1'
'set clab masked'
'set cint 30'
'd psfc/100'


'set gxout vector'
'set cthick 5'
'set arrscl 0.5 30'
'set ccolor 14'
'd skip(u10,3);skip(v10,3)'
*;skip(mag(u10,v10),6)'
'cbarn'


'draw title Temperatura a 2m, Presion Superficial y Viento a 10m'
'printim todo.gif gif white'

