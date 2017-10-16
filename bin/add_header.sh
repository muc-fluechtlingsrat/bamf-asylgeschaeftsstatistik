#!/bin/bash
#Purpose:     add header as first row
# 2017.10.16   S.Kim

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo "Usage: $(basename $0) filename"
}

if [ $# -ne 1 ]; then
  usage;
  exit 2
fi

FILE=$1
HEADER_FILE=../raw/header.csv
if [ ! -z $HEADER_FILE ]; then
    echo "Sorry, cannot fine $HEADER_FILE , exiting ... "; exit 3
fi

ALREADY_RUN=$(grep -c ASYLANTRAEGE $FILE)
if [ $ALREADY_RUN -ne 0 ]; then
  echo "I think I did this file already"
  exit 2
fi

cat $HEADER_FILE $FILE > /tmp/x.csv; mv /tmp/x.csv $FILE

exit 0

