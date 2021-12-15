import configparser, requests, json

config = configparser.ConfigParser()
config.read('config.ini')

headers = {
    "Accept": "*/*",
    "Content-Type": "application/json",
    "authorization": "Bearer " + config['SECRETS']['DatawrapperToken'],
}
url = "https://api.datawrapper.de/v3/charts?folderId=84534&order=DESC&orderBy=createdAt&limit=100&offset=0&expand=false"

response = requests.request("GET", url, headers=headers)

liste = response.json()['list']
for entry in liste:
  print(entry["publicId"])
  
