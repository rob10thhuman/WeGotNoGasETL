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

print(cars_list)

result = cars_list.to_json(orient = 'split')
parsed = json.loads(result)

joutput = json.dumps(parsed, indent=4)
print(joutput)

f = open("json.txt", "a")
f.write(joutput)
f.close()
