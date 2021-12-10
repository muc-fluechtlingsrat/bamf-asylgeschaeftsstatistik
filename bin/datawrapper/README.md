# datawrapper API code

see [docs](https://developer.datawrapper.de/docs) and [reference](https://developer.datawrapper.de/reference/introduction)

Get your API token and:

```
curl --request GET      --url 'https://api.datawrapper.de/v3/charts?order=DESC&orderBy=createdAt&limit=100&offset=0'      --header 'Accept: */*' --header "Authorization: Bearer xxx" > /tmp/chartlist

```

IDs on the 2019 2020 page:
m29lF TdP8l bNTKz 8uX66 Ckql5 QSQo0 aDOB3 K59kU 6wIm8 eXBG0 TE5DT cTDnE aT7iD Bfvou yUAGA 8SuEA lSm9e 2cQf1 nfk72 jwVac OIDFL tlGm5 fXeDq rWX41

1. move them into datawrapper folder
2. change their data source to `2019_2020` (in github repo)
3. publish them newly
4. download png
(manually replace png)

for `2020_2021` page:

1. copy them all
2. into their folder
3. change data source
4. change title
5. get ids
6. publish
7. establish refresh (?)

Also, rewrite text, and upload the pngs to the new page.
