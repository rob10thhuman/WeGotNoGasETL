from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from webdriver_manager.chrome import ChromeDriverManager
import time 
import pandas as pd
import json 

driver = webdriver.Chrome(ChromeDriverManager().install())
driver.get('https://www.caranddriver.com/shopping-advice/g32463239/new-ev-models-us/')
model = driver.find_elements_by_class_name('listicle-slide-hed-text')
traits = driver.find_elements_by_class_name('listicle-slide-dek ul')

cars_list = [] 
traits_list = []

for m in model:
	cars_list.append(m.get_attribute("textContent"))

for t in traits:
	traits_list.append(t.get_attribute("textContent"))

driver.quit()

cars_list = pd.DataFrame(cars_list)
traits_list = pd.DataFrame(traits_list)

cars_list['Traits'] = traits_list
cars_list = cars_list.rename(columns={0: 'Type'})

cars_list

cars_list['Traits'][6] = cars_list['Traits'][7]
cars_list['Traits'][7] = cars_list['Traits'][8]
cars_list['Traits'][8] = cars_list['Traits'][9]
cars_list['Traits'][9] = cars_list['Traits'][10]
cars_list['Traits'][10] = cars_list['Traits'][11]
cars_list['Traits'][11] = cars_list['Traits'][12]
cars_list['Traits'][12] = cars_list['Traits'][13]
cars_list['Traits'][13] = cars_list['Traits'][14]
cars_list['Traits'][14] = cars_list['Traits'][15]
cars_list['Traits'][15] = cars_list['Traits'][16]
cars_list['Traits'][16] = cars_list['Traits'][17]
cars_list['Traits'][17] = cars_list['Traits'][18]
cars_list['Traits'][18] = cars_list['Traits'][19]
cars_list = cars_list.drop(19)

cars_list

vehicle = cars_list["Type"].str.split("—", n = 1, expand = True)

vehicle

baseprice = cars_list["Traits"].str.split(": ", n = 1, expand = True)
baseprice = baseprice[1].str.split(' ', expand = True)
baseprice = baseprice[0]
baseprice = pd.DataFrame(baseprice)
baseprice
baseprice[0] = baseprice[0].str.replace('EPA','')
baseprice

epafueleconomy = cars_list["Traits"].str.split("y:", n = 1, expand = True)
epafueleconomy = epafueleconomy[1]
epafueleconomy = pd.DataFrame(epafueleconomy)
epafueleconomy
epafueleconomy = epafueleconomy[1].str.split(" E", expand = True)
epafueleconomy = epafueleconomy[0]
epafueleconomy = pd.DataFrame(epafueleconomy)
epafueleconomy

eparange = cars_list["Traits"].str.split("ge:", n = 1, expand = True)
eparange
eparange = eparange[1].str.split("s", expand = True)
eparange = eparange[0]
eparange = pd.DataFrame(eparange)
eparange[0] = eparange[0].str.replace('mile','miles')
eparange

cars = [vehicle[0], baseprice[0], epafueleconomy[0], eparange[0]]
cars
headers = ["vehicle", "baseprice", "epafueleconomy", "eparange"]
df = pd.concat(cars, axis=1, keys=headers)
df.set_index('vehicle')

result = df.to_json(orient='index')
result

parsed = json.loads(result)
print(parsed)

joutput = json.dumps(parsed, indent=4)
print(joutput)

f = open("jsonify2.txt", "a")
f.write(joutput)
f.close()