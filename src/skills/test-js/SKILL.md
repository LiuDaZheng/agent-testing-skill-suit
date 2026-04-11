---
name: test-js
description: JavaScript/TypeScript 测试执行器（Vitest, Jest, Playwright）
metadata:
  openclaw:
    version: "1.0"
  author: Gates
  created: 2026-04-10
  license: MIT
---

# test-js - JavaScript/TypeScript 测试执行器

## 角色定位
你是 JS/TS 测试专家，专注于 Vitest、Jest 和 Playwright 测试框架。你提供测试编写、执行、调试的完整支持。

## 支持的框架

### Vitest (推荐用于 Vite 项目)
**安装**: `npm install -D vitest`

**核心命令**:
```bash
npx vitest                    # 监听模式
npx vitest run                # 运行一次
npx vitest run --coverage     # 带覆盖率
npx vitest run -t "关键词"    # 过滤测试
npx vitest --ui               # UI 模式
```

**测试文件示例**:
```typescript
// sum.test.ts
import { expect, test, describe } from 'vitest'
import { sum } from './sum'

describe('sum function', () => {
  test('adds 1 + 2 to equal 3', () => {
    expect(sum(1, 2)).toBe(3)
  })

  test('handles negative numbers', () => {
    expect(sum(-1, -1)).toBe(-2)
  })
})
```

### Jest (通用 JS 测试)
**安装**: `npm install -D jest`

**核心命令**:
```bash
npx jest                    # 运行所有测试
npx jest --watch            # 监听模式
npx jest --coverage         # 带覆盖率
npx jest testFile.test.js   # 单个文件
npx jest -t "关键词"        # 过滤测试
npx jest --updateSnapshot   # 更新快照
```

**测试文件示例**:
```javascript
// sum.test.js
const sum = require('./sum');

test('adds 1 + 2 to equal 3', () => {
  expect(sum(1, 2)).toBe(3);
});

describe('Math operations', () => {
  test('subtraction', () => {
    expect(5 - 3).toBe(2);
  });
});
```

### Playwright (E2E 测试)
**安装**: `npm init playwright@latest`

**核心命令**:
```bash
npx playwright test                    # 运行所有测试
npx playwright test --headed           # 有头模式
npx playwright test --project=chromium # 指定浏览器
npx playwright test --ui               # UI 模式
npx playwright test --debug            # 调试模式
npx playwright show-report             # 查看报告
```

**测试文件示例**:
```typescript
// tests/example.spec.ts
import { test, expect } from '@playwright/test';

test('has title', async ({ page }) => {
  await page.goto('https://example.com');
  await expect(page).toHaveTitle(/Example/);
});

test('get started link', async ({ page }) => {
  await page.goto('https://example.com');
  await page.getByRole('link', { name: 'Get started' }).click();
  await expect(page).toHaveURL(/.*introduction/);
});
```

## 使用示例

### 示例 1: Vitest 单元测试
```bash
# 安装
npm install -D vitest

# 创建测试文件
cat > sum.test.ts << 'EOF'
import { expect, test } from 'vitest'
export function sum(a: number, b: number) {
  return a + b
}
test('adds numbers', () => {
  expect(sum(1, 2)).toBe(3)
})
EOF

# 运行测试
npx vitest run

# 预期输出
# ✓ sum.test.ts (1)
# ✓ adds numbers
# Test Files 1 passed
```

### 示例 2: Jest 快照测试
```bash
# 安装
npm install -D jest

# 创建测试
cat > component.test.js << 'EOF'
test('snapshot test', () => {
  const component = { name: 'Button', props: { label: 'Click' } };
  expect(component).toMatchSnapshot();
});
EOF

# 运行（首次生成快照）
npx jest --updateSnapshot

# 后续运行（对比快照）
npx jest
```

### 示例 3: Playwright E2E 测试
```bash
# 初始化
npm init playwright@latest

# 运行测试
npx playwright test

# 指定浏览器
npx playwright test --project=chromium

# 生成 HTML 报告
npx playwright show-report
```

### 示例 4: Vitest 覆盖率报告
```bash
# 运行带覆盖率
npx vitest run --coverage

# 查看报告
open coverage/index.html
# 或
cat coverage/coverage-summary.json
```

### 示例 5: 调试失败测试
```bash
# 运行单个失败测试
npx vitest run --reporter=verbose

# 调试模式
npx vitest run --debug

# 查看错误详情
# 检查控制台输出和堆栈跟踪
```

## 常用断言

### Vitest/Jest 断言
```typescript
expect(value).toBe(expected)           // 严格相等
expect(value).toEqual(object)          // 深度相等
expect(value).toBeTruthy()             // 真值
expect(value).toContain(item)          // 包含
expect(value).toThrow(error)           // 抛出异常
expect(value).toMatchSnapshot()        // 快照匹配
expect(fn).toHaveBeenCalled()          // 函数被调用
expect(fn).toHaveBeenCalledWith(arg)   // 函数调用参数
```

### Playwright 断言
```typescript
await expect(page).toHaveTitle(/regex/)
await expect(locator).toBeVisible()
await expect(locator).toHaveText('text')
await expect(locator).toContainText('partial')
await expect(locator).toBeEnabled()
await expect(locator).toBeChecked()
```

## 配置模板

### vitest.config.ts
```typescript
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    coverage: {
      provider: 'v8',
      reporter: [       'text',        'json', 'html'       ],
    },
  },
})
```

### jest.config.js
```javascript
module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/*.test.js'],
  collectCoverage: true,
  coverageDirectory: 'coverage',
};
```

### playwright.config.ts
```typescript
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 30000,
  use: {
    headless: true,
    screenshot: 'only-on-failure',
  },
  projects: [
    { name: 'chromium', use: { browserName: 'chromium' } },
  ],
  reporter: [       ['html'],        ['list'       ]],
});
```

## 错误排查

| 错误 | 解决方案 |
|-----|---------|
| `Cannot find module` | 检查 import 路径，确保文件存在 |
| `ReferenceError: describe is not defined` | Vitest 需配置 `globals: true` 或显式导入 |
| `Error: browserType.launch: Executable doesn't exist` | 运行 `npx playwright install` |
| `Snapshot mismatch` | 检查变更是否预期，运行 `--updateSnapshot` |
| `Test timeout exceeded` | 增加 timeout 或优化异步代码 |

## 最佳实践
1. **测试命名**: 使用描述性名称，说明预期行为
2. **AAA 模式**: Arrange(准备) → Act(执行) → Assert(断言)
3. **独立测试**: 每个测试独立，不依赖其他测试状态
4. **快速反馈**: 单元测试应在毫秒级完成
5. **覆盖率目标**: 建议 80%+ 行覆盖率

## 验收标准
- [ ] 支持 Vitest/Jest/Playwright 三种框架
- [ ] 命令基于官方文档，无编造
- [ ] 提供至少 5 个可执行示例
- [ ] 包含配置模板和断言参考
- [ ] 错误排查指南清晰

## 参考资料
- Vitest: https://vitest.dev/guide/
- Jest: https://jestjs.io/docs/getting-started
- Playwright: https://playwright.dev/docs/intro
- Vitest API: https://vitest.dev/api/
- Jest Expect: https://jestjs.io/docs/expect
- Playwright Assertions: https://playwright.dev/docs/assertions

## 关联 Skills
- test-runner - 统一测试执行器
- test-e2e - E2E 测试（含 Cypress）
- test-api - API 测试

