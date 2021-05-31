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
cars_list = cars_list.rename(columns={0: 'Type', 'Traits': 'Data'})

cars_list

cars_list['Data'][6] = cars_list['Data'][7]
cars_list['Data'][7] = cars_list['Data'][8]
cars_list['Data'][8] = cars_list['Data'][9]
cars_list['Data'][9] = cars_list['Data'][10]
cars_list['Data'][10] = cars_list['Data'][11]
cars_list['Data'][11] = cars_list['Data'][12]
cars_list['Data'][12] = cars_list['Data'][13]
cars_list['Data'][13] = cars_list['Data'][14]
cars_list['Data'][14] = cars_list['Data'][15]
cars_list['Data'][15] = cars_list['Data'][16]
cars_list['Data'][16] = cars_list['Data'][17]
cars_list['Data'][17] = cars_list['Data'][18]
cars_list['Data'][18] = cars_list['Data'][19]
cars_list = cars_list.drop(19)

cars_list = cars_list.set_index('Type')

cars_list

result = cars_list.to_json(orient = 'split')
result

parsed = json.loads(result)
print(parsed)

joutput = json.dumps(parsed, indent=4)
print(joutput)

f = open("jsonify.txt", "a")
f.write(joutput)
f.close()