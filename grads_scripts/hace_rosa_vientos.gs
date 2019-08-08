* draw WindRose plot
'reinit'
**********************************************************************
* define constant
**********************************************************************
*// data file name. data should seems like this:
* Direction_Max_Speed_20.gif // image file name
* Direction Max Speed: 20(M) Unit:(cm/s) // image title
* 58.700000 // below is 16 velocity and every direction
* 32.000000
* 34.600000
* 39.600000
* 56.100000
* 42.000000
* 42.800000
* 54.700000
* 57.700000
* 49.700000
* 50.200000
* 61.800000
* 57.700000
* 47.500000
* 50.300000
* 43.700000
debug=0
*// 0:false,1:true
fn='prueba.txt'
DIRS='N  NNENE ENEE  ESESE SSES  SSWSW WSWW  WNWNW NNWN  '
* circle step
step=5
* font size
hsiz=0.2
vsiz=0.2
* ticks scale
*// I just add 3 minus ticks, if adding more, don't forget change below
*// part which plot it.
scale.1=0.8
scale.2=0.5
scale.3=0.3

**********************************************************************
* get screen dimension
**********************************************************************
'query gxinfo'
tinfo=sublin(result,2)
screenx=subwrd(tinfo,4)
screeny=subwrd(tinfo,6)
ox=screenx/2
oy=screeny/2

**********************************************************************
* calculate image size depending on the screen dimension
**********************************************************************
'set strsiz 'hsiz' 'vsiz
if(screenx>screeny)
Radius=screeny
else
Radius=screenx
endif
Radius=0.4*Radius
if(debug); say 'Radius='Radius; endif

**********************************************************************
* read in image title and image file name
**********************************************************************
tinfo=read(fn)
imagefn=sublin(tinfo,2)
if(debug); say 'outimage name: 'imagefn; endif
tinfo=read(fn)
imagetitle=sublin(tinfo,2)
if(debug); say 'outimage name: 'imagetitle; endif

**********************************************************************
* plot main circle and tags
**********************************************************************
'set line 4 1 6'
'set string 1 bl 1'
i=0
x0=ox
y0=oy+Radius
while(i<=360)
dx0=Radius*math_sin(i/180*3.1416)
dy0=Radius*math_cos(i/180*3.1416)
* a, plot axis on every direction like N,NNW,NW,etc.
if(0=math_fmod(i,45))
* a.1, plot tags
  offsetx=0.4*math_sin(i/180*3.1416)
  offsety=0.2*math_cos(i/180*3.1416)
  'draw string 'ox+dx0-0.1+offsetx' 'oy+dy0-0.1+offsety' 'substr(DIRS,(math_nint(i/22.5))*3+1,3)
* a.2, plot axis
  'draw line 'ox' 'oy' 'ox+dx0' 'oy+dy0
endif
* b, draw circle
'draw line 'x0' 'y0' 'ox+dx0' 'oy+dy0
* c, prepare for next run
x0=ox+dx0
y0=oy+dy0
i=i+step
if(debug); pull something; endif
endwhile


**********************************************************************
* plot minus circle as ticks
**********************************************************************
*// just as ploting main circle
'set line 4 1 1'
x1=ox
y1=oy+scale.1*Radius
x2=ox
y2=oy+scale.2*Radius
x3=ox
y3=oy+scale.3*Radius
i=1
while(i<360)
dx0=Radius*math_sin(i/180*3.1416)
dy0=Radius*math_cos(i/180*3.1416)
dx1=dx0*scale.1
dy1=dy0*scale.1
dx2=dx0*scale.2
dy2=dy0*scale.2
dx3=dx0*scale.3
dy3=dy0*scale.3
* plot 3 major circles as ticks
'draw line 'x1' 'y1' 'ox+dx1' 'oy+dy1
'draw line 'x2' 'y2' 'ox+dx2' 'oy+dy2
'draw line 'x3' 'y3' 'ox+dx3' 'oy+dy3
x1=ox+dx1
y1=oy+dy1
x2=ox+dx2
y2=oy+dy2
x3=ox+dx3
y3=oy+dy3
i=i+step
endwhile

**********************************************************************
* draw image title
**********************************************************************
'set string 1 bl 6'
len=math_strlen(imagetitle)
offsetx=-len/2*vsiz
'draw string 'ox+offsetx' 'oy+Radius+0.4' 'imagetitle
say 'draw string 'ox-1' 'oy+Radius' 'imagetitle
'set string 1 bl 1'


**********************************************************************
* read in data
**********************************************************************
i=1
vmax=0
while(i<=73)
tinfo=read(fn)
tinfo=sublin(tinfo,2)
len=math_strlen(tinfo)
*// note no array in grads, but can use .i to emulate
vel.i=substr(tinfo,1,len-1)
if(vel.i>vmax); vmax=vel.i; endif
if(debug); say 'vel= 'vel.i; endif
i=i+1
endwhile

**********************************************************************
* calculate scale
**********************************************************************
tinfo=vmax
i=0
while(tinfo<0.1)
i=i+1
tinfo=tinfo*10
endwhile

while(tinfo>1)
i=i-1
tinfo=tinfo*0.1
endwhile

if(debug); say 'tinfo= 'tinfo' i='i; endif

tinfo=math_nint(tinfo*10)+1

**********************************************************************
* plot ticks and ticks axis
**********************************************************************
'set line 3 1 6'
i=1
dx0=Radius*math_sin(25/180*3.1416)
dy0=Radius*math_cos(25/180*3.1416)
* I don't like ticks axis, if you need, your can un-comment this line below
*'draw line 'ox' 'oy' 'ox+dx0' 'oy+dy0

tinfo=math_format('%.0f',vmax)
'draw string 'ox+dx0' 'oy+dy0' 'tinfo
while(i<=3)
tinfo=math_format('%.0f',vmax*scale.i)
'draw string 'ox+dx0*scale.i' 'oy+dy0*scale.i' 'tinfo
i=i+1
endwhile


**********************************************************************
* plot wind rose
**********************************************************************
*// normalize data
i=1
vel.i=vel.i/vmax
x0=ox
y0=oy+vel.i*Radius
*// save the first point location
x2=x0
y2=y0
i=2

'set strsiz 0.01 0.01'
'set string 4 bl 1'
'draw string 'ox-8*0.01' 'oy+0.5*0.01' 'BY ZUOHJ FOR TT7
'set string 1 bl 1'
'set strsiz 'hsiz' 'vsiz
while(i<=16)
vel.i=vel.i/vmax
x1=ox+Radius*vel.i*math_sin((i-1)*22.5/180*3.1416)
y1=oy+Radius*vel.i*math_cos((i-1)*22.5/180*3.1416)
'draw line 'x0' 'y0' 'x1' 'y1
if(debug)
  say 'i= 'i', normalize vel.i='vel.i*vmax
  pull something
endif
x0=x1
y0=y1
i=i+1
endwhile
'draw line 'x0' 'y0' 'x2' 'y2
