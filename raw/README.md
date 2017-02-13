# Rohdaten hinter der monatl. Asylgeschäftsstatistik

Auf dem ersten [Refugee Datathon München](https://refugee-datathon-muc.org) haben wir eine [IFG-Anfrage bei FragDenStaat](https://fragdenstaat.de/anfrage/rohdaten-hinter-monatl-asylgeschaftsstatistik/) an das BAMF gestellt, um die Rohdaten hinter der [monatlich veröffentlichten Asylgeschäftsstatistik](http://www.bamf.de/DE/Infothek/Statistiken/Asylzahlen/Asylgesch%C3%A4ftsstatistik/asylgeschaeftsstatistik-node.html) zu bekommen.
Das BAMF hat uns daraufhin [monatliche PDFs bereitgestellt](https://fragdenstaat.de/anfrage/rohdaten-hinter-monatl-asylgeschaftsstatistik/#nachricht-50896).

In diesem Repository haben wir die PDFs in CSV-Dateien konvertiert, um später damit Visualisierungen erstellen zu können.

## HowTo

Benötigt:

* PDFs des [BAMF aus der IFG-Anfrage](https://fragdenstaat.de/anfrage/rohdaten-hinter-monatl-asylgeschaftsstatistik/)
* [Tabula](http://tabula.technology) Herunterladen, starten, warten, auf http://localhost:8080/ finden. Es braucht java.

1. Importiere eine Monats-PDF in Tabula
2. Markiere nur den Inhalt der Tabelle - nicht den Header (damit kann Tabula nicht umgehen). Nutze _Repeat this Selection_ um alle Seiten mitzunehmen.
![](../docs/hkl-tabula-1.png)

3. Klicke auf **Preview & Export Extracted Data**. Stelle dann (links) die **Extraction Method** auf **Lattice**
![](../docs/hkl-tabula-2.png)

4. Prüfe, ob die Daten so aussehen wie im Screenshot darüber. Es sollten keine leeren Spalten zwischen den Zahlen existieren.
5. Exportiere als CSV.
6. Kopiere die CSV-Datei als YYYYMM.csv in das raw-Verzeichnis.
6. Füge jeder CSV als erste Zeile den Inhalt der `header.csv` hinzu.
7. Rufe `../bin/clean_csv.sh 2015.csv` (z.b. für 2015.csv) auf, um die Daten zu putzen (`-` durch `0` ersetzen, Zwischenüberschriften weg, etc.)
8. Rufe `../bin/add_date.sh 2015.csv` auf, um Jahr und Monat als erste Zeile hinzuzufuegen
9. Falls erwuenscht, rufe `../bin/per_country.sh Syrien` auf - extrahiert alle Zeilen fuer Syrien
10. Falls erwuenscht, rufe `../bin/cut_country.sh ../cooked/Syrien.csv` auf - reduziert auf die Spalten JahrMonat, Antraege gesamt, positive, negative, sonstige

