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
OUTPUTDIR=/tmp/output

for DIR in $INTERMED_DIR $OUTPUTDIR; do
  if [ ! -d $DIR ]; then
    mkdir $DIR
  fi
done

grep -h $COUNTRY $INPUTDIR/20????.csv | dos2unix | sort > $OUTPUTDIR/$COUNTRY_tail.csv
cat ../raw/header.csv $OUTPUTDIR/$COUNTRY_tail.csv > $OUTPUTDIR/$COUNTRY.csv

exit 0

