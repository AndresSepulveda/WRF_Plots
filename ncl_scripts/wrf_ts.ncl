
;   Example script - read and plot data from WRF time series output
;   November 2008

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  type = "x11"
; type = "pdf"
; type = "ps"
; type = "ncgm"
  wks = gsn_open_wks(type,"plt_ts")       ; Create a plot workstation


  data = readAsciiTable("pt_a.d01.TS", 19, "float", 1)   ; read the data file

  res = True
  res@tmXTOn         = False        
  res@xyLineThicknesses = 2        
  res@xyLineColor    =  "blue"    
  res@tiYAxisString = "2m Temperature"
  res@tiXAxisString = "Simulation Time"
  res@tiMainString = "12Z 24 Jan 2000"

  plot  = gsn_csm_xy(wks,data(:,1),data(:,5),res)    ; we know column 2 is time and column 6 is T2
                                                     ; read README.tslist in WRF/run for more details
   
end
