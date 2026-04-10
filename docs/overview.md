# Agent Testing Skill Suit - 项目概述

> **好记性不如烂笔头** - 本项目文档作为开发过程中的权威参考，确保所有决策和实现有据可查。

---

## 📋 项目基本信息

| 项目 | 信息 |
|------|------|
| **项目名称** | Agent Testing Skill Suit |
| **项目 ID** | `agent-testing-skill-suit` |
| **创建时间** | 2026-04-10 |
| **项目负责人** | skilldev Agent |
| **项目状态** | 🟢 启动阶段 |
| **预计周期** | 8-12 周 |
| **预计 Skill 数量** | 15+ 个 |

---

## 🎯 项目目标

### 核心目标

开发一套完整的**自动化测试生命周期 Skill 体系**，使 OpenClaw Agent 能够：

1. **理解测试需求** - 分析需求文档、用户故事、API 规范
2. **设计测试用例** - 应用专业测试设计技术（边界值、等价类等）
3. **执行测试** - 跨语言、跨框架执行测试
4. **生成报告** - 自动生成测试报告和质量评估

### 具体目标

| 目标 | 衡量标准 | 优先级 |
|------|---------|--------|
| 覆盖 STLC 全部 6 个阶段 | 需求分析→计划→设计→执行→报告→闭环 | 🔴 P0 |
| 支持 6+ 种测试设计技术 | 边界值、等价类、状态转换、决策表等 | 🔴 P0 |
| 支持 4+ 种编程语言 | JavaScript/TS, Python, Go, Swift | 🔴 P0 |
| 支持主流测试框架 | Vitest, Jest, pytest, Playwright 等 | 🔴 P0 |
| 文档完整率 > 95% | 每个 Skill 包含完整文档 | 🟡 P1 |
| 测试覆盖率 > 80% | 所有 Skill 自身经过充分测试 | 🟡 P1 |

---

## 🏗️ 技术架构：三层模型

```
                        ┌─────────────────┐
                        │  协调层          │
                        │ test-lifecycle  │
                        │ (总协调器)      │
                        └────────┬────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
┌───────▼────────┐      ┌───────▼────────┐      ┌───────▼────────┐
│   阶段层        │      │   阶段层        │      │   阶段层        │
│  (Phase)       │      │  (Phase)       │      │  (Phase)       │
│ test-requirement│     │ test-plan       │      │ test-design     │
│ test-execute    │      │ test-report     │      │                 │
└────────────────┘      └────────────────┘      └────────────────┘
        │                        │                        │
        └────────────────────────┼────────────────────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
┌───────▼────────┐      ┌───────▼────────┐      ┌───────▼────────┐
│   技术层        │      │   技术层        │      │   技术层        │
│  (Technique)   │      │  (Technique)   │      │  (Technique)   │
│ test-boundary  │      │ test-equivalence│     │ test-state      │
│ test-decision  │      │ test-usecase    │      │ test-exploratory│
└────────────────┘      └────────────────┘      └────────────────┘
        │                        │                        │
        └────────────────────────┼────────────────────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
┌───────▼────────┐      ┌───────▼────────┐      ┌───────▼────────┐
│   执行层        │      │   执行层        │      │   执行层        │
│  (Execution)   │      │  (Execution)   │      │  (Execution)   │
│ test-runner    │      │ test-js        │      │ test-python     │
│ test-e2e       │      │ test-api       │      │                 │
└────────────────┘      └────────────────┘      └────────────────┘
```

---

## 📁 项目位置

### 代码仓库

| 类型 | 位置 | 用途 |
|------|------|------|
| **主仓库** | `~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/` | 项目开发 |
| **Skill 安装位置** | `~/.openclaw/skills/` | 生产部署（共享） |
| **文档位置** | `~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/docs/` | 项目文档 |

### 目录结构

