---
name: test-cross-platform
description: 跨平台测试适配 - Web/H5/小程序/App 多平台测试支持
metadata:
  {"openclaw":{"requires":{"bins":[     "wc"]},     "os":["darwin","linux"     ]}}
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

```
跨平台测试支持:
├── Web 端
│   ├── 桌面浏览器 (Chrome/Firefox/Safari)
│   └── 移动浏览器 (Mobile Chrome/Safari)
├── H5 应用
│   ├── 微信 H5
│   ├── 支付宝 H5
│   └── 普通移动 Web
├── 小程序
│   ├── 微信小程序
│   ├── 支付宝小程序
│   └── 百度小程序
└── App
    ├── iOS (原生/混合)
    └── Android (原生/混合)
```

---

## 平台差异处理

### 1. 路径分隔符

| 平台 | 分隔符 | 适配方案 |
|------|--------|---------|
| Windows | `\` | 使用 `pathlib.Path` |
| Linux/macOS | `/` | 使用 `pathlib.Path` |

**适配代码**:
```python
from pathlib import Path

# ✅ 正确：使用 Path
path = Path("tests/fixtures") / "data.json"
```

---

### 2. 环境变量

| 平台 | 设置方式 |
|------|---------|
| Windows (CMD) | `set VAR=value` |
| Windows (PowerShell) | `$env:VAR="value"` |
| Linux/macOS | `export VAR=value` |

**适配代码**:
```python
import os
from dotenv import load_dotenv

load_dotenv('.env.test')
value = os.getenv('TEST_ENV')
```

---

### 3. 进程执行

**适配代码**:
```python
import subprocess
import platform

def run_command(command):
    """跨平台命令执行"""
    system = platform.system()
    shell_cmd = [     'cmd',      '/c', command     ] if system == 'Windows' else [     'sh',      '-c', command     ]
    result = subprocess.run(shell_cmd, capture_output=True, text=True)
    return result.returncode == 0, result.stdout, result.stderr
```

---

### 4. 浏览器驱动

**适配方案**:
```python
from webdriver_manager.chrome import ChromeDriverManager
driver = webdriver.Chrome(ChromeDriverManager().install())
```

---

## 平台特定配置

### Web 端测试配置

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  projects: [
    { name: 'chrome', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'safari', use: { ...devices['Desktop Safari'] } },
    { name: 'Mobile Chrome', use: { ...devices['Pixel 5'] } },
    { name: 'Mobile Safari', use: { ...devices['iPhone 12'] } },
  ],
});
```

---

### H5 应用测试配置

**微信 H5 特殊处理**:
```typescript
import { test, expect } from '@playwright/test';

test('WeChat H5 Login', async ({ page }) => {
  // 模拟微信 User-Agent
  await page.setExtraHTTPHeaders({
    'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_0 like Mac OS X) AppleWebKit/605.1.15 Mobile/15E148 MicroMessenger/8.0.0'
  });

  // 模拟微信 JS-SDK
  await page.addInitScript(() => {
    (window as any).wx = { config: () => {}, ready: (cb: any) => cb() };
  });

  await page.goto('https://example.com/wechat/login');
  await expect(page.locator('.wechat-auth-btn')).toBeVisible();
});
```

---

### 小程序测试配置

**微信小程序测试方案**:

**方案 1: 官方开发者工具 CLI**
```bash
npm install -g miniprogram-simulate
```

**方案 2: UI 自动化（云测试）**
- 微信开发者工具
- 阿里云 MQC
- 腾讯 WeTest

**详细配置**: 详见 `references/miniprogram-testing.md`

---

### App 测试配置

**iOS 测试配置**:
```python
from appium import webdriver

IOS_CAPS = {
    "platformName": "iOS",
    "platformVersion": "16.0",
    "deviceName": "iPhone 14",
    "app": "/path/to/app.app",
    "automationName": "XCUITest",
}

driver = webdriver.Remote("http://localhost:4723/wd/hub", IOS_CAPS)
```

