FILEDIR=$1
OUTDIR="$FILEDIR/out"
fname=$2
$date=$3
filelist=files.txt

mkdir $OUTDIR

echo "$fname.tif" > "$FILEDIR/files.txt"

# Download all the open data (ignoring .ovr overview files) from DG.
# cat files.txt | grep -v -e ".ovr" | xargs wget

# Use gdalbuildvrt to create a virtual raster (VRT) from the raw data.
# This makes it easy to process all the files at once because they’re treated as a single file.
# Also, there's a limit of 15 tilesets on a map style, so for a large number of images a mosaic is a must.
# Side note: VRTs are evaluated lazily, in that nothing happens to the data until you export to a "real" raster file.
# So build up a few different options, then run them all at once at the end.
# Also: VRTs are so cool!
gdalbuildvrt -input_file_list $FILEDIR/${filelist} $OUTDIR/$fname.vrt

# Use gdalwarp to retroject to web mercator. Again use a VRT to delay ac
# This makes tiling faster to avoid Mapbox's 2h timeout for tiling large images.
gdalwarp -s_srs EPSG:4326 -t_srs EPSG:3857 -of vrt -overwrite $OUTDIR/${fname}.vrt $OUTDIR/${fname}_wm.vrt

# Use gdal_translate to create a proper mosaic tif (no longer virtual).
# The raw files from DG are HUGE - 1 gb each because they use very inefficient internal compression, if any at all.
# This command uses more efficient compression and a more effective photometric interpretation (not sure what that is really - I was just using Stack Overflow :)
# Otherwise gdal_translate will take literally days for a large set of large images.
gdal_translate -co tiled=yes -co bigtiff=yes -co compress=jpeg -co photometric=ycbcr -co BLOCKXSIZE=256 -co BLOCKYSIZE=256 -of Gtiff $OUTDIR/${fname}_wm.vrt $OUTDIR/${fname}_final.tif

# Use the Mapbox upload API to get the data into your systems and ready for mapping!
# You'll see a job pop up in Mapbox Studio. When it's done, you can add the tileset to your map.
python /data/upload.py $OUTDIR/${fname}_final.tif $fname $date
