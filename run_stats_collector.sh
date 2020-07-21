#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit
fi

if [ -z "$1" ]
  then
  echo "No argument supplied"
fi

REASON=$1
[ -d ${REASON} ] && rm -rf ${REASON}

mkdir ${REASON}

# tegrastats stat collect
TEGRASTATS_FILENAME=${REASON}/"tegrastats-`date +%Y%m%dT%H%M%S`.log"
sudo tegrastats | while read a; do echo "$a" | awk -v now="$(date +%s)" '{OFS=" "}{print now" "$0}' >> ${TEGRASTATS_FILENAME};  done &

# free -m stat collect
FREE_FILENAME=${REASON}/"free-`date +%Y%m%dT%H%M%S`.log"
sudo free -m -s 1 -t -l | while read a; do echo "$a" | awk -v now="$(date +%s)" '{OFS=" "}{if(NF==7) {print now" "$0;} else {print $0;}}' >> ${FREE_FILENAME};  done &

# iotop stat collect
IOTOP_FILENAME=${REASON}/"iotop-`date +%Y%m%dT%H%M%S`.log"
sudo iotop --batch --time --only --processes --kilobytes > ${IOTOP_FILENAME}

wait
echo "done"
