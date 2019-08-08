
;   Example script to produce plots for a WRF real-data run,
;   with the ARW coordinate dynamics option.

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
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
  wks = gsn_open_wks(type,"plt_Cloud")
  gsn_define_colormap(wks,"WhBlGrYeRe")   ; overwrite the .hluresfile color map


; Set some basic resources
  res = True
  res@MainTitle = "REAL-TIME WRF"

  mpres  = True  ; Map resources
  pltres = True ; Plot resources


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; What times and how many time steps are in the data set?
  times = wrf_user_getvar(a,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  do it = ntimes-1,ntimes-1        ; TIME LOOP

    print("Working on time: " + times(it) )
    res@TimeLabel = times(it)   ; Set Valid time to use on plots

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First get the variables we will need        

    if(isfilevar(a,"QVAPOR"))
      qv = wrf_user_getvar(a,"QVAPOR",it) 
      qv = qv*1000.
      qv@units = "g/kg"   
    end if
    if(isfilevar(a,"QCLOUD"))
      qc = wrf_user_getvar(a,"QCLOUD",it)
      qc = qc*1000.
      qc@units = "g/kg"   
    end if
    if(isfilevar(a,"QRAIN"))
      qr = wrf_user_getvar(a,"QRAIN",it)
      qr = qr*1000.
      qr@units = "g/kg"   
    end if
    if(isfilevar(a,"QICE"))
      qi = wrf_user_getvar(a,"QICE",it)
      qi = qi*1000.
      qi@units = "g/kg"   
    end if

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    do level = 0,24,5      ; LOOP OVER LEVELS

      display_level = level + 1
      opts = res
      opts@cnFillOn         = True
      opts@gsnSpreadColors  = False
      opts@PlotLevelID      = "Eta Level  " + display_level

      if (isvar("qv"))
        contour = wrf_contour(a,wks,qv(level,:,:),opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        delete(contour)
      end if

      if (isvar("qc"))
        contour = wrf_contour(a,wks,qc(level,:,:),opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        delete(contour)
      end if

      if (isvar("qr"))
        contour = wrf_contour(a,wks,qr(level,:,:),opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        delete(contour)
      end if

      if (isvar("qi"))
        qi_plane  = qi(level,:,:)
        contour = wrf_contour(a,wks,qi(level,:,:),opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        delete(contour)
      end if

      delete(opts)

    end do      ; END OF LEVEL LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  end do        ; END OF TIME LOOP     

end
