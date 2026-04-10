# Agent Testing Skill Suit

[![CI/CD](https://github.com/LiuDaZheng/agent-testing-skill-suit/actions/workflows/ci.yml/badge.svg)](https://github.com/LiuDaZheng/agent-testing-skill-suit/actions/workflows/ci.yml)
[![Quality Score](https://img.shields.io/badge/quality-98.9/100-brightgreen)]()
[![Skills](https://img.shields.io/badge/skills-26-blue)]()
[![Documentation](https://img.shields.io/badge/docs-48+-orange)]()
[![License](https://img.shields.io/badge/license-OpenClaw-lightgrey)]()

> **完整的自动化测试生命周期 Skill 体系**  
> 基于 ISTQB STLC 标准，覆盖软件测试全流程

---

## 📋 目录

- [简介](#简介)
- [核心特性](#核心特性)
- [架构设计](#架构设计)
- [快速开始](#快速开始)
- [Skill 清单](#skill-清单)
- [使用示例](#使用示例)
- [项目结构](#项目结构)
- [质量指标](#质量指标)
- [贡献指南](#贡献指南)
- [许可证](#许可证)

---

## 简介

**Agent Testing Skill Suit** 是一套完整的自动化测试生命周期 Skill 体系，包含 26 个专业技能，覆盖软件测试的完整流程。

### 核心价值

- ✅ **完整 STLC 覆盖** - 6 个阶段，从需求到报告
- ✅ **专业测试技术** - 8 种 ISTQB 标准测试设计技术
- ✅ **多语言支持** - Python, JavaScript, E2E, API
- ✅ **开箱即用** - 统一入口，智能路由
- ✅ **高质量保证** - 质量评分 98.9/100，安全检查 0 风险

---

## 核心特性

### 🎯 五层架构模型

```
┌─────────────────────────────────────────┐
│  第 1 层：用户交互层                      │
│  test-assistant (统一入口)              │
├─────────────────────────────────────────┤
│  第 2 层：编排层                          │
│  test-lifecycle + test-workflow         │
├─────────────────────────────────────────┤
│  第 3 层：阶段层（STLC 生命周期）         │
│  6 个 STLC 阶段 Skill                    │
├─────────────────────────────────────────┤
│  第 4 层：技术层（测试设计技术）          │
│  8 种测试设计技术                        │
├─────────────────────────────────────────┤
│  第 5 层：执行层（语言/框架）            │
│  6 个执行 Skill                          │
└─────────────────────────────────────────┘
```

### 📊 完整统计

| 统计项 | 数量 |
|--------|------|
| **总 Skill 数** | 26 |
| **STLC 阶段** | 6/6 (100%) |
| **测试技术** | 8 种 |
| **支持语言** | 4 种 |
| **项目文档** | 48+ |
| **质量评分** | 98.9/100 |
| **安全检查** | 0 风险 |

---

## 架构设计

### 阶段层（6 个 Skill）

基于 ISTQB STLC 标准的 6 个阶段：

1. **test-requirement** - 需求分析
2. **test-plan** - 测试计划
3. **test-design** - 测试设计
4. **test-execute** - 测试执行
5. **test-report** - 测试报告
6. **test-lifecycle** - 生命周期管理

### 技术层（8 个 Skill）

8 种专业测试设计技术：

1. **test-boundary** - 边界值分析
2. **test-equivalence** - 等价类划分
3. **test-state** - 状态转换测试
4. **test-decision** - 决策表测试
5. **test-usecase** - 用例场景测试
6. **test-exploratory** - 探索式测试
7. **test-story-parser** - User Story 解析
8. **test-case-generator** - 测试用例生成

### 执行层（6 个 Skill）

多语言测试执行支持：

1. **test-runner** - 统一执行器
2. **test-js** - JavaScript/TS 测试
3. **test-python** - Python 测试
4. **test-e2e** - 端到端测试
5. **test-api** - API 测试
6. **test-cross-platform** - 跨平台测试

### 辅助层（4 个 Skill）

配置和工具支持：

1. **test-framework-config** - 框架配置
2. **test-ci-cd-config** - CI/CD 配置
3. **test-docker-config** - Docker 配置
4. **test-tool-recommender** - 工具推荐

---

## 快速开始

### 前置条件

- OpenClaw 已安装并配置
- Python 3.8+ (用于 Python 测试)
- Node.js 16+ (用于 JS 测试)

### 安装

Skill 已安装在 `~/.openclaw/skills/`，无需额外安装。

### 基础使用

```bash
# 使用统一入口（推荐）
openclaw run test-assistant "帮我测试登录功能"

# 使用特定 Skill
openclaw run test-design "为登录功能设计测试用例"
openclaw run test-execute "执行测试用例"
openclaw run test-report "生成测试报告"

# 使用工作流
openclaw run test-workflow "启动完整 STLC 流程"
```

---

## Skill 清单

### 阶段层

| Skill | 职责 | 行数 |
|------|------|------|
| test-requirement | 需求分析 | 131 |
| test-plan | 测试计划 | 166 |
| test-design | 测试设计 | 355 |
| test-execute | 测试执行 | 401 |
| test-report | 测试报告 | 328 |
| test-lifecycle | 生命周期管理 | 184 |

### 技术层

| Skill | 职责 | 行数 |
|------|------|------|
| test-boundary | 边界值分析 | 248 |
| test-equivalence | 等价类划分 | 416 |
| test-state | 状态转换测试 | 259 |
| test-decision | 决策表测试 | 328 |
| test-usecase | 用例场景测试 | 426 |
| test-exploratory | 探索式测试 | 431 |
| test-story-parser | User Story 解析 | 409 |
| test-case-generator | 测试用例生成 | 500 |

### 执行层

| Skill | 职责 | 行数 |
|------|------|------|
| test-runner | 统一执行器 | 194 |
| test-js | JavaScript/TS 测试 | 297 |
| test-python | Python 测试 | 372 |
| test-e2e | 端到端测试 | 347 |
| test-api | API 测试 | 490 |
| test-cross-platform | 跨平台测试 | 472 |

### 辅助层

| Skill | 职责 | 行数 |
|------|------|------|
| test-framework-config | 框架配置 | 436 |
| test-ci-cd-config | CI/CD 配置 | 384 |
| test-docker-config | Docker 配置 | 361 |
| test-tool-recommender | 工具推荐 | 429 |

**所有 Skill 均符合 OpenClaw 规范（< 500 行）** ✅

---

## 使用示例

### 示例 1: 完整测试流程

```bash
# 启动完整 STLC 流程
openclaw run test-workflow "启动电商平台的完整测试流程"

# 输出：
# 📋 STLC 流程启动
# 阶段 1: 需求分析 (进行中)
# 阶段 2: 测试计划 (待开始)
# ...
```

### 示例 2: 测试用例设计

```bash
# 为登录功能设计测试用例
openclaw run test-design "为登录功能设计测试用例，包含边界值和等价类"

# 输出：
# ## 测试用例设计
# ### 边界值测试
# - TC-LOGIN-001: 空密码
# - TC-LOGIN-002: 最小长度密码
# ...
```

### 示例 3: 测试执行

```bash
# 执行 Python 测试
openclaw run test-python "运行 tests/ 目录下的所有测试"

# 输出：
# ✅ 测试执行完成
# 总计：50 个测试
# 通过：48 个
# 失败：2 个
```

### 示例 4: 生成报告

```bash
# 生成测试报告
openclaw run test-report "基于执行结果生成测试报告"

# 输出：
# ## 测试总结报告
# 执行率：100%
# 通过率：96%
# 质量评估：优秀
```

---

## 项目结构

```
Agent-Testing-Skill-Suit/
├── src/skills/              # Skill 源码（26 个）
│   ├── test-requirement/
│   ├── test-plan/
│   ├── test-design/
│   ├── test-execute/
│   ├── test-report/
│   ├── test-lifecycle/
│   ├── test-boundary/
│   ├── test-equivalence/
│   ├── ...
│   └── test-workflow/
├── docs/                    # 项目文档（48+ 个）
│   ├── kickoff.md
│   ├── overview.md
│   ├── architecture.md
│   ├── quality-audit-report.md
│   ├── safety-audit-report.md
│   └── ...
├── tests/                   # 测试用例
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── scripts/                 # 辅助脚本
│   ├── skill-audit.py
│   └── skill-quality-audit.sh
├── CHECKLIST.md             # 检查清单
├── DEVELOPMENT.md           # 开发指南
├── PROJECT_STRUCTURE.md     # 项目结构
├── README.md                # 项目说明（本文档）
└── TODO.md                  # 任务清单
```

---

## 质量指标

### 代码质量

| 指标 | 目标 | 实际 | 状态 |
|------|------|------|------|
| **Skill 数量** | 15+ | **26** | ✅ 超额 73% |
| **文档数量** | 10+ | **48+** | ✅ 超额 380% |
| **行数合规** | < 500 行 | **100%** | ✅ 全部合规 |
| **质量评分** | > 80 | **98.9** | ✅ 优秀 |
| **安全检查** | 0 风险 | **0** | ✅ 无风险 |
| **STLC 覆盖** | 6 阶段 | **6/6** | ✅ 完整覆盖 |
| **测试技术** | 6+ 种 | **8 种** | ✅ 超额 33% |

### 审计报告

- ✅ **质量审计报告**: `docs/quality-audit-report.md`
- ✅ **安全审计报告**: `docs/safety-audit-report.md`
- ✅ **验证报告**: `docs/verification-report.md`

---

## 贡献指南

### 开发流程

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

### 代码规范

- 遵循 OpenClaw Skill 规范
- 所有 Skill < 500 行
- 包含完整的 YAML frontmatter
- 至少 3 个使用示例
- 包含验收检查清单

### 提交规范

使用 Conventional Commits：

```
feat: 新功能
fix: Bug 修复
docs: 文档更新
style: 格式调整
refactor: 重构
test: 测试相关
chore: 构建/工具
```

---

## 许可证

本项目遵循 OpenClaw Skills 许可协议。

---

## 联系方式

- **项目地址**: https://github.com/LiuDaZheng/agent-testing-skill-suit
- **问题反馈**: https://github.com/LiuDaZheng/agent-testing-skill-suit/issues
- **邮件**: jiejun.liu@comonetwork.com

---

## 致谢

感谢 OpenClaw 社区提供的平台和工具支持。

感谢 ISTQB 提供的测试标准指导。

---

**最后更新**: 2026-04-10  
**版本**: v1.0.0  
**状态**: ✅ 正式发布
