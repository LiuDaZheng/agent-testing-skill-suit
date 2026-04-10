---
name: test-framework-config
description: 测试框架配置生成 - pytest/Playwright 核心配置
metadata:
  {"openclaw":{"requires":{"bins":["wc"]},"os":["darwin","linux"]}}
---

# 测试框架配置生成 Skill

## 角色定位
你是一名测试架构师，专注于**测试框架核心配置生成**，提供 pytest 和 Playwright 的开箱即用配置。

## 核心职责
1. 生成 Pytest 配置文件
2. 生成 Playwright 浏览器自动化配置
3. 环境检查与验证

---

## Pytest 配置生成

### pytest.ini 配置模板

```ini
[pytest]
# 测试发现
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*

# 输出格式
addopts = 
    -v                      # 详细输出
    --tb=short             # 简化 traceback
    --strict-markers       # 严格标记
    --color=yes            # 彩色输出

# 标记定义
markers =
    smoke: 冒烟测试
    integration: 集成测试
    e2e: 端到端测试
    performance: 性能测试
    security: 安全测试
    high: 高优先级
    medium: 中优先级
    low: 低优先级

# 日志配置
log_cli = true
log_cli_level = INFO
log_cli_format = %(asctime)s [%(levelname)s] %(message)s
log_cli_date_format = %Y-%m-%d %H:%M:%S

# 缓存配置
cache_dir = .pytest_cache

# 超时配置 (需要 pytest-timeout)
timeout = 300
timeout_method = thread
```

---

### conftest.py 配置模板

```python
"""
Pytest 全局配置和 Fixtures

提供：
- 全局 fixtures
- Hook 函数
- 测试数据生成
"""

import pytest
import os
import sys
from pathlib import Path

# 添加项目根目录到 Python 路径
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))


@pytest.fixture(scope="session")
def project_dir():
    """项目根目录"""
    return project_root


@pytest.fixture(scope="session")
def test_data_dir():
    """测试数据目录"""
    return project_root / "tests" / "fixtures"


@pytest.fixture
def sample_user():
    """示例用户数据"""
    return {
        "phone": "13800138000",
        "password": "Test123!",
        "email": "test@example.com"
    }


@pytest.fixture
def api_base_url():
    """API 基础 URL"""
    return os.getenv("API_BASE_URL", "http://localhost:8000")


@pytest.fixture
def browser_name():
    """浏览器类型"""
    return os.getenv("BROWSER", "chromium")


# Hook: 测试前执行
def pytest_configure(config):
    """配置钩子"""
    config.addinivalue_line(
        "markers", "smoke: 冒烟测试"
    )
    config.addinivalue_line(
        "markers", "integration: 集成测试"
    )


# Hook: 测试后生成报告
def pytest_sessionfinish(session, exitstatus):
    """会话结束钩子"""
    print(f"\n测试完成，退出状态：{exitstatus}")
```

---

### requirements.txt 配置模板

```txt
# 核心测试框架
pytest==8.0.0
pytest-cov==4.1.0          # 覆盖率报告
pytest-xdist==3.5.0        # 并行执行
pytest-timeout==2.2.0      # 超时控制
pytest-html==4.1.0         # HTML 报告

# API 测试
requests==2.31.0
httpx==0.26.0              # 异步 HTTP
pytest-requests==0.0.8

# 浏览器自动化
playwright==1.40.0
pytest-playwright==0.4.4

# 性能测试
locust==2.20.0

# 数据验证
pydantic==2.5.3            # 数据验证
jsonschema==4.20.0         # JSON Schema 验证

# 工具库
python-dotenv==1.0.0       # 环境变量
Faker==21.0.0              # 测试数据生成
freezegun==1.4.0           # 时间冻结

# 代码质量
flake8==7.0.0
black==23.12.1
isort==5.13.2
mypy==1.8.0
```

---

## Playwright 配置生成

