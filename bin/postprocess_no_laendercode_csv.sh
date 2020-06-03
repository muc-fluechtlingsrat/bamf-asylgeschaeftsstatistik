#!/bin/bash
# Purpose:     clean, add header, add date 
#              special version for no_laendercode rows
# 2018.08.01   S.Kim
#set -xv

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo "Usage: $(basename $0) filename"
}

if [ $# -ne 1 ]; then
  usage;
  exit 2
fi

FILE=$1
if [ ! -f $FILE ]; then
    echo "Sorry, cannot find $FILE , exiting ... "; exit 3
fi

HEADER_FILE=../raw/header.csv
if [ ! -f $HEADER_FILE ]; then
    echo "Sorry, cannot find $HEADER_FILE , exiting ... "; exit 3
fi

ALREADY_RUN=$(grep -c ASYLANTRAEGE $FILE)
if [ $ALREADY_RUN -ne 0 ]; then
  echo "I think I did this file already, exiting"
  exit 2
fi
# and action

### Cleaning - special for no_laendercode
# for some strange reason we have trailing commas
sed -i.bak 's/,$//' $FILE
rm $FILE.bak
### Add empty column where laendercode would be
csvcut -c1 $FILE > /tmp/csv1
sed -i.bak 's/$/,/' /tmp/csv1
csvcut -c2- $FILE > /tmp/csv2
csvjoin -H /tmp/csv1 /tmp/csv2 | tail -n +2 > $FILE
# add header, remove Windows endoflines etc
cat $HEADER_FILE $FILE | dos2unix > /tmp/x.csv; mv /tmp/x.csv $FILE
### Add Date

./add_date_no_laendercode.sh $FILE

### Some Last Checks
# Check if your csv is clean
csvclean -n $FILE
CLEAN=$?
if [ ! $CLEAN ]; then
  echo "Sorry, your csv is not clean"
fi
echo "Enjoy your file: $FILE"
exit 0

