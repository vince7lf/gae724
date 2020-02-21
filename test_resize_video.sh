gst-launch-1.0 filesrc location=~/Downloads/1080p.mp4 ! qtdemux ! h264parse ! nvv4l2decoder ! nvvidconv ! 'video/x-raw(memory:NVMM),width=(int)480, height=(int)480' ! nv3dsink -e
