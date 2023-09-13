# This code generates a snapshot of Nighttime Lights 
# North and South Korea as of April 2023

# Installing packages: 
#using Pkg
#Pkg.add("Package Name")

# Importing packages:
using Rasters
using GADM
using Statistics
using Plots

# Set your folder path
path = "/Users/meghapatnaik/Dropbox/SATELLITE_ECONOMICS/LUISS/LECTURE_3/"

# Read in Tile 3 for April 2023
# tif file below can be downloaded at: "https://eogdata.mines.edu/nighttime_light/monthly/v10/2023/202304/vcmcfg/"
raster1 = Raster("$path/SVDNB_npp_20230401-20230430_75N060E_vcmcfg_v10_c202305081600.avg_rade9h.tif", lazy=true)

# Crop Tile 3 to Korea bounding box
korea_bounds = X(Between(124.2650, 131.8675)), Y(Between(33.0000, 43.0000))
korea_nl = raster1[korea_bounds...]

# Extreme values messing up the scale of the heat map
plot(korea_nl)

# Winsorize these and redraw the map 
koreanl_2 = copy(korea_nl)
threshold = quantile!(vec(koreanl_2),0.99)
korea_nl[korea_nl .> threshold] .= threshold

# Border between N and S Korea already visible
plot(korea_nl) 

# adding the SK border
southkorea = GADM.get("KOR")
southkorea_border = southkorea.geom

# The bright lights in the sea are likely fishing boats for photophylic squid
plot!(southkorea_border, linewidth=0.5, linecolor = :maroon, fillalpha=0)

# adding the NK border to plot
northkorea = GADM.get("PRK")
northkorea_border = northkorea.geom
plot!(northkorea_border, linewidth=0.5, linecolor = :maroon, fillalpha=0)

# save the plot 
savefig("$path/korea.png")

