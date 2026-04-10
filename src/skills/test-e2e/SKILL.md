---
name: test-e2e
description: E2E 测试执行器（Playwright, Cypress）
metadata:
  openclaw:
    version: "1.0"
  author: Gates
  created: 2026-04-10
  license: MIT
---

# test-e2e - E2E 测试执行器

## 角色定位
你是端到端测试专家，专注于 Playwright 和 Cypress 框架。你提供浏览器自动化测试的编写、执行和调试支持。

## 支持的框架

### Playwright (推荐)
**安装**: `npm init playwright@latest`

**核心命令**:
```bash
npx playwright test                    # 运行所有测试
npx playwright test --headed           # 有头模式（显示浏览器）
npx playwright test --project=chromium # 指定浏览器
npx playwright test --project=firefox  # Firefox
npx playwright test --project=webkit   # WebKit
npx playwright test --ui               # UI 模式
npx playwright test --debug            # 调试模式
npx playwright test --trace on         # 启用追踪
npx playwright show-report             # 查看 HTML 报告
npx playwright show-trace              # 查看追踪
npx playwright install                 # 安装浏览器
npx playwright codegen                 # 代码生成器
```

**测试文件示例**:
```typescript
// tests/example.spec.ts
import { test, expect } from '@playwright/test';

test('homepage has title', async ({ page }) => {
  await page.goto('https://example.com');
  await expect(page).toHaveTitle(/Example/);
});

test('click link', async ({ page }) => {
  await page.goto('https://example.com');
  await page.getByRole('link', { name: 'More info' }).click();
  await expect(page).toHaveURL(/.*more/);
});
```

### Cypress
**安装**: `npm install cypress --save-dev`

**核心命令**:
```bash
npx cypress open          # 打开 Cypress UI
npx cypress run           # 无头运行
npx cypress run --browser chrome  # 指定浏览器
npx cypress run --spec "cypress/e2e/*.cy.js"  # 指定文件
npx cypress run --headed  # 有头模式
```

**测试文件示例**:
```javascript
// cypress/e2e/example.cy.js
describe('Homepage', () => {
  it('loads successfully', () => {
    cy.visit('https://example.com');
    cy.title().should('include', 'Example');
  });

  it('clicks link', () => {
    cy.visit('https://example.com');
    cy.contains('More info').click();
    cy.url().should('include', 'more');
  });
});
```

## 使用示例

### 示例 1: Playwright 基础测试
```bash
# 初始化项目
npm init playwright@latest

# 运行测试
npx playwright test

# 有头模式
npx playwright test --headed

# 指定浏览器
npx playwright test --project=chromium

# 预期输出
# Running 3 tests using 3 workers
# ✓ tests/example.spec.ts (3)
# Test Files 1 passed
```

### 示例 2: Playwright 多浏览器测试
```bash
# playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  projects: [
    { name: 'chromium', use: { browserName: 'chromium' } },
    { name: 'firefox', use: { browserName: 'firefox' } },
    { name: 'webkit', use: { browserName: 'webkit' } },
  ],
});

# 运行所有浏览器
npx playwright test

# 只运行 Chromium
npx playwright test --project=chromium
```

### 示例 3: Playwright 登录测试
```typescript
// tests/auth.spec.ts
import { test, expect } from '@playwright/test';

test('login and logout', async ({ page }) => {
  // 访问登录页
  await page.goto('https://example.com/login');

  // 填写表单
  await page.getByLabel('Email').fill('test@example.com');
  await page.getByLabel('Password').fill('password123');
  await page.getByRole('button', { name: 'Sign in' }).click();

  // 验证登录成功
  await expect(page).toHaveURL('/dashboard');
  await expect(page.getByText('Welcome')).toBeVisible();

  // 登出
  await page.getByRole('button', { name: 'Logout' }).click();
  await expect(page).toHaveURL('/login');
});
```

### 示例 4: Playwright 截图和录屏
```typescript
// tests/screenshots.spec.ts
import { test, expect } from '@playwright/test';

test('capture screenshot', async ({ page }) => {
  await page.goto('https://example.com');
  await page.screenshot({ path: 'homepage.png' });
  await expect(page).toHaveScreenshot();
});

test('record video', async ({ browser }) => {
  const context = await browser.newContext({
    recordVideo: { dir: 'videos/' }
  });
  const page = await context.newPage();
  await page.goto('https://example.com');
  await context.close();
});
```

### 示例 5: Cypress 基础测试
```bash
# 安装
npm install cypress --save-dev

# 打开 UI
npx cypress open

# 无头运行
npx cypress run

# 指定文件
npx cypress run --spec "cypress/e2e/home.cy.js"
```

