#!/bin/bash
#Purpose:     extract year from filename and add it as first column
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
re='[0-9]{4}.csv'
s=${FILE##*/}
if ! [[ $s =~ $re ]] ; then
   echo "The filename $s doesn't follow the expected pattern YYYY.csv, exiting"; exit 1
fi
FILE_BASE=${s%.*}
FILE_FIRSTFOUR=${s:0:4}
INTERMED_DIR=../intermediate

for DIR in $INTERMED_DIR; do
  if [ ! -d $DIR ]; then
    mkdir $DIR
  fi
done
echo "Adding $FILE_FIRSTFOUR"

ALREADY_RUN=$(grep -c YEAR_MONTH $FILE)
if [ $ALREADY_RUN -ne 0 ]; then
  echo "I think I did this file already"
  exit 2
fi
cat $FILE | sed "s/^/${FILE_FIRSTFOUR},/" >  $INTERMED_DIR/${FILE_BASE}_with_date.csv
head -1 $INTERMED_DIR/${FILE_BASE}_with_date.csv | sed "s/^${FILE_FIRSTFOUR}/YEAR_MONTH/" >  $INTERMED_DIR/${FILE_BASE}_datehead.csv
tail -n +2 $INTERMED_DIR/${FILE_BASE}_with_date.csv > $INTERMED_DIR/${FILE_BASE}_datetail.csv
cat $INTERMED_DIR/${FILE_BASE}_datehead.csv $INTERMED_DIR/${FILE_BASE}_datetail.csv > $INTERMED_DIR/${FILE_BASE}_date.csv

if [ -f $INTERMED_DIR/${FILE_BASE}_date.csv ]; then
  mv $INTERMED_DIR/${FILE_BASE}_date.csv ${FILE}
fi

exit 0

