# must preprocess files.txt to make individual files w/filenames in them
# e.g. 1.txt contains the first 5 filenames
# recommended so that mapbox tiling can happen in parallel without
# tons of tilesets that can't all be used on a single map

FILEDIR="/data/thursday"
OUTDIR="$FILEDIR/out"

mkdir $OUTDIR

# download all non-.ovr files

cat files.txt | grep -v -e ".ovr" | xargs wget

fname=thurs-mosaic
filelist=local.txt

gdalbuildvrt -input_file_list $FILEDIR/${filelist} $OUTDIR/$fname.vrt
gdalwarp -s_srs EPSG:4326 -t_srs EPSG:3857 -of vrt -overwrite $OUTDIR/${fname}.vrt $OUTDIR/${fname}_wm.vrt
gdal_translate -co tiled=yes -co bigtiff=yes -co compress=jpeg -co photometric=ycbcr -co BLOCKXSIZE=256 -co BLOCKYSIZE=256 -of Gtiff $OUTDIR/mosaic_wm.vrt $OUTDIR/${fname}_wm.tif
python upload.py ${fname}_wm.tif

#########################################
# Old process below                     #
# Fallback if MB chokes on giant raster #
# 2h max processing time                #
#########################################


# this files.txt happened to split into 8 groups of ~5 filenames.
# process each one individually
# 1. Making vrt just simplifies things a bit by defining a web mercator mosaic.
# 2. Warp the input files, with proper internal compression. Much faster
# processing this way since file sizes are much smaller than otherwise.
# 3. Use Mapbox's upload API to kick off processing into tiles

#for i in {1..8};
#do
#    gdalbuildvrt -input_file_list $FILEDIR/$i.txt $OUTDIR/$i.vrt
#    gdalwarp -s_srs EPSG:4326 -t_srs EPSG:3857 -of vrt -overwrite $OUTDIR/${i}.vrt $OUTDIR/${i}_wm.vrt
#    gdal_translate -co tiled=yes -co bigtiff=yes -co compress=jpeg -co photometric=ycbcr -co BLOCKXSIZE=256 -co BLOCKYSIZE=256 -of Gtiff $OUTDIR/${i}_wm.vrt $OUTDIR/${i}_wm.tif
#    python upload.py ${i}
#done
