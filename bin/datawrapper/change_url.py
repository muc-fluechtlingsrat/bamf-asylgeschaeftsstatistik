import configparser, requests, json

config = configparser.ConfigParser()
config.read('config.ini')

headers = {
    "Accept": "*/*",
    "Content-Type": "application/json",
    "authorization": "Bearer " + config['SECRETS']['DatawrapperToken'],
}

ids = json.loads(config['DATA']['ids_2019_2020'])

for id in ids:
  print(id)
  url = "https://api.datawrapper.de/v3/charts/" + id
  print(url)
  response = requests.request("GET", url, headers=headers)
  external_data_url = response.json()['metadata']['data']['external-data']
  external_data_url_list = external_data_url.split('/') 
  external_data_url_list[7] = '2019_2020'
  external_data_url = '/'.join(external_data_url_list)
  print(external_data_url)

  payload = {
         "metadata": {
           "data": {
             "external-data": 
               external_data_url
           }
         }
       }
  print(type(payload))
  response = requests.request("PATCH", url, json=payload, headers=headers)
  

