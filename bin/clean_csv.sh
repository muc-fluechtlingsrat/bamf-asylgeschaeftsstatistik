#!/bin/bash
#Purpose:     Clean and prepare data from bamf PDFs
#             Replace minus signs with zeros, and delete continent sum rows
#             and dots in numbers 
# 2016.06.18   S.Kim

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo "Usage: $(basename $0) filename"
}

FILE=$1
s=${FILE##*/}
FILE_BASE=${s%.*}
INTERMED_DIR=../intermediate
OUTPUT_DIR=../output
for DIR in $INTERMED_DIR $OUTPUT_DIR ; do
  if [ ! -d $DIR ]; then
    mkdir $DIR
done
# Replace minus signs
cat $FILE | sed 's/,-/,0/g' > $INTERMED_DIR/${FILE_BASE}_zeros.csv 

# We don't want the rows with: Spalte 1, Europa, Afrika, Amerika, Asien, Unbekannt, Herkunftsläer gesamt
cat $INTERMED_DIR/${FILE_BASE}_zeros.csv | sed '/^Spalte 1/d;/^Europa/d;/^Afrika/d;/^Amerika/d;/^Asien/d;/^Unbekannt/d;/^Herkunnftsl/d' > $INTERMED_DIR/${FILE_BASE}_cleaned.csv

if [ -f $INTERMED_DIR/${FILE_BASE}_cleaned.csv ]; then
  mv $INTERMED_DIR/${FILE_BASE}_cleaned.csv $OUTPUT_DIR/${FILE_BASE}.csv
fi
# Replace dots in numbers

exit 0