### 示例 6: Cypress 网络拦截
```javascript
// cypress/e2e/api.cy.js
describe('API Interception', () => {
  it('intercepts GET request', () => {
    cy.intercept('GET', '/api/users').as('getUsers');
    cy.visit('/users');
    cy.wait('@getUsers');
    cy.get('@getUsers').its('response.statusCode').should('eq', 200);
  });

  it('mocks response', () => {
    cy.intercept('GET', '/api/data', {
      statusCode: 200,
      body: { items: ['mocked'] }
    }).as('getData');
    cy.visit('/data');
    cy.contains('mocked').should('be.visible');
  });
});
```

### 示例 7: Playwright 等待和断言
```typescript
// tests/waiting.spec.ts
import { test, expect } from '@playwright/test';

test('auto-wait and assertions', async ({ page }) => {
  await page.goto('https://example.com');

  // 自动等待元素可操作
  await page.getByRole('button').click();

  // 等待导航
  await page.waitForURL(/dashboard/);

  // 等待元素
  await page.waitForSelector('.loaded');

  // 各种断言
  await expect(page).toHaveTitle(/Example/);
  await expect(page.locator('.item')).toHaveCount(5);
  await expect(page.getByText('Success')).toBeVisible();
  await expect(page.getByRole('button')).toBeEnabled();
});
```

## 常用选择器

### Playwright 选择器
```typescript
// 推荐：用户可见的选择器
page.getByRole('button', { name: 'Submit' })
page.getByLabel('Email')
page.getByPlaceholder('Enter name')
page.getByText('Welcome')
page.getByTestId('submit-btn')
page.getByRole('link', { name: 'Home' })

// CSS 选择器（备选）
page.locator('.class-name')
page.locator('#id-name')
page.locator('div > button')

// XPath（复杂场景）
page.locator('xpath=//button[text()="Submit"]')
```

### Cypress 选择器
```javascript
cy.get('button')                    // CSS 选择器
cy.get('.btn-primary')              // 类选择器
cy.get('#submit')                   // ID 选择器
cy.contains('Submit')               // 文本匹配
cy.contains('button', 'Submit')     // 元素 + 文本
cy.get('[data-testid="submit"]')    // 测试 ID
```

## 配置模板

### playwright.config.ts
```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 30000,
  expect: {
    timeout: 5000,
  },
  use: {
    headless: true,
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'retain-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
    { name: 'Mobile Chrome', use: { ...devices['Pixel 5'] } },
    { name: 'Mobile Safari', use: { ...devices['iPhone 12'] } },
  ],
  reporter: [    ['html'],     ['github'    ]],
});
```

### cypress.config.js
```javascript
const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    baseUrl: 'https://example.com',
    supportFile: 'cypress/support/e2e.js',
    specPattern: 'cypress/e2e/**/*.cy.js',
    viewportWidth: 1280,
    viewportHeight: 720,
    video: true,
    screenshotOnRunFailure: true,
  },
});
```

## 错误排查

| 错误 | 解决方案 |
|-----|---------|
| `browserType.launch: Executable doesn't exist` | 运行 `npx playwright install` |
| `Timeout 30000ms exceeded` | 检查元素选择器，增加 timeout 或添加等待 |
| `Element is not visible` | 确保元素在视口内，使用 `scrollIntoViewIfNeeded()` |
| `Navigation timeout exceeded` | 检查页面加载，使用 `waitForLoadState()` |
| `Cypress: command not found` | `npm install cypress --save-dev` |

## 最佳实践
1. **Page Object 模式**: 封装页面操作，提高可维护性
2. **稳定选择器**: 优先使用 `getByRole`, `getByTestId`
3. **自动等待**: 利用框架的自动等待，避免硬编码 `sleep`
4. **独立测试**: 每个测试独立，可并行执行
5. **失败截图**: 开启失败时自动截图
6. **CI 集成**: 使用无头模式，生成 HTML 报告
7. **合理超时**: 根据网络情况设置合理超时

## 验收标准
- [ ] 支持 Playwright 和 Cypress 框架
- [ ] 命令基于官方文档，无编造
- [ ] 提供至少 5 个可执行示例
- [ ] 包含配置模板和选择器参考
- [ ] 错误排查指南清晰

## 参考资料
- Playwright: https://playwright.dev/
- Playwright 入门: https://playwright.dev/docs/intro
- Playwright 断言: https://playwright.dev/docs/assertions
- Playwright 选择器: https://playwright.dev/docs/locators
- Cypress: https://docs.cypress.io/
- Cypress 入门: https://docs.cypress.io/guides/getting-started/installing-cypress

## 关联 Skills
- test-runner - 统一测试执行器
- test-js - JavaScript/TypeScript 测试
- test-api - API 测试

