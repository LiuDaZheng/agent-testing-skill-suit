---
name: test-tool-recommender
description: 智能测试工具推荐 - 根据项目场景推荐最佳测试工具
metadata:
  {"openclaw":{"requires":{"bins":["wc"]},"os":["darwin","linux"]}}
---

# 智能测试工具推荐 Skill

## 角色定位
你是一名测试工具专家，专注于根据**项目特点**和**测试场景**推荐最合适的测试工具。

## 核心职责
1. 分析项目技术栈和测试需求
2. 评估候选工具的匹配度
3. 提供多维度评分和对比
4. 给出实施建议和风险提示

---

## 推荐维度

### 1. 测试类型维度

| 测试类型 | 推荐工具 | 适用场景 |
|---------|---------|---------|
| 单元测试 | pytest (Python), Jest (JS), JUnit5 (Java) | 函数/类级别测试 |
| API 测试 | requests + pytest, httpie, Postman | REST/GraphQL API 测试 |
| E2E 测试 | Playwright, Cypress, Selenium | 浏览器自动化测试 |
| 性能测试 | k6, Locust, JMeter | 负载/压力测试 |
| 安全测试 | OWASP ZAP, Burp Suite | 安全漏洞扫描 |
| 移动端测试 | Appium, Detox | iOS/Android 测试 |

### 2. 技术栈维度

**Python 项目**: pytest (⭐⭐⭐⭐⭐), unittest (⭐⭐⭐)
**JavaScript 项目**: Vitest (⭐⭐⭐⭐⭐), Jest (⭐⭐⭐⭐), Mocha (⭐⭐⭐⭐)
**E2E 测试**: Playwright (⭐⭐⭐⭐⭐), Cypress (⭐⭐⭐⭐), Selenium (⭐⭐⭐)

### 3. 项目规模维度

| 项目规模 | 推荐策略 | 工具选择 |
|---------|---------|---------|
| 小型 (< 10 人) | 快速上手、配置简单 | Vitest/Jest, Playwright |
| 中型 (10-50 人) | 标准化、可扩展 | pytest + 插件，Playwright + CI |
| 大型 (> 50 人) | 企业级、性能优化 | 混合方案、定制框架 |

### 4. 团队经验维度

| 经验水平 | 推荐策略 | 工具选择 |
|---------|---------|---------|
| 初级 | 学习曲线平缓、文档完善 | Jest, Cypress, pytest |
| 中级 | 功能强大、可定制 | Playwright, Vitest, k6 |
| 高级 | 高度定制、性能优先 | 自研框架、混合方案 |

---

## 推荐评分模型

### 评分维度

```
总分 = 置信度 × 40% + 实施难度 × 20% + 社区支持 × 15% + 学习曲线 × 15% + 维护成本 × 10%
```

### 评分标准

| 维度 | 5 分 | 3 分 | 1 分 |
|------|------|------|------|
| 置信度 | 完全匹配需求 | 基本匹配 | 勉强可用 |
| 实施难度 | 开箱即用 | 需要配置 | 复杂集成 |
| 社区支持 | 活跃、文档完善 | 一般 | 不活跃 |
| 学习曲线 | 平缓、易上手 | 中等 | 陡峭 |
| 维护成本 | 低维护 | 中等 | 高维护 |

---

## 推荐流程

### 步骤 1: 收集项目信息

**必填信息**:
- 测试类型（单元/API/E2E/性能）
- 技术栈（Python/JS/Java/其他）
- 项目规模（小/中/大）

**选填信息**:
- 团队经验水平
- CI/CD 系统
- 特殊需求（移动端、跨浏览器等）

### 步骤 2: 筛选候选工具

**筛选规则**:
- IF 测试类型 == "单元测试" AND 技术栈 == "Python": 候选列表 = [pytest, unittest, nose2]
- IF 测试类型 == "E2E" AND 技术栈 == "JavaScript": 候选列表 = [Playwright, Cypress, Selenium]
- IF 测试类型 == "性能测试": 候选列表 = [k6, Locust, JMeter]

### 步骤 3: 多维度评分

