#!/bin/bash
# Purpose:     Give me a per country csv, and I'll cut columns, only leaving
#              YearMonth, Total Applications, positive, negative, other
# 2016.06.18   S.Kim
# 2021.12.08   remove option to cut by date

set -vx

SCRIPTNAME=$(basename $0 .sh)

function usage {
   echo 'Usage: $(basename $0) -f <file_cooked_country>.csv -o <outputdir> -s'
}

while getopts "f:o:s" opt; do
    case $opt in
        f)  FILE="$OPTARG"
            ;;
        o)  OUTPUTDIR="$OPTARG"
            ;;
        s)  SONSTIGE=true
            ;;
        *)  usage; exit 0
            ;;
    esac
done

s=${FILE##*/}
FILE_BASE=${s%.*}

if [ ! -d $OUTPUTDIR ]; then
  mkdir $OUTPUTDIR
fi

if [[ $SONSTIGE ]]; then 
csvcut -d, -c "YEAR_MONTH,ENTSCHEIDUNGEN ueber Asylantraege Anerkennungen als Asylberechtigte (Art 16a und Familienasyl),ENTSCHEIDUNGEN ueber Asylantraege Anerkennungen als Fluechtling gem. Par. 3 I AsylG,ENTSCHEIDUNGEN ueber Asylantraege Gewaehrung von subsidiaerem Schutz gem. Par. 4 I AsylG,ENTSCHEIDUNGEN ueber Asylantraege Feststellung eines Abschiebungsverbotes gem. Par. 60 V/VII AufenthG,ENTSCHEIDUNGEN ueber Asylantraege Ablehnungen (unbegr. abgel./offens unbegr. abgel.),ENTSCHEIDUNGEN ueber Asylantraege sonstige Verfahrenserledigungen" $FILE > $OUTPUTDIR/${FILE_BASE}_cut.csv
sed -i.bak '1s/.*/YEAR_MONTH,Asylberechtigt,Fluechtling,subs. Schutz,Abschiebungsverbot,Abgelehnt,sonstige Verfahrenserledigungen/' $OUTPUTDIR/${FILE_BASE}_cut.csv
else
csvcut -d, -c "YEAR_MONTH,ENTSCHEIDUNGEN ueber Asylantraege Anerkennungen als Asylberechtigte (Art 16a und Familienasyl),ENTSCHEIDUNGEN ueber Asylantraege Anerkennungen als Fluechtling gem. Par. 3 I AsylG,ENTSCHEIDUNGEN ueber Asylantraege Gewaehrung von subsidiaerem Schutz gem. Par. 4 I AsylG,ENTSCHEIDUNGEN ueber Asylantraege Feststellung eines Abschiebungsverbotes gem. Par. 60 V/VII AufenthG,ENTSCHEIDUNGEN ueber Asylantraege Ablehnungen (unbegr. abgel./offens unbegr. abgel.)" $FILE > $OUTPUTDIR/${FILE_BASE}_cut_nixsonst.csv
sed -i.bak '1s/.*/YEAR_MONTH,Asylberechtigt,Fluechtling,subs. Schutz,Abschiebungsverbot,Abgelehnt/' $OUTPUTDIR/${FILE_BASE}_cut_nixsonst.csv
fi
