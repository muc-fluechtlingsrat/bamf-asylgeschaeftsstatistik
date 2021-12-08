#!/bin/bash
# Purpose:     extract quota for one country and sort by month
# 2017.10.18   S.Kim

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

if [ -z $COUNTRY -o -z $YEARS ]; then
  usage;
  exit 2
fi

INPUTDIR=../raw
OUTPUTDIR=../cooked
if [ ! -d $OUTPUTDIR ]; then
  mkdir $OUTPUTDIR
fi
OUTPUTFILE=${OUTPUTDIR}/${COUNTRY}_quota.csv
echo "YEAR_MONTH,Herkunftsland,Entscheidungen insgesamt,Ablehnungen,sonstige Erledigungen, bereinigte Schutzquote, BAMF-Schutzquote" > $OUTPUTFILE

for YEAR in $YEARS; do
  for MONTH in {01..12}; do
    if [ -f $INPUTDIR/$YEAR/${YEAR}${MONTH}.csv ]; then
      echo "getting quota for $YEAR $MONTH"
      ./get_schutzquote.sh $INPUTDIR/$YEAR/${YEAR}${MONTH}.csv
      grep -h $COUNTRY $OUTPUTDIR/${YEAR}${MONTH}_quota.csv | sort >> $OUTPUTFILE
    else
       echo "no file $INPUTDIR/$YEAR/${YEAR}${MONTH}.csv found, continuing"
    fi
  done
done
echo $OUTPUTFILE

exit 0

