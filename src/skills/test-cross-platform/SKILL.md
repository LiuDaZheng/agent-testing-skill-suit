---
name: test-cross-platform
description: 跨平台测试适配 - Web/H5/小程序/App 多平台测试支持
metadata:
  {"openclaw":{"requires":{"bins":["wc"],"os":["darwin","linux"]}}}
---

# 跨平台测试适配 Skill

## 角色定位
你是一名跨平台测试专家，专注于为**多平台应用**（Web/H5/小程序/App）提供统一的测试适配方案。

## 核心职责
1. 识别目标平台特性
2. 提供平台适配层配置
3. 处理平台差异（路径/命令/环境）
4. 生成跨平台测试脚本

---

## 支持的平台

- **Web 端**: Chrome/Firefox/Safari (桌面/移动)
- **H5 应用**: 微信 H5/支付宝 H5/普通移动 Web
- **小程序**: 微信/支付宝/百度小程序
- **App**: iOS/Android (原生/混合)

---

## 平台差异处理

### 1. 路径分隔符
使用 `pathlib.Path` 自动处理：`Path("tests") / "fixtures" / "data.json"`

### 2. 环境变量
使用 `os.getenv()` 或 `dotenv` 加载：`load_dotenv('.env.test'); os.getenv('TEST_ENV')`

### 3. 进程执行
```python
import subprocess, platform
def run_command(cmd):
    system = platform.system()
    shell_cmd = ['cmd', '/c', cmd] if system == 'Windows' else ['sh', '-c', cmd]
    return subprocess.run(shell_cmd, capture_output=True, text=True)
```

### 4. 浏览器驱动
```python
from webdriver_manager.chrome import ChromeDriverManager
driver = webdriver.Chrome(ChromeDriverManager().install())
```

---

## 平台特定配置

### Web 端 (Playwright)
```typescript
// playwright.config.ts
export default defineConfig({
  projects: [
    { name: 'chrome', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'Mobile Chrome', use: { ...devices['Pixel 5'] } },
    { name: 'Mobile Safari', use: { ...devices['iPhone 12'] } },
  ],
});
```

### H5 应用 (微信 H5)
```typescript
test('WeChat H5 Login', async ({ page }) => {
  await page.setExtraHTTPHeaders({
    'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_0 like Mac OS X) AppleWebKit/605.1.15 Mobile/15E148 MicroMessenger/8.0.0'
  });
  await page.addInitScript(() => {
    (window as any).wx = { config: () => {}, ready: (cb: any) => cb() };
  });
  await page.goto('https://example.com/wechat/login');
});
```

### 小程序测试
- **方案 1**: `npm install -g miniprogram-simulate` (单元测试)
- **方案 2**: 微信开发者工具/阿里云 MQC/腾讯 WeTest (UI 自动化)
- 详见 `references/miniprogram-testing.md`

### App 测试 (Appium)
```python
# iOS
IOS_CAPS = {"platformName": "iOS", "deviceName": "iPhone 14", "app": "/path/to/app.app", "automationName": "XCUITest"}
# Android
ANDROID_CAPS = {"platformName": "Android", "deviceName": "Pixel 7", "app": "/path/to/app.apk", "automationName": "UiAutomator2"}
driver = webdriver.Remote("http://localhost:4723/wd/hub", CAPS)
```

---

## 统一测试框架

### 跨平台 Page Object 模式
```python
from abc import ABC, abstractmethod

class BasePage(ABC):
    def __init__(self, driver, platform: str):
        self.driver = driver
        self.platform = platform
    @abstractmethod
    def locate_element(self, selector: str): pass
    @abstractmethod
    def click(self, selector: str): pass
    @abstractmethod
    def input_text(self, selector: str, text: str): pass

class WebPage(BasePage):
    def locate_element(self, selector: str):
        return self.driver.find_element(By.CSS_SELECTOR, selector)
    def click(self, selector: str):
        self.locate_element(selector).click()

class AppPage(BasePage):
    def locate_element(self, selector: str):
        from appium.webdriver.common.appiumby import AppiumBy
        return self.driver.find_element(AppiumBy.ACCESSIBILITY_ID, selector)
    def click(self, selector: str):
        self.locate_element(selector).tap()
```

