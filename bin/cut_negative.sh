#!/bin/bash
#Purpose:      Give me a per country csv, and I'll cut columns, only leaving
#              YearMonth , negative
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
# Format changed slightly, we had a "" column until 201605
# I should probably do this with csvtools ... sorry.
sed -i 's/,"",/,/' $FILE
csvcut -d, -c1,12,7 $FILE > $OUTPUTDIR/${FILE_BASE}_cut_negative.csv
sed '1s/.*/YEAR_MONTH,Asylberechtigt,Fluechtling, subs. Schutz,Abschiebungsverbot,Abgelehnt,sonstige Verfahrenserledigungen/' $OUTPUTDIR/${FILE_BASE}_cut.csv > $OUTPUTDIR/tmpfile.csv
mv $OUTPUTDIR/tmpfile.csv  $OUTPUTDIR/${FILE_BASE}_cut.csv

exit 0

