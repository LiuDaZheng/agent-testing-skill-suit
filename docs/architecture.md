# 架构设计

> 三层架构模型：阶段层 + 技术层 + 执行层

---

## 🏗️ 整体架构

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

## 📋 分层说明

### 第一层：阶段层（STLC 生命周期）

基于 ISTQB 标准的软件测试生命周期（STLC）6 个阶段：

| Skill | 职责 | 核心功能 |
|-------|------|---------|
| test-requirement | 需求分析 | 需求可测试性分析、风险识别、RTM 创建 |
| test-plan | 测试计划 | 测试策略、资源规划、时间估算 |
| test-design | 测试设计 | 测试场景、用例设计、数据准备 |
| test-execute | 测试执行 | 执行调度、结果收集、异常处理 |
| test-report | 测试报告 | 报告生成、质量评估、改进建议 |
| test-lifecycle | 总协调器 | 阶段调度、进度跟踪、报告汇总 |

### 第二层：技术层（测试设计技术）

基于 ISTQB 测试设计技术：

| Skill | 技术 | 应用场景 |
|-------|------|---------|
| test-boundary | 边界值分析 (BVA) | 数值范围、数组、字符串、循环 |
| test-equivalence | 等价类划分 (EP) | 输入分类、状态分区 |
| test-state | 状态转换测试 | 工作流、状态依赖 |
| test-decision | 决策表测试 | 业务规则、复杂逻辑 |
| test-usecase | 用例场景测试 | 用户旅程、端到端场景 |
| test-exploratory | 探索式测试 | 新功能、回归盲区 |

### 第三层：执行层（语言/框架）

跨语言、跨框架的测试执行：

| Skill | 支持技术 |
|-------|---------|
| test-runner | 统一执行器（智能识别项目类型） |
| test-js | Vitest, Jest, Playwright |
| test-python | pytest, unittest |
| test-e2e | Playwright, Cypress |
| test-api | REST, GraphQL |

---

## 🎯 设计原则

### 1. 单一职责 (Single Responsibility)

每个 Skill 只负责一个明确的职责：
- 阶段层：负责 STLC 的特定阶段
- 技术层：负责特定测试设计技术
- 执行层：负责特定语言/框架的测试执行

### 2. 分层解耦 (Layered Decoupling)

各层之间松耦合：
- 阶段层不依赖具体技术实现
- 技术层不依赖具体语言框架
- 执行层提供统一接口

### 3. 灵活组合 (Flexible Composition)

支持灵活组合使用：
```
完整流程：test-lifecycle → test-design → test-boundary → test-runner
单一功能：test-boundary (仅边界值分析)
跨层组合：test-design + test-equivalence + test-js
```

### 4. 渐进复杂度 (Progressive Complexity)

- 新手：使用 test-lifecycle 自动识别
- 专家：指定具体技术和框架

---

## 📊 Skill 清单

### 阶段层 (6 个)

- [ ] test-requirement
- [ ] test-plan
- [ ] test-design
- [ ] test-execute
- [ ] test-report
- [ ] test-lifecycle

### 技术层 (6 个)

- [x] test-boundary (已完成，待验收)
- [x] test-equivalence (已完成，待验收)
- [ ] test-state
- [ ] test-decision
- [ ] test-usecase
- [ ] test-exploratory

### 执行层 (5 个)

- [ ] test-runner
- [ ] test-js
- [ ] test-python
- [ ] test-e2e
- [ ] test-api

**总计**: 17 个 Skill

---

## 🔗 参考资料

- ISTQB Foundation Level Syllabus v4.0
- OpenClaw Skills 规范：https://docs.openclaw.ai/tools/skills
- 创建 Skills: https://docs.openclaw.ai/tools/creating-skills

---

*最后更新：2026-04-10*
*版本：1.0*
*状态：架构设计完成*
