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
    "ids": ["m29lF","TdP8l","bNTKz","8uX66","Ckql5","QSQo0","aDOB3","K59kU","6wIm8","eXBG0","TE5DT","cTDnE","aT7iD","Bfvou","yUAGA","8SuEA","lSm9e","2cQf1","nfk72","jwVac","OIDFL","tlGm5","fXeDq","rWX41"],
    "patch": {"folderId": 84532}
}

response = requests.request("PATCH", url, json=payload, headers=headers)

print(response.text)
