# 自动化测试 Skill 调研报告

## 📋 执行摘要

本报告调研了如何为 OpenClaw 开发自动化测试相关的 Skill，旨在帮助 Agent 进行开发的测试工作。基于对现有测试框架、OpenClaw Skill 规范和 ClawHub 现有技能的分析，提供了完整的 Skill 开发策略建议。

---

## 🔍 一、测试工具与框架概览（2026）

### 1.1 主流测试框架分类

| 测试类型 | JavaScript/TypeScript | Python | Swift | Go |
|---------|----------------------|--------|-------|-----|
| **单元测试** | Vitest (首选), Jest | pytest | XCTest | go test |
| **集成测试** | Supertest | pytest + httpx | XCTest | httptest |
| **E2E 测试** | Playwright, Cypress | Playwright | XCUITest | rod |
| **API 测试** | Jest + Supertest | pytest + requests | - | - |
| **性能测试** | k6 | locust | - | - |

### 1.2 核心测试工具特性

#### Vitest (JavaScript/TypeScript)
- ✅ 首选推荐（2026 年趋势）
- ✅ 与 Vite 生态无缝集成
- ✅ 支持组件测试、快照测试
- ✅ 原生 ESM 支持
- 命令：`npx vitest`, `npx vitest --coverage`, `npx vitest --watch`

#### Jest (JavaScript/TypeScript)
- ✅ 成熟稳定，生态丰富
- ⚠️ 配置相对复杂
- ✅ 支持快照测试、模拟
- 命令：`npx jest`, `npx jest --coverage`, `npx jest --watch`

#### pytest (Python)
- ✅ Python 测试标准
- ✅ 插件生态丰富（pytest-cov, pytest-asyncio）
- ✅ 简洁的语法
- 命令：`pytest`, `pytest --cov=app`, `pytest -v`

#### Playwright (跨语言 E2E)
- ✅ 支持 Chromium, Firefox, WebKit
- ✅ 自动等待、网络拦截
- ✅ 跨语言（JS, Python, Java, .NET）
- 命令：`npx playwright test`, `npx playwright test --debug`

---

## 📐 二、Skill 组织策略

### 2.1 方案对比

| 方案 | 优点 | 缺点 | 推荐度 |
|------|------|------|--------|
| **单一 Skill** | 简单易管理，Agent 选择成本低 | 认知负载高，技能描述冗长 | ⭐⭐ |
| **按测试类型分** | 职责清晰，易于维护 | Skill 数量较多 | ⭐⭐⭐⭐ |
| **按语言分** | 语言特定工具隔离 | 跨语言项目复杂 | ⭐⭐ |
| **分层架构** | 核心 + 扩展，灵活 | 初始复杂度高 | ⭐⭐⭐⭐⭐ |

### 2.2 推荐方案：分层架构

```
测试 Skill 体系
├── 核心层 (Core)
│   └── test-runner (测试执行器)
│       - 统一接口
│       - 智能识别项目类型
│       - 跨框架支持
│
├── 语言层 (Language-Specific)
│   ├── test-js (JavaScript/TypeScript)
│   ├── test-python (Python)
│   ├── test-swift (Swift)
│   └── test-go (Go)
│
├── 类型层 (Test-Type)
│   ├── test-unit (单元测试)
│   ├── test-integration (集成测试)
│   ├── test-e2e (端到端测试)
│   └── test-api (API 测试)
│
└── 工具层 (Tool-Specific)
    ├── test-playwright (Playwright E2E)
    ├── test-cypress (Cypress E2E)
    ├── test-jest (Jest 配置)
    └── test-pytest (pytest 配置)
```

### 2.3 为什么选择分层架构？

1. **用户体验优先**
   - 普通用户：只需 `test-runner`，自动识别项目
   - 高级用户：可以指定具体框架/语言

2. **维护性**
   - 核心层稳定，语言层/工具层可独立更新
   - 新增框架只需添加新 Skill，不影响现有

3. **Agent 友好**
   - 清晰的职责边界
   - 减少模型选择困惑
   - 支持组合使用

---

## 📝 三、Skill 规范详解

### 3.1 标准目录结构

```
skill-name/
├── SKILL.md              # 必需：技能定义
├── README.md             # 推荐：使用说明
├── package.json          # 可选：Node.js 依赖
├── requirements.txt      # 可选：Python 依赖
├── src/                  # 可选：辅助脚本
│   ├── runner.js
│   └── utils.py
└── examples/             # 可选：示例
    └── test-example.js
```

### 3.2 SKILL.md 必需字段

```markdown
---
name: test-runner
description: 智能测试执行器，支持多语言和测试框架
homepage: https://github.com/yourusername/test-runner-skill
metadata: {
  "openclaw": {
    "emoji": "🧪",
    "requires": {
      "bins": ["node", "npm"],
      "anyBins": ["vitest", "jest", "pytest", "playwright"],
      "config": ["testing.enabled"]
    },
    "os": ["darwin", "linux"],
    "install": [
      {
        "id": "npm",
        "kind": "node",
        "package": "vitest",
        "bins": ["vitest"],
        "label": "安装 Vitest (npm)",
        "os": ["darwin", "linux"]
      }
    ]
  }
}
---
```

### 3.3 SKILL.md 内容结构

```markdown
# Skill 名称

## 何时使用

| 场景 | 操作 |
|------|------|
| 运行单元测试 | 调用 test-unit |
| 运行 E2E 测试 | 调用 test-e2e |
| 生成测试报告 | 调用 test-report |

## 核心功能

### 1. 功能名称
说明 + 示例

### 2. 功能名称
说明 + 示例

## 命令参考

```bash
# 示例命令
npx vitest run
pytest --cov=app
```

## 最佳实践

- 实践 1
- 实践 2

## 故障排除

### 常见问题 1
解决方案

### 常见问题 2
解决方案
```

