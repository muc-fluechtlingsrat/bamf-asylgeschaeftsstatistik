FROM mcr.microsoft.com/openjdk/jdk:11-ubuntu

RUN apt update && apt-get install -y csvkit wget git vim && \
locale-gen de_DE.UTF-8 && update-locale LANG=de_DE.UTF-8
RUN git clone https://github.com/muc-fluechtlingsrat/bamf-asylgeschaeftsstatistik.git

ENV YEAR=$YEAR MONTH=$MONTH GITTOKEN=$GITTOKEN

CMD ["/bamf-asylgeschaeftsstatistik/bin/pdf_to_raw.sh","-y","$YEAR","-m","$MONTH","-t","$GITTOKEN"]
