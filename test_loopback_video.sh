#!/bin/bash
gst-launch-1.0 filesrc location=~/Downloads/1080p.mp4 ! decodebin name=dec ! queue ! videoconvert ! nvvidconv ! 'video/x-raw(memory:NVMM),width=(int)600,height=(int)300,format=NV12' ! autovideosink dec. ! queue ! decodebin ! nvvidconv ! 'video/x-raw,format=YUY2' ! v4l2sink device=/dev/video1 -e
