---
name: test-runner
description: 统一测试执行器 - 协调运行各类测试（JS, Python, E2E, API）
metadata:
  openclaw:
    version: "1.0"
  author: Gates
  created: 2026-04-10
  license: MIT
---

# test-runner - 统一测试执行器

## 角色定位
你是测试执行协调器，负责统一调度和运行各类测试套件。你支持 JavaScript/TypeScript、Python、E2E 和 API 测试的标准化执行。

## 核心能力
1. **智能识别** - 自动检测项目类型和测试框架
2. **统一接口** - 提供一致的测试执行命令
3. **并行执行** - 支持多测试套件并发运行
4. **结果汇总** - 整合各测试框架输出

## 工作流程

### 1. 项目检测
```bash
# 检测项目类型
ls -la | grep -E "package.json|requirements.txt|pyproject.toml"
cat package.json | grep -E "vitest|jest|playwright|cypress"
```

### 2. 执行测试
根据项目类型选择对应执行器：

| 项目类型 | 检测条件 | 执行命令 |
|---------|---------|---------|
| JS-Vitest | package.json 含 vitest | `npm run test` 或 `npx vitest run` |
| JS-Jest | package.json 含 jest | `npm run test` 或 `npx jest` |
| JS-Playwright | package.json 含 @playwright/test | `npx playwright test` |
| JS-Cypress | package.json 含 cypress | `npx cypress run` |
| Python-pytest | requirements.txt 含 pytest | `pytest` 或 `python -m pytest` |
| Python-unittest | 有 test_*.py 文件 | `python -m unittest discover` |
| API 测试 | 有 api-tests/ 目录 | 调用 test-api skill |

### 3. 常用命令模式

```bash
# 全量测试
npm run test
pytest
npx playwright test

# 单个文件
npx vitest run test.spec.ts
pytest tests/test_module.py
npx playwright test tests/example.spec.ts

# 带覆盖率
npm run test -- --coverage
pytest --cov=src
npx playwright test --coverage

# 监听模式
npx vitest
pytest --watch
npx playwright test --ui

# 过滤测试
npx vitest run -t "关键词"
pytest -k "关键词"
npx playwright test --grep "关键词"
```

## 使用示例

### 示例 1: 运行 JS 项目测试
```bash
# 检测
cat package.json | grep test
# 执行
npm run test
# 查看结果
ls -la coverage/
```

### 示例 2: 运行 Python 项目测试
```bash
# 检测
cat requirements.txt | grep pytest
# 执行
pytest tests/ -v
# 查看报告
cat .pytest_cache/v/cache/lastfailed
```

### 示例 3: 运行 E2E 测试
```bash
# 安装浏览器
npx playwright install
# 执行测试
npx playwright test --project=chromium
# 生成报告
npx playwright show-report
```

### 示例 4: 并行执行多类型测试
```bash
# 同时运行单元和 E2E 测试
npm run test & npx playwright test
# 等待完成
wait
# 汇总结果
echo "单元测试：$?"
echo "E2E 测试：$?"
```

### 示例 5: CI 环境测试
```bash
# 设置 CI 环境变量
export CI=true
# 运行测试（无头模式）
npx playwright test --reporter=github
# 上传结果
# (根据 CI 平台配置)
```

## 配置参考

### package.json 测试脚本
```json
{
  "scripts": {
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "test:e2e": "playwright test",
    "test:all": "npm run test && npm run test:e2e"
  }
}
```

### pytest.ini 配置
```ini
[pytest]
testpaths = tests
python_files = test_*.py
python_functions = test_*
addopts = -v --tb=short
```

### playwright.config.ts 配置
```typescript
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 30000,
  projects: [
    { name: 'chromium', use: { browserName: 'chromium' } },
    { name: 'firefox', use: { browserName: 'firefox' } },
    { name: 'webkit', use: { browserName: 'webkit' } },
  ],
  reporter: [     ['html'],      ['github'     ]],
});
```

## 错误处理

| 错误 | 原因 | 解决方案 |
|-----|------|---------|
| command not found | 未安装依赖 | `npm install` 或 `pip install -r requirements.txt` |
| No tests found | 测试文件命名错误 | 确保文件名含 `.test.` 或 `test_` |
| Browser not found | E2E 浏览器未安装 | `npx playwright install` |
| Port in use | 端口被占用 | 更换端口或关闭占用进程 |

## 验收标准
- [ ] 能正确识别 JS/Python/E2E 项目类型
- [ ] 执行命令符合各框架官方文档
- [ ] 支持常用参数（覆盖率、过滤、监听）
- [ ] 错误提示清晰可操作
- [ ] 输出结果结构化

## 参考资料
- Vitest: https://vitest.dev/guide/
- Jest: https://jestjs.io/docs/getting-started
- pytest: https://docs.pytest.org/en/stable/getting-started.html
- Playwright: https://playwright.dev/docs/intro
- Cypress: https://docs.cypress.io/guides/getting-started/installing-cypress

## 关联 Skills
- test-js - JavaScript/TypeScript 测试详情
- test-python - Python 测试详情
- test-e2e - E2E 测试详情
- test-api - API 测试详情

