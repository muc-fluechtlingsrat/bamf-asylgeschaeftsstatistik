#!/bin/bash
#Purpose:     Clean and prepare data from bamf PDFs
#             Replace minus signs with zeros, and delete continent sum rows
#             and dots in numbers
# 2016.06.18   S.Kim

set -ef -o pipefail

SCRIPTNAME=$(basename $0 .sh)

function usage {
  echo "Usage: $(basename $0) filename"
}

FILE=$1

if [ "$1" = "" ]; then
  usage
  exit 1
fi

set -u

s=${FILE##*/}
FILE_BASE=${s%.*}
INTERMED_DIR=../intermediate

# create temp folder
mkdir -p $INTERMED_DIR

# Replace minus signs
sed 's/,-/,0/g' $FILE > $INTERMED_DIR/${FILE_BASE}_zeros.csv

# We don't want the rows with: Spalte 1, Europa, Afrika, Amerika, Asien, Unbekannt, Herkunftsländer gesamt
sed '/^Spalte 1/d;/^Europa/d;/^Afrika/d;/^Amerika/d;/^Asien/d;/^Unbekannt/d;/^Herkunftsl.nder/d' $INTERMED_DIR/${FILE_BASE}_zeros.csv > $INTERMED_DIR/${FILE_BASE}_no_continents.csv

# Remove second Australien (first ist the country, second is the continent)
gawk '/Australien/ && seen { next } /Australien/ && !seen { seen=1 } 1' $INTERMED_DIR/${FILE_BASE}_no_continents.csv > $INTERMED_DIR/${FILE_BASE}_no_australia.csv

# Replace dots in numbers
sed 's/\([0-9]\)\.\([0-9]\)/\1\2/g' $INTERMED_DIR/${FILE_BASE}_no_australia.csv > $INTERMED_DIR/${FILE_BASE}_cleaned.csv

if [ -f $INTERMED_DIR/${FILE_BASE}_cleaned.csv ]; then
  mv $INTERMED_DIR/${FILE_BASE}_cleaned.csv ${FILE}
fi

exit 0