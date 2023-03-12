#!/bin/bash

#
# Finds pictures recursive in the search dir
# by its min rating
#
# Prerequisites:
# - exiv2
# 
# Command line parameters:
# 1. minimal rating. Range from 1 till 5. 
# 2. search dir
# 

set -e -u

min_rating=$1
search_dir=$2

if [[ "$min_rating" != [1-5] ]]; then 
    echo "wrong rating '$min_rating'" >&2; 
    exit 1;
fi 

while read -d $'\0' file
do
    rating=`exiv2 -K Exif.Image.Rating -K Xmp.xmp.Rating -Pv "$file" | sort -n | tail -1 || true`
    if [ -n "$rating" ] && [ "$rating" -ge 3 ]; then 
        echo $file
    fi
done < <( find "$search_dir" -type f -print0 )
