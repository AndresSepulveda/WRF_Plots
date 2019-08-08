'reinit'
'set display color white'
'clear'
'open Cupex_d01.ctl'
'set mpdset hires'
'set lat -50 -45'
'set lon -78 -72'
'set t 2'
'rgbset'

'set vpage 0.1 5.5 4.3 8.5'
'set clevs 100 150 200 250 300 350 400 450 500 550 600 650 '
'set ccols 41 42 43 44 45 46 47 48 49 56 57 58 59'
'set gxout shaded'
'set grads off'
'd smth9(rainnc+rainc)'
'cbar'
'draw title Precipitacion [mm]'


'set vpage 5.4 10.8 4.3 8.5'
'set clevs  1 2 3 4 5 6 7 8 9 10 11 12 13'
'set ccols   20 31 41 71 61  72  62 63 64 65 66 67 68 69 '
'set gxout shaded'
'set grads off'
'd smth9(t2-273)'
'cbarn'
'draw title T a 2m[ºC]'


'set vpage 0.1 5.5 0 4.4'
'set clevs  20 40 60 80 100 120 140 160'
'set ccols   21 22 23 24 25 26 27 28 29 '
'set gxout shaded'
'set grads off'
'd lh'
'cbar'
'draw title Latetnt Heat Flux [W/m2]'

'set vpage 5.4 10.8 0 4.4'
'set clevs  0.005 0.0055 0.006 0.0065 0.007 0.0075 0.008 0.0085 0.009'
'set ccols  20 31 32 33 34 35 36 37 38 39'
'set grads off'
'd q2'
'cbarn'
'draw title Razon de Mezcla a 2m [kg/kg] '

'printim cuadros.gif gif x900 y800 white'



