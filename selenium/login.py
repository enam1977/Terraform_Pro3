# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
import logging

logging.basicConfig(
    format='%(asctime)s %(levelname)-8s %(message)s',
    level=logging.INFO,
    datefmt='%Y-%m-%d %H:%M:%S')

# driver = webdriver.Chrome()
# print ('Browser started successfully. Navigating to the demo page to login.')
# driver.get('https://www.saucedemo.com/')


# Start the browser and login with standard_user
def login(user, password):
    logging.info('Starting the browser...')
    # --uncomment when running in Azure DevOps.
    options = ChromeOptions()
    # solve DevToolsActivePort
    options.add_argument("--headless")
    options.add_argument('--no-sandbox')
    # options.add_argument('--disable-dev-shm-usage')
    driver = webdriver.Chrome('/usr/bin/chromedriver', options=options)
    # print ('Browser started successfully. Navigating to the demo page to login.')
    driver.get('https://www.saucedemo.com/')
    # input user, password
    driver.find_element_by_css_selector("input[id=user-name]").send_keys(user)
    driver.find_element_by_css_selector(
        "input[id=password]").send_keys(password)
    driver.find_element_by_css_selector("input[id=login-button]").click()
    product_label = driver.find_element_by_css_selector(
        "span[class=title").text
    assert "PRODUCTS" in product_label
    logging.info('Login with username: {:s} and password: {:s} successfully.'.format(
        user, password))
    return driver

# add all items to cart


def add_items(driver, nums):
    for i in range(nums):
        prod = "a[id='item_"+str(i)+"_title_link']"
        # print(prod)
        driver.find_element_by_css_selector(prod).click()
        driver.find_element_by_css_selector(
            'button.btn_primary.btn_inventory').click()
        product = driver.find_element_by_css_selector(
            "div[class='inventory_details_name large_size']").text
        logging.info("Add " + product + " to cart successfully!")
        # back to main menu
        driver.find_element_by_css_selector(
            'button[id=back-to-products]').click()
    logging.info(str(nums)+" products has been added to the cart.")


def remove_items(driver, nums):
    for i in range(nums):
        prod = "a[id='item_"+str(i)+"_title_link']"
        # print(prod)
        driver.find_element_by_css_selector(prod).click()
        driver.find_element_by_css_selector(
            'button.btn_secondary.btn_inventory').click()
        product = driver.find_element_by_css_selector(
            "div[class='inventory_details_name large_size']").text
        logging.info("Remove " + product + " from the cart successfully!")
        # back to main menu
        driver.find_element_by_css_selector(
            'button[id=back-to-products]').click()
    logging.info(str(nums)+" products has been removed from the cart.")


if __name__ == "__main__":
    USERNAME = 'standard_user'
    PASSWORD = 'secret_sauce'
    driver = login(USERNAME, PASSWORD)
    # driver.find_element_by_css_selector("a[id='item_1_title_link']").click()
    nums = 6
    add_items(driver, nums)
    remove_items(driver, nums)
    logging.info('Selenium tests are all successfully completed!')
