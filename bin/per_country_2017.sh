#!/bin/bash
#Purpose:     extract data for one country and sort by month
# 2016.06.18   S.Kim

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo "Usage: $(basename $0) country"
}

if [ $# -ne 1 ]; then
  usage;
  exit 2
fi

COUNTRY=$1
INPUTDIR=../raw
OUTPUTDIR=../cooked

for DIR in $OUTPUTDIR; do
  if [ ! -d $DIR ]; then
    mkdir $DIR
  fi
done

grep -h ${COUNTRY} $INPUTDIR/2017??.csv | dos2unix | sort > $OUTPUTDIR/${COUNTRY}_tail_2017.csv
head -1 $INPUTDIR/header.csv | sed "s/^${FILE_FIRSTSIX}/YEAR_MONTH,/" >  $OUTPUTDIR/dateheader.csv


cat $OUTPUTDIR/dateheader.csv $OUTPUTDIR/${COUNTRY}_tail_2017.csv > $OUTPUTDIR/${COUNTRY}_2017.csv

exit 0

