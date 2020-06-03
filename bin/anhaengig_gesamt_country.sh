#!/bin/bash
#Purpose:      Give me a per country csv, and I'll cut columns, only leaving
#              YearMonth, Country, ANHÄNGIGE VERFAHREN aufgrund von Erstantraegen,ANHÄNGIGE VERFAHREN aufgrund von Folgeantraegen
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
csvcut -d, -c1,2,14,15 $FILE > $OUTPUTDIR/${FILE_BASE}_cut_anhaengig.csv
sed '1s/.*/YEAR_MONTH,Herkunftsland,ANHÄNGIGE VERFAHREN aufgrund von Erstantraegen,ANHÄNGIGE VERFAHREN aufgrund von Folgeantraegen/' $OUTPUTDIR/${FILE_BASE}_cut_anhaengig.csv > $OUTPUTDIR/tmpfile.csv
mv $OUTPUTDIR/tmpfile.csv  $OUTPUTDIR/${FILE_BASE}_cut_anhaengig.csv
echo $OUTPUTDIR/${FILE_BASE}_cut_anhaengig.csv
exit 0

