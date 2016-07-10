#!/bin/bash
#Purpose:      Give me a per country csv, and I'll cut columns, only leaving
#              YearMonth, Total Applications, positive, negative, other
# 2016.06.18   S.Kim

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

for DIR in $OUTPUTDIR; do
  if [ ! -d $DIR ]; then
    mkdir $DIR
  fi
done

csvcut -d, -c1,9,10,11,12,13,14 $FILE > $OUTPUTDIR/${FILE_BASE}_cut.csv
sed '1s/.*/YEAR_MONTH,Asylberechtigt,Fluechtling, subs. Schutz,Abschiebungsverbot,Abgelehnt,sonstige Verfahrenserledigungen/' $OUTPUTDIR/${FILE_BASE}_cut.csv > $OUTPUTDIR/tmpfile.csv
mv $OUTPUTDIR/tmpfile.csv  $OUTPUTDIR/${FILE_BASE}_cut.csv

exit 0