### playwright.config.ts 配置模板

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  // 测试目录
  testDir: './tests/e2e',
  
  // 超时配置
  timeout: 30 * 1000,
  expect: {
    timeout: 5000
  },
  
  // 失败重试
  retries: process.env.CI ? 2 : 0,
  
  // 并行执行
  workers: process.env.CI ? 1 : undefined,
  
  // 报告器
  reporter: [
    ['html', { outputFolder: 'reports/playwright' }],
    ['json', { outputFile: 'reports/playwright/results.json' }],
    ['junit', { outputFile: 'reports/playwright/junit.xml' }],
    ['list']
  ],
  
  // 共享配置
  use: {
    // 基础 URL
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    
    // 浏览器上下文
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    
    // 动作超时
    actionTimeout: 10000,
    navigationTimeout: 30000,
  },
  
  // 浏览器配置
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    // 移动端
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] },
    },
  ],
});
```

---

### Page Object 模板

```typescript
// tests/e2e/pages/login.page.ts
import { Page, Locator, expect } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly phoneInput: Locator;
  readonly codeInput: Locator;
  readonly loginButton: Locator;
  readonly errorMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.phoneInput = page.locator('input[name="phone"]');
    this.codeInput = page.locator('input[name="code"]');
    this.loginButton = page.locator('button[type="submit"]');
    this.errorMessage = page.locator('.error-message');
  }

  async goto() {
    await this.page.goto('/login');
  }

  async login(phone: string, code: string) {
    await this.phoneInput.fill(phone);
    await this.codeInput.fill(code);
    await this.loginButton.click();
  }

  async expectSuccess() {
    await expect(this.page).toHaveURL(/\/home/);
  }

  async expectError(message: string) {
    await expect(this.errorMessage).toContainText(message);
  }
}

export default LoginPage;
```

---

## 使用示例

### 示例 1: 生成 Pytest 配置

**用户输入**：
```
帮我生成 pytest 配置文件，需要支持覆盖率报告和 HTML 报告
```

**Skill 输出**：
```markdown
## Pytest 配置已生成

### 1. pytest.ini
[已提供完整配置，见上方模板]

### 2. conftest.py
[已提供完整配置，见上方模板]

### 3. requirements.txt
[已提供完整配置，见上方模板]

### 使用方法
```bash
# 运行测试并生成报告
pytest tests/ \
  --cov=src \
  --cov-report=html:reports/coverage \
  --html=reports/test-report.html \
  --self-contained-html

# 查看报告
open reports/test-report.html
open reports/coverage/index.html
```
```

---

### 示例 2: 生成 Playwright 配置

**用户输入**：
```
帮我配置 Playwright E2E 测试，需要支持多浏览器
```

**Skill 输出**：
```markdown
## Playwright 配置已生成

### 1. playwright.config.ts
[已提供完整配置，包含 Chromium/Firefox/WebKit]

### 2. Page Object 模板
[已提供 login.page.ts 示例]

### 使用方法
```bash
# 安装依赖
npm install -D @playwright/test
npx playwright install

# 运行所有浏览器
npx playwright test

# 仅运行 Chromium
npx playwright test --project=chromium

# 查看报告
npx playwright show-report
```
```

---

### 示例 3: 完整测试环境配置

**用户输入**：
```
为新项目配置完整的 Python 测试环境
```

**Skill 输出**：
```markdown
## 完整测试环境配置

### 1. 创建目录结构
```bash
mkdir -p tests/{unit,api,e2e,fixtures}
mkdir -p reports
touch pytest.ini conftest.py requirements.txt
```

### 2. 生成配置文件
- pytest.ini: [配置内容]
- conftest.py: [配置内容]
- requirements.txt: [配置内容]

### 3. 安装依赖
```bash
pip install -r requirements.txt
playwright install chromium
```

### 4. 运行测试
```bash
pytest tests/ -v --cov=src --html=reports/test-report.html
```
```

---

## 与上下游 Skill 的接口

### 上游输入
- 来自 test-plan: 测试策略和工具选型
- 来自 test-execute: 执行环境需求

### 下游输出
- 供 test-python 使用：pytest 配置
- 供 test-e2e 使用：Playwright 配置
- 供 test-runner 使用：执行环境

---

## 验收检查清单

- [ ] pytest 配置完整可用
- [ ] Playwright 配置完整可用
- [ ] 使用示例清晰
- [ ] 配置文件可直接使用
- [ ] 与上下游 Skill 接口明确

---

*版本：1.0 | 基于测试框架最佳实践 | 位置：~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/src/skills/test-framework-config/*
