# 文件输出规范

## 输出目录结构

```
outputs/
└── test-session-YYYYMMDD-NNN/
    ├── 01-requirements/
    │   ├── user-story.md
    │   └── acceptance-criteria.json
    ├── 02-plan/
    │   └── test-plan.md
    ├── 03-design/
    │   ├── test-cases.md
    │   └── test-data.json
    ├── 04-execution/
    │   ├── execution-results.json
    │   └── defects.md
    ├── 05-report/
    │   ├── test-summary.md
    │   └── quality-assessment.md
    └── session-state.json
```

### 目录命名规则

| 目录 | 说明 | 包含文件 |
|------|------|---------|
| 01-requirements | 需求分析产物 | user-story.md, acceptance-criteria.json |
| 02-plan | 测试计划产物 | test-plan.md |
| 03-design | 测试设计产物 | test-cases.md, test-data.json |
| 04-execution | 测试执行产物 | execution-results.json, defects.md |
| 05-report | 测试报告产物 | test-summary.md, quality-assessment.md |

### 会话目录命名

格式：`test-session-YYYYMMDD-NNN`

示例:
- `test-session-20260410-001`
- `test-session-20260410-002`
- `test-session-20260411-001`

## 文件命名规范

### 基本原则

1. **使用小写字母**
   - ✅ `user-story.md`
   - ❌ `User-Story.md`
   - ❌ `USER_STORY.md`

2. **单词间用连字符**
   - ✅ `test-cases.md`
   - ✅ `execution-results.json`
   - ❌ `testCases.md`
   - ❌ `test_cases.md`

3. **包含日期和版本号（如需要）**
   - ✅ `test-summary-20260410-v1.md`
   - ✅ `test-summary-20260410-v2.md`

### 标准文件名

| 文件类型 | 文件名 | 格式 |
|---------|--------|------|
| User Story | `user-story.md` | Markdown |
| 验收标准 | `acceptance-criteria.json` | JSON |
| 测试计划 | `test-plan.md` | Markdown |
| 测试用例 | `test-cases.md` | Markdown |
| 测试数据 | `test-data.json` | JSON |
| 执行结果 | `execution-results.json` | JSON |
| 缺陷报告 | `defects.md` | Markdown |
| 测试总结 | `test-summary.md` | Markdown |
| 质量评估 | `quality-assessment.md` | Markdown |
| 会话状态 | `session-state.json` | JSON |

## 文件格式

### Markdown 文件 (.md)

**用途**: 文档、报告、用例描述

**结构要求**:
```markdown
# 标题

## 章节 1

内容...

## 章节 2

内容...
```

**示例 - user-story.md**:
```markdown
# User Story

## 标题
用户可以使用微信登录

## 描述
作为用户，我希望使用微信账号快速登录，以便无需记住额外密码。

## 验收标准
1. 显示微信登录按钮
2. 点击后跳转到微信授权页面
3. 授权成功后自动登录并跳转首页
4. 首次登录自动创建账号

## 优先级
P0
```

### JSON 文件 (.json)

**用途**: 结构化数据、配置、结果

**格式要求**:
- 使用 2 空格缩进
- UTF-8 编码
- 无 BOM

**示例 - acceptance-criteria.json**:
```json
{
  "user_story": "用户可以使用微信登录",
  "criteria": [
    {
      "id": "AC1",
      "description": "显示微信登录按钮",
      "type": "functional",
      "priority": "P0"
    },
    {
      "id": "AC2",
      "description": "点击后跳转到微信授权页面",
      "type": "functional",
      "priority": "P0"
    }
  ],
  "metadata": {
    "created_at": "2026-04-10T10:00:00Z",
    "version": "1.0"
  }
}
```

