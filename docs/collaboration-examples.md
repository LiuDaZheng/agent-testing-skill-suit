# Skill 协同工作示例

本文档展示 Agent-Testing-Skill-Suit 中所有 Skill 如何协同工作，覆盖完整的 STLC（软件测试生命周期）流程。

## Skill 架构概览

```
新增 Skill（5 个）：
├── test-story-parser      # User Story 解析
├── test-case-generator    # 测试用例生成
├── test-framework-config  # 框架配置管理
├── test-tool-recommender  # 工具推荐
└── test-cross-platform    # 跨平台适配

阶段层 Skill（增强后，3 个）：
├── test-design            # 测试设计（集成 test-story-parser + test-case-generator）
├── test-execute           # 测试执行（集成 test-framework-config + test-cross-platform）
└── test-report            # 测试报告（集成 test-execute + test-framework-config）

执行层 Skill（示例）：
├── test-python            # Python 测试执行
├── test-js                # JavaScript 测试执行
├── test-api               # API 测试执行
└── test-e2e               # E2E 测试执行
```

---

## 完整 STLC 流程示例

### 场景：电商平台登录功能测试

#### 步骤 1: 需求解析（test-story-parser）

**用户输入**：

```
解析以下需求文档：
"""
作为电商用户，我希望能够通过手机号和密码登录系统，
以便访问我的个人订单、购物车和收藏夹。

验收标准：
1. 输入正确的手机号（11 位）和密码可以成功登录
2. 输入错误的密码显示"密码错误"提示
3. 密码长度必须在 8-20 位之间，包含大小写字母和数字
4. 连续 5 次登录失败后账号锁定 30 分钟
5. 支持"记住我"功能，7 天内免登录
"""
```

**test-story-parser 输出**：

```json
{
  "user_story": {
    "id": "US-LOGIN-001",
    "role": "电商用户",
    "goal": "通过手机号和密码登录系统",
    "benefit": "访问个人订单、购物车和收藏夹"
  },
  "acceptance_criteria": [
    {
      "id": "AC-001",
      "text": "输入正确的手机号（11 位）和密码可以成功登录",
      "type": "functional"
    },
    {
      "id": "AC-002",
      "text": "输入错误的密码显示\"密码错误\"提示",
      "type": "functional"
    },
    {
      "id": "AC-003",
      "text": "密码长度必须在 8-20 位之间，包含大小写字母和数字",
      "type": "validation"
    },
    {
      "id": "AC-004",
      "text": "连续 5 次登录失败后账号锁定 30 分钟",
      "type": "security"
    },
    {
      "id": "AC-005",
      "text": "支持\"记住我\"功能，7 天内免登录",
      "type": "functional"
    }
  ]
}
```

---

#### 步骤 2: 测试设计（test-design + test-case-generator）

**用户输入**：

```
基于以下 AC 生成测试用例：
- AC-001: 输入正确的手机号（11 位）和密码可以成功登录
- AC-002: 输入错误的密码显示"密码错误"提示
- AC-003: 密码长度必须在 8-20 位之间，包含大小写字母和数字
- AC-004: 连续 5 次登录失败后账号锁定 30 分钟
- AC-005: 支持"记住我"功能，7 天内免登录
```

**test-design 调用 test-case-generator 输出**：

