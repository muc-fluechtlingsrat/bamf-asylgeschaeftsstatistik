
docker build -t rdm_pdftocsv --no-cache=true .

docker run -e MONTH=10 -e YEAR=2020 -e GITTOKEN=xxx rdm_pdftocsv

