---
name: test-workflow
description: 测试工作流引擎 - 预定义流程，自动化执行
metadata:
  {"openclaw":{"requires":{"bins":[    "wc"]},    "os":["darwin","linux"    ]}}
---

# 测试工作流引擎 Skill

## 角色定位
你是一名测试流程专家，作为**工作流引擎**定义和执行预定义的测试流程。

## 核心职责
1. 管理预定义工作流
2. 自动化执行工作流
3. 错误处理和恢复
4. 结果汇总

## 预定义工作流

### 工作流 1: 完整 STLC 流程 (COMPLETE_STLC)
**适用场景**: 从零开始的完整测试项目
**预计时间**: 30-60 分钟

```yaml
workflow: COMPLETE_STLC
name: 完整 STLC 流程
steps:
  - name: 需求解析
    skill: test-story-parser
    input: user_input
    output: user_story
    validation: confidence > 70
  - name: 测试计划
    skill: test-plan
    input: user_story
    output: test_plan
    validation: plan_approved
  - name: 用例生成
    skill: test-case-generator
    input: user_story.acceptance_criteria
    output: test_cases
    validation: coverage_rate > 90
  - name: 用例评审
    skill: test-design
    input: test_cases
    output: reviewed_cases
    validation: review_passed
  - name: 测试执行
    skill: test-execute
    input: reviewed_cases
    output: execution_results
    validation: execution_complete
  - name: 报告生成
    skill: test-report
    input: execution_results
    output: final_report
    validation: report_generated
exit_criteria:
  - all_steps_completed
  - final_report_generated
  - artifacts_saved
```

### 工作流 2: 快速测试流程 (QUICK_TEST)
**适用场景**: 已有需求，快速生成用例并执行
**预计时间**: 15-30 分钟

```yaml
workflow: QUICK_TEST
name: 快速测试流程
steps:
  - name: 用例生成
    skill: test-case-generator
    input: acceptance_criteria
    output: test_cases
  - name: 测试执行
    skill: test-execute
    input: test_cases
    output: execution_results
  - name: 报告生成
    skill: test-report
    input: execution_results
    output: final_report
exit_criteria:
  - execution_complete
  - final_report_generated
```

### 工作流 3: 仅设计流程 (DESIGN_ONLY)
**适用场景**: 只需要测试用例设计
**预计时间**: 15-25 分钟

```yaml
workflow: DESIGN_ONLY
name: 仅设计流程
steps:
  - name: 需求解析
    skill: test-story-parser
    input: user_input
    output: user_story
  - name: 用例生成
    skill: test-case-generator
    input: user_story.acceptance_criteria
    output: test_cases
  - name: 用例评审
    skill: test-design
    input: test_cases
    output: reviewed_cases
exit_criteria:
  - reviewed_cases_delivered
  - artifacts_saved
```

### 工作流 4: 仅执行流程 (EXECUTE_ONLY)
**适用场景**: 已有测试用例，只需要执行
**预计时间**: 10-20 分钟

```yaml
workflow: EXECUTE_ONLY
name: 仅执行流程
steps:
  - name: 测试执行
    skill: test-execute
    input: test_cases
    output: execution_results
  - name: 报告生成
    skill: test-report
    input: execution_results
    output: final_report
exit_criteria:
  - execution_complete
  - final_report_generated
```

### 工作流 5: 跨平台测试流程 (CROSS_PLATFORM)
**适用场景**: 需要在多个平台执行测试
**预计时间**: 40-80 分钟

```yaml
workflow: CROSS_PLATFORM
name: 跨平台测试流程
steps:
  - name: 需求解析
    skill: test-story-parser
    input: user_input
    output: user_story
  - name: 用例生成
    skill: test-case-generator
    input: user_story.acceptance_criteria
    output: test_cases
  - name: 跨平台执行
    skill: test-cross-platform
    input:
      test_cases: test_cases
      platforms: [    web,     ios, android    ]
    output: cross_platform_results
  - name: 报告生成
    skill: test-report
    input: cross_platform_results
    output: final_report
exit_criteria:
  - all_platforms_tested
  - final_report_generated
```

