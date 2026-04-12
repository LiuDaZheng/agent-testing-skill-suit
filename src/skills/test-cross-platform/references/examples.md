# 跨平台测试完整示例

## 示例 1: 完整的跨平台登录测试

### 目录结构
```
tests/cross_platform/
├── conftest.py
├── pages/
│   ├── base_login.py
│   ├── web_login.py
│   ├── ios_login.py
│   └── android_login.py
├── factories/
│   └── driver_factory.py
└── test_login.py
```

### 代码实现

**conftest.py**:
```python
import pytest
from selenium import webdriver
from appium import webdriver as appium_driver

@pytest.fixture(scope="session")
def driver_factory():
    """驱动工厂 fixture"""
    class Factory:
        def __init__(self):
            self.drivers = {}
        
        def get(self, platform: str):
            if platform not in self.drivers:
                if platform == 'web':
                    self.drivers[platform] = webdriver.Chrome()
                elif platform == 'ios':
                    caps = {"platformName": "iOS", "deviceName": "iPhone 14"}
                    self.drivers[platform] = appium_driver.Remote("http://localhost:4723/wd/hub", caps)
                elif platform == 'android':
                    caps = {"platformName": "Android", "deviceName": "Pixel 7"}
                    self.drivers[platform] = appium_driver.Remote("http://localhost:4723/wd/hub", caps)
            return self.drivers[platform]
        
        def cleanup(self):
            for driver in self.drivers.values():
                driver.quit()
    
    factory = Factory()
    yield factory
    factory.cleanup()
```

**pages/base_login.py**:
```python
from abc import ABC, abstractmethod

class BaseLogin(ABC):
    @abstractmethod
    def enter_phone(self, phone: str): pass
    
    @abstractmethod
    def enter_code(self, code: str): pass
    
    @abstractmethod
    def click_login(self): pass
    
    @abstractmethod
    def is_logged_in(self) -> bool: pass
```

**pages/web_login.py**:
```python
from pages.base_login import BaseLogin
from selenium.webdriver.common.by import By

class WebLogin(BaseLogin):
    def __init__(self, driver):
        self.driver = driver
    
    def enter_phone(self, phone: str):
        self.driver.find_element(By.NAME, "phone").send_keys(phone)
    
    def enter_code(self, code: str):
        self.driver.find_element(By.NAME, "code").send_keys(code)
    
    def click_login(self):
        self.driver.find_element(By.CSS_SELECTOR, "button[type='submit']").click()
    
    def is_logged_in(self) -> bool:
        return "/home" in self.driver.current_url
```

**pages/ios_login.py**:
```python
from pages.base_login import BaseLogin
from appium.webdriver.common.appiumby import AppiumBy

class IOSLogin(BaseLogin):
    def __init__(self, driver):
        self.driver = driver
    
    def enter_phone(self, phone: str):
        self.driver.find_element(AppiumBy.ACCESSIBILITY_ID, "phone").send_keys(phone)
    
    def enter_code(self, code: str):
        self.driver.find_element(AppiumBy.ACCESSIBILITY_ID, "code").send_keys(code)
    
    def click_login(self):
        self.driver.find_element(AppiumBy.ACCESSIBILITY_ID, "login").tap()
    
    def is_logged_in(self) -> bool:
        return self.driver.find_element(AppiumBy.ACCESSIBILITY_ID, "home") is not None
```

**test_login.py**:
```python
import pytest
from pages.web_login import WebLogin
from pages.ios_login import IOSLogin
from pages.android_login import AndroidLogin

@pytest.mark.parametrize("platform,login_class", [
    ("web", WebLogin),
    ("ios", IOSLogin),
    ("android", AndroidLogin),
])
def test_login_success(driver_factory, platform, login_class):
    """跨平台登录测试"""
    driver = driver_factory.get(platform)
    login_page = login_class(driver)
    
    login_page.enter_phone("13800138000")
    login_page.enter_code("123456")
    login_page.click_login()
    
    assert login_page.is_logged_in()
```

### 运行命令

```bash
# 运行所有平台
pytest tests/cross_platform/test_login.py -v

# 仅运行 Web
pytest tests/cross_platform/test_login.py -v -k "web"

# 仅运行 iOS
pytest tests/cross_platform/test_login.py -v -k "ios"

# 并行执行
pytest tests/cross_platform/test_login.py -v -n 3
```

---

## 示例 2: 跨平台搜索测试

```python
# tests/cross_platform/test_search.py
import pytest

class BaseSearch:
    def __init__(self, driver):
        self.driver = driver
    
    def search(self, keyword: str):
        self.enter_keyword(keyword)
        self.click_search()
        return self.get_results()
    
    def enter_keyword(self, keyword: str): pass
    def click_search(self): pass
    def get_results(self): pass

class WebSearch(BaseSearch):
    def enter_keyword(self, keyword: str):
        self.driver.find_element(By.NAME, "q").send_keys(keyword)
    
    def click_search(self):
        self.driver.find_element(By.CSS_SELECTOR, "button.search").click()
    
    def get_results(self):
        return self.driver.find_elements(By.CSS_SELECTOR, ".result-item")

@pytest.mark.parametrize("platform", ["web", "ios", "android"])
def test_search_product(driver_factory, platform):
    driver = driver_factory.get(platform)
    search = WebSearch(driver) if platform == "web" else AppSearch(driver)
    
    results = search.search("iPhone")
    assert len(results) > 0
```
