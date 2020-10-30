#!/bin/bash

#
# Copies pictures recursive 
# and preserving the directory structure
# from a source dir to a target dir
# by its min rating
#
# Prerequisites:
# - exiv2
# 
# Command line parameters:
# 1. minimal rating. Range from 1 till 5. 
# 2. source dir
# 3. target dir. Will be created if does not exist.
# 

set -e -u

min_rating=$1
source_dir=$2
target_dir=$3

if [[ "$min_rating" != [1-5] ]]; then 
    echo "wrong rating '$min_rating'" >&2; 
    exit 1;
fi 

log_file=$target_dir/copybyrating.log

log () {
   echo -e `date "+%Y:%m:%d %H:%M:%S"`: $@
}

mkdir -p $target_dir
target_dir=`realpath $target_dir`

cd $source_dir

log "started..."
copied=0
while read -d $'\0' file
do
    rating=`exiv2 -K Exif.Image.Rating -Pv "$file" || true`
    if [ -n "$rating" ] && [ "$rating" -ge 3 ]; then 
        cp --parents "$file" "$target_dir"
        (( copied=copied+1 ))
    fi
done < <( find . -type f -print0 )

log "finished, copied $copied."
