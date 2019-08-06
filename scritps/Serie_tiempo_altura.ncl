    begin
    ;********************************************************
    ; read in netCDF file and make a loop for all time steps
    ;********************************************************
      in     = addfile("./wrfout_d01_2019-06-21_00:00:00.nc","r")
     Latitude = 14.3779
     Longitude = -77.2934
     altura = 280    ; in m

    ;********************************************************
    ; Process all the time steps
    ;********************************************************

    times = wrf_user_list_times(in)     ; get times in the file
    ntimes = dimsizes(times)            ; number of times in the file
    windspd = new(ntimes,float)         ; creation of a Windspeed vector at each time step

    do it = 0,1 ;ntimes-1                  ;Loop for the time: it= starting time

    time = it

    res = True      
    res@returnInt = True                       ; False : return real values, True: return interger values
    point = wrf_user_ll_to_ij(in,Longitude,Latitude,res)       ; wrf_user_ll_to_ij(nc_file,lon,lat,opt)
     
     x = point(0)
     y = point(1)


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

    ;*******************************************************************************
    ;     - Interpolate wind speed and wind direction at 80m height -          *
    ;*******************************************************************************
 
          ; Interpolate U,V to altura in Meters
          u_plane  = wrf_user_intrp3d( u,height,"h", altura,0.,False)
          v_plane  = wrf_user_intrp3d( v,height,"h", altura,0.,False)
     
          ; Calculate Wind Speed from Vectors
          spd = (u_plane*u_plane + v_plane*v_plane)^(0.5)
          windspd(it)=spd(x,y)

          ; Wind direction at 80 Meters
          r2d = 45.0/atan(1.0)       ; conversion factor (radians to degrees)
          dir = atan2(u_plane,v_plane) * r2d + 180
          dir80 = dir(x,y)

          ; Wind Speed
          spd@description = "Wind Speed"
          spd@units = "m/s"
          u_plane@units = "m/s"

    end do

    ;************************************************************
    ;  - Print the variables at the screen -                    *
    ;************************************************************

    npts=ntimes
    fName = ("serie_tiempo_viento_"+altura+"m_en_Lat_"+Latitude+"_Lon_"+Longitude+".txt")
    data  = new( npts, "string")
            
    print("  Time    Wind_speed        " + altura + " m ")
    print("X,Y location is: " + x + "," + y) 

    do it = 0,1 ;ntimes-1

        print (sprintf("%5.0f",it)    +" " \
                 +sprintf("%23.2f", windspd(it)) +"  " )
    end do                     ; end of time loop

    do it = 0,1 ;ntimes-1

       data (it)= (sprintf("%5.0f",it)    +" " \
                 +sprintf("%23.2f", windspd(it)) +"  " )
    end do                     ; end of time loop

 asciiwrite (fName , data)

end


