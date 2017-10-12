# norcal-fires-imagery
Making open imagery of the October 2017 Sonoma-Napa fires available as slippy maps.

Plan:
- [ ] PENDING: Move all [post-event DG data](https://www.digitalglobe.com/opendata/santa-rosa-wildfires/post-event) to an EC2 instance.
- [ ] Try making some false color tifs.
- [ ] Upload to Mapbox using the [uploads](https://www.mapbox.com/api-documentation/#uploads) API.
- [ ] Make a map with everything, like [this one](https://api.mapbox.com/styles/v1/robinkraft/cj8nn4lvp7yoq2ro1klhjltw8.html?fresh=true&title=true&access_token=pk.eyJ1Ijoicm9iaW5rcmFmdCIsImEiOiJQLUp2RU9NIn0.B20c6fiHx0NCgfSOE3HYbw#14.02/38.4891/-122.6985)
- [ ] Blog about what worked, what didn't.

####

Start downloading everything listed on DG site:

```shell
dirnames=( "105001000C598E00" "20300103003FD800SWIR" "103001007107C600" "1040010033CAE100" "1040010034C51100" "1040010033888D00" )

for i in "${dirnames[@]}"
do
  cat files.txt | grep -v ovr | grep $i | xargs wget -P $i/
done
```

####

https://www.digitalglobe.com/opendata/santa-rosa-wildfires/post-event

Background reading
https://dg-cms-uploads-production.s3.amazonaws.com/uploads/document/file/1/ShortwaveInfrared-DS-SWIR_DS_0217.pdf
http://blog.digitalglobe.com/technologies/revealing-the-hidden-world-with-shortwave-infrared-swir-imagery/
http://blog.digitalglobe.com/technologies/our-eyes-can-play-tricks-on-us-but-shortwave-infrared-swir-imagery-reveals-all-part-1-of-2/?utm_source=Part-1-post&utm_medium=blog&utm_campaign=SWIR
http://blog.digitalglobe.com/technologies/use-cases-for-swir-imagery-taking-a-closer-look-part-2-of-2/?utm_source=Part-2-post&utm_medium=blog&utm_campaign=SWIR
http://www.harrisgeospatial.com/Learn/Blogs/Blog-Details/TabId/2716/ArtMID/10198/ArticleID/15700/Using-SWIR-and-LWIR-Imagery-to-Analyze-Forest-Fires.aspx

SWIR todos,:
* create 6,3,1 3-band, 8-bit image
* show along w/smokey visual data - slider of sorts http://microsites.digitalglobe.com/interactive/swir/
