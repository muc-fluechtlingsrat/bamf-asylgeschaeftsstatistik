#!/bin/bash
#Purpose:     extract yearmonth from filename and add it as first column
# 2016.06.18   S.Kim created
# 2018.02.16   S.Kim make data iso 

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo "Usage: $(basename $0) filename"
}

if [ $# -ne 1 ]; then
  usage;
  exit 2
fi

FILE=$1
re='[0-9]{6}_no_laendercode.csv'
s=${FILE##*/}
if ! [[ $s =~ $re ]] ; then
   echo "The filename $s doesn't follow the expected pattern YYYYMM_no_laendercode.csv, exiting"; exit 1
fi
FILE_BASE=${s%.*}
FILE_FIRSTSIX_ISO=${FILE_BASE:0:4}-${FILE_BASE:4:2}
INTERMED_DIR=../intermediate

for DIR in $INTERMED_DIR; do
  if [ ! -d $DIR ]; then
    mkdir $DIR
  fi
done
echo "Adding $FILE_FIRSTSIX_ISO"

ALREADY_RUN=$(grep -c YEAR_MONTH $FILE)
if [ $ALREADY_RUN -ne 0 ]; then
  echo "I think I did this file already"
  exit 2
fi
cat $FILE | sed "s/^/${FILE_FIRSTSIX_ISO},/" >  $INTERMED_DIR/${FILE_BASE}_with_date.csv
head -1 $INTERMED_DIR/${FILE_BASE}_with_date.csv | sed "s/^${FILE_FIRSTSIX_ISO}/YEAR_MONTH/" >  $INTERMED_DIR/${FILE_BASE}_datehead.csv
tail -n +2 $INTERMED_DIR/${FILE_BASE}_with_date.csv > $INTERMED_DIR/${FILE_BASE}_datetail.csv
cat $INTERMED_DIR/${FILE_BASE}_datehead.csv $INTERMED_DIR/${FILE_BASE}_datetail.csv > $INTERMED_DIR/${FILE_BASE}_date.csv

if [ -f $INTERMED_DIR/${FILE_BASE}_date.csv ]; then
  mv $INTERMED_DIR/${FILE_BASE}_date.csv ${FILE}
fi

exit 0

