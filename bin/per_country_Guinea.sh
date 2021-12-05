#!/bin/bash
#Purpose:     extract data for one country and sort by month
# 2016.06.18   S.Kim

set -euo pipefail
#set -vx

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo "Usage: $(basename $0) -c country -y 'YYYY1 YYYY2', e.g. $(basename $0) -c Syrien -y '2016 2017'"
}

while getopts "c:y:" opt; do
    case $opt in
        c)  COUNTRY="$OPTARG"
            ;;
        y)  YEARS="$OPTARG"
            ;;
        *)  usage; exit 1
            ;;
    esac
done
if [ $# -ne 4 ]; then usage; exit 2; fi

INPUTDIR=../raw
OUTPUTDIR=../cooked
if [ ! -d $OUTPUTDIR ]; then
  mkdir $OUTPUTDIR
fi
cat /dev/null > $OUTPUTDIR/${COUNTRY}_tail.csv

for YEAR in $YEARS; do
  grep -h $COUNTRY $INPUTDIR/$YEAR/${YEAR}??.csv | grep -v Bissau | sort >> $OUTPUTDIR/${COUNTRY}_tail.csv
done

cat $OUTPUTDIR/dateheader.csv $OUTPUTDIR/${COUNTRY}_tail.csv > $OUTPUTDIR/$COUNTRY.csv
csvclean -n $OUTPUTDIR/$COUNTRY.csv
echo $OUTPUTDIR/$COUNTRY.csv
exit 0