```markdown
## TC-LOGIN-001: 有效手机号登录

### 前置条件
- 用户已注册，手机号：13800138000
- 密码：Test@1234（符合复杂度要求）
- 应用已启动，处于登录页面

### 测试步骤
1. 输入手机号：13800138000
2. 输入密码：Test@1234
3. 点击"登录"按钮

### 预期结果
- 登录成功，跳转到首页
- 显示欢迎消息："欢迎，[用户名]"
- 顶部导航栏显示用户头像

### 优先级
High

### 自动化标记
可自动化：Yes
对应 AC: AC-001

---

## TC-LOGIN-002: 无效密码登录

### 前置条件
- 用户已注册，手机号：13800138000
- 应用已启动，处于登录页面

### 测试步骤
1. 输入手机号：13800138000
2. 输入密码：Wrong@1234
3. 点击"登录"按钮

### 预期结果
- 登录失败，停留在登录页面
- 显示错误提示："密码错误"
- 密码框清空，手机号保留

### 优先级
High

### 自动化标记
可自动化：Yes
对应 AC: AC-002

---

## TC-PWD-001: 密码长度边界测试

### 前置条件
- 应用已启动，处于登录页面

### 测试步骤
1. 输入手机号：13800138000
2. 输入密码：7 位密码（Test@12）
3. 点击"登录"按钮

### 预期结果
- 提示"密码长度必须在 8-20 位之间"
- 登录失败

### 优先级
Medium

### 自动化标记
可自动化：Yes
对应 AC: AC-003

---

## TC-PWD-002: 密码复杂度验证

### 前置条件
- 应用已启动，处于登录页面

### 测试步骤
1. 输入手机号：13800138000
2. 输入密码：12345678（纯数字，无字母）
3. 点击"登录"按钮

### 预期结果
- 提示"密码必须包含大小写字母和数字"
- 登录失败

### 优先级
Medium

### 自动化标记
可自动化：Yes
对应 AC: AC-003

---

## TC-SEC-001: 账号锁定机制

### 前置条件
- 用户已注册，手机号：13800138000
- 应用已启动，处于登录页面

### 测试步骤
1. 连续 5 次输入错误密码
2. 第 6 次输入正确密码
3. 点击"登录"按钮

### 预期结果
- 第 5 次失败后显示"账号已锁定，请 30 分钟后重试"
- 第 6 次即使密码正确也登录失败
- 30 分钟后可以正常登录

### 优先级
High

### 自动化标记
可自动化：Yes
对应 AC: AC-004

---

## TC-FUNC-001: 记住我功能

### 前置条件
- 用户已注册，手机号：13800138000
- 应用已启动，处于登录页面

### 测试步骤
1. 输入手机号：13800138000
2. 输入密码：Test@1234
3. 勾选"记住我"复选框
4. 点击"登录"按钮
5. 关闭应用，7 天内重新打开

### 预期结果
- 登录成功
- 7 天内重新打开应用，自动登录，无需输入密码
- 超过 7 天后，需要重新登录

### 优先级
Medium

### 自动化标记
可自动化：Yes
对应 AC: AC-005
```

**test-design 补充边界场景**：

```markdown
## TC-LOGIN-003: 特殊字符手机号处理

### 前置条件
- 应用已启动，处于登录页面

### 测试步骤
1. 输入手机号：1380013800a（包含字母）
2. 输入密码：Test@1234
3. 点击"登录"按钮

### 预期结果
- 提示"请输入有效的 11 位手机号"
- 登录失败

### 优先级
Medium

### 自动化标记
可自动化：Yes

---

## TC-LOGIN-004: 网络异常处理

### 前置条件
- 应用已启动，处于登录页面
- 模拟网络断开

### 测试步骤
1. 输入手机号：13800138000
2. 输入密码：Test@1234
3. 点击"登录"按钮

### 预期结果
- 显示"网络连接失败，请检查网络设置"
- 登录失败，可重试

### 优先级
Medium

### 自动化标记
可自动化：Yes（需网络模拟工具）
```

---

#### 步骤 3: 测试执行（test-execute + test-python）

**用户输入**：

```
执行登录模块的测试用例
```

**test-execute 执行流程**：

1. **读取测试用例**（来自 test-design）
   - 输入：TC-LOGIN-001, TC-LOGIN-002, TC-PWD-001, TC-PWD-002, TC-SEC-001, TC-FUNC-001, TC-LOGIN-003, TC-LOGIN-004

