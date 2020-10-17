import pandas
import numpy as np
data = pandas.read_csv("latitudeLongitudeBail.csv")
data['latitude'].replace('', np.nan, inplace=True)
data['longitude'].replace('', np.nan, inplace=True)
#print(data['latitude'][13437])
#print(len(np.where(pandas.isna(data))[0]))
data = data.dropna(axis=0)
data.to_csv("latitudeLongitudeBail(1).csv")
