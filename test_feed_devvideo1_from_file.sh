gst-launch-1.0 filesrc location=~/Downloads/1080p.mp4 ! h264parse ! nvv4l2decoder ! nvvidconv ! 'video/x-raw,width=480,height=480' ! v4l2sink device=/dev/video1 -e
