#!/bin/bash
#

DEBUG=1
#WIDTH=("240" "320" "480" "640" "720")
WIDTH=("720" "480" "320" "240")
#WIDTH=("720" "480")
#HEIGHT=("320" "480" "640" "720" "1280")
HEIGHT=("1280" "640" "480" "320")
#FPS=("1/1" "15/1" "30/1" "60/1")
FPS=("60/1" "30/1" "15/1" "1/1")
#FPS=("60/1")
LOCATION="/home/lefv2603/projects/gae724/videos/20200308/20200308_150241.mp4"

echo -e "" > /tmp/run_deepscene_batch.trace
#
for fps in "${FPS[@]}"; do
  echo "FPS is ${fps}" | tee -a /tmp/run_deepscene_batch.trace
  for idx in "${!WIDTH[@]}"; do
    width=${WIDTH[${idx}]}
    height=${HEIGHT[${idx}]}
    echo "WIDTHxHEIGTH is \"${width}\"x\"${height}\"" | tee -a /tmp/run_deepscene_batch.trace
    source /home/lefv2603/run_deepscene.sh -d "${DEBUG}" -w "${width}" -h "${height}" -f "${fps}" -l "${LOCATION}" &
    pid="$!"
    wait $pid || { echo "there were errors" >&2; exit 1; }
  done 
done

