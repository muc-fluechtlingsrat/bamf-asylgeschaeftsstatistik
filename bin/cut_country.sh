#!/bin/bash
#Purpose:      Give me a per country csv, and I'll cut columns, only leaving
#              YearMonth, Total Applications, positive, negative, other
#              If d "delete to" is set, delete old months up to this date
# 2016.06.18   S.Kim

set -euo pipefail
#set -vx

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo 'Usage: $(basename $0) -f file_cooked_country.csv -d YYYY-MM, e.g. ./cut_country.sh -f ../cooked/Iran.csv -d "2016-12" '
}

while getopts "f:d:" opt; do
    case $opt in
        f)  FILE="$OPTARG"
            ;;
        d)  SINCE="$OPTARG"
            ;;
        *)  usage
            ;;
    esac
done

SINCE="${SINCE:-FULL}"
s=${FILE##*/}
FILE_BASE=${s%.*}
OUTPUTDIR=../cooked

if [ ! -d $OUTPUTDIR ]; then
  mkdir $OUTPUTDIR
fi
# Format changed slightly, we had a "" column until 201605
# I should probably do this with csvtools ... sorry.
sed -i 's/,"",/,/' $FILE
csvcut -d, -c1,8,9,10,11,12,13 $FILE > $OUTPUTDIR/${FILE_BASE}_cut.csv
sed '1s/.*/YEAR_MONTH,Asylberechtigt,Fluechtling, subs. Schutz,Abschiebungsverbot,Abgelehnt,sonstige Verfahrenserledigungen/' $OUTPUTDIR/${FILE_BASE}_cut.csv > $OUTPUTDIR/tmpfile.csv
if [ "$SINCE" = "FULL" ]; then
  mv $OUTPUTDIR/tmpfile.csv  $OUTPUTDIR/${FILE_BASE}_cut.csv
else 
 # echo "Removing rows before $SINCE"
 sed "2,/^$SINCE/d" $OUTPUTDIR/tmpfile.csv > $OUTPUTDIR/${FILE_BASE}_cut.csv
fi

echo "$OUTPUTDIR/${FILE_BASE}_cut.csv"
exit 0

