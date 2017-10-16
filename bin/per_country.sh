#!/bin/bash
#Purpose:     extract data for one country and sort by month
# 2016.06.18   S.Kim

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo 'Usage: $(basename $0) -c country -y "YYYY1 YYYY2", e.g. $(basename $0) -c Syrien "2016 2017"'
}

while getopts "c:y:" opt; do
    case $opt in
        c)  COUNTRY="$OPTARG"
            ;;
        y)  YEARS="$OPTARG"
            ;;
        *)  usage
            ;;
    esac
done

INPUTDIR=../raw
OUTPUTDIR=../cooked
if [ ! -d $OUTPUTDIR ]; then
  mkdir $OUTPUTDIR
fi
cat /dev/null > $OUTPUTDIR/$COUNTRY_tail.csv

for YEAR in $YEARS; do
  grep -h $COUNTRY $INPUTDIR/$YEAR/${YEAR}??.csv | dos2unix | sort >> $OUTPUTDIR/$COUNTRY_tail.csv
done

cat $OUTPUTDIR/dateheader.csv $OUTPUTDIR/$COUNTRY_tail.csv > $OUTPUTDIR/$COUNTRY.csv

exit 0

