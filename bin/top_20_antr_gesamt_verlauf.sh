#!/bin/bash
# Purpose:     do the antr_gesamt_verlauf for the top 20 countries of origin 
#              (identified by spreadsheet, i confess)
# 2018.05.28   S.Kim

#set -vx
set -euo pipefail

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo 'Usage: $(basename $0) -f antr_verlauf.csv -c top_20_countries.csv'
}

while getopts "f:c:" opt; do
    case $opt in
        f)  VERLAUFFILE="$OPTARG"
            ;;
        c)  COUNTRYFILE="$OPTARG"
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

RESULTFILE=$OUTPUTDIR/$SCRIPTNAME.csv
cat /dev/null > $RESULTFILE
cat $COUNTRYFILE | \
while read COUNTRY; do
  echo $COUNTRY
  grep "$COUNTRY" $VERLAUFFILE >> $RESULTFILE
done

echo "$RESULTFILE is my output."

exit 0

