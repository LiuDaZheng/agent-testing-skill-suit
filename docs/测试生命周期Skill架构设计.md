# 测试生命周期 Skill 架构设计

## 📋 问题核心

**你的问题**：完整测试生命周期（包括测试方案编写、测试用例生成、测试类型如边界测试等）是否应该放在一个 Skill 里，还是分开？

**答案**：❌ **不应该放在一个 Skill 里**，应该采用**分层架构 + 生命周期阶段分离**的设计。

---

## 🎯 一、为什么不能放在一个 Skill 里？

### 1.1 单一 Skill 的问题

| 问题 | 说明 | 影响 |
|------|------|------|
| **认知负载过高** | STLC 6 个阶段 + N 种测试类型 + M 种技术框架 = 数千行文档 | Agent 无法有效理解和使用 |
| **职责不清晰** | 一个 Skill 既做规划又做执行还做报告 | Agent 选择困难，不知道何时调用 |
| **维护困难** | 任何阶段的变化都需要修改整个 Skill | 更新风险高，容易引入 bug |
| **无法组合** | 用户只想生成测试用例，却要加载整个生命周期逻辑 | 资源浪费，响应慢 |
| **违反单一职责** | 测试规划 ≠ 测试执行 ≠ 测试报告 | 每个阶段都是独立的专业领域 |

### 1.2 OpenClaw Skill 最佳实践

根据官方文档和现有优秀 Skill 的分析：

```
✅ 优秀 Skill 特征：
- 行数 < 500
- Token 数 < 4000
- 命令数 < 10
- 决策点 < 5
- 职责单一清晰

❌ 糟糕 Skill 特征：
- 行数 > 1000
- Token 数 > 8000
- 命令数 > 20
- 决策点 > 10
- 职责模糊，"什么都能做"
```

**完整测试生命周期的复杂度**：
- 6 个阶段 × 5 种测试类型 × 4 种语言 × 3 种框架 = **360+ 种场景**
- 预估需要 **5000+ 行** 文档
- 预估需要 **40000+ Tokens**

**结论**：远超单个 Skill 的合理范围！

---

## 🏗️ 二、推荐架构：三维分层模型

### 2.1 架构总览

```
                        ┌─────────────────┐
                        │  协调层 (Orchestration)  │
                        │  test-lifecycle  │
                        └────────┬────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
┌───────▼────────┐      ┌───────▼────────┐      ┌───────▼────────┐
│   阶段层        │      │   阶段层        │      │   阶段层        │
│  (Phase)       │      │  (Phase)       │      │  (Phase)       │
│ test-plan      │      │ test-design    │      │ test-execute   │
└────────────────┘      └────────────────┘      └────────────────┘
        │                        │                        │
        └────────────────────────┼────────────────────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
┌───────▼────────┐      ┌───────▼────────┐      ┌───────▼────────┐
│   技术层        │      │   技术层        │      │   技术层        │
│  (Technique)   │      │  (Technique)   │      │  (Technique)   │
│ test-boundary  │      │ test-equivalence│     │ test-state     │
└────────────────┘      └────────────────┘      └────────────────┘
        │                        │                        │
        └────────────────────────┼────────────────────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
┌───────▼────────┐      ┌───────▼────────┐      ┌───────▼────────┐
│   执行层        │      │   执行层        │      │   执行层        │
│  (Execution)   │      │  (Execution)   │      │  (Execution)   │
│ test-runner    │      │ test-js        │      │ test-python    │
└────────────────┘      └────────────────┘      └────────────────┘
```

### 2.2 第一维：STLC 阶段层（按生命周期）

| Skill | 职责 | 核心功能 | 预估复杂度 |
|-------|------|----------|-----------|
| **test-lifecycle** | 总协调器 | 阶段调度、进度跟踪、报告汇总 | ⭐⭐⭐ |
| **test-requirement** | 需求分析 | 需求可测试性分析、风险识别 | ⭐⭐ |
| **test-plan** | 测试计划 | 测试策略、资源规划、时间估算 | ⭐⭐⭐ |
| **test-design** | 测试设计 | 测试场景、用例设计、数据准备 | ⭐⭐⭐⭐ |
| **test-execute** | 测试执行 | 执行调度、结果收集、异常处理 | ⭐⭐⭐ |
| **test-report** | 测试报告 | 报告生成、质量评估、改进建议 | ⭐⭐ |

