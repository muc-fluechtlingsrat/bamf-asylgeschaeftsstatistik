To create the docker image and extract the data from a BAMF pdf to a csv, then commit it to the repo:

```
docker build -t rdm_bamf --no-cache=true .

docker run -e MONTH=10 -e YEAR=2020 -e GITTOKEN=xxx rdm_bamf
```

The image is also on [docker hub](https://hub.docker.com/repository/docker/ynux/rdm_bamf), but not always in the newest version.

To organize the data by country and prepare the csv files for the visualizations: 

```
docker run rdm_bamf sh -c "cd /bamf-asylgeschaeftsstatistik/bin; ./for_country_do.sh -y 2019_2020 -t <datawrapper_token>
```

to create the datawrapper visualizations, continue with the python scripts in the datawrapper directory.
