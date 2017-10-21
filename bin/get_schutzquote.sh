#!/bin/bash
#Purpose:      Calculate the percentage of positive (OK to stay) decisions
#              (natuerlich die bereinigte Schutzquote, als wuerden wir
#               Dreck produzieren!)
# 2017.10.16   S.Kim

# bereinigt=(G6-M6-L6)/(G6-M6)
# BAMF=(G6-M6-L6)/G6
SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo "Usage: $(basename $0) file"
}

if [ $# -ne 1 ]; then
  usage;
  exit 2
fi

FILE=$1
s=${FILE##*/}
FILE_BASE=${s%.*}
OUTPUTDIR=../cooked

if [ ! -d $OUTPUTDIR ]; then
  mkdir $OUTPUTDIR
fi

# Format changed slightly, we had a "" column until 201605
# I should probably do this with csvtools ... sorry.
sed -i 's/,"",/,/' $FILE
# reduce to relevant columns
csvcut -d, -c1,2,7,12,13 $FILE > $OUTPUTDIR/${FILE_BASE}_quota_tmp.csv
# vFPAT to handle comma in quotes, like "Kongo, Dem. Republik"
awk -vFPAT='([^,]*)|("[^"]+")' -vOFS=, '{if ($4-$4-$5 != 0 && $3-$5 != 0){print $1,$2,$3,$4,$5,100*($3-$4-$5)/($3-$5), 100*($3-$4-$5)/($3)} else {print $1,$2,$3,$4,$5,"nd,nd"}}' $OUTPUTDIR/${FILE_BASE}_quota_tmp.csv > $OUTPUTDIR/${FILE_BASE}_quota.csv
# add header
sed -i '1s/.*/YEAR_MONTH,Herkunftsland,Entscheidungen insgesamt,Ablehnungen,sonstige Erledigungen, bereinigte Schutzquote, BAMF-Schutzquote/' $OUTPUTDIR/${FILE_BASE}_quota.csv 
rm $OUTPUTDIR/${FILE_BASE}_quota_tmp.csv
exit 0

