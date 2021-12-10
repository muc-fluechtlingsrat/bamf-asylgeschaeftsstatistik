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

ids = ["m29lF","TdP8l","bNTKz","8uX66","Ckql5","QSQo0","aDOB3","K59kU","6wIm8","eXBG0","TE5DT","cTDnE","aT7iD","Bfvou","yUAGA","8SuEA","lSm9e","2cQf1","nfk72","jwVac","OIDFL","tlGm5","fXeDq","rWX41"]

for id in ids:
  url = "https://api.datawrapper.de/v3/charts/" + id
  response = requests.request("PATCH", url, json=payload, headers=headers)
  print(response.text)