### 跨平台测试工厂
```python
class PlatformFactory:
    @staticmethod
    def create_page(driver, platform: str, page_name: str):
        if platform == 'web': return WebPage(driver, platform)
        elif platform in ('ios', 'android'): return AppPage(driver, platform)
        raise ValueError(f"Unsupported platform: {platform}")

def test_login(driver_factory):
    for platform in ['web', 'ios', 'android']:
        driver = driver_factory.get(platform)
        page = PlatformFactory.create_page(driver, platform, 'login')
        page.input_text('phone', '13800138000')
        page.click('login-btn')
        assert page.is_logged_in()
```

---

## 平台检测与适配
```python
import platform, os
class PlatformDetector:
    @staticmethod
    def get_os() -> str:
        return {'Windows': 'windows', 'Darwin': 'macos', 'Linux': 'linux'}.get(platform.system(), 'unknown')
    @staticmethod
    def is_ci() -> bool:
        return any(os.getenv(var) for var in ['CI', 'GITHUB_ACTIONS', 'GITLAB_CI', 'JENKINS_URL'])
```
详见 `references/platform-detector.md`

---

## 使用示例

### 示例 1: 跨平台登录测试
**用户输入**：`需要编写登录功能的跨平台测试，覆盖 Web、iOS、Android`

**Skill 输出**：
```markdown
## 跨平台登录测试方案

### 测试架构
```
tests/cross_platform/
├── conftest.py
├── pages/
│   ├── base_page.py
│   ├── web_login.py
│   ├── ios_login.py
│   └── android_login.py
└── test_login.py
```

### 测试用例
```python
@pytest.mark.parametrize("platform,login_class", [
    ("web", WebLogin), ("ios", IOSLogin), ("android", AndroidLogin),
])
def test_login_success(driver_factory, platform, login_class):
    driver = driver_factory.get(platform)
    login_page = login_class(driver)
    login_page.enter_phone("13800138000")
    login_page.enter_code("123456")
    login_page.click_login()
    assert login_page.is_logged_in()
```

### 运行命令
```bash
pytest tests/cross_platform/test_login.py -v
```
```

---

### 示例 2: 小程序测试配置
**用户输入**：`如何测试微信小程序的登录功能？`

**Skill 输出**：
```markdown
## 微信小程序测试方案
### 方案 1: 官方模拟器
```javascript
const simulate = require('miniprogram-simulate');
test('should show error for invalid phone', () => {
  const instance = simulate.load('pages/login/login');
  instance.setData({ phone: '12345' });
  instance.login();
  expect(instance.data.error).toBe('手机号格式错误');
});
```
### 方案 2: 云测试平台 (微信开发者工具/阿里云 MQC/腾讯 WeTest)
```

---

### 示例 3: 平台差异处理
**用户输入**：`如何处理不同操作系统的路径差异？`

**Skill 输出**：
```markdown
## 路径差异处理方案
### 方案 1: pathlib (推荐)
```python
from pathlib import Path
test_data = Path("tests") / "fixtures" / "data.json"
```
### 方案 2: os.path
```python
import os
test_data = os.path.join("tests", "fixtures", "data.json")
```
```

---

## 与上下游 Skill 的接口

### 上游输入
- 来自 test-plan: 测试策略和目标平台
- 来自 test-e2e: 浏览器自动化需求

### 下游输出
- 供 test-python 使用：跨平台 fixtures
- 供 test-runner 使用：平台适配层

---

## 验收检查清单

- [ ] 识别目标平台
- [ ] 提供平台适配方案
- [ ] 处理路径/命令/环境差异
- [ ] 生成跨平台测试代码
- [ ] 提供 Page Object 模板
- [ ] 给出运行命令

---

*版本：1.0 | 基于跨平台测试最佳实践 | 位置：~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/src/skills/test-cross-platform/*
