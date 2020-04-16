#!/bin/bash

usage () { echo "Usage : $0 -d <--debug=[1*|2|3|4|5]> -w <--width=[240|320|480|720*|768|800|832|864|1024|1152|1280]> -h <--height=[240|320|480|720|768|800|832|864|1024|1152|1280*]> -f <--fps=1..30..60*/1> -l <--location=/home/lefv2603/projects/gae724/videos/20200308/20200308_152338.mp4>"; }

DEBUG=1
WIDTH=240   #320o 480o 720o (720p) 768o  832x  768x  800x  864x  900x  960x 1080x(1080p)
HEIGHT=320 #576o 640o 1280o       1024o 1120x 1280x 1280x 1152x 1280x 1600x 1920x
# 
# works (320,576), (480,640), (720,1280), (768,1024), (768x1152), (800,1152), (832,1024), (864,1024)
# does not work (832,1120), (832,1152), (768,1280), (800,1280), (864,1152), (900,1152), (900,1280), (960,1600), (1080,1920), (1024,1024)
FPS=60/1
LOCATION="/home/lefv2603/projects/gae724/videos/20200308/20200308_152338.mp4"
#LOCATION="/home/lefv2603/projects/gae724/videos/20200308/20200308_150945.mp4"
BITRATE=28000000 # 28026 kbps futur use

#if [ $# -ne 5 ]
#then
  #usage
  #exit 1
#fi

while getopts d:w:h:f:l: opt ; do
  case $opt in
    d) DEBUG=$OPTARG ;;
    w) WIDTH=$OPTARG ;;
    h) HEIGHT=$OPTARG ;;
    f) FPS=$OPTARG ;;
    l) LOCATION=$OPTARG ;;
    #*) usage; exit 1;;
  esac
done

# source (or .) to execute a shell script in the same proce4ss, keeping and sharing the env var. 
source /home/lefv2603/init.sh 

GST_DEBUG=${DEBUG} gst-launch-1.0 --gst-debug -v filesrc location=${LOCATION} ! qtdemux ! h264parse ! nvv4l2decoder enable-max-performance=1 ! nvvidconv flip-method=3 ! videorate ! videoscale ! "video/x-raw(memory:NVMM), format=(string)NV12, width=(int)${WIDTH}, height=(int)${HEIGHT}, framerate=(fraction)${FPS}" ! nvvidconv ! videorate ! videoscale ! "video/x-raw, format=(string)I420, width=(int)${WIDTH}, height=(int)${HEIGHT}, framerate=(fraction)${FPS}" ! decodebin ! videoconvert ! videoscale ! "video/x-raw,format=(string)RGB,width=(int)${WIDTH},heigth=(int)${HEIGHT}" ! v4l2sink device=/dev/video1 &

pids="$!"

#~/projects/dusty-nv/jetson-inference/build/aarch64/bin/segnet-camera --camera=/dev/video1 --network=fcn-resnet18-deepscene-864x480 --visualize=mask --alpha=255 &
~/projects/dusty-nv/jetson-inference/build/aarch64/bin/segnet-camera.py --camera=/dev/video1 --network=fcn-resnet18-deepscene-576x320 --visualize=mask --alpha=255 &

wait $pids || { echo "there were errors" >&2; exit 1; }
source /home/lefv2603/kill_deepscene.sh
