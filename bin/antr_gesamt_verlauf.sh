#!/bin/bash
# Purpose:     From the monthly BAMF statistics, create csv of 
#              one of the rows over time, per country
#              e.g. ASYLANTRAEGE insgesamt,ASYLANTRAEGE davon Erstantraege,ASYLANTRAEGE davon Folgeantraege,
#              ENTSCHEIDUNGEN ueber Asylantraege insgesamt, ENTSCHEIDUNGEN all flavors, 
#              ENTSCHEIDUNGEN ueber Asylantraege sonstige Verfahrenserledigungen,
#              ANHÄNGIGE VERFAHREN aufgrund von Erstantraegen
# 2018.05.22   S.Kim

#set -vx
set -euo pipefail
IFS=$'\n\t'

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo "Usage: $(basename $0) -c column -y \"YYYY1 YYYY2\", e.g. $(basename $0) -c 4 -y \"2016 2017\" "
}

# you need csvjoin of verion 1 or higher for this
csvjoinversion=$(csvjoin --version 2>&1 | sed -e 's/csvjoin \([0-9]*\)\..*/\1/')
if [ $csvjoinversion -lt 1 ]; then 
  echo "i need csvjoin version > 1.0.0, you have $csvjoinversion"; 
  exit 2
fi

while getopts "c:y:h" opt; do
    case $opt in
        c)  COLUMN="$OPTARG"
            ;;
        y)  IFS=$'\n\t\ '
            YEARS="$OPTARG"
            IFS=$'\n\t'
            ;;
        h)  usage
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
  for MONTH in {01..06}; do
  #for MONTH in {01..12}; do
    if [ -f $INPUTDIR/$YEAR/${YEAR}${MONTH}.csv ]; then
      TMPFILE_SMALL=/tmp/$(basename ${TMPFILE_ALL} .csv)_${YEAR}_${MONTH}.csv
      echo "YEAR_MONTH, ${YEAR}_${MONTH}" > "${TMPFILE_SMALL}"
      cat ../raw/all_countries.csv | \
      while read COUNTRY; do
set +u
set +e
set +o pipefail

        COUNTRY_NOQUOTES=${COUNTRY//\"}
        COUNTRYVAL=$(csvgrep -m "$COUNTRY_NOQUOTES" -c 2 $INPUTDIR/$YEAR/${YEAR}${MONTH}.csv | grep -v YEAR_MONTH | csvcut -c $COLUMN)
        COUNTRYVAL=${COUNTRYVAL:-0}
        #if [ "${COUNTRYVAL}x" == "x" ]; then COUNTRYVAL=0; fi
set -u
set -e
set -o pipefail
        echo "$COUNTRY, $COUNTRYVAL" >> "${TMPFILE_SMALL}"  
      done
      csvjoin -c1 -d\, $TMPFILE_ALL ${TMPFILE_SMALL} 1>> "${TMPFILE_ALL}-intermediate" 2>/tmp/joinerrors
      # join cannot do this in place
      mv ${TMPFILE_ALL}-intermediate ${TMPFILE_ALL}
    fi
  done
done

mv $TMPFILE_ALL $OUTPUTDIR
echo "$OUTPUTDIR/$(basename $TMPFILE_ALL) is my output."

exit 0

