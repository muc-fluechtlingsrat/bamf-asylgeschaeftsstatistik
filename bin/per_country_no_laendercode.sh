#!/bin/bash
# Purpose: extract data for one country and sort by month
#          Special edition for no_laendercode entities, e.g. Herkunftslaender gesamt
# 2016.06.18   S.Kim
# 2021.12.08   S.Kim create dateheader.csv from header.csv

set -euo pipefail
#set -vx

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo "Usage: $(basename $0) -c country -y 'YYYY1 YYYY2', e.g. $(basename $0) -c gesamt -y '2016 2017'"
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
  grep -h $COUNTRY $INPUTDIR/$YEAR/${YEAR}??_no_laendercode.csv | sort >> $OUTPUTDIR/${COUNTRY}_tail.csv
done

# if we grepped for "gesamt", we will also get all the headers
sed -i '/^YEAR_MONTH/d' $OUTPUTDIR/${COUNTRY}_tail.csv 
	  
sed 's/^/YEAR_MONTH,/' ../raw/header.csv > $OUTPUTDIR/dateheader.csv
cat $OUTPUTDIR/dateheader.csv $OUTPUTDIR/${COUNTRY}_tail.csv > $OUTPUTDIR/$COUNTRY.csv
csvclean -n $OUTPUTDIR/$COUNTRY.csv
echo $OUTPUTDIR/$COUNTRY.csv
exit 0

