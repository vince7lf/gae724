#!/bin/bash
HOME="/home/lefv2603/projects/dusty-nv/jetson-inference/build/aarch64/bin"
"${HOME}/segnet-camera.py" --network=fcn-resnet18-cityscapes --camera=/dev/video1 --alpha=255
