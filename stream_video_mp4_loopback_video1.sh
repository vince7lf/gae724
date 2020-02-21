#!/bin/bash
# loopback requires to be started
gst-launch-1.0 -v filesrc location=/home/lefv2603/Downloads/1080p.mp4 ! tee name=qtdemux ! decodebin ! videoconvert ! video/x-raw ! v4l2sink device=/dev/video1
