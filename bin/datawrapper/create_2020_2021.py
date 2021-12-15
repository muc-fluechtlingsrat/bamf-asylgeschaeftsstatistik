import configparser, requests, json, logging

logging.basicConfig(level=logging.DEBUG)
config = configparser.ConfigParser()
config.read('config.ini')

headers = {
    "Accept": "*/*",
    "Content-Type": "application/json",
    "authorization": "Bearer " + config['SECRETS']['DatawrapperToken'],
}

copy_id_abs = "m29lF"
copy_id_pct = "TdP8l"
folder_id = "84534"
countries = json.loads(config['DATA']['countries'])

def copy_and_move(copy_id, folder_id):
  url_copy = "https://api.datawrapper.de/v3/charts/" + copy_id + "/copy"
  response_copy = requests.request("POST", url_copy, headers=headers)
  logging.debug("copy: " + str(response_copy.status_code))
  public_id = response_copy.json()['publicId']
  # move to new folder
  payload = {
    "ids": [public_id],
    "patch": {"folderId": folder_id}
  }
  url = "https://api.datawrapper.de/v3/charts"
  response_move = requests.request("PATCH", url, json=payload, headers=headers)
  logging.info("move: " + response_move.text)
  return public_id

def change_title_and_source(chart_id, YYYY1_YYYY2, source_suffix, title_suffix):
  url = "https://api.datawrapper.de/v3/charts/" + chart_id
  response_get = requests.request("GET", url, headers=headers)
  logging.debug("get: " + response_get.text)
  external_data_url = response_get.json()['metadata']['data']['external-data']
  external_data_url_list = external_data_url.split('/') 
  external_data_url_list[7] = YYYY1_YYYY2
  external_data_url_list[8] = country + source_suffix
  external_data_url = '/'.join(external_data_url_list)
  title = country + title_suffix
  payload = {
         "metadata": {
           "data": {
             "external-data": 
               external_data_url
           }
         },
         "title": title
       }
  response_patch = requests.request("PATCH", url, json=payload, headers=headers)
  logging.debug("patch: " + str(response_patch.status_code))

for country in countries:
  logging.info("Do absolute chart for " + country)
  abs_chart_id = copy_and_move(copy_id_abs, folder_id)
  logging.info("New chart " + abs_chart_id)
  logging.info("Do percentage chart for " + country)
  change_title_and_source(abs_chart_id, "2020_2021", "_cut.csv", " 2020/2021")
  pct_chart_id = copy_and_move(copy_id_pct, folder_id)
  logging.info("New chart " + pct_chart_id)
  change_title_and_source(pct_chart_id, "2020_2021", "_cut_nixsonst.csv", " 2020/2021 in percent")

