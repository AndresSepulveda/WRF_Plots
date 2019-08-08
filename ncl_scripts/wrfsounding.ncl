; wrfsoundings.ncl
; WRF RR/HRRR NCL plotting scripts
; Curtis Alexander
; NOAA/OAR/ESRL/GSD/AMB
; 18 March 2009
;
; This script plots vertical profiles of temperature, dewpoint and wind
; from one or two files at given location(s).

;
; Set NetCDF file paths/names here and add extension (.nc)
;
FILENAME1="wrfout_d01_2012-09-10_00:00:00.nc"
FILENAME2="wrfout_d01_2012-09-10_03:00:00.nc"

;
; Change lat/lon of sounding points here
;
LAT1= -23.5
LON1= -46.6
LAT2= -23.5
LON2= -46.6

;
; Change time step here
;
TIME1=0
TIME2=0

;
; Change GRIB vertical level type here (p for pressure or n for natural)
;
LEVELS="p"

;
; Change output file path/name here without filename extension
;
OUTFILENAME=""+FILENAME1+""

;
; Change NetCDF field names here
;
PBTEMPNAME1="T"
QVAPORNAME1="QVAPOR"
BAPRESNAME1="PB"
PBPRESNAME1="P"
BAGEOPNAME1="PHB"
PBGEOPNAME1="PH"
UCOMPNAME1="U"
VCOMPNAME1="V"
PBTEMPNAME2="T"
QVAPORNAME2="QVAPOR"
BAPRESNAME2="PB"
PBPRESNAME2="P"
BAGEOPNAME2="PHB"
PBGEOPNAME2="PH"
UCOMPNAME2="U"
VCOMPNAME2="V"
NLATNAME="XLAT"
NLONNAME="XLONG"

