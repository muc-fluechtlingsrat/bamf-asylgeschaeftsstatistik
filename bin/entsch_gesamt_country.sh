#!/bin/bash
#Purpose:      Give me a per country csv, and I'll cut columns, only leaving
#              YearMonth, Country, ENTSCHEIDUNGEN ueber Asylantraege insgesamt
#              COUNTRY=Somalia; SUM_ENTSCH=$(./entsch_gesamt_country.sh ../cooked/${COUNTRY}.csv; \
#               csvstat --sum ../cooked/${COUNTRY}_cut_entsch.csv | grep ENTSCH | cut -d: -f2); \
#               echo "$COUNTRY, $SUM_ENTSCH" >> ../cooked/sum_entsch.csv
# 2017.12.11   S.Kim

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo "Usage: $(basename $0) file"
}

if [ $# -ne 1 ]; then
  usage;
  exit 2
fi

FILE=$1
s=${FILE##*/}
FILE_BASE=${s%.*}
OUTPUTDIR=../cooked
SUFFIX=_cut_entsch

for DIR in $OUTPUTDIR; do
  if [ ! -d $DIR ]; then
    mkdir $DIR
  fi
done
# Format changed slightly, we had a "" column until 201605
# I should probably do this with csvtools ... sorry.
sed -i 's/,"",/,/' $FILE
csvcut -d, -c1,2,7 $FILE > $OUTPUTDIR/${FILE_BASE}${SUFFIX}.csv
sed '1s/.*/YEAR_MONTH,Herkunftsland,ENTSCHEIDUNGEN ueber Asylantraege insgesamt/' $OUTPUTDIR/${FILE_BASE}${SUFFIX}.csv > $OUTPUTDIR/tmpfile.csv
mv $OUTPUTDIR/tmpfile.csv  $OUTPUTDIR/${FILE_BASE}${SUFFIX}.csv

exit 0

