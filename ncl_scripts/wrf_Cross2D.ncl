
;   Extract t2 along a cross section and plot (over time) 
;   on an xy-plot

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
;
; The WRF ARW input file.  
; This needs to have a ".nc" appended, so just do it.
  a = addfile("/atmos/WRF/Domains/Storm2000/wrfout_d01_2000-01-24_12:00:00.nc","r")


; We generate plots, but what kind do we prefer?
  type = "x11"
; type = "pdf"
; type = "ps"
; type = "ncgm"
  wks = gsn_open_wks(type,"plt_Cross2D")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; get time information and strip out the day and hour
  times_in_file = a->Times
  dim = dimsizes(times_in_file)
  times = new(dim(0),string)
  do i=0,dim(0)-1
    times(i) = chartostring(times_in_file(i,8:12))
  end do

; get t2 for all times and xlon (for lable info)
; extract data along a given line
  t2   = wrf_user_getvar(a, "T2",-1)
  t2   = 1.8*(t2-273.16)+32.
  t2@description = t2@description + " (F)"
  xlon = wrf_user_getvar(a, "XLONG",0)
  dims = dimsizes(t2)
  plane = new(2,float)
  plane = (/ dims(2)/2, dims(1)/2 /)       ; pivot point (x,y) through center of domain
  angle = 90.                              ; plot from west to east
  opts = False                             ; start and end point not supplied

  X_plane = wrf_user_intrp2d(xlon,plane,angle,opts)
  t_plane = wrf_user_intrp2d(t2,plane,angle,opts)


  res = True
  res@tiMainString = "Surface temperature along a cross section"
  res@tmXBMode = "Manual"
  res@tiXAxisString = "longitute"
  res@xyLineThicknesses      = (/ 3, 3, 3, 3, 3 /)
  res@xyLineColors           = (/ 2, 60, 145, 170, 200 /)
  res@xyExplicitLegendLabels = times
  res@lgItemOrder            = (/ 4, 3, 2, 1, 0 /)
  res@pmLegendDisplayMode    = "Always" 
  res@lgPerimOn              = False   
  res@pmLegendSide           = "Top"    
  res@pmLegendParallelPosF   = 0.15      
  res@pmLegendOrthogonalPosF = -0.37   
  res@pmLegendWidthF         = 0.15  
  res@pmLegendHeightF        = 0.15 

  plot = gsn_csm_xy(wks,X_plane,t_plane,res)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end
