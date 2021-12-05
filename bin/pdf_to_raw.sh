#!/bin/bash

while getopts 'ymt:h' opt; do
  case "$opt" in
    y)
      YEAR="$OPTARG"
      ;;

    m)
      MONTH="$OPTARG"
      ;;

    t)
      GITTOKEN="$OPTARG"
      ;;
   
    ?|h)
      echo "Usage: $(basename $0) -y YEAR YYYY -m MONTH MM -t GITTOKEN"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

# translate to German month name. You need the locale generated for this.
MONATSNAME=$(LC_ALL=de_DE.utf8 date -d "2000-$MONTH-11" +%B)
PDF=hkl-antrags-entscheidungs-bestandsstatistik-$MONATSNAME_LC-$YEAR.pdf

# get the pdf
wget "https://www.bamf.de/SharedDocs/Anlagen/DE/Statistik/Asylgeschaeftsstatistik/$PDF?__blob=publicationFile&v=2" -O $PDF

# run tabula.sh 
./bamf-asylgeschaeftsstatistik/bin/tabula.sh $PDF $YEAR$MONTH.csv

# git push the new csv
mv $YEAR$MONTH.csv bamf-asylgeschaeftsstatistik/raw/$YEAR
git add ../raw/$YEAR/$YEAR$MONTH*.csv
git -c "user.name=ynux" -c "user.email=ynux@gmx.net" commit -m "adding raw $MONATSNAME $YEAR data" ../raw/$YEAR/$YEAR$MONTH*.csv

git push https://ynux:$GITTOKEN@github.com/muc-fluechtlingsrat/bamf-asylgeschaeftsstatistik.git
