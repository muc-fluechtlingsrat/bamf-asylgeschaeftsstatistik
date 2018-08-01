#!/bin/bash
#Purpose:      Give me a per country csv, and I'll cut columns, only leaving
#              YearMonth, Country, ASYLANTRAEGE insgesamt (both first and follow up)
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

for DIR in $OUTPUTDIR; do
  if [ ! -d $DIR ]; then
    mkdir $DIR
  fi
done
# Format changed slightly, we had a "" column until 201605
# I should probably do this with csvtools ... sorry.
sed -i 's/,"",/,/' $FILE
csvcut -d, -c1,2,4 $FILE > $OUTPUTDIR/${FILE_BASE}_cut_antraege.csv
sed '1s/.*/YEAR_MONTH,Herkunftsland,ASYLANTRAEGE insgesamt/' $OUTPUTDIR/${FILE_BASE}_cut_antraege.csv > $OUTPUTDIR/tmpfile.csv
mv $OUTPUTDIR/tmpfile.csv  $OUTPUTDIR/${FILE_BASE}_cut_antraege.csv
echo $OUTPUTDIR/${FILE_BASE}_cut_antraege.csv
exit 0

