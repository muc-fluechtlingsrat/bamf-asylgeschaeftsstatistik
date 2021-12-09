#!/bin/bash
# Purpose:     Create csv by country from csv by month
#              which are the base for the histograms on our webpage refugee-datathon-muc.org
# 2021.12.08   S.Kim
set -vx
while getopts 'y:m:t:h' opt; do
  case "$opt" in
    y)
      FOR_YEARS="$OPTARG"
      ;;
    t)
      GITTOKEN="$OPTARG"
      ;;
    ?|h)
      echo "Usage: $(basename $0) -y FOR_YEARS YYYY_YYYY -t GITTOKEN"
      exit 1
      ;;
  esac
done

set -euo pipefail
# written to be used in our docker container
OUTPUTDIR=../cooked/$FOR_YEARS/

COUNTRIES="Afghanistan Syrien Irak Iran Nigeria Eritrea Pakistan Somalia Russische Tuerkei Ungeklaert Sierra Aethiopien Jemen Libyen Mali Georgien Guinea Albanien Aserbaidschan Moldau Venezuela"
# create per country csv
for COUNTRY in ${COUNTRIES}; do ./per_country.sh -c ${COUNTRY} -y "$FOR_YEARS" -o ${OUTPUTDIR}; done
# create reduced csv for decisions incl. sonstige
for COUNTRY in ${COUNTRIES}; do ./cut_country.sh -f ${OUTPUTDIR}/${COUNTRY}.csv -o ${OUTPUTDIR} -s; done
# create reduced csv for decisions excl. sonstige
for COUNTRY in ${COUNTRIES}; do ./cut_country.sh -f ${OUTPUTDIR}/${COUNTRY}.csv -o ${OUTPUTDIR}; done
# commit all
git config user.email "ynux@gmx.net"
git config user.name "ynux"
git pull
for COUNTRY in ${COUNTRIES}; do git add ${OUTPUTDIR}/${COUNTRY}*.csv; done
for COUNTRY in ${COUNTRIES}; do git commit ${OUTPUTDIR}/${COUNTRY}*.csv -m "did $(basename $0) for years $FOR_YEARS " ; done
# git push interactively
git push https://ynux:"$GITTOKEN"@github.com/muc-fluechtlingsrat/bamf-asylgeschaeftsstatistik.git
