#!/bin/bash
# Purpose:    Clean and prepare data from bamf PDFs
#             Replace minus signs with zeros, and delete continent sum rows
#             and dots in numbers
# Remark:     csvkit only usable once we got clean csv   
# 2016.06.18  S.Kim

SCRIPTNAME=$(basename $0 .sh)

function usage {
  echo "Usage: $(basename $0) filename"
}

FILE=$1

if [ "$1" = "" ]; then
  usage
  exit 1
fi

set -euo pipefail
#set -vx
s=${FILE##*/}
FILE_BASE=${s%.*}
INTERMED_DIR=../intermediate
FILE_PATH=${FILE%/*}
YEAR=${FILE_BASE:0:4}

# create temp folder
mkdir -p $INTERMED_DIR || true

# careful - copy to workdir
cp ${FILE} $INTERMED_DIR/${FILE_BASE}.csv
# We don't want the rows with: Spalte 1, 
sed -i '/^Spalte 1/d' $INTERMED_DIR/${FILE_BASE}.csv 
# Replace minus signs
sed -i 's/,-/,0/g' $INTERMED_DIR/${FILE_BASE}.csv
# Remove dots in numbers
sed -i 's/\([0-9]\)\.\([0-9]\)/\1\2/g' $INTERMED_DIR/${FILE_BASE}.csv 
# Write these to another file - they have one column less, "Laendercode": Europa, 
# Afrika, Amerika, Asien, Unbekannt, Herkunftsländer gesamt ...
# ... Australien with Laendercode 523 is the country, Australien without the continent:
sed -n '/^Europa/p;/^Afrika/p;/^Amerika/p;/^Asien/p;/Australien,[^523]/p;/^Unbekannt/p;/^Herkunftslaender/p' $INTERMED_DIR/${FILE_BASE}.csv > $INTERMED_DIR/${FILE_BASE}_no_laendercode.csv

# remove the no_laendercodes from the main csv
grep -Fvxf $INTERMED_DIR/${FILE_BASE}_no_laendercode.csv $INTERMED_DIR/${FILE_BASE}.csv > $INTERMED_DIR/${FILE_BASE}_cleaned.csv

csvclean -n $INTERMED_DIR/${FILE_BASE}_no_laendercode.csv && csvclean -n $INTERMED_DIR/${FILE_BASE}_cleaned.csv

if [ -f $INTERMED_DIR/${FILE_BASE}_cleaned.csv ]; then
  mv $INTERMED_DIR/${FILE_BASE}_cleaned.csv ${FILE}
fi
if [ -f $INTERMED_DIR/${FILE_BASE}_no_laendercode.csv ]; then
  mv $INTERMED_DIR/${FILE_BASE}_no_laendercode.csv ../raw/${YEAR}/${FILE_BASE}_no_laendercode.csv
fi

echo "I produced ${FILE} and ${FILE_PATH}/${FILE_BASE}_no_laendercode.csv for you"

exit 0