### 2.3 第二维：测试技术层（按测试类型）

| Skill | 职责 | 核心技术 | 应用场景 |
|-------|------|----------|----------|
| **test-boundary** | 边界值分析 | BVA、边界识别、临界值测试 | 输入范围、数组、循环 |
| **test-equivalence** | 等价类划分 | EP、有效/无效类、分区测试 | 输入分类、状态分区 |
| **test-state** | 状态转换 | 状态机、迁移测试、路径覆盖 | 工作流、状态依赖 |
| **test-decision** | 决策表 | 条件组合、规则覆盖 | 业务规则、复杂逻辑 |
| **test-usecase** | 用例场景 | 用户旅程、端到端场景 | 功能流程、集成场景 |
| **test-exploratory** | 探索式测试 | 基于章程、会话测试 | 新功能、回归盲区 |

### 2.4 第三维：技术执行层（按语言/框架）

| Skill | 职责 | 支持技术 |
|-------|------|----------|
| **test-runner** | 统一执行器 | 智能识别、跨框架 |
| **test-js** | JavaScript/TS | Vitest, Jest, Playwright |
| **test-python** | Python | pytest, unittest |
| **test-e2e** | E2E 测试 | Playwright, Cypress |
| **test-api** | API 测试 | REST, GraphQL |

---

## 📝 三、详细设计示例

### 3.1 协调器：test-lifecycle

```markdown
---
name: test-lifecycle
description: 测试生命周期协调器，编排完整测试流程
metadata:
  openclaw:
    emoji: "🔄"
    requires:
      skills: ["test-plan", "test-design", "test-execute", "test-report"]
---

# 测试生命周期协调器

## 何时使用

| 场景 | 操作 |
|------|------|
| 完整测试流程 | 调用 lifecycle.run-full |
| 从特定阶段开始 | 调用 lifecycle.run-from phase=design |
| 查看进度 | 调用 lifecycle.status |

## 核心工作流

```
需求分析 → 测试计划 → 测试设计 → 测试执行 → 测试报告
   ↓           ↓           ↓           ↓           ↓
test-requirement → test-plan → test-design → test-execute → test-report
```

## 命令参考

```bash
# 运行完整生命周期
lifecycle.run-full project="./my-app"

# 从设计阶段开始
lifecycle.run-from phase=design project="./my-app"

# 查看当前状态
lifecycle.status

# 生成阶段报告
lifecycle.report phase=design
```

## 与其他 Skill 的协作

- 调用 `test-plan` 生成测试计划
- 调用 `test-design` 设计测试用例
- 调用 `test-boundary` 等生成特定类型用例
- 调用 `test-execute` 执行测试
- 调用 `test-report` 生成报告
```

### 3.2 阶段层：test-design

```markdown
---
name: test-design
description: 测试设计 - 生成测试场景和用例
metadata:
  openclaw:
    emoji: "🎨"
    requires:
      skills: ["test-boundary", "test-equivalence", "test-state"]
---

# 测试设计

## 何时使用

| 场景 | 操作 |
|------|------|
| 生成测试用例 | 调用 design.generate |
| 应用测试技术 | 调用 design.apply-technique type=boundary |
| 评审测试用例 | 调用 design.review |

## 核心功能

### 1. 测试用例生成

基于需求文档、用户故事、API 规范生成测试用例

### 2. 测试技术选择

自动选择合适的测试设计技术：
- 边界值分析（输入有范围）
- 等价类划分（输入可分类）
- 状态转换（有状态依赖）
- 决策表（复杂业务规则）

### 3. 用例评审

检查用例覆盖率、冗余度、可执行性

## 命令参考

```bash
# 生成测试用例
design.generate requirements="./docs/requirements.md"

# 应用边界值分析
design.apply-technique type=boundary target="./src/input.ts"

# 生成等价类测试
design.apply-technique type=equivalence target="./src/classifier.ts"

# 评审测试用例
design.review suite="./tests/"
```

## 输出格式

每个测试用例包含：
- 用例 ID
- 测试目标
- 前置条件
- 测试步骤
- 预期结果
- 测试数据
- 覆盖的需求
```

### 3.3 技术层：test-boundary

