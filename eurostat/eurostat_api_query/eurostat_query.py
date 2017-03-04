import requests
import json

#this is an example request
baseurl = 'http://ec.europa.eu/eurostat/wdds/'
service = 'rest/data/'
version = 'v2.1/'
fmt     = 'json/'
lang    = 'en/'
dataset = 'nama_gdp_c'
opt     = '?precision=1&geo=EU28&unit=EUR_HAB&time=2010&time=2011&indic_na=B1GM'

#this is a first try to get a document that is interesting for us
dataset = 'tps00180'
opt = ''

#build the url and request the data
url = baseurl + service + version + fmt + lang + dataset + opt
data = requests.get(url, params={'format': 'json'}).json()

#print the data
print (json.dumps(data, sort_keys=True, indent=4))

