import configparser, requests
  
config = configparser.ConfigParser()
config.read('config.ini')

headers = {
    "Accept": "*/*",
    "Content-Type": "application/json",
    "authorization": "Bearer " + config['SECRETS']['DatawrapperToken'],
}

url = "https://api.datawrapper.de/v3/charts"

payload = {
    "ids": ["w8qk5"],
    "patch": {"folderId": 84534}
}

response = requests.request("PATCH", url, json=payload, headers=headers)

