'reinit'
'open salida_wrf.ctl'
'set lon -73'
'set lat -36'
'set z 1 27'

'set vpage 0.0 3.9 1.0 8.0'
'set grads off'

'set ccolor 2'
'd u'
'draw title u [m/s]'
'draw ylab z[km]'

'set vpage 3.5 7.4 1.0 8.0'
'set grads off'
'set ccolor 3'
'd v'
'draw title  v [m/s]'
'draw ylab z[km]'

'set vpage 7.1 11 1.0 8.0'
'set grads off'
'set ccolor 4'
'd mag(u,v)'
'draw title  Mag(u,v) [m/s]'
'draw ylab z[km]'

'printim perfilvertica.gif gif x1000 y700 white'
