      load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
      load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

      nlvmax=69

      f = addfile("wrfout_d01_2013-09-21_18:00:00","r")

      Z = wrf_user_getvar(f,"height", -1) ;m Model Height
      Zter = wrf_user_getvar(f,"ter" , -1) ;m Terrain Height

      Zcat = Z(:,0:nlvmax-1,:,:)

      do kk = 0, nlvmax-1
        Zcat(:,kk,:,:) = Zcat(:,kk,:,:) - Zter
      end do

      print(Zcat(0,:,30,30))
