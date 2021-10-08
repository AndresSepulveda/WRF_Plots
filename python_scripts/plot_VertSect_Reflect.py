# plot_VerSec_Reflec.py
#
# From: https://wrf-python.readthedocs.io/en/latest/plot.html 2021/10/08
#

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
start_point = CoordPair(lat=-37.00, lon=-80.0)
end_point   = CoordPair(lat=-37.00, lon=-77.8)

# Compute the vertical cross-section interpolation.  Also, include the
# lat/lon points along the cross-section in the metadata by setting latlon
# to True.
z_cross = vertcross(Z, z, wrfin=ncfile, start_point=start_point,
                    end_point=end_point, latlon=True, meta=True)
dbz_cross = 10.0 * np.log10(z_cross)

# Create a figure that will have 3 subplots
fig = plt.figure(figsize=(12,9))
ax_dbz = fig.add_subplot(2,2,4)


# Make the contour plot for dbz
levels = [5 + 5*n for n in range(15)]
dbz_contours = ax_dbz.contourf(to_np(dbz_cross), levels=levels,
                               cmap=get_cmap("jet"))
cb_dbz = fig.colorbar(dbz_contours, ax=ax_dbz)
cb_dbz.ax.tick_params(labelsize=5)

# Set the x-ticks to use latitude and longitude labels
coord_pairs = to_np(dbz_cross.coords["xy_loc"])
x_ticks = np.arange(coord_pairs.shape[0])
x_labels = [pair.latlon_str() for pair in to_np(coord_pairs)]
ax_dbz.set_xticks(x_ticks[::20])
ax_dbz.set_xticklabels(x_labels[::20], rotation=45, fontsize=4)

# Set the y-ticks to be height
vert_vals = to_np(dbz_cross.coords["vertical"])
v_ticks = np.arange(vert_vals.shape[0])
ax_dbz.set_yticks(v_ticks[::20])
ax_dbz.set_yticklabels(vert_vals[::20], fontsize=4)

# Set the x-axis and  y-axis labels
ax_dbz.set_xlabel("Latitude, Longitude", fontsize=5)
ax_dbz.set_ylabel("Height (m)", fontsize=5)

# Add a title
ax_dbz.set_title("Cross-Section of Reflectivity (dBZ)", {"fontsize" : 7})

plt.savefig("VertSect_Reflec.pnf")
