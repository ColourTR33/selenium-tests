import logging
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.firefox.service import Service as FirefoxService
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.firefox.options import Options as FirefoxOptions

# Configure logging
logging.basicConfig(
    filename='test_log.log',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def run_test(browser):
    try:
        if browser == "chrome":
            # Setup Chrome options
            chrome_options = ChromeOptions()
            chrome_options.add_argument("--no-sandbox")
            chrome_options.add_argument("--disable-dev-shm-usage")
            chrome_options.add_argument("--window-size=1920x1080")  # Set window size
            
            driver = webdriver.Chrome(service=ChromeService(), options=chrome_options)
            logging.info("Initialized Chrome driver")
        elif browser == "firefox":
            # Setup Firefox options
            firefox_options = FirefoxOptions()
            firefox_options.add_argument("--window-size=1920x1080")  # Set window size

            driver = webdriver.Firefox(service=FirefoxService(), options=firefox_options)
            logging.info("Initialized Firefox driver")

        # Go to a website
        driver.get("https://www.example.com")
        logging.info("Navigated to https://www.example.com")

        # Example assertion
        assert "Example Domain" in driver.title
        logging.info("Test passed: Title is as expected")

    except Exception as e:
        logging.error(f"An error occurred: {e}")
    finally:
        driver.quit()
        logging.info("Driver quit")

if __name__ == "__main__":
    # Run tests for both browsers
    for browser in ["chrome", "firefox"]:
        run_test(browser)
