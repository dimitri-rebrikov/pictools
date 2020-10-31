#!/bin/bash

#
# Copies pictures recursive 
# and preserving the directory structure
# from a list. For example produced by findbyrating.sh.
# This is useful if the findbyrating.sh is started on one machine, 
# for example directly on a NAS, but copy operations shall be done
# from another machine, for example on the PC connected to the NAS.
# 
# Command line parameters:
# 1. the list
# 2. the target dir
# 3. the beggining part of the source path of the files in the list to be removed. Optional. This is useful if the path to the share on the PC differs from the path on the NFS.
# 

set -e -u

list_file=$1
target_dir=$2
remove_path=${3:-""}

mkdir -p $target_dir
target_dir=`realpath $target_dir`

while read -d $'\n' source_file
do
    adjusted_file=${source_file#$remove_path}
    echo "$adjusted_file -> $target_dir"
    cp --parents "$adjusted_file" "$target_dir"
done < "$list_file"