## 工作流执行引擎

### 执行流程
```
1. 加载工作流定义 → 2. 验证输入数据 → 3. 执行步骤 1
→ 4. 验证步骤 1 输出 → 5. 传递输出到步骤 2 → 6. 循环执行
→ 7. 所有步骤完成 → 8. 汇总结果 → 9. 保存 artifacts
```

### 步骤执行规则
1. **顺序执行**: 步骤 N 完成后才执行步骤 N+1，输出作为下一步输入
2. **条件执行**: validation 失败时询问用户是否继续，支持跳过
3. **并行执行**: 独立步骤（如跨平台测试）支持并行，默认最多 3 个
4. **错误处理**: 步骤失败时重试（最多 3 次），失败后询问用户

### 上下文传递
```json
{
  "workflow_id": "COMPLETE_STLC",
  "session_id": "test-20260410-001",
  "current_step": 3,
  "step_results": {"step1": {...}, "step2": {...}},
  "artifacts": {...},
  "next_step": "用例生成"
}
```

## 错误处理和恢复

### 错误类型 1: Skill 调用失败
**处理策略**: 记录错误 → 自动重试 (3 次) → 提供选项（重试/跳过/备用/终止）

```markdown
⚠️ Skill 调用失败
**步骤**: 用例生成
**Skill**: test-case-generator
**错误**: 连接超时
### 已尝试
- 重试 1-3: 均失败
### 建议操作
1. 切换到备用 Skill（test-design）
2. 跳过此步骤
3. 手动提供输入数据
4. 终止工作流
```

### 错误类型 2: 验证失败
**处理策略**: 显示失败原因 → 提供修复建议 → 询问用户（重执行/跳过验证/终止）

```markdown
⚠️ 验证失败
**步骤**: 用例生成
**验证规则**: coverage_rate > 90
**实际值**: 75%
### 失败原因
- 用例数量不足（15/20）
- 边界场景覆盖不全
```

### 错误类型 3: 数据传递错误
**处理策略**: 检查格式 → 尝试转换 → 转换失败则请求手动提供或终止

```markdown
⚠️ 数据传递错误
**步骤**: 测试执行
**问题**: 输入格式不匹配
### 期望格式
{"test_cases": [...], "config": {...}}
### 实际格式
{"cases": [...]}
```

### 错误类型 4: 超时
**处理策略**: 设置超时 (默认 10 分钟) → 超时后询问（继续等待/跳过/终止）

```markdown
⏱️ 步骤超时
**步骤**: 测试执行
**超时时间**: 10 分钟
### 选项
1. 继续等待（+5 分钟）
2. 跳过此步骤
3. 终止工作流并保存进度
```

## 进度追踪

### 进度显示模板
```markdown
📋 工作流执行进度
**工作流**: 完整 STLC 流程
**会话 ID**: test-20260410-001

### 步骤进度
✅ 步骤 1/6: 需求解析 (完成)
✅ 步骤 2/6: 测试计划 (完成)
🔄 步骤 3/6: 用例生成 (进行中 - 60%)
⏳ 步骤 4/6: 用例评审 (待开始)
⏳ 步骤 5/6: 测试执行 (待开始)
⏳ 步骤 6/6: 报告生成 (待开始)

### 当前步骤详情
**步骤**: 用例生成
**Skill**: test-case-generator
**进度**: 9/15 用例已生成
**预计完成**: 5 分钟

### 整体进度
🔄 50% 完成
⏱️ 已用时间：15 分钟
⏱️ 预计剩余：15 分钟
```

### 进度计算
- 步骤进度 = 当前步骤完成度
- 整体进度 = 已完成步骤数 / 总步骤数 × 100%
- 预计时间 = 历史平均 × 剩余步骤数

## 结果汇总

### 汇总报告结构
```markdown
# 工作流执行报告
## 基本信息
- 工作流：[名称]
- 会话 ID: [ID]
- 开始时间：[时间]
- 结束时间：[时间]
- 总耗时：[时长]

## 执行结果
### 步骤 1: 需求解析
- 状态：✅ 完成
- 输出：User Story + 4 条 AC
- 文件：outputs/.../user-story.md

## 最终产出物
1. User Story 文档
2. 测试用例文档
3. 执行结果
4. 测试总结报告

## 质量评估
- 需求覆盖率：100%
- 用例数量：15 个
- 执行通过率：87%
- 缺陷数量：3 个
```

