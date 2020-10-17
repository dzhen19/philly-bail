import pgeocode
import pandas
import numpy as np
from uszipcode import SearchEngine
search = SearchEngine(simple_zipcode=True)
lat = []
lon = []
data = pandas.read_csv("zipVsBailAmount.csv")
zipcodes = data["zip"]
print(zipcodes.values)
nomi = pgeocode.Nominatim('us')
newData = nomi.query_postal_code(data["zip"].values.tolist())

data['latitude'] = newData['latitude']
data['longitude'] = newData['longitude']
data['latitude'].replace('', np.nan, inplace=True)
data['longitude'].replace('', np.nan, inplace=True)
data = data.dropna(axis=0)
print(len(np.where(pandas.isnull(data))[0]))
data.to_csv("latitudeLongitudeBail(2).csv")
