gst-launch-1.0 -v filesrc location=/home/lefv2603/Downloads/1080p.mp4 ! tee ! qtdemux ! decodebin ! videoconvert ! videoscale ! videorate ! "video/x-raw,format=(string)RGB,width=(int)640,heigth=(int)480,framerate=15/1" ! identity drop-allocation=0 ! v4l2sink device=/dev/video1