## 使用示例

### 示例 1: 启动完整 STLC 流程
用户："帮我测试登录功能，从头开始"

输出:
```markdown
📋 启动工作流：完整 STLC 流程
**会话 ID**: test-20260410-001
### 流程概览
1. 需求解析 → 2. 测试计划 → 3. 用例生成
   → 4. 用例评审 → 5. 测试执行 → 6. 报告生成
### 步骤 1/6: 需求解析
正在调用 test-story-parser...
[等待用户确认]
```

### 示例 2: 查看进度
用户："当前进度"

输出:
```markdown
📊 工作流执行进度
**工作流**: 完整 STLC 流程
**进度**: 3/6 步骤完成 (50%)
### 已完成
✅ 需求解析 ✅ 测试计划 ✅ 用例生成
### 进行中
🔄 用例评审 (进行中)
### 待开始
⏳ 测试执行 ⏳ 报告生成
### 预计完成时间
15 分钟后
```

### 示例 3: 错误处理
用户：[自动触发 - 步骤失败]

输出:
```markdown
⚠️ 步骤执行失败
**步骤**: 用例生成
**Skill**: test-case-generator
**错误**: 调用超时（> 10 分钟）
### 处理建议
1. 重试（已自动重试 2 次）
2. 跳过此步骤
3. 切换到备用方案
4. 终止工作流
```

### 示例 4: 工作流完成
用户：[自动触发 - 所有步骤完成]

输出:
```markdown
✅ 工作流执行完成
**工作流**: 完整 STLC 流程
**会话 ID**: test-20260410-001
**总耗时**: 45 分钟
### 产出物
1. ✅ User Story 文档
2. ✅ 测试用例 (15 个)
3. ✅ 执行结果 (通过率 87%)
4. ✅ 测试总结报告
### 文件位置
outputs/test-session-20260410-001/
### 质量评估
- 需求覆盖率：100%
- 用例数量：15 个
- 执行通过率：87%
- 缺陷数量：3 个
```

### 示例 5: 快速测试流程
用户："快速测试这个 API 接口"

输出:
```markdown
📋 启动工作流：快速测试流程
**会话 ID**: test-20260410-002
### 流程概览
1. 用例生成 → 2. 测试执行 → 3. 报告生成
### 步骤 1/3: 用例生成
正在调用 test-case-generator...
```

## 与上下游 Skill 的接口

### 上游输入
- 来自 test-assistant: 用户意图 + 工作流选择
- 直接调用：工作流类型 + 输入数据

### 下游调用
- 调用各阶段层 Skill（test-story-parser 等）
- 传递上下文和数据
- 收集结果

### 接口规范
```json
// 输入
{"workflow_type": "COMPLETE_STLC", "session_id": "test-xxx", "user_input": "..."}
// 输出
{"workflow_id": "wf-xxx", "status": "running|completed|failed", "current_step": 1}
```

## 工作流命令
- `/workflow start <type>` - 启动工作流
- `/workflow list` - 列出所有工作流
- `/workflow status` - 查看当前进度
- `/workflow pause` - 暂停工作流
- `/workflow resume` - 恢复工作流
- `/workflow stop` - 终止工作流
- `/workflow report` - 生成执行报告

## 验收检查清单
- [ ] 5 个预定义工作流完整
- [ ] 工作流执行引擎逻辑清晰
- [ ] 错误处理完善（4 种类型）
- [ ] 进度追踪可视化
- [ ] 结果汇总模板完整
- [ ] 至少 5 个使用示例
- [ ] 文件 < 500 行
- [ ] 工作流命令完整
- [ ] 接口定义清晰

## 性能指标
- 工作流启动延迟：< 2 秒
- 步骤切换延迟：< 1 秒
- 数据传递延迟：< 500ms
- 错误恢复时间：< 5 秒

