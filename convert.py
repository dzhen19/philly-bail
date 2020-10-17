import pgeocode
import pandas
from uszipcode import SearchEngine
search = SearchEngine(simple_zipcode=True)
lat = []
lon = []
data = pandas.read_csv("zipVsBailAmount.csv")
zipcodes = data["zip"]
print(zipcodes.values)
for row in zipcodes.values:
    zipcode = search.by_zipcode(row)
    zipcode = zipcode.to_dict()
    lat.append(zipcode['lat'])
    lon.append(zipcode['lng'])
#nomi = pgeocode.Nominatim('us')
#newData = nomi.query_postal_code(data["zip"].values.tolist())

lat = pandas.DataFrame(lat, columns=['latitude'])
lon = pandas.DataFrame(lon, columns=['longitude'])
data['latitude'] = lat['latitude']
data['longitude'] = lon['longitude']
data.to_csv("latitudeLongitudeBail.csv")