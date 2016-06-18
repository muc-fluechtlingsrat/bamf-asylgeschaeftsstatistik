#!/bin/bash
#Purpose:     extract yearmonth from filename and add it as first row
# 2016.06.18   S.Kim

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo "Usage: $(basename $0) filename"
}

if [ $# -ne 1 ]; then
  usage;
  exit 2
fi

FILE=$1
s=${FILE##*/}
FILE_BASE=${s%.*}
FILE_FIRSTSIX=${s:0:6}
INTERMED_DIR=../intermediate
OUTPUT_DIR=../output
for DIR in $INTERMED_DIR $OUTPUT_DIR ; do
  if [ ! -d $DIR ]; then
    mkdir $DIR
  fi
done
echo "Adding $FILE_FIRSTSIX"

cat $FILE | sed "s/^/${FILE_FIRSTSIX},/" >  $INTERMED_DIR/${FILE_BASE}_with_date.csv
head -1 $INTERMED_DIR/${FILE_BASE}_with_date.csv | sed "s/^${FILE_FIRSTSIX}/YEAR_MONTH/" >  $INTERMED_DIR/${FILE_BASE}_datehead.csv
tail -n +2 $INTERMED_DIR/${FILE_BASE}_with_date.csv > $INTERMED_DIR/${FILE_BASE}_datetail.csv
cat $INTERMED_DIR/${FILE_BASE}_datehead.csv $INTERMED_DIR/${FILE_BASE}_datetail.csv > $INTERMED_DIR/${FILE_BASE}_date.csv

#if [ -f $INTERMED_DIR/${FILE_BASE}_date.csv ]; then
#  mv $INTERMED_DIR/${FILE_BASE}_date.csv $OUTPUT_DIR/${FILE_BASE}.csv
#fi

exit 0

