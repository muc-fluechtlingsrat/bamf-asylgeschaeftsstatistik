FROM mcr.microsoft.com/openjdk/jdk:11-ubuntu

RUN apt update && apt-get install -y csvkit wget git vim && \
locale-gen de_DE.UTF-8 && update-locale LANG=de_DE.UTF-8 && \
wget https://github.com/tabulapdf/tabula-java/releases/download/v1.0.5/tabula-1.0.5-jar-with-dependencies.jar
RUN git clone https://github.com/muc-fluechtlingsrat/bamf-asylgeschaeftsstatistik.git

ENV YEAR=$YEAR MONTH=$MONTH GITTOKEN=$GITTOKEN

CMD ["sh", "-c", "/bamf-asylgeschaeftsstatistik/bin/pdf_to_raw.sh","-y","$YEAR","-m","$MONTH","-t","$GITTOKEN"]
