#!/bin/bash

usage () { echo "Usage : $0 -n <--NR=[1|2*]>"; } 

# line number returned by the ps -ef | grep command, matching the process running
if [ -z "${NR}" ]; then 
  NR=1 # defaut if the second line if run by parent process
fi


while getopts n: opt ; do
  case $opt in
    n) NR=$OPTARG ;;
    #*) usage; exit 1;;
  esac
done

echo "NR=${NR}"

myvar=$(ps -ef | grep -e "fcn-resnet18-deepscene"); echo "$myvar" | if [ "$(wc -l)" -gt 1 ]; then kill -9 $(echo "$myvar" | awk -F" " -vnr="${NR}" 'NR==nr {print $2}'); else echo "deepscene not running"; fi
