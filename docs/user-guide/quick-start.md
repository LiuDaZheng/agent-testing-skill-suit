# Agent Testing Skill Suit - 快速入门

**版本**: 1.0  
**更新日期**: 2026-04-10  
**适用对象**: 测试工程师、QA、测试经理

---

## 🚀 5 分钟快速开始

### 步骤 1: 了解 STLC 流程

Agent Testing Skill Suit 基于 ISTQB 标准的软件测试生命周期 (STLC)：

```
需求分析 → 测试计划 → 测试设计 → 测试执行 → 测试报告
   ↓          ↓          ↓          ↓          ↓
test-    test-    test-     test-    test-
requirement  plan    design    execute  report
```

### 步骤 2: 选择你的起点

#### 场景 A: 我有需求文档，需要测试
```bash
# 1. 分析需求
使用 test-requirement

# 2. 制定计划
使用 test-plan

# 3. 设计测试
使用 test-boundary, test-state 等

# 4. 执行测试
使用 test-runner

# 5. 生成报告
使用 test-report
```

#### 场景 B: 我只需要设计测试用例
```bash
# 直接使用测试设计技术
test-boundary    # 边界值分析
test-state       # 状态转换测试
test-equivalence # 等价类划分
```

#### 场景 C: 我有代码，需要执行测试
```bash
# 使用统一执行器
test-runner --project ./my-project
```

---

## 📚 核心 Skill 使用指南

### 1. test-requirement - 需求分析

**何时使用**: 拿到需求文档，需要识别测试点

**使用方法**:
```
向 test-requirement 提供需求文档或描述
```

**示例**:
```
用户：分析以下登录需求的可测试性
"用户可以使用手机号或邮箱登录，密码长度 8-20 位"

输出:
- 功能需求：手机号登录、邮箱登录、密码验证
- 测试条件：
  - TC-LOGIN-001: 有效手机号登录
  - TC-LOGIN-002: 有效邮箱登录
  - TC-LOGIN-003: 密码长度边界测试 (8 位、20 位)
  - TC-LOGIN-004: 密码长度超限 (7 位、21 位)
- 需求缺陷：未说明密码复杂度要求、未说明错误处理
```

**输出**: RTM（需求跟踪矩阵）、需求缺陷清单

---

### 2. test-plan - 测试计划

**何时使用**: 需要制定测试策略和计划

**使用方法**:
```
向 test-plan 提供项目信息和测试目标
```

**示例**:
```
用户：为电商平台制定测试策略

输出:
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

**输出**: 测试计划文档、测试策略、风险评估

---

### 3. test-boundary - 边界值分析

**何时使用**: 需要设计边界测试用例

**使用方法**:
```
向 test-boundary 提供输入范围和边界条件
```

**示例**:
```
用户：为年龄验证（18-60 岁）设计边界值测试

输出:
边界值：17, 18, 19, 59, 60, 61

测试用例:
- BVA-001: 输入 17 → 预期：Invalid
- BVA-002: 输入 18 → 预期：Valid (最小边界)
- BVA-003: 输入 19 → 预期：Valid
- BVA-004: 输入 59 → 预期：Valid
- BVA-005: 输入 60 → 预期：Valid (最大边界)
- BVA-006: 输入 61 → 预期：Invalid
```

**输出**: 边界值列表、测试用例集

---

### 4. test-state - 状态转换测试

**何时使用**: 系统有明确的状态和状态转换

**使用方法**:
```
向 test-state 提供状态定义和转换规则
```

**示例**:
```
用户：为订单系统设计状态转换测试

输出:
状态: Created, Paid, Shipped, Delivered, Cancelled, Refunded

有效转换:
- Created → Paid: 支付成功
- Created → Cancelled: 用户取消
- Paid → Shipped: 商家发货
- Paid → Refunded: 退款申请
- Shipped → Delivered: 确认收货

