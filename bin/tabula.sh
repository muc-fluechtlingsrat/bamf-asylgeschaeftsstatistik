# Following https://github.com/tabulapdf/tabula-java/wiki/Using-the-command-line-tabula-extractor-tool
# First argument is the downloaded pdf from http://www.bamf.de/SharedDocs/Anlagen/DE/Downloads/Infothek/Statistik/Asyl/
# e.g. $HOME/Downloads/hkl-antrags-entscheidungs-bestandsstatistik-februar-2018.pdf
# Second is the target file, in our example ../raw/2018/201802.csv
set -vx
TABULAJAR=./tabula-1.0.2-jar-with-dependencies.jar
java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p 1 "$1" > $2
java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p 2 "$1" >> $2
java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p 3 "$1" >> $2
java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p 4 "$1" >> $2
java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p 5 "$1" >> $2
java -jar ${TABULAJAR} -l -a 192.058,16.838,539.342,827.167 -p 6 "$1" >> $2

csvclean -n $2
