#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit
fi

if [[ -z "$1" || -z "$2" ]]
  then
  echo "argument missing"
fi

REASON=$1
[ -d ${REASON} ] || mkdir ${REASON} 

COMMENTS_FILE="${REASON}/comments.csv"

echo "$(date +%s),\"$2\"" >> ${COMMENTS_FILE}
