# test-js 命令参考

## Vitest 命令
```bash
# 基础命令
npx vitest                    # 监听模式
npx vitest run                # 运行一次
npx vitest run --coverage     # 覆盖率
npx vitest run -t "pattern"   # 过滤测试
npx vitest --ui               # UI 模式

# 配置文件
npx vitest --config vitest.config.ts
```

## Jest 命令
```bash
# 基础命令
npx jest                      # 运行测试
npx jest --watch              # 监听模式
npx jest --coverage           # 覆盖率
npx jest -t "pattern"         # 过滤测试
npx jest --updateSnapshot     # 更新快照

# 配置文件
npx jest --config jest.config.js
```

## Playwright 命令
```bash
# 基础命令
npx playwright test                    # 运行测试
npx playwright test --headed           # 有头模式
npx playwright test --project=chromium # 指定浏览器
npx playwright test --ui               # UI 模式
npx playwright test --debug            # 调试模式

# 报告
npx playwright show-report             # HTML 报告
npx playwright show-trace              # 追踪

# 工具
npx playwright install                 # 安装浏览器
npx playwright codegen                 # 代码生成
```

## 配置模板

### vitest.config.ts
```typescript
import { defineConfig } from 'vitest/config'
export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    coverage: { provider: 'v8', reporter: ['text', 'html'] },
  },
})
```

### jest.config.js
```javascript
module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/*.test.js'],
  collectCoverage: true,
}
```

### playwright.config.ts
```typescript
import { defineConfig } from '@playwright/test';
export default defineConfig({
  testDir: './tests',
  timeout: 30000,
  projects: [{ name: 'chromium', use: { browserName: 'chromium' } }],
  reporter: [['html'], ['list']],
})
```

## 官方文档
- Vitest: https://vitest.dev/
- Jest: https://jestjs.io/
- Playwright: https://playwright.dev/