2. **调用 test-framework-config 获取执行配置**

   ```json
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

3. **根据测试类型选择执行 Skill**
   - UI 测试 → 调用 test-e2e (Selenium/Playwright)
   - API 测试 → 调用 test-api
   - 本例为 UI 测试，调用 test-e2e

4. **执行测试并收集结果**

   ```json
   {
     "total": 8,
     "passed": 6,
     "failed": 2,
     "blocked": 0,
     "skipped": 0,
     "execution_time": "2m 15s",
     "details": [
       {"tc": "TC-LOGIN-001", "status": "Pass", "time": "15s"},
       {"tc": "TC-LOGIN-002", "status": "Pass", "time": "12s"},
       {"tc": "TC-PWD-001", "status": "Pass", "time": "10s"},
       {"tc": "TC-PWD-002", "status": "Pass", "time": "11s"},
       {"tc": "TC-SEC-001", "status": "Fail", "time": "45s", "reason": "账号未锁定"},
       {"tc": "TC-FUNC-001", "status": "Pass", "time": "20s"},
       {"tc": "TC-LOGIN-003", "status": "Pass", "time": "8s"},
       {"tc": "TC-LOGIN-004", "status": "Fail", "time": "14s", "reason": "异常处理未触发"}
     ]
   }
   ```

5. **记录缺陷**

   ```markdown
   ## 缺陷 ID: BUG-LOGIN-001
   
   ### 基本信息
   - 标题：连续 5 次登录失败后账号未锁定
   - 模块：用户登录
   - 严重程度：Major
   - 优先级：High
   - 对应 AC: AC-004
   
   ### 重现步骤
   1. 输入正确手机号
   2. 连续 5 次输入错误密码
   3. 第 6 次输入正确密码，仍然可以登录
   
   ### 预期结果
   第 5 次失败后账号应锁定 30 分钟
   
   ### 实际结果
   账号未锁定，第 6 次可以正常登录
   
   ---
   
   ## 缺陷 ID: BUG-LOGIN-002
   
   ### 基本信息
   - 标题：网络异常时未显示友好提示
   - 模块：用户登录
   - 严重程度：Minor
   - 优先级：Medium
   - 对应 TC: TC-LOGIN-004
   
   ### 重现步骤
   1. 断开网络连接
   2. 输入手机号和密码
   3. 点击登录
   
   ### 预期结果
   显示"网络连接失败，请检查网络设置"
   
   ### 实际结果
   显示"未知错误"，无明确提示
   ```

6. **传递执行结果给 test-report**
   - 输出：测试执行记录、缺陷报告

---

#### 步骤 4: 测试报告（test-report）

**用户输入**：

```
生成测试总结报告
```

**test-report 执行流程**：

1. **读取测试执行结果**（来自 test-execute）

   ```json
   {
     "total": 8,
     "passed": 6,
     "failed": 2,
     "blocked": 0,
     "pass_rate": "75%"
   }
   ```

2. **读取测试用例**（来自 test-design）
   - 8 个测试用例，覆盖 5 个 AC

3. **读取报告模板配置**（来自 test-framework-config）

   ```json
   {
     "template": "html",
     "include_charts": true,
     "quality_gates": {
       "critical_defects": 0,
       "major_defects": 5,
       "pass_rate": 90
     }
   }
   ```

4. **生成测试总结报告**

```markdown
# 测试总结报告 - 电商平台登录功能 v1.2.0

## 执行摘要
- 测试周期：2024-01-15 ~ 2024-01-16
- 测试类型：功能测试、安全测试
- 测试结论：⚠️ 条件发布

## 测试概览
| 指标 | 数值 | 目标 | 状态 |
|------|------|------|------|
| 用例总数 | 8 | - | - |
| 已执行 | 8 | 100% | ✅ |
| 通过 | 6 | >90% | ⚠️ |
| 失败 | 2 | <10% | ⚠️ |
| 通过率 | 75% | >90% | ❌ |

## 缺陷统计
| 严重程度 | 数量 | 已修复 | 待修复 |
|----------|------|--------|--------|
| Critical | 0 | 0 | 0 |
| Major | 1 | 0 | 1 |
| Minor | 1 | 0 | 1 |
| **总计** | **2** | **0** | **2** |

## 需求覆盖
| AC ID | 描述 | 测试用例数 | 状态 |
|-------|------|------------|------|
| AC-001 | 正确登录 | 1 | ✅ |
| AC-002 | 错误密码 | 1 | ✅ |
| AC-003 | 密码复杂度 | 2 | ✅ |
| AC-004 | 账号锁定 | 1 | ❌ (缺陷) |
| AC-005 | 记住我 | 1 | ✅ |
| **覆盖率** | - | **6/5=120%** | **100%** |

## 质量评估
| 维度 | 评分 (1-5) | 说明 |
|------|------------|------|
| 功能完整性 | 4.0 | 核心功能正常，账号锁定失效 |
| 安全性 | 3.5 | 账号锁定机制未生效，存在风险 |
| 用户体验 | 4.0 | 错误提示基本友好 |
| 稳定性 | 4.5 | 无崩溃问题 |
| **综合评分** | **4.0** | **可发布（需修复 Major 缺陷）** |

## 风险评估
| 风险 | 影响 | 概率 | 缓解措施 |
|------|------|------|----------|
| 账号锁定机制失效 | 暴力破解风险 | High | 发布前必须修复 |
| 网络异常提示不友好 | 用户体验下降 | Low | 下版本优化 |

## 发布建议
⚠️ **条件发布**
- 建议发布，但需在下版本优先修复 BUG-LOGIN-001（账号锁定）
- 发布后加强安全监控
- BUG-LOGIN-002 可在 v1.2.1 修复
```

1. **输出多格式报告**
   - `report.html` - HTML 格式（含可视化图表）
   - `report.md` - Markdown 格式
   - `report.json` - JSON 格式（用于系统集成）

---

## 完整工作流图示

```
┌─────────────────────────────────────────────────────────────────┐
│                        STLC 完整流程                            │
└─────────────────────────────────────────────────────────────────┘

