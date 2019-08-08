
;   Example script to produce plots for a WRF real-data run,
;   with the ARW coordinate dynamics option.

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
;load "./WRFUserARW.ncl"

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
  wks = gsn_open_wks(type,"plt_Surface2")

; Set some Basic Plot options
  res = True
  res@MainTitle                   = "REAL-TIME WRF"

  pltres = True
  mpres = True


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; What times and how many time steps are in the data set?
  times = wrf_user_getvar(a,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    res@TimeLabel = times(0)    ; Set Valid time to use on plots

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; TERRAIN

      ter = wrf_user_getvar(a,"HGT",0)
      opts = res
      opts@cnFillOn = True
      opts@ContourParameters = (/ 100. /)
      opts@lbBoxLinesOn = False
      contour = wrf_contour(a,wks,ter,opts)
      delete(opts)
      plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)


    ; LANDUSE , SOIL & VEGETATION FRACTION

      opts = res
      opts@cnFillOn = True
      opts@cnRasterModeOn = True
      opts@gsnSpreadColorStart = 32

      if(isfilevar(a,"LU_INDEX"))
        land = wrf_user_getvar(a,"LU_INDEX",0)
        contour = wrf_contour(a,wks,land,opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
      end if
  
      if(isfilevar(a,"ISLTYP"))
        isoil = wrf_user_getvar(a,"ISLTYP",0)
        contour = wrf_contour(a,wks,isoil,opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
      end if
  
      if(isfilevar(a,"VEGFRA"))
        vgf = wrf_user_getvar(a,"VEGFRA",0)
        opts@gsnSpreadColorStart= 0
        opts@ContourParameters = (/ 10. /);
        contour = wrf_contour(a,wks,vgf,opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
      end if
  
      delete(opts)
  
  
    ; SOIL TEMPERATURE

      if(isfilevar(a,"TSLB"))
        tsoil = wrf_user_getvar(a,"TSLB",0)
        dimsl = dimsizes(tsoil)
        do level = 0, dimsl(0)-1
          slevel = level+1
          opts = res
          opts@cnFillOn = True
          opts@gsnSpreadColorEnd = -10
          opts@PlotLevelID = "Level  " + slevel
          contour = wrf_contour(a,wks,tsoil(level,:,:),opts)
          plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        end do
        delete(opts)
        delete(tsoil)
      end if


      opts = res
      opts@cnFillOn = True
      opts@ContourParameters = (/ 240.,300.,5./)
      opts@gsnSpreadColorEnd = -10

      if(isfilevar(a,"ST000010"))
        tsoil = wrf_user_getvar(a,"ST000010",0)
        contour = wrf_contour(a,wks,tsoil,opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        delete(tsoil)
      end if
      if(isfilevar(a,"ST010040"))
        tsoil = wrf_user_getvar(a,"ST010040",0)
        contour = wrf_contour(a,wks,tsoil,opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        delete(tsoil)
      end if
      if(isfilevar(a,"ST040100"))
        tsoil = wrf_user_getvar(a,"ST040100",0)
        contour = wrf_contour(a,wks,tsoil,opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        delete(tsoil)
      end if
      if(isfilevar(a,"ST100200"))
        tsoil = wrf_user_getvar(a,"ST100200",0)
        contour = wrf_contour(a,wks,tsoil,opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        delete(tsoil)
      end if

      delete(opts)

  
    ; SOIL MOISTURE
    
      if(isfilevar(a,"SMOIS"))
        sf_sfc_phys  = a@SF_SURFACE_PHYSICS
        if ( sf_sfc_phys .eq. 2 ) then         ; only available from LSM option
          soilm = wrf_user_getvar(a,"SMOIS",0)
          dimsl = dimsizes(soilm)
          do level = 0, dimsl(0)-1
            slevel = level+1
            opts = res
            opts@cnFillOn = True
            opts@gsnSpreadColorEnd = -10
            opts@PlotLevelID = "Level  " + slevel
            contour = wrf_contour(a,wks,soilm(level,:,:),opts)
            plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
          end do
          delete(opts)
          delete(soilm)
        end if
      end if


      opts = res
      opts@cnFillOn = True
      opts@gsnSpreadColorEnd = -10

      if(isfilevar(a,"SM000010"))
        soilm = wrf_user_getvar(a,"SM000010",0)
        contour = wrf_contour(a,wks,soilm,opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        delete(soilm)
      end if
      if(isfilevar(a,"SM010040"))
        soilm = wrf_user_getvar(a,"SM010040",0)
        contour = wrf_contour(a,wks,soilm,opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        delete(soilm)
      end if
      if(isfilevar(a,"SM040100"))
        soilm = wrf_user_getvar(a,"SM040100",0)
        contour = wrf_contour(a,wks,soilm,opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        delete(soilm)
      end if
      if(isfilevar(a,"SM100200"))
        soilm = wrf_user_getvar(a,"SM100200",0)
        contour = wrf_contour(a,wks,soilm,opts)
        plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
        delete(soilm)
      end if

      delete(opts)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end
