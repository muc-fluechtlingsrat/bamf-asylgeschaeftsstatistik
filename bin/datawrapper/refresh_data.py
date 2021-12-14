import configparser, requests, json

config = configparser.ConfigParser()
config.read('config.ini')

headers = {
    "Accept": "*/*",
    "Content-Type": "application/json",
    "authorization": "Bearer " + config['SECRETS']['DatawrapperToken'],
}

#ids = json.loads(config['DATA']['ids_2019_2020'])
ids = ["WlXG7", "RDQlD"]

for id in ids:
  print(id)
  url = "https://api.datawrapper.de/v3/charts/" + id + "/data/refresh"
  response = requests.request("POST", url, headers=headers)
