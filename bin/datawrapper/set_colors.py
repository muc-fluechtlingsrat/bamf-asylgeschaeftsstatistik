import configparser, requests
  
config = configparser.ConfigParser()
config.read('config.ini')

headers = {
    "Accept": "*/*",
    "Content-Type": "application/json",
    "authorization": "Bearer " + config['SECRETS']['DatawrapperToken'],
}

payload = {
         "metadata": {
           "visualize": {
             "custom-colors": {
               "Asylberechtigt": "#29a71e",
               "Fluechtling": "#47b01d",
               "subs. Schutz": "#67d45d",
               "Abschiebungsverbot": "#dfff87",
               "Abgelehnt": "#d62728",
               "sonstige Verfahrenserledigungen": "#cccccc",
             },
           }
         }
       }

ids = json.loads(config['DATA']['ids_2019_2020'])

for id in ids:
  print(id)
  url = "https://api.datawrapper.de/v3/charts/" + id
  response = requests.request("PATCH", url, json=payload, headers=headers)
