# 项目辅助 Skill 清单

> **更新时间**: 2026-04-10 03:05
> **状态**: 已按用户要求清除所有部署

---

## 📦 项目使用的辅助 Skill

### 核心开发类（2 个）

| Skill | 状态 | 用途 | 来源 |
|-------|------|------|------|
| `skill-creator` | ✅ 已内置 | Skill 开发核心工具 | OpenClaw 官方 |
| `github` | ✅ 已内置 | GitHub 集成 | OpenClaw 官方 |

### 项目管理类（2 个）

| Skill | 状态 | 用途 | 安装来源 |
|-------|------|------|---------|
| `task-planning` | ❌ 已清除 | 软件开发任务规划 | ClawHub |
| `project-documentation` | ❌ 已清除 | 项目文档完整工作流 | ClawHub |

### 文档生成类（3 个）

| Skill | 状态 | 用途 | 安装来源 |
|-------|------|------|---------|
| `technical-doc-generator` | ❌ 已清除 | 专业技术文档生成 | ClawHub |
| `api-doc-generator` | ❌ 已清除 | API 文档生成 | ClawHub |
| `sovereign-api-docs-generator` | ❌ 已清除 | API 文档生成器 | ClawHub |

### 质量与审计类（3 个）

| Skill | 状态 | 用途 | 安装来源 |
|-------|------|------|---------|
| `agent-audit` | ❌ 已清除 | AI Agent 配置审计 | ClawHub |
| `agent-cost-monitor` | ❌ 已清除 | Token 使用和成本跟踪 | ClawHub |
| `agent-safety` | ❌ 已清除 | AI Agent 输出安全检查 | ClawHub |

---

## 📊 总计

| 类别 | 数量 | 状态 |
|------|------|------|
| **核心开发类** | 2 | ✅ 已内置（可用） |
| **项目管理类** | 2 | ❌ 已清除 |
| **文档生成类** | 3 | ❌ 已清除 |
| **质量审计类** | 3 | ❌ 已清除 |
| **总计** | **10** | **2 个可用，8 个已清除** |

---

## ⚠️ 当前状态

### 可用 Skill（2 个）

```bash
# 已内置，可随时使用
skill-creator      # Skill 开发
github            # 版本控制
```

### 已清除 Skill（8 个）

按用户要求，所有辅助 Skill 已从部署目录清除：
- ❌ `~/.openclaw/skills/` - 已清空
- ❌ `~/.openclaw/workspace-main/skills/` - 已清空

**注意**: 这些 Skill 只是从部署目录清除，如果需要可以重新安装。

---

## 🔄 重新安装指南

如需重新安装辅助 Skill：

```bash
# 项目管理类
clawhub install task-planning --force
clawhub install project-documentation --force

# 文档生成类
clawhub install technical-doc-generator --force
clawhub install api-doc-generator --force
clawhub install sovereign-api-docs-generator --force

# 质量审计类
clawhub install agent-audit --force
clawhub install agent-cost-monitor --force
clawhub install agent-safety --force
```

**预计安装时间**: 10-15 分钟

---

## 📋 原始安装记录

### 安装时间
- **安装日期**: 2026-04-10
- **安装位置**: `~/.openclaw/workspace-main/skills/` (后迁移到 `~/.openclaw/skills/`)
- **清除日期**: 2026-04-10 02:50

### 安装来源
所有辅助 Skill 均来自 ClawHub：
- `task-planning` - 任务规划
- `project-documentation` - 项目文档
- `technical-doc-generator` - 技术文档生成
- `api-doc-generator` - API 文档生成
- `sovereign-api-docs-generator` - API 文档生成器
- `agent-audit` - 质量审计
- `agent-cost-monitor` - 成本跟踪
- `agent-safety` - 安全检查

### 安装命令（历史记录）

```bash
# 项目管理
clawhub install task-planning --force
clawhub install project-documentation --force

# 文档生成
clawhub install technical-doc-generator --force
clawhub install api-doc-generator --force
clawhub install sovereign-api-docs-generator --force

# 质量审计
clawhub install agent-audit --force
clawhub install agent-cost-monitor --force
clawhub install agent-safety --force
```

---

## 📝 使用说明

### 当前可用（2 个）

**skill-creator**:
```bash
# 创建新 Skill
skill-creator.create "test-new-skill"
```

**github**:
```bash
# 代码提交
github.commit "feat: add new skill"
```

### 需要重新安装（8 个）

**task-planning**:
```bash
# 创建项目任务板
task-planning.create-project "Agent Testing Skill Suit"
```

**technical-doc-generator**:
```bash
# 生成技术文档
technical-doc-generator.generate "test-boundary"
```

**agent-audit**:
```bash
# 质量审计
agent-audit.run "test-boundary"
```

---

## 🔗 相关文档

- [辅助 Skill 需求调研报告](辅助 Skill 需求调研报告.md)
- [辅助 Skill 安装完成报告](辅助 Skill 安装完成报告.md)
- [恢复方案](recovery-plan.md)

---

*最后更新：2026-04-10 03:05*
*状态：8 个已清除，2 个内置可用*
*重新安装：按需执行*
