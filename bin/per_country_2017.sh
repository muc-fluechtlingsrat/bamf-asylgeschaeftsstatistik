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


grep -h ${COUNTRY} $INPUTDIR/2016??.csv | dos2unix | sort > $OUTPUTDIR/${COUNTRY}_tail_2017.csv
grep -h ${COUNTRY} $INPUTDIR/2017??.csv | dos2unix | sort >> $OUTPUTDIR/${COUNTRY}_tail_2017.csv

cat $OUTPUTDIR/dateheader.csv $OUTPUTDIR/${COUNTRY}_tail_2017.csv > $OUTPUTDIR/${COUNTRY}_2017.csv
rm $OUTPUTDIR/${COUNTRY}_tail_2017.csv 

exit 0

