#!/bin/bash

if [ $# -eq 0 ]; then
  echo "No arguments provided"
  echo "Please provide path"
  exit 1
fi

HOME="/home/lefv2603/projects/gae724/videos"
FILES="${HOME}/$1"

[ ! -d "${FILES}" ] && { echo "Directory '${FILES}' does not exist."; exit 1; }

echo "parsing .mp4 files in ${FILES}"
for ext in mp4; do 
  files=( "${FILES}"/*."$ext" )
  printf 'number of %s files: %d\n' "$ext" "${#files[@]}"

  # loop over all the files having the current extension
  for f in "${files[@]}"; do
    echo "Processing $f file..."
    filename=$(basename -- "$f")
    extension="${filename##*.}"
    filename="${filename%.*}"
    echo "extension is '${extension}'"
    echo "filename is '${filename}'"

    # make dir if it does not exist
    [ ! -d "${FILES}/${filename}" ] && { echo "Creating directory '${FILES}/${filename}'"; mkdir "${FILES}/${filename}"; }

    # extract images from videos, every 5 frames
    gst-launch-1.0 -v filesrc location=${f} ! qtdemux ! decodebin ! queue ! nvvidconv flip-method=3 ! videorate ! 'video/x-raw,framerate=1/5' ! nvjpegenc ! multifilesink location="${FILES}/${filename}/${filename}_%d.jpg"
  done 
done