```markdown
---
name: test-boundary
description: 边界值分析 - 识别和测试边界条件
metadata:
  openclaw:
    emoji: "📏"
---

# 边界值分析 (BVA)

## 何时使用

| 场景 | 特征 | 操作 |
|------|------|------|
| 数值范围 | min, max, 阈值 | 调用 boundary.analyze type=numeric |
| 数组/集合 | 长度限制、容量 | 调用 boundary.analyze type=array |
| 字符串 | 长度、格式限制 | 调用 boundary.analyze type=string |
| 循环 | 0 次、1 次、n 次 | 调用 boundary.analyze type=loop |

## 核心方法

### 1. 边界识别

- 最小值 (min)
- 略大于最小值 (min+1)
- 正常值 (nominal)
- 略小于最大值 (max-1)
- 最大值 (max)
- 略小于最小值 (min-1) - 无效
- 略大于最大值 (max+1) - 无效

### 2. 边界类型

| 类型 | 示例 | 边界点 |
|------|------|--------|
| 数值 | age: 18-65 | 17, 18, 19, 64, 65, 66 |
| 数组 | list: 0-100 项 | -1, 0, 1, 99, 100, 101 |
| 字符串 | name: 1-50 字符 | "", 1 字符，50 字符，51 字符 |
| 循环 | for i=0 to n | 0, 1, n-1, n, n+1 |

## 命令参考

```bash
# 分析数值边界
boundary.analyze type=numeric target="age: 18-65"

# 分析数组边界
boundary.analyze type=array target="items: max 100"

# 生成边界测试用例
boundary.generate target="./src/input-validator.ts"

# 与等价类结合
boundary.with-equivalence target="./src/classifier.ts"
```

## 示例输出

```typescript
// 生成的测试用例
describe('Boundary Tests - Age Validator', () => {
  test('rejects age below minimum (17)', () => {
    expect(validateAge(17)).toBe(false);
  });
  
  test('accepts minimum age (18)', () => {
    expect(validateAge(18)).toBe(true);
  });
  
  test('accepts age just above minimum (19)', () => {
    expect(validateAge(19)).toBe(true);
  });
  
  test('accepts age just below maximum (64)', () => {
    expect(validateAge(64)).toBe(true);
  });
  
  test('accepts maximum age (65)', () => {
    expect(validateAge(65)).toBe(true);
  });
  
  test('rejects age above maximum (66)', () => {
    expect(validateAge(66)).toBe(false);
  });
});
```
```

### 3.4 技术层：test-equivalence

```markdown
---
name: test-equivalence
description: 等价类划分 - 减少测试用例数量的同时保证覆盖率
metadata:
  openclaw:
    emoji: "🔀"
---

# 等价类划分 (EP)

## 何时使用

| 场景 | 特征 | 操作 |
|------|------|------|
| 输入可分类 | 有效/无效输入 | 调用 equivalence.partition |
| 多条件组合 | 多个输入字段 | 调用 equivalence.combine |
| 状态分区 | 不同状态有不同行为 | 调用 equivalence.by-state |

## 核心方法

### 1. 识别等价类

**有效等价类**：符合规格的输入
**无效等价类**：不符合规格的输入

### 2. 划分原则

- 每个等价类中的输入应该产生相同的行为
- 从每个等价类中选择一个代表值
- 确保覆盖所有有效和无效类

### 3. 与边界值结合

等价类划分 + 边界值分析 = 最佳覆盖率

## 示例

### 输入：成绩 (0-100)

| 等价类 | 代表值 | 说明 |
|--------|--------|------|
| 有效：0-100 | 50 | 正常成绩 |
| 有效边界：0 | 0 | 最低分 |
| 有效边界：100 | 100 | 满分 |
| 无效：<0 | -1 | 负数 |
| 无效：>100 | 101 | 超出范围 |

### 输入：用户类型 (admin, user, guest)

| 等价类 | 代表值 | 测试重点 |
|--------|--------|----------|
| 有效：admin | admin | 管理员权限 |
| 有效：user | user | 普通用户 |
| 有效：guest | guest | 访客 |
| 无效：其他 | hacker | 非法类型 |

## 命令参考

```bash
# 划分等价类
equivalence.partition target="score: 0-100"

# 生成等价类测试
equivalence.generate target="./src/grader.ts"

# 组合多个字段
equivalence.combine fields="type, status, role"

# 与边界值结合
equivalence.with-boundary target="./src/validator.ts"
```
```

---

## 🎯 四、使用场景示例