```
Agent-Testing-Skill-Suit/
├── 项目概述.md              # 本文档
├── 项目计划.md              # 详细项目计划（task-planning 生成）
├── docs/                    # 项目文档
│   ├── 架构设计.md
│   ├── Skill 规范.md
│   └── 开发指南.md
├── skills/                  # Skill 源代码
│   ├── test-lifecycle/
│   ├── test-boundary/
│   ├── test-equivalence/
│   └── ...
├── references/              # 参考资料
│   ├── STLC 标准.md
│   ├── 测试设计技术.md
│   └── 框架文档.md
└── tests/                   # 测试用例
    ├── unit/
    ├── integration/
    └── e2e/
```

---

## 📐 设计原则

### 核心原则（来自官方文档）

1. **简洁至上** (Concise is Key)
   - 上下文窗口是公共资源
   - 每个 Skill < 500 行，< 4000 Tokens
   - 只添加 Agent 不知道的信息

2. **适度自由度** (Set Appropriate Degrees of Freedom)
   - 高自由度：文本指令（多种方法有效时）
   - 中自由度：伪代码（有优选模式时）
   - 低自由度：具体脚本（一致性关键时）

3. **单一职责** (Single Responsibility)
   - 每个 Skill 职责清晰
   - 可独立开发、测试、更新
   - 支持灵活组合

### 质量标准

| 维度 | 标准 | 验证方法 |
|------|------|---------|
| **行数** | < 500 行/Skill | `wc -l SKILL.md` |
| **Token 数** | < 4000/Skill | `wc -m SKILL.md` |
| **命令数** | < 10 个/Skill | 人工审查 |
| **决策点** | < 5 个/Skill | 人工审查 |
| **文档完整性** | > 95% | agent-audit |
| **测试覆盖率** | > 80% | test-runner |

---

## 🔧 实施方法

### 开发流程

```
需求分析 → 设计评审 → 开发实现 → 文档生成 → 质量审计 → 发布部署
   ↓           ↓           ↓           ↓           ↓           ↓
references  skill-    编码实现   technical-  agent-     clawhub
           creator              doc-gen     audit      publish
```

### 工具链

| 工具 | 用途 | 状态 |
|------|------|------|
| `skill-creator` | Skill 框架创建 | ✅ 已安装 |
| `github` | 版本控制 | ✅ 已安装 |
| `task-planning` | 任务管理 | ✅ 已安装 |
| `technical-doc-generator` | 文档生成 | ✅ 已安装 |
| `api-doc-generator` | API 文档 | ✅ 已安装 |
| `agent-audit` | 质量审计 | ✅ 已安装 |
| `agent-safety` | 安全检查 | ✅ 已安装 |
| `agent-cost-monitor` | 成本跟踪 | ✅ 已安装 |

### Sub-Agent 分工

| Sub-Agent | 职责 | 交付物 |
|-----------|------|--------|
| **Agent 1** | 阶段层 Skill 开发 | test-requirement, test-plan, test-design, test-execute, test-report |
| **Agent 2** | 技术层 Skill 开发（基础） | test-boundary, test-equivalence |
| **Agent 3** | 技术层 Skill 开发（高级） | test-state, test-decision, test-usecase, test-exploratory |
| **Agent 4** | 执行层 Skill 开发 | test-runner, test-js, test-python, test-e2e, test-api |
| **Agent 5** | 文档与质量 | 所有文档、测试用例、质量审计 |

---

## 📚 参考资料（可信来源）

### 官方标准

| 资料 | 来源 | 可信度 |
|------|------|--------|
| STLC 6 阶段 | GeeksforGeeks, ISTQB | ⭐⭐⭐⭐⭐ |
| 边界值分析 (BVA) | ISTQB, Katalon | ⭐⭐⭐⭐⭐ |
| 等价类划分 (EP) | ISTQB, Katalon | ⭐⭐⭐⭐⭐ |
| 状态转换测试 | ISTQB, TestDevLab | ⭐⭐⭐⭐⭐ |
| 决策表测试 | ISTQB, TestFort | ⭐⭐⭐⭐⭐ |

