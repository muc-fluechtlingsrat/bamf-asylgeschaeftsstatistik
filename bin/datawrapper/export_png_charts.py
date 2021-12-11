import configparser, requests, json

config = configparser.ConfigParser()
config.read('config.ini')

headers = {
    "Accept": "image/png",
    "Content-Type": "application/json",
    "authorization": "Bearer " + config['SECRETS']['DatawrapperToken'],
}

ids = json.loads(config['DATA']['ids_2019_2020'])
for id in ids:
  print(id)
  url = "https://api.datawrapper.de/v3/charts/" + id + "/export/png?unit=px&mode=rgb&width=540&plain=false&scale=2&zoom=2&borderWidth=10&download=true&fullVector=false&ligatures=true&transparent=false&logo=auto"
  response = requests.request("GET", url, headers=headers)
  with open( id + '_2019_2020.png', 'wb') as file:
    file.write(response.content)

    
  
  