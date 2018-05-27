#!/bin/bash
# Purpose:     From the monthly BAMF statistics, create csv of 
#              one of the rows over time, per country
#              e.g. ASYLANTRAEGE insgesamt,ASYLANTRAEGE davon Erstantraege,ASYLANTRAEGE davon Folgeantraege,
#              ENTSCHEIDUNGEN ueber Asylantraege insgesamt, ENTSCHEIDUNGEN all flavors, 
#              ENTSCHEIDUNGEN ueber Asylantraege sonstige Verfahrenserledigungen,
#              ANHÄNGIGE VERFAHREN aufgrund von Erstantraegen
# 2018.05.22   S.Kim

set -vx
#set -euo pipefail

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo 'Usage: $(basename $0) -c column -y "YYYY1 YYYY2", e.g. $(basename $0) -c 4 "2016 2017"'
}

while getopts "c:y:" opt; do
    case $opt in
        c)  COLUMN="$OPTARG"
            ;;
        y)  YEARS="$OPTARG"
            ;;
        *)  usage
            ;;
    esac
done

COLHEADER=$(csvcut -c $COLUMN ../raw/header.csv | tr ' ' '_' )
echo "The column number $COLUMN is $COLHEADER."
INPUTDIR=../raw
OUTPUTDIR=../cooked
if [ ! -d $OUTPUTDIR ]; then
  mkdir $OUTPUTDIR
fi
TMPFILE_ALL=/tmp/${SCRIPTNAME}_${COLHEADER}.csv
echo bla > /tmp/antr_gesamt_verlauf_ASYLANTRAEGE_davon_Erstantraege.csv
echo "YEAR_MONTH" > $TMPFILE_ALL
cat "../raw/all_countries.csv" >> "${TMPFILE_ALL}"

for YEAR in ${YEARS}; do
  #for MONTH in {01..12}; do
  for MONTH in {01..12}; do
    TMPFILE_SMALL=/tmp/$(basename ${TMPFILE_ALL} .csv)_${YEAR}_${MONTH}.csv
    echo "YEAR_MONTH, ${YEAR}_${MONTH}" > "${TMPFILE_SMALL}"
    cat ../raw/all_countries.csv | \
    while read COUNTRY; do
set +u
set +e
set +o pipefail
      COUNTRYVAL=$(csvgrep -m "$COUNTRY" -c 2 $INPUTDIR/$YEAR/${YEAR}${MONTH}.csv | grep -v YEAR_MONTH | csvcut -c $COLUMN)
      COUNTRYVAL=${COUNTRYVAL:-0}
set -u
set -e
set -o pipefail
      if [ -z $COUNTRYVAL ]; then COUNTRYVAL=0; fi
      echo "$COUNTRY, $COUNTRYVAL" >> "${TMPFILE_SMALL}"  
    done
    join --nocheck-order -t\, $TMPFILE_ALL ${TMPFILE_SMALL} 1>> "${TMPFILE_ALL}-intermediate" 2>/tmp/joinerrors
    # join cannot do this in place
    mv ${TMPFILE_ALL}-intermediate ${TMPFILE_ALL}
  done
done

mv $TMPFILE_ALL $OUTPUTDIR
echo "$OUTPUTDIR/$(basename $TMPFILE_ALL) is my output."

exit 0

