#!/bin/bash
#Purpose:     Clean and prepare data from bamf PDFs
#             Replace minus signs with zeros, and delete Sum Rows
# 2016.06.18   S.Kim

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo "Usage: $(basename $0) filename"
}

FILE=$1
s=${FILE##*/}
FILE_BASE=${s%.*}
# Replace minus signs
cat $FILE | sed 's/,-/,0/g' > ${FILE_BASE}_zeros.csv 

# We don't want the rows with: Spalte 1, Europa, Afrika, Amerika, Asien, Unbekannt, Herkunftsläer gesamt
cat ${FILE_BASE}_zeros.csv | sed '/^Spalte 1/d;/^Europa/d;/^Afrika/d;/^Amerika/d;/^Asien/d;/^Unbekannt/d;/^Herkunnftsl/d' > ${FILE_BASE}_cleaned.csv

exit 0

