# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome import options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.expected_conditions import presence_of_element_located
from selenium.webdriver.chrome.options import Options

option = webdriver.ChromeOptions
options.headless = True

# Start the browser and login with standard_user
url = 'https://www.saucedemo.com/'
driver = webdriver.Chrome()
driver.get(url)
wait = WebDriverWait(driver, 10)
print("my website name is" + url)
print('Browser started successfully. Navigating to the demo page to login.', options=options)
# def login(user, password):
#  print('Starting the browser...')
# --uncomment when running in Azure DevOps.
# options = ChromeOptions()
# options.add_argument("--headless")
# driver = webdriver.Chrome(options=options)

# wait = WebDriverWait(driver, 10)

username = "standard_user"
password = "secret_sauce"
driver.find_element(By.CSS_SELECTOR, '[id="user-name"]').send_keys(username)
driver.find_element(By.CSS_SELECTOR, '[id="password"]').send_keys(password)
driver.find_element(By.CSS_SELECTOR, '[id="login-button"]').click()

print('login succesfull')

items_added = driver.find_elements_by_class_name('btn_inventory')

for item in items_added:
    item.click()
print({len(items_added)}, 'items have been added')

driver.find_element_by_class_name('shopping_cart_link').click()
WebDriverWait(driver, 10)
cart_remove_items = driver.find_elements_by_class_name('cart_button')

for remove_item in cart_remove_items:
    remove_item.click()

print({len(cart_remove_items)}, 'items items have been removed')

Wait = WebDriverWait(driver, 10)
