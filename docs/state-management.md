# 状态管理规范

## 会话状态结构

```json
{
  "session_id": "test-YYYYMMDD-NNN",
  "user_id": "user-xxx",
  "workflow_id": "COMPLETE_STLC",
  "started_at": "ISO8601",
  "updated_at": "ISO8601",
  "status": "running|completed|paused|failed",
  "current_stage": "test-design",
  "completed_stages": ["requirement", "plan"],
  "current_step": 3,
  "total_steps": 6,
  "artifacts": {
    "user_story": {
      "title": "...",
      "description": "...",
      "acceptance_criteria": [...]
    },
    "test_plan": {...},
    "test_cases": [...],
    "execution_results": [...],
    "final_report": {...}
  },
  "metrics": {
    "elapsed_minutes": 30,
    "estimated_remaining_minutes": 15,
    "completion_percentage": 50
  }
}
```

### 字段说明

| 字段 | 类型 | 说明 |
|------|------|------|
| session_id | string | 会话唯一标识，格式：test-YYYYMMDD-NNN |
| user_id | string | 用户标识 |
| workflow_id | string | 工作流类型（COMPLETE_STLC/QUICK_TEST 等） |
| started_at | string | ISO8601 格式的开始时间 |
| updated_at | string | ISO8601 格式的最后更新时间 |
| status | enum | 会话状态：running/completed/paused/failed |
| current_stage | string | 当前阶段（test-design 等） |
| completed_stages | array | 已完成阶段列表 |
| current_step | number | 当前步骤序号 |
| total_steps | number | 总步骤数 |
| artifacts | object | 生成的所有产物 |
| metrics | object | 进度指标 |

## 状态持久化

### 方案 1: 文件存储（推荐）

**位置**: `state/sessions/{session_id}.json`

**优点**:
- 简单直观
- 可追溯历史
- 易于调试
- 支持会话恢复

**缺点**:
- 需要文件 IO
- 磁盘空间占用

**实现示例**:
```javascript
// 保存状态
function saveState(sessionId, state) {
  const path = `state/sessions/${sessionId}.json`;
  fs.writeFileSync(path, JSON.stringify(state, null, 2));
}

// 加载状态
function loadState(sessionId) {
  const path = `state/sessions/${sessionId}.json`;
  return JSON.parse(fs.readFileSync(path, 'utf-8'));
}
```

### 方案 2: 内存存储

**位置**: OpenClaw session state

**优点**:
- 快速访问
- 无需文件 IO
- 自动清理

**缺点**:
- 会话结束即丢失
- 无法跨会话恢复
- 内存占用

**实现示例**:
```javascript
// 保存到内存
session.state.testSession = state;

// 从内存加载
const state = session.state.testSession;
```

### 方案 3: 混合方案

**策略**:
- 热数据：内存（当前会话状态）
- 冷数据：文件（历史会话、完整 artifacts）
- 定期同步：每 5 分钟或关键操作后

**优点**:
- 兼顾性能和持久化
- 支持快速访问和恢复
- 减少磁盘 IO

**缺点**:
- 实现复杂
- 需要同步机制

## 状态更新规则

### 更新时机

1. **每完成一个步骤更新一次**
   - 步骤完成后立即更新 current_step
   - 更新 step_results
   - 更新 updated_at

2. **关键数据立即保存**
   - User Story 生成后
   - 测试用例生成后
   - 执行结果产生后
   - 报告生成后

3. **定期备份（每 5 分钟）**
   - 完整状态保存到文件
   - 创建备份副本
   - 清理旧备份（保留最近 3 个）

### 更新流程

```
1. 修改状态数据
   ↓
2. 验证数据完整性
   ↓
3. 更新 updated_at 时间戳
   ↓
4. 保存到内存（热数据）
   ↓
5. 异步保存到文件（冷数据）
   ↓
6. 确认保存成功
```

### 并发控制

```javascript
// 使用锁避免并发写入
async function updateState(sessionId, updates) {
  await acquireLock(sessionId);
  try {
    const state = loadState(sessionId);
    Object.assign(state, updates);
    state.updated_at = new Date().toISOString();
    saveState(sessionId, state);
  } finally {
    releaseLock(sessionId);
  }
}
```

## 状态恢复

### 恢复流程

```
1. 通过 session_id 加载
   ↓
2. 验证数据完整性
   ↓
3. 检查会话状态
   ↓
4. 恢复到最近的状态
   ↓
5. 显示恢复确认
```

### 恢复场景

#### 场景 1: 正常恢复
```
用户："继续上次的测试"
→ 加载 session_id
→ 验证数据完整
→ 恢复状态
→ 显示进度
→ 询问是否继续
```

#### 场景 2: 会话过期
```
用户："继续 test-20260401-001"
→ 加载会话
→ 检查时间（> 24 小时）
→ 提示会话过期
→ 询问是否创建新会话
```

#### 场景 3: 数据损坏
```
用户："继续 test-20260410-001"
→ 加载会话
→ 验证失败（JSON 解析错误）
→ 尝试从备份恢复
→ 备份失败则提示重新开始
```

### 数据完整性验证

```javascript
function validateState(state) {
  const required = ['session_id', 'workflow_id', 'status', 'artifacts'];
  for (const field of required) {
    if (!state[field]) {
      throw new Error(`Missing required field: ${field}`);
    }
  }
  
  // 验证 artifacts 结构
  if (typeof state.artifacts !== 'object') {
    throw new Error('Invalid artifacts structure');
  }
  
  return true;
}
```

## 会话生命周期

### 状态转换

```
[新建] → [运行中] → [暂停] → [运行中] → [完成]
              ↓           ↓
           [失败]      [超时]
```

### 状态转换规则

| 当前状态 | 触发事件 | 新状态 |
|---------|---------|--------|
| 新建 | 开始执行 | 运行中 |
| 运行中 | 用户暂停 | 暂停 |
| 暂停 | 用户恢复 | 运行中 |
| 运行中 | 所有步骤完成 | 完成 |
| 运行中 | 错误无法恢复 | 失败 |
| 运行中 | 超时（> 24 小时） | 失败 |
| 完成 | - | （终态） |
| 失败 | - | （终态） |

## 清理策略

### 自动清理

- **完成会话**: 保留 7 天后清理
- **失败会话**: 保留 3 天后清理
- **临时文件**: 会话结束后立即清理

### 手动清理

```bash
# 清理所有完成会话
rm state/sessions/completed-*.json

# 清理指定会话
rm state/sessions/test-20260410-001.json
```

## 监控和日志

### 状态变更日志

```json
{
  "timestamp": "2026-04-10T10:00:00Z",
  "session_id": "test-20260410-001",
  "action": "state_update",
  "changes": {
    "current_step": {"from": 2, "to": 3},
    "status": {"from": "running", "to": "running"}
  }
}
```

### 性能指标

- 状态加载时间：< 100ms
- 状态保存时间：< 200ms
- 恢复成功率：> 99%
