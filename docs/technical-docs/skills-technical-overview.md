# Agent Testing Skill Suit - 技术文档总览

**版本**: 1.0  
**生成日期**: 2026-04-10  
**文档状态**: 进行中 (5/19 Skill 已完成)  
**工作目录**: `~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/`

---

## 📋 目录

1. [项目概述](#项目概述)
2. [已完成的 Skill](#已完成的-skill)
3. [Skill 详细文档](#skill-详细文档)
4. [架构设计](#架构设计)
5. [使用指南](#使用指南)

---

## 项目概述

Agent Testing Skill Suit 是一套基于 ISTQB 标准的测试自动化技能集合，覆盖完整的软件测试生命周期 (STLC)。

### 项目目标
- 提供标准化的测试设计技术
- 实现测试执行自动化
- 支持完整的 STLC 流程
- 基于权威标准 (ISTQB)

### 技术栈
- **标准**: ISTQB Foundation Level
- **参考**: GeeksforGeeks, Guru99, ToolsQA
- **平台**: OpenClaw Skills
- **语言**: 中文为主，支持双语

---

## 已完成的 Skill

当前完成 5/19 个 Skill：

| Skill | 类型 | 描述 | 状态 |
|-------|------|------|------|
| test-requirement | STLC 阶段层 | 需求分析、RTM 创建 | ✅ 完成 |
| test-plan | STLC 阶段层 | 测试计划、策略制定 | ✅ 完成 |
| test-runner | 执行层 | 统一测试执行器 | ✅ 完成 |
| test-boundary | 技术层 | 边界值分析 (BVA) | ✅ 完成 |
| test-state | 技术层 | 状态转换测试 | ✅ 完成 |

---

## Skill 详细文档

### 1. test-requirement - 需求分析

**位置**: `src/skills/test-requirement/`  
**版本**: 1.0  
**基于**: ISTQB STLC 第一阶段

#### 核心职责
1. 识别可测试的需求（功能 + 非功能）
2. 创建需求跟踪矩阵（RTM）
3. 发现需求缺陷（模糊、矛盾、缺失）
4. 评估自动化可行性

#### 工作流程
```
收集需求文档 → 需求分类 → 创建 RTM → 识别需求缺陷 → 自动化评估
```

#### 输出交付物
- 需求分析报告
- RTM（需求跟踪矩阵）
- 需求缺陷清单
- 自动化可行性报告

#### 使用示例
```bash
# 分析登录需求
用户输入：分析以下登录需求的可测试性
"用户可以使用手机号或邮箱登录，密码长度 8-20 位"

输出：
- 功能需求：手机号登录、邮箱登录、密码验证
- 测试条件：
  - TC-LOGIN-001: 有效手机号登录
  - TC-LOGIN-002: 有效邮箱登录
  - TC-LOGIN-003: 密码长度边界测试 (8 位、20 位)
  - TC-LOGIN-004: 密码长度超限 (7 位、21 位)
- 需求缺陷：未说明密码复杂度要求、未说明错误处理
```

#### 验收标准
- [ ] 已识别所有功能需求
- [ ] 已识别所有非功能需求
- [ ] RTM 已创建（需求 ID→测试条件映射）
- [ ] 需求缺陷已记录（模糊、矛盾、缺失）
- [ ] 自动化可行性已评估

---

### 2. test-plan - 测试计划

**位置**: `src/skills/test-plan/`  
**版本**: 1.0  
**基于**: ISTQB STLC 第二阶段

#### 核心职责
1. 定义测试目标和范围
2. 制定测试策略（方法、工具、环境）
3. 评估风险并制定缓解方案
4. 估算资源和时间
5. 定义入口/出口准则

#### 工作流程
```
定义测试目标 → 确定测试范围 → 制定测试策略 → 风险评估 → 
资源估算 → 进度计划 → 定义入口/出口准则
```

#### 输出交付物
- 测试计划文档（主文档）
- 测试策略文档
- 风险评估报告
- 资源估算表
- 测试进度计划

#### 使用示例
```bash
# 制定测试策略
用户输入：为电商平台制定测试策略

输出：
## 测试策略
- 测试方法：混合（核心功能自动化，探索性测试手动）
- 测试类型：功能测试、性能测试、安全测试、兼容性测试
- 测试级别：集成测试、系统测试、验收测试
- 自动化工具：Selenium（UI）、Postman（API）、JMeter（性能）
- 测试环境：
  - 浏览器：Chrome、Firefox、Safari（最新 2 版本）
  - 设备：iOS、Android（主流机型）
  - 服务器：与生产环境配置一致
```

#### 验收标准
- [ ] 测试目标已明确定义
- [ ] 测试范围已界定（含范围外）
- [ ] 测试策略已制定（方法、工具、环境）
- [ ] 风险已识别并有缓解措施
- [ ] 资源估算已完成
- [ ] 进度计划已制定
- [ ] 入口/出口准则已定义

---

### 3. test-runner - 统一测试执行器

**位置**: `src/skills/test-runner/`  
**版本**: 1.0  
**类型**: 执行层 Skill

#### 核心能力
1. **智能识别** - 自动检测项目类型和测试框架
2. **统一接口** - 提供一致的测试执行命令
3. **并行执行** - 支持多测试套件并发运行
4. **结果汇总** - 整合各测试框架输出

#### 支持的项目类型
| 项目类型 | 检测条件 | 执行命令 |
|---------|---------|---------|
| JS-Vitest | package.json 含 vitest | `npm run test` 或 `npx vitest run` |
| JS-Jest | package.json 含 jest | `npm run test` 或 `npx jest` |
| JS-Playwright | package.json 含 @playwright/test | `npx playwright test` |
| JS-Cypress | package.json 含 cypress | `npx cypress run` |
| Python-pytest | requirements.txt 含 pytest | `pytest` 或 `python -m pytest` |
| Python-unittest | 有 test_*.py 文件 | `python -m unittest discover` |
| API 测试 | 有 api-tests/ 目录 | 调用 test-api skill |

#### 常用命令模式
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

#### 验收标准
- [ ] 能正确识别 JS/Python/E2E 项目类型
- [ ] 执行命令符合各框架官方文档
- [ ] 支持常用参数（覆盖率、过滤、监听）
- [ ] 错误提示清晰可操作
- [ ] 输出结果结构化

---

### 4. test-boundary - 边界值分析

**位置**: `src/skills/test-boundary/`  
**版本**: 1.0  
**基于**: ISTQB 黑盒测试设计技术

#### 核心概念
边界值分析 (BVA) 是一种黑盒测试设计技术，专注于测试输入范围的边界值。基于观察：**错误更可能出现在输入范围的边缘而非中间**。

#### BVA 测试值集合
对于范围 [min, max]，测试以下值：
```
边界值集合 = {min-1, min, min+1, max-1, max, max+1}
```

#### 与等价类划分的关系
- **ECP (等价类划分)**：将输入分组，每组选一个代表值
- **BVA (边界值分析)**：在 ECP 基础上，额外测试边界处的极端值
- **最佳实践**：两者结合使用，先 ECP 分组，再 BVA 测边界

#### 使用示例
```yaml
# 年龄验证 (18-60 岁)
test_cases:
  - id: BVA-001
    input: 17
    expected: Invalid (低于最小边界)
  - id: BVA-002
    input: 18
    expected: Valid (最小边界)
  - id: BVA-003
    input: 19
    expected: Valid (最小边界 +1)
  - id: BVA-004
    input: 59
    expected: Valid (最大边界 -1)
  - id: BVA-005
    input: 60
    expected: Valid (最大边界)
  - id: BVA-006
    input: 61
    expected: Invalid (高于最大边界)
```

#### 最佳实践
1. 识别所有边界类型（数值、字符串、集合、时间）
2. 考虑极端值（负数、零、极大值、空值）
3. 与等价类结合使用
4. 文档化边界表

#### 验收标准
- [ ] 正确识别输入范围的边界值
- [ ] 设计覆盖 min-1, min, min+1, max-1, max, max+1 的测试用例
- [ ] 区分有效边界和无效边界
- [ ] 将 BVA 与 ECP 结合使用
- [ ] 记录边界相关缺陷

---

### 5. test-state - 状态转换测试

**位置**: `src/skills/test-state/`  
**版本**: 1.0  
**基于**: ISTQB 状态转换测试技术

#### 核心概念
状态转换测试是一种黑盒测试技术，用于测试系统在不同输入事件下的状态变化行为。适用于有限状态机 (FSM) 系统。

#### 关键术语
- **状态 (State)**: 系统在某一时刻的条件或情况
- **转换 (Transition)**: 从一个状态到另一个状态的变化
- **事件 (Event)**: 触发转换的输入或条件
- **动作 (Action)**: 转换产生的输出或结果

#### 测试设计方法

**1. 状态转换图**
```
[Idle] --插入卡片--> [CardInserted]
[CardInserted] --输入 PIN--> [PINEntered]
[PINEntered] --验证成功--> [Authenticated]
[PINEntered] --验证失败--> [CardRetained]
```

**2. 状态转换表**
| 当前状态 | 事件/输入 | 下一状态 (成功) | 下一状态 (失败) | 动作 |
|---------|----------|----------------|----------------|------|
| Idle | 插入卡片 | CardInserted | - | 读卡 |
| CardInserted | 输入 PIN | PINEntered | CardRetained | 提示输入 |

**3. 覆盖标准**
- **0-switch 覆盖**: 覆盖所有单个转换
- **1-switch 覆盖**: 覆盖所有长度为 2 的转换序列
- **n-switch 覆盖**: 覆盖所有长度为 n+1 的转换序列
- **无效转换测试**: 测试不允许的状态转换

#### 使用示例
```yaml
# 订单状态转换测试
状态:
  - Created(已创建)
  - Paid(已支付)
  - Shipped(已发货)
  - Delivered(已送达)
  - Cancelled(已取消)
  - Refunded(已退款)

有效转换:
  Created → Paid: 支付成功
  Created → Cancelled: 用户取消
  Paid → Shipped: 商家发货
  Paid → Refunded: 退款申请
  Shipped → Delivered: 确认收货
  Shipped → Refunded: 退货退款

测试序列:
  - TC1: Created → Paid → Shipped → Delivered (正常流程)
  - TC2: Created → Cancelled (取消流程)
  - TC3: Created → Paid → Refunded (退款流程)
  - TC4: Paid → Created (无效转换，应拒绝)
```

#### 验收标准
- [ ] 已绘制完整的状态转换图
- [ ] 已创建状态转换表 (包含所有状态、事件、转换)
- [ ] 0-switch 覆盖率达到 100%
- [ ] 已测试所有无效转换
- [ ] 已测试超时和异常场景
- [ ] 测试用例可执行且结果可验证

---

## 架构设计

### Skill 分层架构

```
┌─────────────────────────────────────────┐
│           STLC 协调层                     │
│         (test-lifecycle)                │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           STLC 阶段层 (6 个)               │
│  test-requirement → test-plan →         │
│  test-design → test-execute →           │
│  test-report                            │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           技术层 (6 个)                   │
│  test-boundary, test-equivalence,       │
│  test-state, test-decision,             │
│  test-usecase, test-exploratory         │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           执行层 (5 个)                   │
│  test-runner, test-js, test-python,     │
│  test-e2e, test-api                     │
└─────────────────────────────────────────┘
```

### 依赖关系

```
test-lifecycle (协调器)
  ↓
test-requirement → test-plan → test-design → test-execute → test-report
  ↓                    ↓           ↓             ↓              ↓
技术层 Skills ←──────────────────────────────────────────────┘
  ↓
执行层 Skills (test-runner 统一调度)
```

---

## 使用指南

### 快速开始

#### 1. 需求分析阶段
```bash
# 使用 test-requirement 分析需求
# 输入：需求文档
# 输出：RTM、需求缺陷清单
```

#### 2. 测试计划阶段
```bash
# 使用 test-plan 制定计划
# 输入：RTM、项目计划
# 输出：测试计划文档、测试策略
```

#### 3. 测试设计阶段
```bash
# 使用技术层 Skills 设计测试用例
# test-boundary: 边界值分析
# test-state: 状态转换测试
# test-equivalence: 等价类划分
```

#### 4. 测试执行阶段
```bash
# 使用 test-runner 统一执行
test-runner --project ./my-project
```

#### 5. 测试报告阶段
```bash
# 使用 test-report 生成报告
# 输入：测试结果
# 输出：测试总结报告
```

### 最佳实践

1. **遵循 STLC 流程**: 按阶段顺序执行，不要跳过阶段
2. **文档化**: 每个阶段的输出都要保存
3. **可追溯**: 使用 RTM 保持需求 - 测试用例的映射
4. **持续改进**: 根据测试结果优化测试策略

---

## 参考资料

- ISTQB Foundation Level Syllabus: https://www.istqb.org/
- GeeksforGeeks STLC: https://www.geeksforgeeks.org/software-testing/software-testing-life-cycle-stlc/
- Guru99 STLC Guide: https://www.guru99.com/software-testing-life-cycle.html
- ToolsQA: https://toolsqa.com/

---

**文档生成**: 2026-04-10  
**下次更新**: 待剩余 14 个 Skill 完成后  
**维护者**: Gates (文档与质量保障 Agent)
