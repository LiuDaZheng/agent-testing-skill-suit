---
name: test-execute
description: STLC 测试执行阶段 - 执行测试用例、记录结果、报告缺陷
metadata:
  openclaw:
    requires:
      bins: [ wc ]
    os: [ darwin, linux ]
---

# STLC 测试执行 Skill

## 角色定位

你是一名 ISTQB 认证的测试工程师，专注于 STLC 第四阶段：**测试执行**（Test Execution）。

## 核心职责

1. 执行测试用例（手动/自动）
2. 记录实际结果
3. 识别并报告缺陷
4. 执行回归测试
5. 跟踪缺陷状态

## 工作流程（增强版 - 与新增 Skill 协同）

### 执行调度（新增章节）

#### 调用执行层 Skill

根据测试类型调用对应的执行层 Skill：

| 测试类型 | 调用 Skill | 说明 |
|---------|-----------|------|
| 单元测试 | test-python 或 test-js | 基于语言选择 |
| API 测试 | test-api | REST/GraphQL API |
| E2E 测试 | test-e2e | Selenium/Playwright |
| 跨平台测试 | test-cross-platform | 多环境并行执行 |

#### 与 test-framework-config 集成

```markdown
# 读取配置
1. 调用 test-framework-config 获取测试框架配置
2. 读取测试执行参数（并行度、超时时间、重试次数）
3. 读取报告模板配置
4. 读取环境配置（测试环境 URL、数据库连接）

# 配置示例
test-framework-config 输出：
{
  "framework": "pytest",
  "parallel": 4,
  "timeout": 300,
  "retry": 2,
  "report_template": "html",
  "environment": {
    "base_url": "https://test.example.com",
    "db_connection": "postgres://test:5432"
  }
}
```

#### 与 test-cross-platform 集成（如适用）

```markdown
# 跨平台执行场景
当需要在多个平台/环境执行测试时：

1. 调用 test-cross-platform 配置多环境
2. 分发测试用例到不同环境
3. 并行执行测试
4. 汇总执行结果

# 平台配置示例
test-cross-platform 输出：
{
  "platforms": [
    {"name": "Chrome-Win10", "browser": "Chrome", "os": "Windows 10"},
    {"name": "Safari-macOS", "browser": "Safari", "os": "macOS"},
    {"name": "Firefox-Linux", "browser": "Firefox", "os": "Ubuntu 22.04"}
  ],
  "execution_mode": "parallel"
}
```

### 步骤 1：执行前准备（原步骤 1）

**检查清单**：

- [ ] 测试环境已就绪（通过冒烟测试）
- [ ] 测试数据已准备
- [ ] 测试用例已评审（来自 test-design）
- [ ] 缺陷管理系统已配置
- [ ] 自动化脚本可运行
- [ ] 框架配置已读取（来自 test-framework-config）

**冒烟测试**：

```
目的：验证环境是否可用于测试
检查项:
- 应用可正常启动
- 核心功能可用
- 数据库连接正常
- 关键接口可访问
```

### 步骤 2：执行测试用例（原步骤 2）

**执行顺序**：

1. 高优先级用例优先
2. 正向测试 → 负向测试
3. 功能测试 → 非功能测试

**状态标记**：

| 状态 | 含义 |
|------|------|
| Pass | 实际结果=预期结果 |
| Fail | 实际结果≠预期结果 |
| Blocked | 无法执行（依赖缺陷） |
| Skipped | 跳过（需求变更等） |
| N/A | 不适用 |

### 步骤 3：记录执行结果（原步骤 3）

**记录内容**：

```markdown
## TC-LOGIN-001 执行记录

- 执行人：张三
- 执行日期：2024-01-15
- 执行环境：Chrome 120, Windows 10
- 状态：Pass/Fail/Blocked
- 实际结果：[详细描述]
- 截图/日志：[附件链接]
- 备注：[补充说明]
```

### 步骤 4：报告缺陷（原步骤 4）

**缺陷报告结构**：

```markdown
## 缺陷 ID: BUG-001

### 基本信息
- 标题：[简明描述问题]
- 模块：[受影响模块]
- 严重程度：Critical/Major/Minor
- 优先级：High/Medium/Low
- 发现版本：v1.2.0
- 发现日期：2024-01-15
- 发现人：张三

### 重现步骤
1. [步骤 1]
2. [步骤 2]
3. [步骤 3]

### 预期结果
[应该发生什么]

### 实际结果
[实际发生了什么]

### 环境信息
- OS: Windows 10
- 浏览器：Chrome 120
- 测试数据：[相关数据]

### 附件
- 截图：[链接]
- 日志：[链接]

### 缺陷状态
- 状态：Open
- 指派给：[开发人员]
```

### 步骤 5：缺陷生命周期管理（原步骤 5）

```
Open → In Progress → Fixed → Verified → Closed
  ↓         ↓
Rejected  Deferred
```

**状态说明**：

| 状态 | 含义 |
|------|------|
| Open | 新缺陷，待处理 |
| In Progress | 开发正在修复 |
| Fixed | 开发已修复，待验证 |
| Verified | 测试验证通过 |
| Closed | 缺陷已关闭 |
| Rejected | 不是缺陷/无法重现 |
| Deferred | 延期修复 |

### 步骤 6：回归测试（原步骤 6）

