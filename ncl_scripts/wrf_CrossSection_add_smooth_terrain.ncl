
;   Example script to produce plots for a WRF real-data run,
;   with the ARW coordinate dynamics option.
;   Plot data on a cross section
;   This script will plot data at a set angle through a specified point

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
  wks = gsn_open_wks(type,"plt_CrossSection_smooth1")


; Set some basic resources
  res = True
  res@MainTitle = "REAL-TIME WRF"
  res@Footer = False
  
  pltres = True

  ter_res = True
  opts_ter = ter_res
  opts_ter@gsnYRefLine = 0.0
  opts_ter@gsnAboveYRefLineColor = "black"
  opts_ter@gsnDraw = False
  opts_ter@gsnFrame = False


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  FirstTime = True
  times  = wrf_user_getvar(a,"times",-1) ; get times in the file
  ntimes = dimsizes(times)          ; number of times in the file

  mdims = getfilevardimsizes(a,"P") ; get some dimension sizes for the file
  nd = dimsizes(mdims)

;---------------------------------------------------------------

  ter  = wrf_user_getvar(a,"ter",0)  
  xlon = wrf_user_getvar(a, "XLONG",0)


  do it = 0,ntimes-1,2             ; TIME LOOP

    print("Working on time: " + times(it) )
    res@TimeLabel = times(it)   ; Set Valid time to use on plots

    tc  = wrf_user_getvar(a,"tc",it)     ; T in C
    rh = wrf_user_getvar(a,"rh",it)      ; relative humidity
    z   = wrf_user_getvar(a, "z",it)     ; grid point height

    if ( FirstTime ) then                ; get height info for labels
      zmin = 0.
      zmax = max(z)/1000.
      nz   = floattoint(zmax/2 + 1)
      FirstTime = False
    end if
    z_values = fspan(zmin,zmax,nz)
    ;printVarSummary(z_values)
    dimzz = dimsizes(z_values)
    opts_ter@trYMaxF = z_values(dimzz-2)*1000


;---------------------------------------------------------------

    do ip = 1, 3      	; we are doing 3 plots
			; all with the pivot point (plane) in the center of the domain
			; at angles 0, 45 and 90
 ;         
 ;                   |
 ;       angle=0 is  |
 ;                   |
 ;        
        if(ip .eq. 1) then
          angle = 90.
        end if
        if(ip .eq. 2) then
          angle = 0.
        end if
        if(ip .eq. 3) then
          angle = 45.
        end if

        plane = new(2,float)
        plane = (/ mdims(nd-1)/2, mdims(nd-2)/2 /)    ; pivot point is center of domain (x,y)
        opts = False  

        rh_plane = wrf_user_intrp3d(rh,z,"v",plane,angle,opts)
        tc_plane = wrf_user_intrp3d(tc,z,"v",plane,angle,opts)
        ter_plane = wrf_user_intrp2d(ter,plane,angle,opts)
        X_plane = wrf_user_intrp2d(xlon,plane,angle,opts)

        rh_plane2 = rh_plane
        tc_plane2 = tc_plane
        cross_dims = dimsizes(rh_plane2)
        rank = dimsizes(cross_dims)
        ;printVarSummary(rh_plane2)
        iz_do = 25
        do iz = 0,24
          iz_do = iz_do-1
          do ix = 0,cross_dims(rank-1)-1
            if ( ismissing(rh_plane2(iz_do,ix)) ) then
              rh_plane2(iz_do,ix) = rh_plane2(iz_do+1,ix)
            end if
            if ( ismissing(tc_plane2(iz_do,ix)) ) then
              tc_plane2(iz_do,ix) = tc_plane2(iz_do+1,ix)
            end if
          end do
        end do

        dim = dimsizes(rh_plane)                      ; Find the data span - for use in labels
        zspan = dim(0)

        
      ; Options for XY Plots
        opts_xy                         = res
        opts_xy@tiYAxisString           = "Height (km)"
        opts_xy@cnMissingValPerimOn     = True
        opts_xy@cnMissingValFillColor   = 0
        opts_xy@cnMissingValFillPattern = 11
        opts_xy@tmYLMode                = "Explicit"
        opts_xy@tmYLValues              = fspan(0,zspan,nz)                    ; Create tick marks
        opts_xy@tmYLLabels              = sprintf("%.1f",fspan(zmin,zmax,nz))  ; Create labels   
        opts_xy@tiXAxisFontHeightF      = 0.020
        opts_xy@tiYAxisFontHeightF      = 0.020
        opts_xy@tmXBMajorLengthF        = 0.02
        opts_xy@tmYLMajorLengthF        = 0.02
        opts_xy@tmYLLabelFontHeightF    = 0.015
        opts_xy@PlotOrientation         = tc_plane@Orientation


      ; Plotting options for RH
        opts_rh = opts_xy
        opts_rh@ContourParameters       = (/ 10., 90., 10. /)
        opts_rh@pmLabelBarOrthogonalPosF = -0.07
        opts_rh@cnFillOn                = True
        opts_rh@cnFillColors            = (/"White","White","White", \
                                            "White","Chartreuse","Green", \
                                            "Green3","Green4", \
                                            "ForestGreen","PaleGreen4"/)

      ; Plotting options for Temperature
        opts_tc = opts_xy
        opts_tc@cnInfoLabelOrthogonalPosF = 0.00
        opts_tc@ContourParameters  = (/ 5. /)


      ; Get the contour info for the rh and temp
        contour_tc = wrf_contour(a,wks,tc_plane,opts_tc)
        contour_rh = wrf_contour(a,wks,rh_plane,opts_rh)
        contour_rh2 = wrf_contour(a,wks,rh_plane2,opts_rh)
        contour_tc2 = wrf_contour(a,wks,tc_plane2,opts_tc)

;Contour terrain cross section
        contour_ter = gsn_csm_xy(wks,X_plane,ter_plane,opts_ter)


      ; MAKE PLOTS         
        ;plot = wrf_overlays(a,wks,(/contour_rh,contour_tc/),pltres)
        ;plot = wrf_overlays(a,wks,(/contour_rh,contour_tc,contour_ter/),pltres)
        ;plot = wrf_overlays(a,wks,(/contour_rh2,contour_tc2/),pltres)
        plot = wrf_overlays(a,wks,(/contour_rh2,contour_tc2,contour_ter/),pltres)

      ; Delete options and fields, so we don't have carry over
        delete(opts_tc)
        delete(opts_rh)
        delete(tc_plane)
        delete(tc_plane2)
        delete(rh_plane)
        delete(rh_plane2)
        delete(X_plane)
        delete(ter_plane)

    end do  ; make next cross section

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  end do        ; END OF TIME LOOP

end