**示例 - execution-results.json**:
```json
{
  "session_id": "test-20260410-001",
  "total_cases": 15,
  "passed": 13,
  "failed": 2,
  "skipped": 0,
  "pass_rate": 86.67,
  "execution_time_seconds": 120,
  "results": [
    {
      "case_id": "TC001",
      "status": "passed",
      "duration_ms": 500
    },
    {
      "case_id": "TC002",
      "status": "failed",
      "duration_ms": 300,
      "error": "Expected 200 but got 500"
    }
  ]
}
```

## 保存时机

### 1. 每个阶段完成后立即保存

```
阶段完成 → 生成产物 → 保存到对应目录 → 更新 session-state.json
```

**示例流程**:
```
需求分析完成
  ↓
生成 user-story.md 和 acceptance-criteria.json
  ↓
保存到 outputs/test-session-xxx/01-requirements/
  ↓
更新 session-state.json 中的 completed_stages
```

### 2. 关键数据实时保存

**关键数据定义**:
- User Story
- 测试用例
- 执行结果
- 缺陷报告

**保存策略**:
```
数据生成 → 立即保存 → 确认成功 → 继续执行
```

### 3. 会话结束时完整保存

**保存内容**:
- 所有 artifacts
- 完整 session-state.json
- 执行日志
- 质量评估报告

**保存流程**:
```
1. 收集所有 artifacts
   ↓
2. 生成最终报告
   ↓
3. 更新 session-state.json 状态为 completed
   ↓
4. 完整保存到 outputs/
   ↓
5. 创建备份
```

## 文件版本管理

### 版本命名

格式：`<filename>-v<version>.<ext>`

示例:
- `test-summary-v1.md`
- `test-summary-v2.md`
- `test-cases-v1.md`

### 版本更新规则

1. **小修改**: 递增版本号（v1 → v2）
2. **重大修改**: 保留旧版本，创建新版本
3. **最终版本**: 不带版本号（test-summary.md）

### 版本历史

```
outputs/
└── test-session-20260410-001/
    └── 05-report/
        ├── test-summary-v1.md
        ├── test-summary-v2.md
        └── test-summary.md  (最终版本)
```

## 文件访问

### 相对路径访问

```
# 从项目根目录访问
outputs/test-session-20260410-001/01-requirements/user-story.md

# 从会话目录访问
01-requirements/user-story.md
```

### 绝对路径访问

```
~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/outputs/test-session-20260410-001/01-requirements/user-story.md
```

### 文件访问命令

```bash
# 查看文件内容
cat outputs/test-session-20260410-001/01-requirements/user-story.md

# 打开文件（macOS）
open outputs/test-session-20260410-001/01-requirements/user-story.md

# 列出所有产物
find outputs/test-session-20260410-001 -type f
```

## 文件清理

### 临时文件

**定义**: 执行过程中生成的中间文件

**清理时机**: 会话结束后

**清理规则**:
```bash
# 清理临时文件
rm outputs/test-session-*/tmp/*

# 清理日志文件（保留最近 7 天）
find outputs/test-session-*/logs -mtime +7 -delete
```

### 过期会话

**定义**: 完成超过 30 天的会话

**清理规则**:
```bash
# 清理 30 天前的会话
find outputs -maxdepth 1 -name "test-session-*" -mtime +30 -exec rm -rf {} \;
```

## 备份策略

### 本地备份

**位置**: `backups/outputs/`

**频率**: 每天一次

**保留**: 最近 7 天

### 备份命令

```bash
# 创建备份
cp -r outputs/ backups/outputs-$(date +%Y%m%d)/

# 清理旧备份
find backups -maxdepth 1 -name "outputs-*" -mtime +7 -exec rm -rf {} \;
```

## 验收检查清单

- [ ] 目录结构符合规范
- [ ] 文件命名使用小写和连字符
- [ ] Markdown 格式正确
- [ ] JSON 格式正确（2 空格缩进）
- [ ] 保存时机正确（阶段完成/实时/会话结束）
- [ ] 版本管理规范
- [ ] 清理策略执行
- [ ] 备份策略执行