### OpenClaw 规范

| 资料 | 来源 | URL |
|------|------|-----|
| Skills 规范 | OpenClaw 官方 | https://docs.openclaw.ai/tools/skills |
| 创建 Skills | OpenClaw 官方 | https://docs.openclaw.ai/tools/creating-skills |
| Skill Creator | 内置 Skill | `skill-creator` |

### 测试框架文档

| 框架 | 官方文档 | 可信度 |
|------|---------|--------|
| Vitest | https://vitest.dev/ | ⭐⭐⭐⭐⭐ |
| Jest | https://jestjs.io/ | ⭐⭐⭐⭐⭐ |
| pytest | https://docs.pytest.org/ | ⭐⭐⭐⭐⭐ |
| Playwright | https://playwright.dev/ | ⭐⭐⭐⭐⭐ |

---

## ⚠️ 重要约束

### 禁止行为

- ❌ **不能瞎编** - 所有测试技术必须基于 ISTQB 等官方标准
- ❌ **不能猜测** - 不确定的内容必须查阅官方文档
- ❌ **不能抄袭** - 参考可以，必须用自己的话表述
- ❌ **不能超纲** - 每个 Skill 必须符合行数、Token 限制

### 必须遵守

- ✅ **引用来源** - 所有技术决策必须标注来源
- ✅ **验证实现** - 所有代码必须经过测试
- ✅ **文档完整** - 每个 Skill 必须包含完整文档
- ✅ **安全审计** - 发布前必须通过 agent-safety 检查

---

## 📊 项目里程碑

| 阶段 | 时间 | 交付物 | 状态 |
|------|------|--------|------|
| **Phase 1: 核心基础** | 第 1-3 周 | test-runner, test-boundary, test-equivalence, test-design | 🟡 未开始 |
| **Phase 2: 生命周期** | 第 4-7 周 | test-plan, test-execute, test-report, test-lifecycle | ⚪ 未开始 |
| **Phase 3: 高级技术** | 第 8-10 周 | test-state, test-decision, test-usecase, test-exploratory | ⚪ 未开始 |
| **Phase 4: 执行层** | 第 11-14 周 | test-js, test-python, test-e2e, test-api | ⚪ 未开始 |
| **Phase 5: 收尾** | 第 15-16 周 | 集成测试、文档完善、发布 | ⚪ 未开始 |

---

## 🎯 成功标准

### 功能标准

- [ ] 15+ 个 Skill 全部开发完成
- [ ] 覆盖 STLC 全部 6 个阶段
- [ ] 支持 6+ 种测试设计技术
- [ ] 支持 4+ 种编程语言
- [ ] 支持主流测试框架

### 质量标准

- [ ] 所有 Skill 通过 agent-audit 审计
- [ ] 所有 Skill 通过 agent-safety 检查
- [ ] 测试覆盖率 > 80%
- [ ] 文档完整率 > 95%
- [ ] 用户满意度 > 4.5/5

### 发布标准

- [ ] 发布到 ClawHub
- [ ] 获得官方收录
- [ ] 社区反馈良好

---

## 📝 变更记录

| 日期 | 变更内容 | 负责人 |
|------|---------|--------|
| 2026-04-10 | 项目立项，创建概述文档 | skilldev |
| - | - | - |

---

## 🔗 相关链接

- **项目仓库**: `~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/`
- **Skill 安装位置**: `~/.openclaw/workspace-main/skills/`
- **OpenClaw 文档**: https://docs.openclaw.ai/
- **ClawHub**: https://clawhub.ai
- **ISTQB 标准**: https://www.istqb.org/

---

*文档版本：1.0*
*创建时间：2026-04-10*
*最后更新：2026-04-10*
*负责人：skilldev Agent*