### 3.4 认知负载评估（WC 指标）

| 指标 | 目标值 | 说明 |
|------|--------|------|
| 行数 | < 500 行 | 保持简洁 |
| Token 数 | < 4000 | 模型友好 |
| 命令数 | < 10 个 | 避免 overwhelm |
| 决策点 | < 5 个 | 简化选择 |

---

## 🎯 四、推荐 Skill 设计方案

### 4.1 核心 Skill：test-runner

**职责**：统一测试执行接口，智能识别项目类型

**功能**：
- 自动检测项目语言（package.json, requirements.txt, go.mod）
- 智能选择测试框架
- 执行测试并生成报告
- 支持增量测试（watch 模式）

**示例指令**：
```
- 运行所有测试
- 运行单个测试文件
- 运行并生成覆盖率报告
- 监听模式运行测试
```

### 4.2 语言特定 Skill

#### test-js (JavaScript/TypeScript)
```markdown
---
name: test-js
description: JavaScript/TypeScript 测试执行（Vitest, Jest, Playwright）
metadata: {
  "openclaw": {
    "requires": { "bins": ["node", "npm"] },
    "anyBins": ["vitest", "jest", "playwright"]
  }
}
---
```

**功能**：
- Vitest 单元测试
- Jest 测试（遗留项目）
- Playwright E2E 测试
- 组件测试（React, Vue）

#### test-python (Python)
```markdown
---
name: test-python
description: Python 测试执行（pytest, unittest）
metadata: {
  "openclaw": {
    "requires": { "bins": ["python", "pip"] },
    "anyBins": ["pytest"]
  }
}
---
```

**功能**：
- pytest 单元测试
- pytest 集成测试
- pytest-asyncio 异步测试
- 覆盖率报告

### 4.3 测试类型 Skill

#### test-e2e (端到端测试)
**功能**：
- Playwright 配置
- Cypress 配置
- 浏览器选择
- 截图/录屏
- 网络拦截

#### test-api (API 测试)
**功能**：
- REST API 测试
- GraphQL 测试
- 认证处理
- 响应验证

---

## 📋 五、开发路线图

### Phase 1: MVP (1-2 周)
- [ ] `test-runner` 核心 Skill
- [ ] 支持 JavaScript/TypeScript (Vitest)
- [ ] 支持 Python (pytest)
- [ ] 基础测试执行和报告

### Phase 2: 扩展 (2-3 周)
- [ ] `test-e2e` Skill (Playwright)
- [ ] `test-api` Skill
- [ ] 覆盖率报告生成
- [ ] CI/CD 集成

### Phase 3: 完善 (3-4 周)
- [ ] 更多语言支持 (Go, Swift)
- [ ] 测试生成（AI 辅助编写测试）
- [ ] 性能测试支持
- [ ] 测试修复建议

---

## 🔗 六、参考资源

### 官方文档
- OpenClaw Skills: https://docs.openclaw.ai/tools/skills
- 创建 Skills: https://docs.openclaw.ai/tools/creating-skills
- ClawHub: https://clawhub.ai

### 现有 Skill 参考
- test-runner: https://github.com/openclaw/skills/tree/main/skills/cmanfre7/test-runner
- cypress-agent-skill: https://github.com/KahlilR23/cypress-agent-skill

### 测试框架文档
- Vitest: https://vitest.dev/
- Playwright: https://playwright.dev/
- pytest: https://docs.pytest.org/
- Cypress: https://docs.cypress.io/

---

## 💡 七、关键建议

### 7.1 设计原则

1. **渐进式复杂度**
   - 新手：一个命令运行所有测试
   - 专家：精细控制每个参数

2. **智能默认值**
   - 自动检测项目类型
   - 使用最佳实践配置
   - 减少用户决策

3. **错误友好**
   - 清晰的错误信息
   - 自动修复建议
   - 常见问题 FAQ

### 7.2 技术决策

| 决策 | 推荐 | 理由 |
|------|------|------|
| 默认 JS 测试框架 | Vitest | 2026 年趋势，Vite 生态 |
| 默认 Python 框架 | pytest | 行业标准 |
| 默认 E2E 工具 | Playwright | 跨浏览器，跨语言 |
| Skill 组织 | 分层架构 | 灵活、可维护 |

### 7.3 发布策略

1. **内部测试** → 团队内使用
2. **ClawHub 发布** → 社区反馈
3. **迭代优化** → 根据反馈改进
4. **官方收录** → 进入官方 Skills

---

## 📊 八、认知负载评估模板

对于每个 Skill，使用以下模板评估：

```markdown
## WC 认知负载评估

- **行数**: XXX / 500
- **Token 数**: XXXX / 4000
- **命令数**: X / 10
- **决策点**: X / 5
- **依赖数**: X / 5
- **示例数**: X / 3

**状态**: ✅ 通过 / ⚠️ 需要优化 / ❌ 需要重构
```

---

## ✅ 总结

开发自动化测试 Skill 的最佳策略是：

1. **采用分层架构**：核心 + 语言 + 类型 + 工具
2. **从 MVP 开始**：先做 `test-runner` 支持主流框架
3. **遵循规范**：严格按照 OpenClaw Skill 格式
4. **用户友好**：智能默认值 + 清晰错误信息
5. **持续迭代**：根据反馈逐步扩展

**下一步行动**：
1. 创建 `test-runner` Skill 目录
2. 编写 SKILL.md 初稿
3. 实现核心功能
4. 内部测试
5. 发布到 ClawHub

---

*报告生成时间：2026-04-10*
*调研来源：OpenClaw 官方文档、ClawHub、GitHub、测试框架官方文档*
