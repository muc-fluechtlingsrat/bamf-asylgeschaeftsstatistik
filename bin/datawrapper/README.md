# datawrapper API code

see [docs](https://developer.datawrapper.de/docs) and [reference](https://developer.datawrapper.de/reference/introduction). This is sooo nice even with generated code in many languages.

Get your API token and put it into your config.ini. 

Create an python3 virtualenv and install the requirements.txt. 

Sometimes trying curl is also nice, like to list all your charts:

```
curl --request GET --url 'https://api.datawrapper.de/v3/charts?order=DESC&orderBy=createdAt&limit=100&offset=0' --header 'Accept: */*' --header "Authorization: Bearer xxx" > /tmp/chartlist

```
I experienced a weird behaviour: The python scripts worked one day then stopped the next, while curl was still working. Reading stackoverflow discussions i started to suspect that something in my Wifi config changed but python requests cannot handle it (cache?), so i just disabled and re-enabled my Wifi. This helped. I did not investigate further.

### For the 2019 2020 charts

Datawrapper now lets you organize your charts in teams and folders. This is good and i use it.

1. move all charts of on webpage into datawrapper folder: `move_to_folder.py`
2. fix the colors - somehow one of the greens turned blue: `set_colors.py`
2. change their data source to `2019_2020` (pointing to the raw csv in this github repo): `change_url.py`
3. refresh the charts from the updated data: `refresh_data.py`
3. publish them: `publish_charts.py`
4. download png `export_png_charts.py`
5. put your beautiful new chart pngs with the link to the interactive chart on the web page. To help you with this: `get_title.py`

### For 2020 2021 charts

1. Create folder
1. Add country list to config.php, and for each country:
    3. `create_2020_2021` does:
    2. Copy two charts (not sure what fork would be doing)  
    2. move their folder
    3. change data source
    4. change title. 
2. Then for all
    5. get ids `get_ids_in_folder.py` and add to `config.ini`
    6. refresh `refresh_data.py` 
    7. publish `publish_charts.py`
    8. and download `export_png_charts.py`