### 场景 1：完整测试流程

```
用户：为这个用户注册 API 生成完整测试

Agent 工作流：
1. test-lifecycle.run-full
   ├── test-requirement.analyze (分析 API 文档)
   ├── test-plan.create (制定测试策略)
   ├── test-design.generate
   │   ├── test-boundary.generate (边界测试)
   │   ├── test-equivalence.generate (等价类测试)
   │   └── test-state.generate (状态转换测试)
   ├── test-execute.run (执行测试)
   └── test-report.generate (生成报告)
```

### 场景 2：只生成边界测试

```
用户：为这个输入验证函数生成边界测试

Agent 工作流：
1. test-boundary.analyze (识别边界)
2. test-boundary.generate (生成测试用例)
3. test-runner.run (可选：执行测试)
```

### 场景 3：只生成测试计划

```
用户：为这个新项目制定测试计划

Agent 工作流：
1. test-requirement.analyze (分析需求)
2. test-plan.create (生成测试计划)
```

---

## 📊 五、复杂度对比

| 方案 | Skill 数量 | 单个 Skill 复杂度 | 总复杂度 | 可维护性 |
|------|-----------|----------------|----------|----------|
| **单一 Skill** | 1 | ⭐⭐⭐⭐⭐ (极高) | 高 | ❌ 差 |
| **分层架构** | 15 | ⭐⭐ (低) | 中 | ✅ 优秀 |

### 分层架构优势

1. **每个 Skill 职责单一** - 易于理解和维护
2. **可独立开发和测试** - 降低风险
3. **灵活组合** - 按需使用
4. **渐进式采用** - 可以先用核心 Skill，逐步扩展
5. **社区贡献友好** - 不同人可以贡献不同 Skill

---

## 🚀 六、开发优先级建议

### Phase 1: 核心基础 (2-3 周)

| Skill | 优先级 | 理由 |
|-------|--------|------|
| test-runner | 🔴 P0 | 执行基础，已有参考实现 |
| test-boundary | 🔴 P0 | 最常用测试技术 |
| test-equivalence | 🔴 P0 | 最常用测试技术 |
| test-design | 🟡 P1 | 用例生成核心 |

### Phase 2: 生命周期 (3-4 周)

| Skill | 优先级 | 理由 |
|-------|--------|------|
| test-plan | 🟡 P1 | 测试规划 |
| test-execute | 🟡 P1 | 执行管理 |
| test-report | 🟡 P1 | 报告生成 |
| test-lifecycle | 🟢 P2 | 协调器（依赖前面） |

### Phase 3: 高级技术 (4-6 周)

| Skill | 优先级 | 理由 |
|-------|--------|------|
| test-state | 🟢 P2 | 状态转换测试 |
| test-decision | 🟢 P2 | 决策表测试 |
| test-usecase | 🟢 P2 | 场景测试 |
| test-exploratory | 🟢 P3 | 探索式测试 |

### Phase 4: 语言扩展 (6-8 周)

| Skill | 优先级 | 理由 |
|-------|--------|------|
| test-js | 🔴 P0 | JavaScript/TS 支持 |
| test-python | 🔴 P0 | Python 支持 |
| test-e2e | 🟡 P1 | E2E 测试 |
| test-api | 🟡 P1 | API 测试 |

---

## ✅ 七、总结与建议

### 核心答案

**❌ 不应该放在一个 Skill 里**

**✅ 应该采用分层架构**：
- **阶段层**：按 STLC 6 个阶段分离
- **技术层**：按测试技术类型分离
- **执行层**：按语言/框架分离

### 关键优势

1. **符合 OpenClaw Skill 规范** - 每个 Skill 保持简洁
2. **Agent 友好** - 清晰的职责边界，易于选择
3. **可维护** - 独立开发、测试、更新
4. **可扩展** - 新增技术/语言不影响现有
5. **灵活组合** - 按需使用，避免资源浪费

### 下一步行动

1. **从 test-boundary 开始** - 最常用、最清晰的测试技术
2. **参考现有实现** - GitHub 上的 test-runner Skill
3. **快速迭代** - 先 MVP，再逐步扩展
4. **内部测试** - 团队内验证后再发布

---

*设计文档版本：1.0*
*生成时间：2026-04-10*
*基于：STLC 标准、OpenClaw Skill 规范、测试设计最佳实践*