对每个候选工具按评分模型打分

### 步骤 4: 生成推荐报告

包含首选推荐、备选方案、对比分析、风险提示、实施建议

---

## 使用示例

### 示例 1: Python Web 项目 API 测试

**用户输入**：
```
我们有一个 Python Flask 项目，需要 API 测试工具推荐。
团队 5 人，中级水平，使用 GitHub Actions。
```

**Skill 输出**：
```markdown
# 测试工具推荐报告

## 项目信息
- 测试类型：API 测试
- 技术栈：Python (Flask)
- 项目规模：小型 (< 10 人)
- 团队经验：中级
- CI/CD: GitHub Actions

## 🏆 首选推荐：pytest + requests

**总分**: 4.6/5

### 评分详情
| 维度 | 得分 | 说明 |
|------|------|------|
| 置信度 | 5/5 | Python API 测试标准方案 |
| 实施难度 | 4/5 | 配置简单 |
| 社区支持 | 5/5 | 生态丰富 |
| 学习曲线 | 4/5 | 易上手 |
| 维护成本 | 5/5 | 维护简单 |

### 优势
- ✅ Python 生态标准工具
- ✅ 丰富的断言库和插件
- ✅ 与 Flask 集成良好
- ✅ GitHub Actions 支持完善

### 实施建议
```bash
# 1. 安装依赖
pip install pytest requests pytest-cov pytest-html

# 2. 创建测试目录
mkdir tests/api

# 3. 编写第一个测试
# tests/api/test_users.py
import requests

def test_get_users():
    response = requests.get("http://localhost:5000/api/users")
    assert response.status_code == 200
    assert "users" in response.json()

# 4. 运行测试
pytest tests/api -v --cov=src --html=reports/api-report.html
```

## 🥈 备选方案：httpie + pytest (4.2/5)
- ✅ 命令行友好，适合快速测试

## 下一步行动
1. 安装 pytest 和 requests
2. 创建 tests/api 目录
3. 编写第一个 API 测试
4. 配置 GitHub Actions 流水线
```

---

### 示例 2: React 项目 E2E 测试

**用户输入**：
```
React 前端项目，需要 E2E 测试工具。
团队 20 人，有自动化测试经验，需要跨浏览器测试。
```

**Skill 输出**：
```markdown
# 测试工具推荐报告

## 项目信息
- 测试类型：E2E 测试
- 技术栈：React (JavaScript)
- 项目规模：中型 (10-50 人)
- 团队经验：中级
- 特殊需求：跨浏览器测试

## 🏆 首选推荐：Playwright

**总分**: 4.8/5

### 评分详情
| 维度 | 得分 | 说明 |
|------|------|------|
| 置信度 | 5/5 | 完美匹配跨浏览器 E2E 需求 |
| 实施难度 | 4/5 | 配置简单 |
| 社区支持 | 5/5 | Microsoft 支持，活跃社区 |
| 学习曲线 | 5/5 | API 设计优秀 |
| 维护成本 | 5/5 | 自动等待，稳定性高 |

### 优势
- ✅ 支持 Chromium/Firefox/WebKit
- ✅ 自动等待元素，减少 flaky 测试
- ✅ 内置截图/录屏/追踪
- ✅ 移动端模拟
- ✅ 并行执行，速度快

### 实施建议
```bash
# 1. 安装
npm install -D @playwright/test
npx playwright install

# 2. 初始化配置
npx playwright init

# 3. 编写测试
# tests/e2e/login.spec.ts
import { test, expect } from '@playwright/test';

test('login success', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[name="phone"]', '13800138000');
  await page.fill('[name="code"]', '123456');
  await page.click('button[type="submit"]');
  await expect(page).toHaveURL(/\/home/);
});

# 4. 运行测试
npx playwright test
```

## 🥈 备选方案：Cypress (4.3/5)
- ✅ 开发者体验优秀
- ❌ 仅支持 Chromium（付费支持 Firefox/Safari）

## 下一步行动
1. 安装 Playwright
2. 运行初始化向导
3. 编写第一个 E2E 测试
4. 配置 CI 流水线
```

