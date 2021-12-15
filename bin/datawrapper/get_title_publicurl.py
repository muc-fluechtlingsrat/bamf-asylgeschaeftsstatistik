import configparser, requests, json

config = configparser.ConfigParser()
config.read('config.ini')

headers = {
    "Accept": "*/*",
    "Content-Type": "application/json",
    "authorization": "Bearer " + config['SECRETS']['DatawrapperToken'],
}

ids = json.loads(config['DATA']['ids_2020_2021'])

for id in ids:
  print(id)
  url = "https://api.datawrapper.de/v3/charts/" + id
  try:
    response = requests.request("GET", url, headers=headers)
    response.raise_for_status()
    public_url = response.json()['publicUrl']
    print(public_url)
    title = response.json()['title']
    print(title)
  except requests.exceptions.HTTPError as err:
    print (err.response.text)
    raise SystemExit(err)
    

  
