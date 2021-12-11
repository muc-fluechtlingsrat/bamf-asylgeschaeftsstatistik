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
  url = "https://api.datawrapper.de/v3/charts/" + id + "/publish"
  response = requests.request("POST", url, headers=headers)
