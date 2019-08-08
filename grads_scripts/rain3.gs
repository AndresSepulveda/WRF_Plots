
function main(args)

if (args = '')
  prompt 'Enter forecast date (ddmmYYYY) --> '
  pull date
  prompt 'Enter forecast Hour --> '
  pull hora
  prompt 'Enter longitude --> '
  pull hilon
  prompt 'Enter latitude --> '
  pull hilat
  metric = 'y'
  if (metric='n' | metric='N') ; units='e' ; endif
else
  time   = subwrd(args,1)
  hilon  = subwrd(args,2)
  hilat  = subwrd(args,3)
endif

'set mpdset hires'
'set display color white'
'run rgbset.gs'
'set mpt 0 79 1 10'
'set mpt 1 79 1 10'

ans = 1
frame = 1

'set t 'time
'q dims'
rec=sublin(result,5)
_analysis=subwrd(rec,6)
'set grads off'
'set gxout shaded'
'set clevs 3 6 12 24 48 '
'set ccols 0  33 39 7 8 2'
'set strsiz .2'
'set string 1 l 6'
'set strsiz .15'
'set string 1 l 3'
'draw string 4.5 8.0 ' _analysis
'set strsiz .10'
'draw string 3.0 0.3 WRF, DGEO, Universidad de Concepcion'
'run cbar.gs'
'set lev 900'
'set gxout barb'
'set ccols 47'
'd skip(u,5,5);v;mag(u,v)'
'set lev 1000'
return