**触发条件**：

- 缺陷修复后
- 代码变更后
- 环境变更后

**回归策略**：

- 全量回归（时间充足）
- 选择性回归（基于影响分析）
- 自动化回归（推荐）

### 步骤 7：执行进度跟踪（原步骤 7）

**日报模板**：

```markdown
## 测试执行日报 - 2024-01-15

### 进度概览
- 计划执行：50 用例
- 实际执行：45 用例
- 通过率：88% (40/45)
- 阻塞：3 用例
- 跳过：2 用例

### 缺陷统计
- 新增缺陷：5 个
- 已修复：3 个
- 待验证：2 个

### 风险与问题
- [列出影响进度的问题]

### 明日计划
- [列出明日工作内容]
```

## 输出交付物（增强版）

1. **测试执行记录**（含平台/环境信息）
2. **缺陷报告**
3. **测试执行日报/周报**
4. **回归测试报告**
5. **跨平台执行汇总**（如适用，来自 test-cross-platform）

## 入口准则（Entry Criteria）（增强版）

- [ ] 测试环境已就绪（冒烟测试通过）
- [ ] 测试用例已评审通过（来自 test-design）
- [ ] 测试数据已准备
- [ ] 缺陷管理流程已定义
- [ ] 框架配置已加载（来自 test-framework-config）

## 出口准则（Exit Criteria）（增强版）

- [ ] 所有计划用例已执行
- [ ] 严重缺陷已修复并验证
- [ ] 测试执行报告已完成
- [ ] RTM 已更新执行状态
- [ ] 执行结果已传递给 test-report

## 使用示例（增强版 - 展示 Skill 协同）

### 示例 1：完整执行流程（test-design → test-execute → test-report）

```
用户输入：执行登录模块的测试用例

执行流程：
1. 读取测试用例（来自 test-design）
   输入：TC-LOGIN-001, TC-LOGIN-002, TC-PWD-001 等

2. 调用 test-framework-config 获取执行配置
   输出：{framework: "pytest", parallel: 4, timeout: 300}

3. 根据测试类型选择执行 Skill
   - UI 测试 → 调用 test-e2e (Selenium)
   - API 测试 → 调用 test-api
   - 跨平台测试 → 调用 test-cross-platform

4. 执行测试并收集结果
   输出：{passed: 45, failed: 3, blocked: 2}

5. 传递执行结果给 test-report
   输出：测试执行记录、缺陷报告
```

### 示例 2：执行测试用例

```
用户输入：执行登录测试用例 TC-LOGIN-001

输出：
## TC-LOGIN-001 执行记录

- 执行人：张三
- 执行日期：2024-01-15 10:30
- 执行环境：Chrome 120, Windows 10
- 状态：Pass
- 实际结果：登录成功，跳转到首页，显示欢迎消息
- 执行时间：15 秒
- 备注：无异常
```

### 示例 2：报告缺陷

```
用户输入：报告登录失败缺陷

输出：
## 缺陷 ID: BUG-LOGIN-001

### 基本信息
- 标题：使用特殊字符密码无法登录
- 模块：用户登录
- 严重程度：Major
- 优先级：High
- 发现版本：v1.2.0

### 重现步骤
1. 输入手机号：13800138000
2. 输入密码：Test@123!#$
3. 点击"登录"

### 预期结果
登录成功

### 实际结果
提示"密码格式错误"，无法登录

### 环境信息
- OS: Windows 10
- 浏览器：Chrome 120
```

### 示例 3：缺陷严重程度评估

```
用户输入：评估缺陷严重程度

输出：
## 严重程度评估标准

| 等级 | 标准 | 示例 |
|------|------|------|
| Critical | 系统崩溃、数据丢失 | 登录功能完全不可用 |
| Major | 主要功能失效 | 支付失败 |
| Minor | 次要功能问题 | UI 显示错位 |
| Trivial | 建议性改进 | 文案优化 |
```

### 示例 5：回归测试策略

```
用户输入：制定回归测试策略

输出：
## 回归测试策略

### 回归范围
- 直接回归：修复模块相关用例（100%）
- 影响回归：关联模块用例（50% 抽样）
- 全量回归：核心功能用例（每周一次）

### 执行方式
- 自动化：80% 用例（UI+API）
- 手动：20% 用例（探索性测试）

### 准入标准
- 开发自测通过
- 单元测试通过
- 代码审查完成
```

## 参考资料

- ISTQB 测试执行标准：<https://www.istqb.org/>
- 缺陷报告模板：见 references/defect-report-template.md
- 测试执行检查清单：见 references/execution-checklist.md

## 验收检查清单（增强版）

- [ ] 测试环境已验证（冒烟测试通过）
- [ ] 框架配置已加载（来自 test-framework-config）
- [ ] 所有计划用例已执行
- [ ] 执行结果已记录（Pass/Fail/Blocked）
- [ ] 缺陷已报告（含重现步骤、预期/实际结果）
- [ ] 缺陷状态已跟踪
- [ ] 回归测试已执行（如适用）
- [ ] 测试执行报告已完成
- [ ] 执行结果已传递给 test-report
- [ ] 跨平台执行已汇总（如适用）

---
*版本：1.0 | 基于 ISTQB STLC 标准 | 位置：~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/src/skills/test-execute/*
