#!/bin/bash
url=https://apod.nasa.gov/apod/
#url=https://apod.nasa.gov/apod/ap130213.html
#url=https://apod.nasa.gov/apod/ap130918.html
#url=https://apod.nasa.gov/apod/ap160804.html
prefix=ch_
if [ $# -gt 0 ]; then
  url=$1
fi
imageurl=`curl $url 2> /dev/null | grep IMG | cut -d\" -f2` 
filename=`echo $imageurl | cut -d/ -f3`
if [ -z $filename ]; then
  echo "Problem finding filename"
  exit 2
fi

curl https://apod.nasa.gov/apod/$imageurl -o $filename 2> /dev/null
size=`identify $filename | cut -d' ' -f3`

eog $filename
echo -n "Use new image? "
read ans

if [ $ans == "y" -o $ans == "yes" ]; then
  convert chblank.png -resize $size tmp_resize_chblank.png
  composite -gravity south tmp_resize_chblank.png $filename calvin.jpg
  rm tmp_resize_chblank.png
  feh --bg-scale calvin.jpg
fi
rm $filename

#echo "Composite image created: $prefix$filename"
