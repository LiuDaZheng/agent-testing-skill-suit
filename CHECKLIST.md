# Agent-Testing-Skill-Suit - 检查清单

> **项目位置**: `~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/`
> **核心规则**: 所有 Skill 开发项目放在 `workspace-skilldev/` 下

---

## ⭐ 核心规则（必须遵守）

### 规则 1: 项目位置

**所有 Skill 开发项目必须放在 `~/.openclaw/workspace-skilldev/` 下**

✅ 正确：`~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/`

❌ 错误：
- `~/.openclaw/projects/` ❌
- `~/.openclaw/workspace-main/` ❌

### 规则 2: 禁止部署

**项目验收前，所有 Skill 不得部署到任何地方**

✅ 正确：`src/skills/` 目录

❌ 错误：
- `~/.openclaw/skills/` ❌ (仅限验收后)
- `~/.openclaw/workspace-main/skills/` ❌

---

## 📋 开发检查清单

### 创建 Skill

- [ ] **位置检查**: `src/skills/<skill-name>/`
- [ ] **SKILL.md**: 包含 YAML frontmatter
- [ ] **references/**: 技术资料
- [ ] **示例**: 至少 3-5 个使用示例
- [ ] **规范**: 通过 yamllint 和 markdownlint

### 测试

- [ ] **单元测试**: `tests/unit/`
- [ ] **集成测试**: `tests/integration/`
- [ ] **E2E 测试**: `tests/e2e/`

### 文档

- [ ] **技术文档**: 完整
- [ ] **API 文档**: 准确
- [ ] **用户指南**: 清晰

### 验收

- [ ] **代码审查**: 通过
- [ ] **测试审查**: 所有测试通过
- [ ] **文档审查**: 完整
- [ ] **项目验收**: 委员会批准

### 部署（仅验收后）

- [ ] **验收确认**: 批准
- [ ] **部署位置**: `~/.openclaw/skills/`
- [ ] **验证**: `openclaw skills list`

---

## ⚠️ 禁止事项

- ❌ 项目放在 `projects/` 目录
- ❌ 提前部署到 `~/.openclaw/skills/`
- ❌ 部署到 `workspace-main/skills/`
- ❌ Sub-Agent 任务不明确位置

---

## 🎯 Sub-Agent 任务说明模板

```markdown
## 任务：创建 <skill-name> Skill

### 位置（重要 ⭐）

**必须创建到**: `~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/src/skills/<skill-name>/`

**禁止位置**:
- ❌ `~/.openclaw/skills/` (生产环境)
- ❌ `~/.openclaw/workspace-main/skills/` (临时工作区)
- ❌ `~/.openclaw/projects/` (错误目录)

### 完成后确认

请确认：
1. Skill 创建位置：`~/.openclaw/workspace-skilldev/...`
2. 未部署到 `~/.openclaw/skills/`
```

---

## 📁 项目结构

```
Agent-Testing-Skill-Suit/
├── README.md                    # 含禁止部署规则
├── DEVELOPMENT.md               # 含位置规范
├── CHECKLIST.md                 # 本文件
├── src/skills/                  # Skill 源码
├── tests/                       # 测试
└── docs/                        # 文档
```

---

## 🔗 相关文档

- [AGENTS.md](../AGENTS.md) - 核心规则
- [README.md](README.md) - 项目概述
- [DEVELOPMENT.md](DEVELOPMENT.md) - 开发指南
- [项目创建检查清单](../项目创建检查清单.md) - 通用检查清单

---

*创建时间：2026-04-10*
*版本：1.0*
*目的：防止项目位置和部署错误*