**Android 测试配置**:
```python
ANDROID_CAPS = {
    "platformName": "Android",
    "platformVersion": "13",
    "deviceName": "Pixel 7",
    "app": "/path/to/app.apk",
    "automationName": "UiAutomator2",
}

driver = webdriver.Remote("http://localhost:4723/wd/hub", ANDROID_CAPS)
```

---

## 统一测试框架

### 跨平台 Page Object 模式

**基类**:
```python
from abc import ABC, abstractmethod

class BasePage(ABC):
    """跨平台页面基类"""

    def __init__(self, driver, platform: str):
        self.driver = driver
        self.platform = platform

```

**Web 实现**:
```python
class WebPage(BasePage):
    def locate_element(self, selector: str):
        return self.driver.find_element(By.CSS_SELECTOR, selector)

    def click(self, selector: str):
        self.locate_element(selector).click()

    def input_text(self, selector: str, text: str):
        elem = self.locate_element(selector)
        elem.clear()
        elem.send_keys(text)
```

**App 实现**:
```python
class AppPage(BasePage):
    def locate_element(self, selector: str):
        from appium.webdriver.common.appiumby import AppiumBy
        return self.driver.find_element(AppiumBy.ACCESSIBILITY_ID, selector)

    def click(self, selector: str):
        self.locate_element(selector).tap()

    def input_text(self, selector: str, text: str):
        self.locate_element(selector).set_value(text)
```

---

### 跨平台测试工厂

```python
from pages.web_page import WebPage
from pages.app_page import AppPage

class PlatformFactory:
    @staticmethod
    def create_page(driver, platform: str, page_name: str):
        if platform == 'web':
            return WebPage(driver, platform)
        elif platform in ('ios', 'android'):
```

---

## 平台检测与适配

### 自动平台检测

```python
import platform
import os

class PlatformDetector:
    @staticmethod
    def get_os() -> str:
        system = platform.system()
        return {'Windows': 'windows', 'Darwin': 'macos', 'Linux': 'linux'}.get(system, 'unknown')

    @staticmethod
    def is_ci() -> bool:
        ci_vars = [     'CI',      'GITHUB_ACTIONS', 'GITLAB_CI', 'JENKINS_URL'     ]
        return any(os.getenv(var) for var in ci_vars)
```

**详细实现**: 详见 `references/platform-detector.md`

---

## 使用示例
### 示例 1: 跨平台登录测试
## 跨平台登录测试方案

### 1. 测试架构
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

### 2. 测试用例
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
    driver = driver_factory.get(platform)
    login_page = login_class(driver)
    login_page.enter_phone("13800138000")
    login_page.enter_code("123456")
    login_page.click_login()
    assert login_page.is_logged_in()
```

### 3. 运行命令
```bash
pytest tests/cross_platform/test_login.py -v
```
```

---

### 示例 2: 小程序测试配置
## 微信小程序测试方案

### 方案 1: 官方模拟器 (单元测试)
```javascript
const simulate = require('miniprogram-simulate');

describe('Login Page', () => {
  let loginInstance;

  beforeAll(() => {
    loginInstance = simulate.load('pages/login/login');
  });

  test('should show error for invalid phone', () => {
    loginInstance.setData({ phone: '12345' });
    loginInstance.login();
    expect(loginInstance.data.error).toBe('手机号格式错误');
  });
});
```

### 方案 2: 云测试平台
- 微信开发者工具 CLI
- 阿里云 MQC
- 腾讯 WeTest

### 注意事项
1. 需要 mock wx 对象
2. 模拟授权流程
3. 真机测试使用开发者工具
```

---

### 示例 3: 平台差异处理
## 路径差异处理方案

### 方案 1: 使用 pathlib (推荐)
```python
from pathlib import Path

# 自动处理路径分隔符
test_data = Path("tests") / "fixtures" / "data.json"
```

### 方案 2: 使用 os.path
```python
import os

test_data = os.path.join("tests", "fixtures", "data.json")
```

### 方案 3: 动态获取驱动路径
```python
from pathlib import Path
import platform

def get_driver_path(browser: str) -> str:
    system = platform.system()
    drivers_dir = Path(__file__).parent.parent.parent / 'drivers'
    ext = '.exe' if system == 'Windows' else ''
    return str(drivers_dir / f"{browser}driver{ext}")
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

