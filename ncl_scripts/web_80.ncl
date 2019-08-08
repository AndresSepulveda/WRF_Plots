    ; --------------  LOAD FUNCTIONS AND PROCEDURES ----------------

    load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
    load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
    load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
    load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

    ; --------------  BEGINING OF NCL SCRIPT ----------------


    begin
    ;********************************************************
    ; read in netCDF file and make a loop for all time steps
    ;********************************************************
      in     = addfile("/home/mallesh/Downloads/ncl examples/data.nc","r")


    ;********************************************************
    ; Process all the time steps
    ;********************************************************



    times = wrf_user_list_times(in)            ; get times in the file
    ntimes = dimsizes(times)            ; number of times in the file

    T100 = new(ntimes,float)            ; creation of a T vector at each time step
    P98 = new(ntimes,float)               ; creation of a P vector at each time step
    Q = new(ntimes,float)               ; creation of a Q vector at each time step
    rh100 = new(ntimes,float)               ; creation of a RH vector at each time step
    windspd80 = new(ntimes,float)            ; creation of a Windspeed vector at each time step
    ;print(ntimes)

    do it = 0,8784 ;ntimes-1                  ;Loop for the time: it= starting time

    time = it


    ;************************************************
    ;  - Select lon & lat of the point of interest -
    ;************************************************
    ; - The function wrf_user_ll_to_ij find the nearest grid point for a specific lat and lon

    Latitude = 14.3779
    Longitude = 77.2934

    res = True      
    res@returnInt = True                       ; False : return real values, True: return interger values
    point = wrf_user_ll_to_ij(in,Longitude,Latitude,res)       ; wrf_user_ll_to_ij(nc_file,lon,lat,opt)
     
     x = point(0)
     y = point(1)

     ;print("X location is: " + x)            ; print the value of X at the screen
     ;print("Y location is: " + y)            ; print the value of Y at the screen



    ;*************************************************************************************
    ;  - extract wind, Temperature, Pressure, relative humidity and height coordinates-  *
    ;*************************************************************************************

    ; Wind and Height
        u  = wrf_user_getvar(in,"ua",time)        ; u averaged to mass points
        v  = wrf_user_getvar(in,"va",time)        ; v averaged to mass points
        height  = wrf_user_getvar(in, "z",time) ; height is our vertical coordinate
        ter = wrf_user_getvar(in, "ter",time) ; model terrain height (HGT_M, HGT_U, HGT_V)
     
    ; Conform data to Terrain Height   
       nheight = conform(height,ter,(/1,2/)) ; assuming height is a 3d array and ter is a 2d array
       height = height - nheight

    ; Temperature

     T_in = wrf_user_getvar(in, "tc", time)      ; Extract sea level pressure (°C)

    ; Surface Pressure

     P_in = wrf_user_getvar(in, "pressure", time)      ; Extract sea level pressure (Pa)



    ; Relative humidity

     rh_in = wrf_user_getvar(in, "rh", time)      ; Extract relative humidity (%)

    ;print(rh_in)      


    ;*******************************************************************************
    ;     - Interpolate wind speed and wind direction at 80m height -          *
    ;*******************************************************************************


         
         ; Interpolate U,V to 80 Meters
          u_plane  = wrf_user_intrp3d( u,height,"h", 80,0.,False)
          v_plane  = wrf_user_intrp3d( v,height,"h", 80,0.,False)
     
          ; Calculate Wind Speed from Vectors
          spd = (u_plane*u_plane + v_plane*v_plane)^(0.5)
          windspd80(it)=spd(x,y)

          ; Wind direction at 80 Meters
       r2d = 45.0/atan(1.0)       ; conversion factor (radians to degrees)
       dir = atan2(u_plane,v_plane) * r2d + 180
       dir80 = dir(x,y)

          ; Wind Speed
          spd@description = "Wind Speed"
          spd@units = "m/s"
          u_plane@units = "m/s"

    ;************************************************************
    ;  - Interpolate temperature at 100m height -                *
    ;************************************************************
       T_plane  = wrf_user_intrp3d( T_in,height,"h", 98,0.,False)
       T100(it)=T_plane(x,y)
    ;************************************************************
    ;  - Interpolate P at 98m height -                       *
    ;************************************************************
       P_plane  = wrf_user_intrp3d( P_in,height,"h", 98,0.,False)
       P98(it)=P_plane(x,y)
    ;************************************************************
    ;  - Interpolate rh at 98m height -                       *
    ;************************************************************

       rh_plane  = wrf_user_intrp3d( rh_in,height,"h", 98,0.,False)
       rh100(it)=rh_plane(x,y)
       



    end do



    ;************************************************************
    ;  - Print the variables at the screen -                    *
    ;************************************************************

    npts=ntimes
    fName = "foo_arw_ncl80.txt"
    data  = new( npts, "string")
       
     
    print("  Time      Tc_100m      P_100      RH_98m      Wind_speed_80m        ")
     
    do it = 0,8784 ;ntimes-1

        print (sprintf("%5.0f",it)    +" " \
          +sprintf("%21.2f", T100(it)) +"  " \
                 +sprintf("%19.2f", P98(it)) +"  " \
          +sprintf("%31.2f", rh100(it)) +"  " \
                 +sprintf("%23.2f", windspd80(it)) +"  " )


    end do                     ; end of time loop

    do it = 0,8784 ;ntimes-1

       data (it)= (sprintf("%5.0f",it)    +" " \
          +sprintf("%21.2f", T100(it)) +"  " \
                 +sprintf("%19.2f", P98(it)) +"  " \
          +sprintf("%31.2f", rh100(it)) +"  " \
                 +sprintf("%23.2f", windspd80(it)) +"  " )


    end do                     ; end of time loop

 asciiwrite (fName , data)

end



