# Following https://github.com/tabulapdf/tabula-java/wiki/Using-the-command-line-tabula-extractor-tool
# First argument is the downloaded pdf from http://www.bamf.de/SharedDocs/Anlagen/DE/Downloads/Infothek/Statistik/Asyl/
# e.g. $HOME/Downloads/hkl-antrags-entscheidungs-bestandsstatistik-februar-2018.pdf
# Second is the target file, in our example ../raw/2018/201802.csv

# the number of columns are different, some will be 27, those without laendercode 26, so the result will not be a clean csv table

SCRIPTNAME=$(basename $0 .sh)
function usage {
   echo "Usage: $0 input.pdf output.csv, e.g. $0 hkl-antrags-entscheidungs-bestandsstatistik-februar-2018.pdf 201802.csv "
}
if [ "$#" -ne 2 ]; then
  usage;
  exit 1;
fi

set -vx
TABULAJAR=./tabula-1.0.3-jar-with-dependencies.jar
java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p 1 "$1" > $2
java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p 2 "$1" >> $2
java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p 3 "$1" >> $2
java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p 4 "$1" >> $2
java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p 5 "$1" >> $2
java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p 6 "$1" >> $2

