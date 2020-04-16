#!/bin/bash
sudo jetson_clocks
sudo rmmod ~/projects/v4l2loopback/v4l2loopback.ko
sudo insmod ~/projects/v4l2loopback/v4l2loopback.ko max_buffers=8 devices=1
#sudo insmod ~/projects/v4l2loopback/v4l2loopback.ko max_buffers=8 devices=2
~/projects/v4l2loopback/utils/v4l2loopback-ctl set-fps 60 /dev/video1
#~/projects/v4l2loopback/utils/v4l2loopback-ctl set-fps 60 /dev/video2
#v4l2loopback-ctl set-caps "video/x-raw,format=UYVY,width=640,height=480" /dev/video1
v4l2-ctl -d 1 --all