步骤 1: 需求解析
┌──────────────┐
│  用户需求文档  │
└──────┬───────┘
       │
       ▼
┌──────────────────┐
│ test-story-parser│
│ - 解析 User Story│
│ - 提取 AC        │
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│ 结构化 User Story│
│ + AC 列表         │
└──────┬───────────┘

步骤 2: 测试设计
       │
       ▼
┌──────────────────┐
│   test-design    │
│ - 选择测试技术   │
│ - 设计测试数据   │
│                  │
│ 调用：           │
│ test-case-generator│
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│ 测试用例文档     │
│ + 自动化标记     │
└──────┬───────────┘

步骤 3: 测试执行
       │
       ▼
┌──────────────────┐
│  test-execute    │
│ - 调度执行 Skill  │
│ - 记录执行结果   │
│ - 报告缺陷       │
│                  │
│ 调用：           │
│ test-framework-config│
│ test-cross-platform│
│ test-python/js/api/e2e│
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│ 执行结果         │
│ + 缺陷报告       │
└──────┬───────────┘

步骤 4: 测试报告
       │
       ▼
┌──────────────────┐
│   test-report    │
│ - 汇总执行数据   │
│ - 计算质量指标   │
│ - 生成报告       │
│                  │
│ 输入：           │
│ test-execute 结果│
│ test-design 用例 │
│ test-framework-config 模板│
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│ 测试总结报告     │
│ + 发布建议       │
└──────────────────┘
```

---

## 其他协同场景示例

### 场景 2：跨平台测试

```
用户输入：在多个浏览器上执行 E2E 测试

流程：
1. test-execute 调用 test-cross-platform 配置多环境
   - Chrome-Win10
   - Safari-macOS
   - Firefox-Linux

2. test-cross-platform 分发测试用例到不同环境

3. 并行执行测试（调用 test-e2e）

4. 汇总执行结果

5. test-report 生成跨平台兼容性报告
```

### 场景 3：框架配置变更

```
用户输入：切换测试框架从 pytest 到 unittest

流程：
1. 调用 test-framework-config 更新配置
   - framework: unittest
   - parallel: 2
   - report_template: xml

2. test-execute 读取新配置

3. 执行测试（调用 test-python，使用 unittest）

4. test-report 使用新模板生成报告
```

### 场景 4：工具推荐

```
用户输入：推荐适合 API 测试的工具

流程：
1. 调用 test-tool-recommender
   - 输入：测试类型=API, 语言=Python, 预算=免费

2. test-tool-recommender 输出：
   - 推荐：pytest + requests
   - 备选：httpie + unittest
   - 理由：生态完善、文档丰富、社区活跃

3. 调用 test-framework-config 配置推荐工具

4. 执行测试
```

---

## Skill 接口总结

| Skill | 上游输入 | 下游输出 | 协同 Skill |
|-------|----------|----------|------------|
| test-story-parser | 自然语言需求 | 结构化 User Story + AC | test-design |
| test-case-generator | AC 列表 | 测试用例草稿 | test-design |
| test-design | User Story + AC | 完整测试用例文档 | test-story-parser, test-case-generator, test-execute |
| test-framework-config | 配置需求 | 框架配置 JSON | test-execute, test-report |
| test-tool-recommender | 测试需求 | 工具推荐列表 | test-framework-config |
| test-cross-platform | 测试用例 + 平台列表 | 跨平台执行结果 | test-execute |
| test-execute | 测试用例 + 配置 | 执行结果 + 缺陷报告 | test-design, test-framework-config, test-cross-platform, test-report |
| test-report | 执行结果 + 用例 + 配置 | 测试总结报告 + 发布建议 | test-execute, test-design, test-framework-config |

---

## 验收检查清单

使用本协同工作流时，请确保：

- [ ] test-story-parser 正确解析 User Story 和 AC
- [ ] test-case-generator 基于 AC 生成完整测试用例
- [ ] test-design 补充边界场景和探索性测试
- [ ] test-framework-config 提供正确的执行配置
- [ ] test-execute 正确调度执行层 Skill
- [ ] test-cross-platform 正确配置多环境（如适用）
- [ ] test-report 正确汇总数据并生成报告
- [ ] 所有 Skill 输出格式符合接口约定
- [ ] 完整 STLC 流程可追溯（需求→用例→执行→报告）

---

*文档版本：1.0 | 最后更新：2026-04-10 | 位置：~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/docs/collaboration-examples.md*