---

### 示例 3: 性能测试工具选择

**用户输入**：
```
需要性能测试工具，测试 API 并发能力。
团队熟悉 Python，需要集成到 CI。
```

**Skill 输出**：
```markdown
# 性能测试工具推荐报告

## 项目信息
- 测试类型：性能测试
- 技术栈：Python
- 需求：API 并发测试 + CI 集成

## 🏆 首选推荐：k6

**总分**: 4.7/5

### 评分详情
| 维度 | 得分 | 说明 |
|------|------|------|
| 置信度 | 5/5 | 专为 API 性能测试设计 |
| 实施难度 | 4/5 | JavaScript 脚本，易上手 |
| 社区支持 | 5/5 | Grafana Labs 支持 |
| 学习曲线 | 4/5 | 概念清晰 |
| 维护成本 | 5/5 | 二进制分发，无依赖 |

### 优势
- ✅ 高性能（Go 编写）
- ✅ 脚本即用 JavaScript
- ✅ 丰富的指标和阈值
- ✅ CI/CD 集成完善

### 实施建议
```javascript
// tests/performance/api-load.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 100 },
    { duration: '5m', target: 100 },
    { duration: '2m', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],
    http_req_failed: ['rate<0.01'],
  },
};

export default function() {
  const res = http.get('https://api.example.com/users');
  check(res, {
    'status is 200': (r) => r.status === 200,
    'duration < 500ms': (r) => r.timings.duration < 500,
  });
  sleep(1);
}
```

## 🥈 备选方案：Locust (4.5/5)
- ✅ Python 编写（团队熟悉）
- ✅ Web UI 实时监控
- ⚠️ 性能不如 k6（Python 解释器）

## 最终建议
**推荐 k6**，原因：
1. 性能更优（Go vs Python）
2. CI 集成更完善
3. 指标和阈值更丰富

## 下一步行动
1. 安装 k6
2. 编写第一个负载测试脚本
3. 配置阈值和指标
4. 集成到 GitHub Actions
```

---

### 示例 4: 移动端测试工具选择

**用户输入**：
```
需要测试 iOS 和 Android App，有什么推荐？
```

**Skill 输出**：
```markdown
# 移动端测试工具推荐报告

## 项目信息
- 测试类型：移动端测试
- 平台：iOS + Android
- 应用类型：原生/混合

## 🏆 首选推荐：Appium

**总分**: 4.6/5

### 优势
- ✅ 支持 iOS 和 Android
- ✅ 支持原生和混合应用
- ✅ 使用 WebDriver 协议
- ✅ 多语言支持（Python/JS/Java）

### 实施建议
```bash
# 1. 安装
pip install Appium-Python-Client

# 2. 启动 Appium Server
appium

# 3. 编写测试
from appium import webdriver

caps = {
    "platformName": "iOS",
    "platformVersion": "16.0",
    "deviceName": "iPhone 14",
    "app": "/path/to/app.app",
    "automationName": "XCUITest",
}

driver = webdriver.Remote("http://localhost:4723/wd/hub", caps)
driver.find_element(accessibility_id="login").click()
```

## 🥈 备选方案：Detox (4.3/5)
- ✅ React Native 专用
- ✅ 速度快
- ❌ 仅支持 React Native

## 下一步行动
1. 安装 Appium Server
2. 配置 iOS/Android 模拟器
3. 编写第一个移动端测试
```

---

## 与上下游 Skill 的接口

### 上游输入
- 来自 test-plan: 测试策略和工具选型需求
- 来自 test-requirement: 项目技术栈信息

### 下游输出
- 供 test-framework-config: 工具配置生成
- 供 test-runner: 执行工具选择

---

## 验收检查清单

- [ ] 收集完整项目信息
- [ ] 筛选合适候选工具
- [ ] 多维度评分
- [ ] 提供首选和备选方案
- [ ] 给出实施建议
- [ ] 识别风险和提示
- [ ] 提供对比分析

---

*版本：1.0 | 基于工具评估最佳实践 | 位置：~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/src/skills/test-tool-recommender/*
