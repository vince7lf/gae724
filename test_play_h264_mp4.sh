#!/bin/bash
echo "Ctrl+C in the shell terminal to exit the video"
gst-launch-1.0 filesrc location=~/Downloads/1080p.mp4 ! qtdemux ! queue ! h264parse ! nvv4l2decoder enable-max-performance=1 ! nv3dsink -e 