测试序列:
- TC1: Created → Paid → Shipped → Delivered (正常流程)
- TC2: Created → Cancelled (取消流程)
- TC3: Created → Paid → Refunded (退款流程)
- TC4: Paid → Created (无效转换，应拒绝)
```

**输出**: 状态转换图/表、测试序列

---

### 5. test-runner - 统一测试执行

**何时使用**: 需要执行测试用例

**使用方法**:
```bash
test-runner --project <项目路径>
```

**支持的项目类型**:
- JavaScript/TypeScript (Vitest, Jest, Playwright, Cypress)
- Python (pytest, unittest)
- API 测试
- E2E 测试

**示例**:
```bash
# 执行 JS 项目测试
test-runner --project ./my-js-project

# 执行 Python 项目测试
test-runner --project ./my-python-project

# 执行 E2E 测试
test-runner --project ./my-e2e-project --type e2e
```

**输出**: 测试结果汇总、覆盖率报告

---

## 🎯 典型工作流

### 工作流 1: 新功能测试

```
1. 需求分析
   └─> test-requirement → RTM、需求缺陷清单

2. 测试计划
   └─> test-plan → 测试策略、资源计划

3. 测试设计
   ├─> test-boundary → 边界测试用例
   ├─> test-state → 状态转换测试用例
   └─> test-equivalence → 等价类测试用例

4. 测试执行
   └─> test-runner → 测试结果

5. 测试报告
   └─> test-report → 测试总结报告
```

---

### 工作流 2: 回归测试

```
1. 识别变更
   └─> 使用 RTM 确定受影响的测试用例

2. 更新测试用例
   └─> test-boundary / test-state → 更新用例

3. 执行回归测试
   └─> test-runner --regression → 测试结果

4. 生成回归报告
   └─> test-report → 回归测试报告
```

---

### 工作流 3: 自动化测试

```
1. 评估自动化可行性
   └─> test-requirement → 自动化评估报告

2. 设计自动化测试
   └─> test-boundary / test-state → 自动化用例

3. 实现自动化脚本
   └─> 使用 test-js 或 test-python

4. 执行自动化测试
   └─> test-runner → 自动化执行
```

---

## 📖 最佳实践

### 1. 遵循 STLC 流程
- 不要跳过需求分析阶段
- 每个阶段都要有明确的交付物
- 保持需求 - 测试用例的可追溯性

### 2. 组合使用测试技术
- 边界值分析 + 等价类划分
- 状态转换测试 + 决策表测试
- 多种技术互补，提高覆盖率

### 3. 文档化
- 保存每个阶段的输出
- 使用 RTM 保持可追溯性
- 记录测试决策和假设

### 4. 持续改进
- 根据测试结果优化测试策略
- 定期回顾和更新测试用例
- 收集度量数据（覆盖率、缺陷率等）

---

## 🔗 相关资源

### 文档
- [技术文档总览](../technical-docs/skills-technical-overview.md)
- [集成测试计划](../test-results/integration-test-plan.md)
- [质量审计报告](../audit-reports/quality-audit-summary.md)

### 外部资源
- ISTQB Foundation Level: https://www.istqb.org/
- GeeksforGeeks STLC: https://www.geeksforgeeks.org/software-testing/software-testing-life-cycle-stlc/
- Guru99 STLC Guide: https://www.guru99.com/software-testing-life-cycle.html

---

## ❓ 常见问题

### Q: 我应该从哪个 Skill 开始？
**A**: 取决于你的场景：
- 有需求文档 → test-requirement
- 需要设计用例 → test-boundary 或 test-state
- 需要执行测试 → test-runner

### Q: 这些 Skill 支持哪些编程语言？
**A**: 
- 测试设计技术（BVA、状态转换）与语言无关
- test-runner 支持 JavaScript/TypeScript 和 Python
- 其他语言支持在规划中

### Q: 如何将这些 Skill 集成到 CI/CD？
**A**: 
1. 使用 test-runner 执行测试
2. 在 CI 配置中调用 test-runner
3. 使用 test-report 生成报告
4. 配置质量门禁

### Q: 这些 Skill 符合哪些标准？
**A**: 所有测试设计技术都基于 ISTQB Foundation Level 标准。

---

## 📞 获取帮助

- 查看 [技术文档](../technical-docs/skills-technical-overview.md) 了解详细信息
- 查看 [质量审计报告](../audit-reports/quality-audit-summary.md) 了解 Skill 质量
- 查看每个 Skill 的 SKILL.md 了解详细用法

---

*快速入门指南 | 版本 1.0 | 2026-04-10*
