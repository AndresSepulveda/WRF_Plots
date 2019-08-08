'open test_grads.ctl'
file='prueba.txt'
* Parse the arguments: name, date, longitude, latitude, units

prompt 'Ingrese longitud --> '
pull hilon
prompt 'Ingrese latitud --> '
pull hilat
prompt 'Ingrese nivel --> '
pull hilev

* Find the grid point closest to requsted location
'set lon 'hilon
hilon = subwrd(result,4)
'set lat 'hilat
hilat = subwrd(result,4)
'set lev 'hilev
hilev = subwrd(result,4)

'set t 1 73'
'wnd = mag(u,v)'
'set gxout print'
'set prnopts %g 1 1'
line0 = 'Esta linea es para rellenar'
line = 'Rosa de los Vientos (m/s)'
res0 = write(file,line0)
res01 = write(file,line,append)
'd wnd'
buffer = result
i = 1
line = sublin(buffer,i)
n = subwrd(line,4)
undef = subwrd(line,9)
i = 2
line = sublin(buffer,i)
if ( write_(file,line,append) > 0 )
return -2
endif
i = i + 1
line = sublin(buffer,i)
while ( line != '' )
if ( write_(file,line,append) != 0 )
return -3
endif 
i = i + 1
line = sublin(buffer,i)
endwhile
if ( close(file) != 0 )
return -4
endif

 
function write_(file,line)
rc = write(file,line)
return subwrd(rc,1)

