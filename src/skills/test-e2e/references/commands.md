# test-e2e 命令参考

## Playwright 命令
```bash
# 安装
npm init playwright@latest
npx playwright install

# 运行测试
npx playwright test
npx playwright test --headed
npx playwright test --project=chromium
npx playwright test --project=firefox
npx playwright test --project=webkit

# UI 和调试
npx playwright test --ui
npx playwright test --debug
npx playwright codegen

# 报告
npx playwright show-report
npx playwright show-trace

# 更新
npx playwright install --with-deps
```

## Cypress 命令
```bash
# 安装
npm install cypress --save-dev

# 运行
npx cypress open          # 打开 UI
npx cypress run           # 无头运行
npx cypress run --browser chrome
npx cypress run --spec "cypress/e2e/*.cy.js"
npx cypress run --headed
```

## 配置模板

### playwright.config.ts
```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 30000,
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
  ],
  reporter: [['html'], ['github']],
});
```

### cypress.config.js
```javascript
const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    baseUrl: 'https://example.com',
    specPattern: 'cypress/e2e/**/*.cy.js',
    viewportWidth: 1280,
    viewportHeight: 720,
    video: true,
    screenshotOnRunFailure: true,
  },
});
```

## 常用选择器
```typescript
// Playwright
page.getByRole('button', { name: 'Submit' })
page.getByLabel('Email')
page.getByTestId('submit-btn')
page.locator('.class-name')

// Cypress
cy.get('button')
cy.get('.btn-primary')
cy.contains('Submit')
cy.get('[data-testid="submit"]')
```

## 官方文档
- Playwright: https://playwright.dev/
- Cypress: https://docs.cypress.io/
