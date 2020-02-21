#!/bin/bash

DEV=$(zenity --file-selection \
             --filename=/dev/video1 \
             --file-filter='V4L2 loopback devices | video*')

echo "Select a window to capture..."
XID=$(xwininfo -int | grep 'Window id' | awk '{print $4}')

# camera width/height
CW=640
CH=360

gst-launch-1.0 --eos-on-shutdown \
\
ximagesrc use-damage=false show-pointer=false xid=$XID \
! videoconvert \
! videoscale method=0 add-borders=true \
! video/x-raw,width=$CW,height=$CH,format=YUV \
! videorate \
! tee name=displaypipe \
! tee name=recordpipe \
! queue \
! v4l2sink device=$DEV \
\
displaypipe. \
! queue \
! autovideosink \


exit

## Old pipe fragments below

## start x/y
#SX=0
#SY=0
## end x/y
#EX=640
#EY=360

#ximagesrc use-damage=false startx=$SX starty=$SY endx=$EX endy=$EY \

#recordpipe. \
#! queue \
#! vp8enc \
#! webmmux \
#! filesink location=video.webm