; Load additional NCL functions
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/skewt_func.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

  ; Set plotting resources
  res					= True

  ; Resources for plot size
  ;res@gsnMaximize			= True
  res@gsnDraw				= False
  res@gsnFrame				= False
  res@tfDoNDCOverlay			= True
 
  ; Resources for map background
  res@mpDataBaseVersion			= "Ncarg4_1"
  res@mpDataSetName			= "Earth..2"
  res@mpOutlineBoundarySets             = "GeophysicalAndUSStates"
  ;res@mpOutlineBoundarySets             = "AllBoundaries"
  res@mpDataResolution			= "FinestResolution"
  res@mpGridAndLimbOn			= True
  res@mpGridLatSpacingF			= 5.0
  res@mpGridLonSpacingF			= 5.0
  res@mpPerimOn				= True
  res@mpPerimLineThicknessF		= 2.0
  res@mpUSStateLineThicknessF		= 2.0
  res@mpNationalLineThicknessF		= 2.0
  res@mpGeophysicalLineThicknessF	= 2.0
  res@mpProjection			= "LambertConformal"
  res@mpLimitMode			= "Corners"
  res@pmTickMarkDisplayMode 		= "Always"

  ; Resources for title text
  res@tiMainFont			= 22
  res@tiMainFontHeightF			= 0.012

  ; Resources for map marker
  mres					= True
  mres@gsMarkerColor			= "red"
  mres@gsMarkerSizeF			= 0.01
  mres@gsMarkerThicknessF		= 2.0

  ; Set SkewT background options
  skewtOpts                  		= True

  ; Resources for title text
  skewtOpts@tiMainFont			= 22
  skewtOpts@tiMainFontHeightF		= 0.015

  ; Resources for skewT background
  skewtOpts@DrawColAreaFill  		= True
  skewtOpts@DrawHeightScale  		= True
  skewtOpts@DrawHeightScaleFt 		= False
  skewtOpts@DrawFahrenheit    		= True

  ; Resources for workstation
  skewtOpts@wkBackgroundColor		= "white"
  skewtOpts@wkForegroundColor		= "black"

  ; Set SkewT data options 
  dataOpts 				= True
  dataOpts@ThermoInfo       		= False
  dataOpts@PrintZ			= False

  ; Resources for output filetype and resolution
  wkstype				= "pdf"
  ;wkstype				= "png"
  ;wkstype@wkWidth			= 1280
  ;wkstype@wkHeight			= 960

  ; Resources for workstation colors
  wkstype@wkBackgroundColor		= "white"
  wkstype@wkForegroundColor		= "black"
  
  ; Resources for workspace
  wsMaximumSize				= 32556688 


  ; Open output file
  wks = gsn_open_wks(wkstype, OUTFILENAME)
 
  ; Load two files
  file1 = addfile(FILENAME1,"r")
  file2 = addfile(FILENAME2,"r")

  ; Determine if NetCDF or GRIB file
  count=2
  extension=systemfunc("echo " +FILENAME1+ " | cut -d '.' -f "+count+"")
  do while (extension.ne."")
    count = count + 1
    delete(extension)
    extension=systemfunc("echo " +FILENAME1+ " | cut -d '.' -f "+count+"")
  end do
  count = count - 1
  delete(extension)
  extension=systemfunc("echo " +FILENAME1+ " | cut -d '.' -f "+count+"")

    ; Determine dimensions of the fields
    lats = file1->$NLATNAME$(TIME1,:,:)
    lons = file1->$NLONNAME$(TIME1,:,:)
    dims = dimsizes(lats)
    numx = dims(1)
    numy = dims(0)

    ; Get the closest grid points for the lat/lon points
    gridpts1 = wrf_latlon_to_ij(lats, lons, LAT1, LON1)
    gridpts2 = wrf_latlon_to_ij(lats, lons, LAT2, LON2)
    i1 = gridpts1(0)
    j1 = gridpts1(1)
    i2 = gridpts2(0)
    j2 = gridpts2(1)

    ; Get fields from file
    pbtemp1 = file1->$PBTEMPNAME1$(TIME1,:,i1,j1)
    qvapor1 = file1->$QVAPORNAME1$(TIME1,:,i1,j1)
    bapress1 = file1->$BAPRESNAME1$(TIME1,:,i1,j1)
    pbpress1 = file1->$PBPRESNAME1$(TIME1,:,i1,j1)
    bageopot1 = file1->$BAGEOPNAME1$(TIME1,:,i1,j1)
    pbgeopot1 = file1->$PBGEOPNAME1$(TIME1,:,i1,j1)
    uwrf1 = file1->$UCOMPNAME1$(TIME1,:,:,:)
    vwrf1 = file1->$VCOMPNAME1$(TIME1,:,:,:)
    pbtemp2 = file1->$PBTEMPNAME2$(TIME2,:,i2,j2)
    qvapor2 = file1->$QVAPORNAME2$(TIME2,:,i2,j2)
    bapress2 = file1->$BAPRESNAME2$(TIME2,:,i2,j2)
    pbpress2 = file1->$PBPRESNAME2$(TIME2,:,i2,j2)
    bageopot2 = file1->$BAGEOPNAME2$(TIME2,:,i2,j2)
    pbgeopot2 = file1->$PBGEOPNAME2$(TIME2,:,i2,j2)
    uwrf2 = file1->$UCOMPNAME2$(TIME2,:,:,:)
    vwrf2 = file1->$VCOMPNAME2$(TIME2,:,:,:)

    ; Set map projection information
    res@mpLambertParallel1F             = file1@TRUELAT1
    res@mpLambertParallel2F             = file1@TRUELAT2
    res@mpLambertMeridianF              = file1@STAND_LON
    res@mpLeftCornerLatF                = lats(0,0)
    res@mpLeftCornerLonF                = lons(0,0)
    res@mpRightCornerLatF               = lats(numy - 1, numx - 1)
    res@mpRightCornerLonF               = lons(numy - 1, numx - 1)

    ; Change variables to absolute reference
    temp1 = pbtemp1 + 300
    press1 = bapress1 + pbpress1
    geopot1 = bageopot1 + pbgeopot1
    temp2 = pbtemp2 + 300
    press2 = bapress2 + pbpress2
    geopot2 = bageopot2 + pbgeopot2

    ; Calculate temperature and dewpoint temperature 
    tk1 = wrf_tk(press1, temp1)
    tdk1 = wrf_td(press1, qvapor1) + 273.15
    tk2 = wrf_tk(press2, temp2)
    tdk2 = wrf_td(press2, qvapor2) + 273.15

    ; Calculate earth-relative wind -- need to check staggered grid wind extraction
    uvmet1 = wrf_uvmet(uwrf1, vwrf1, lats, lons, file1@STAND_LON, 0)
    u1 = uvmet1(0,:,i1,j1)
    v1 = uvmet1(1,:,i1,j1)
    uvmet2 = wrf_uvmet(uwrf2, vwrf2, lats, lons, file1@STAND_LON, 0)
    u2 = uvmet2(0,:,i2,j2)
    v2 = uvmet2(1,:,i2,j2)

    ; Set heights to missing since they are on a different vertical grid
    z1 = press1
    z1@_FillValue = -999
    z1 = -999
    z2 = press2
    z2@_FillValue = -999
    z2 = -999

  ; Convert variables to appropriate units (celcius for temps, mb for pressure, kts for wind)
  r2d = 45.0/atan(1.0)
  t1 = tk1 - 273.15
  td1 = tdk1 - 273.15
  p1 = press1/100.0
  Uspd1 = 1.94384449*sqrt(u1*u1 + v1*v1)
  Udir1 = atan2(u1, v1) * r2d + 180.0
  t2 = tk2 - 273.15
  td2 = tdk2 - 273.15
  p2 = press2/100.0
  Uspd2 = 1.94384449*sqrt(u2*u2 + v2*v2)
  Udir2 = atan2(u2, v2) * r2d + 180.0
  tdiff = t1 - t2
  tddiff = td1 - td2
  zdiff = z1 - z2
  Uspddiff = Uspd1 - Uspd2
  Udirdiff = Udir1 - Udir2

  ; Update lat/lon to grid point position
  LAT1=lats(i1,j1)
  LON1=lons(i1,j1)
  LAT2=lats(i2,j2)
  LON2=lons(i2,j2)

  ;
  ; Change title for each plot here or leave blank
  ;
  TITLE1=""+FILENAME1+" Time: "+TIME1+" Lat1: "+LAT1+" Lon1: "+LON1+""
  TITLE2=""+FILENAME2+" Time: "+TIME2+" Lat2: "+LAT2+" Lon2: "+LON2+""
  TITLE3=""+FILENAME1+" - "+FILENAME2+" Time: "+TIME1+" Lat1: "+LAT1+" Lon1: "+LON1+""

  ; Plot points on map
  res@tiMainString     			= TITLE1
  plot = gsn_map(wks, res@mpProjection, res)
  mres@gsMarkerIndex			= 16
  marker1 = gsn_add_polymarker(wks, plot, LON1, LAT1, mres)
  mres@gsMarkerIndex			= 4
  marker2 = gsn_add_polymarker(wks, plot, LON2, LAT2, mres)
  draw(plot)
  frame(wks)

  ; Plot sounding background
  skewtOpts@tiMainString     		= TITLE1
  skewt_bkgd = skewT_BackGround(wks, skewtOpts)
  draw(skewt_bkgd)

  ; Resources for first sounding
  dataOpts@colTemperature 		= "red"
  dataOpts@colDewPt       		= "green"
  dataOpts@colCape        		= "orange"
  dataOpts@colWindP      		= "blue"
  dataOpts@colWindZ       		= "black"                                        
  dataOpts@colWindH     		= "black"                                        
  dataOpts@linePatternTemperature 	= 0
  dataOpts@linePatternDewPt       	= 0
  dataOpts@linePatternCape        	= 0
  dataOpts@xpWind                 	= 45
  skewt_data = skewT_PlotData(wks, skewt_bkgd, p1, t1, td1, z1, Uspd1, Udir1, dataOpts)
  draw(skewt_data)
  ;frame(wks)

  ; Plot sounding background
  ;skewtOpts@tiMainString     		= TITLE2
  ;skewt_bkgd = skewT_BackGround(wks, skewtOpts)
  ;draw(skewt_bkgd)

  ; Set resources for second sounding
  dataOpts@colTemperature 		= "red"
  dataOpts@colDewPt       		= "green"
  dataOpts@colCape        		= "orange"
  dataOpts@colWindP      		= "black"
  dataOpts@colWindZ       		= "black"                                        
  dataOpts@colWindH     		= "black"                                        
  dataOpts@linePatternTemperature 	= 1
  dataOpts@linePatternDewPt       	= 1
  dataOpts@linePatternCape        	= 1
  dataOpts@xpWind                 	= 50
  skewt_data = skewT_PlotData(wks, skewt_bkgd, p2, t2, td2, z2, Uspd2, Udir2, dataOpts)
  draw(skewt_data)
  frame(wks)

end

