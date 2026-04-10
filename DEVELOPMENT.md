# 开发指南

> **重要**: 开发中项目 - 禁止部署规则

---

## 🚨 禁止部署规则

### 核心原则

**在项目验收前，所有 Skill 不得部署到任何地方！**

### 开发位置

| 类型 | 位置 | 说明 |
|------|------|------|
| **开发中 Skill** | `src/skills/<skill-name>/` | 所有开发工作在此进行 |
| **测试用例** | `tests/` | 单元测试、集成测试、E2E 测试 |
| **文档** | `docs/` | 技术文档、用户指南 |

### 禁止部署的位置

| 位置 | 原因 |
|------|------|
| `~/.openclaw/skills/` | ❌ 生产环境，仅限验收后的 Skill |
| `~/.openclaw/workspace-main/skills/` | ❌ 临时工作区，不稳定 |
| 任何 ClawHub 发布 | ❌ 仅限正式发布 |

---

## 📋 开发流程

### 1. 开发阶段

**项目位置**: `~/.openclaw/projects/Agent-Testing-Skill-Suit/`

```bash
# 创建 Skill 目录
mkdir -p src/skills/<skill-name>

# 创建 SKILL.md
cd src/skills/<skill-name>
# 编写 SKILL.md（包含 YAML frontmatter）

# 创建参考资料目录
mkdir -p references/
```

### 2. 自测阶段

```bash
# 编写单元测试
mkdir -p ../../tests/unit/<skill-name>/

# 运行测试（使用 test-runner）
# 等待 test-runner 开发完成后执行
```

### 3. 文档阶段

```bash
# 生成技术文档
# 使用 technical-doc-generator（项目外工具）

# 编写用户指南
mkdir -p ../../docs/user-guide/
```

### 4. 验收阶段

**验收标准**:
- [ ] SKILL.md 符合 OpenClaw 规范
- [ ] 行数 < 500，Token < 4000
- [ ] 引用来源清晰标注
- [ ] 至少 3-5 个使用示例
- [ ] 通过单元测试
- [ ] 通过集成测试
- [ ] 文档完整

### 5. 部署阶段（仅验收后）

**验收通过后**:
```bash
# 由项目负责人执行部署
cp -r src/skills/<skill-name> ~/.openclaw/skills/

# 验证部署
openclaw skills list | grep <skill-name>
```

---

## 🎯 开发规范

### SKILL.md 规范

```markdown
---
name: skill-name
description: 简短描述（< 100 字符）
metadata:
  openclaw:
    emoji: "🔧"
    requires:
      bins: ["node", "npm"]
---

# Skill 名称

## 何时使用

| 场景 | 操作 |
|------|------|
| 场景 1 | 操作 1 |

## 核心功能

### 功能 1
说明 + 示例

## 命令参考

```bash
# 示例命令
```

## 最佳实践

- 实践 1
- 实践 2
```

### 目录规范

```
<skill-name>/
├── SKILL.md              # 必需
├── README.md             # 推荐
├── references/           # 推荐
│   ├── standard.md       # 技术标准
│   └── examples.md       # 使用示例
└── scripts/              # 可选
    └── helper.sh         # 辅助脚本
```

---

## 📊 质量保证

### 代码审查清单

- [ ] SKILL.md 结构完整
- [ ] YAML frontmatter 正确
- [ ] 行数 < 500
- [ ] Token < 4000
- [ ] 引用来源清晰
- [ ] 示例完整（3-5 个）
- [ ] 无拼写错误
- [ ] 无语法错误

### 测试要求

- [ ] 单元测试通过
- [ ] 集成测试通过
- [ ] 边界测试通过
- [ ] 错误处理测试通过

### 文档要求

- [ ] 技术文档完整
- [ ] 用户指南清晰
- [ ] API 文档准确
- [ ] 示例可运行

---

## ⚠️ 常见错误

### 错误 1: 提前部署

**错误做法**:
```bash
# ❌ 开发中直接部署到生产环境
cp src/skills/test-boundary ~/.openclaw/skills/
```

**正确做法**:
```bash
# ✅ 保留在开发目录
# src/skills/test-boundary/

# ✅ 等待验收通过后由项目负责人部署
```

### 错误 2: 忽略测试

**错误做法**:
- 开发完直接提交
- 不编写测试用例
- 不执行自测

**正确做法**:
- 开发完成后编写测试
- 执行单元测试
- 执行集成测试
- 通过所有测试后提交

### 错误 3: 文档不全

**错误做法**:
- 只写 SKILL.md
- 不写使用示例
- 不标注引用来源

**正确做法**:
- 完整的 SKILL.md
- 3-5 个使用示例
- 清晰的引用来源
- 技术文档和用户指南

---

## 📝 提交规范

### Git 提交信息（如使用 Git）

```
<type>(<scope>): <subject>

feat(test-boundary): 添加边界值分析 Skill

- 实现 ISTQB 标准的边界值分析
- 支持 2 值和 3 值边界分析
- 添加 5 个使用示例
- 添加技术标准文档

Closes #123
```

### 提交前检查清单

- [ ] 代码审查通过
- [ ] 所有测试通过
- [ ] 文档完整
- [ ] 无调试代码
- [ ] 无敏感信息
- [ ] 符合开发规范

---

## 🔗 相关资源

- [项目概述](README.md)
- [项目计划](docs/plan.md)
- [架构设计](docs/architecture.md)
- [OpenClaw Skills 规范](https://docs.openclaw.ai/tools/skills)

---

*最后更新：2026-04-10*
*版本：1.0*
*状态：开发中 - 禁止部署*
