#!/bin/bash
# Following https://github.com/tabulapdf/tabula-java/wiki/Using-the-command-line-tabula-extractor-tool
# First argument is the downloaded pdf from http://www.bamf.de/SharedDocs/Anlagen/DE/Downloads/Infothek/Statistik/Asyl/
# e.g. $HOME/Downloads/hkl-antrags-entscheidungs-bestandsstatistik-februar-2018.pdf
# Second is the target file, in our example 201802.csv

SCRIPTNAME=$(basename $0 .sh)
function usage {
   echo "Usage: $0 input.pdf output.csv, e.g. $0 hkl-antrags-entscheidungs-bestandsstatistik-februar-2018.pdf 201802.csv "
}
if [ "$#" -ne 2 ]; then
  usage;
  exit 1;
fi
set -vx
num_pages=$(qpdf --show-npages "$1")
TABULAJAR=/tabula-1.0.5-jar-with-dependencies.jar
for page in $(seq 1 1 $num_pages); do
  java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p $page "$1" >> $2
done

