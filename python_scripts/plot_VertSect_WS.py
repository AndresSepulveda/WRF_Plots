import numpy as np
import matplotlib.pyplot as plt
from matplotlib.cm import get_cmap
import cartopy.crs as crs
import cartopy.feature as cfeature
from netCDF4 import Dataset

from wrf import (getvar, to_np, vertcross, smooth2d, CoordPair, GeoBounds,
                 get_cartopy, latlon_coords, cartopy_xlim, cartopy_ylim)

# Open the NetCDF file
ncfile = Dataset("wrfout_d01_2021-09-22_00:00:00")

# Get the WRF variables
slp = getvar(ncfile, "slp")
smooth_slp = smooth2d(slp, 3)
ctt = getvar(ncfile, "ctt")
z = getvar(ncfile, "z")
dbz = getvar(ncfile, "dbz")
Z = 10**(dbz/10.)
wspd =  getvar(ncfile, "wspd_wdir", units="kt")[0,:]

# Set the start point and end point for the cross section
start_point = CoordPair(lat=26.76, lon=-80.0)
end_point = CoordPair(lat=26.76, lon=-77.8)

# Compute the vertical cross-section interpolation.  Also, include the
# lat/lon points along the cross-section in the metadata by setting latlon
# to True.
z_cross = vertcross(Z, z, wrfin=ncfile, start_point=start_point,
                    end_point=end_point, latlon=True, meta=True)
wspd_cross = vertcross(wspd, z, wrfin=ncfile, start_point=start_point,
                       end_point=end_point, latlon=True, meta=True)
dbz_cross = 10.0 * np.log10(z_cross)

# Make the contour plot for wind speed
wspd_contours = ax_wspd.contourf(to_np(wspd_cross), cmap=get_cmap("jet"))
# Add the color bar
cb_wspd = fig.colorbar(wspd_contours, ax=ax_wspd)
cb_wspd.ax.tick_params(labelsize=5)

# Set the x-ticks to use latitude and longitude labels
coord_pairs = to_np(dbz_cross.coords["xy_loc"])
x_ticks = np.arange(coord_pairs.shape[0])
x_labels = [pair.latlon_str() for pair in to_np(coord_pairs)]
ax_wspd.set_xticks(x_ticks[::20])
ax_wspd.set_xticklabels([], rotation=45)

# Set the y-ticks to be height
vert_vals = to_np(dbz_cross.coords["vertical"])
v_ticks = np.arange(vert_vals.shape[0])
ax_wspd.set_yticks(v_ticks[::20])
ax_wspd.set_yticklabels(vert_vals[::20], fontsize=4)

ax_wspd.set_ylabel("Height (m)", fontsize=5)
ax_wspd.set_title("Cross-Section of Wind Speed (kt)", {"fontsize" : 7})

plt.savefig("VertSect_WS.png")
