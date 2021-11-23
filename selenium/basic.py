from selenium import webdriver
#from selenium.webdriver.common.keys import Keys

# Start the browser and navigate to http://automationpractice.com/index.php.
url = 'http://automationpractice.com/index.php'
driver = webdriver.Chrome(
    "/Users/enamulhaque/Documents/AzureDevops/Udacity/Project3/selenium/chromedriver")
driver.get(url)
print("my website name is" + url)
search_item = "DRESS"
driver.find_element_by_css_selector(
    "input[id='search_query_top']").send_keys(search_item)
driver.find_element_by_css_selector(
    "button[class='btn btn-default button-search']").click()
our_search = driver.find_element_by_css_selector(
    "div[id='center_column']>h1>span.lighter").text
result = driver.find_element_by_css_selector(
    "div[id='center_column']>h1>span.heading-counter").text
assert "DRESS" not in our_search
print("we are in the search result page for " + our_search)

if "7" in result:
    print("we found 7 result successfully")
else:
    print("Error! we did not find 1 results")


# For python3:

# sudo pip3 install selenium
