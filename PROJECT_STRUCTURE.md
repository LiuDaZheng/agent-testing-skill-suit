# 项目目录结构

> 按最佳实践组织的项目结构

---

## 📁 完整目录结构

```
Agent-Testing-Skill-Suit/
│
├── README.md                    # 项目概述（含禁止部署规则）
├── DEVELOPMENT.md               # 开发指南（详细开发流程）
├── PROJECT_STRUCTURE.md         # 本文档
│
├── docs/                        # 项目文档
│   ├── overview.md              # 项目概述
│   ├── architecture.md          # 架构设计
│   ├── plan.md                  # 项目计划
│   ├── kickoff.md               # 项目启动报告
│   ├── suspension.md            # 项目停止报告
│   ├── file-list.md             # 文件清单
│   ├── progress-board.md        # 进度板
│   ├── recovery-plan.md         # 恢复方案
│   ├── migration-plan.md        # 迁移方案
│   ├── api/                     # API 文档（待生成）
│   └── user-guide/              # 用户指南（待生成）
│
├── src/                         # 源代码
│   ├── skills/                  # Skill 源码（开发中）
│   │   ├── test-boundary/       # 边界值分析
│   │   ├── test-equivalence/    # 等价类划分
│   │   └── ...                  # 其他 Skill
│   └── scripts/                 # 辅助脚本
│
├── tests/                       # 测试
│   ├── unit/                    # 单元测试
│   ├── integration/             # 集成测试
│   └── e2e/                     # E2E 测试
│
├── config/                      # 配置文件
├── scripts/                     # 项目脚本
├── logs/                        # 开发日志
│   ├── stlc-skills-development-log.md
│   ├── test-skills-dev-log.md
│   ├── test-skills-development-log.md
│   └── test-skills-summary.md
└── references/                  # 参考资料
    ├── 自动化测试 Skill 调研报告.md
    ├── 测试生命周期 Skill 架构设计.md
    ├── 辅助 Skill 需求调研报告.md
    └── 辅助 Skill 安装完成报告.md
```

---

## 📋 目录说明

### 根目录文件

| 文件 | 说明 |
|------|------|
| README.md | 项目概述，包含禁止部署规则 |
| DEVELOPMENT.md | 开发指南，详细开发流程和规范 |
| PROJECT_STRUCTURE.md | 本文档，目录结构说明 |

### docs/ - 项目文档

| 文件 | 说明 |
|------|------|
| overview.md | 项目目标、范围、交付物 |
| architecture.md | 三层架构设计文档 |
| plan.md | 16 周项目计划，5 个 Phase |
| kickoff.md | 项目启动会议记录 |
| suspension.md | 项目停止记录 |
| file-list.md | 完整文件清单 |
| progress-board.md | 实时进度追踪 |
| recovery-plan.md | 恢复方案 |
| migration-plan.md | 自动迁移方案 |

### src/skills/ - Skill 源码

**重要**: 所有开发中的 Skill 都在此目录

| Skill | 状态 | 说明 |
|-------|------|------|
| test-boundary | ✅ 已完成 | 边界值分析 |
| test-equivalence | ✅ 已完成 | 等价类划分 |
| 其他 15 个 | ⏳ 待开发 | 见项目计划 |

### tests/ - 测试目录

| 目录 | 说明 |
|------|------|
| unit/ | 单元测试（每个 Skill 的独立测试） |
| integration/ | 集成测试（Skill 间协作测试） |
| e2e/ | E2E 测试（完整流程测试） |

### logs/ - 开发日志

| 文件 | 说明 |
|------|------|
| stlc-skills-development-log.md | 阶段层 Skill 开发日志 |
| test-skills-dev-log.md | 执行层 Skill 开发日志 |
| test-skills-development-log.md | 完整开发日志 |
| test-skills-summary.md | 开发总结 |

### references/ - 参考资料

| 文件 | 说明 |
|------|------|
| 自动化测试 Skill 调研报告.md | 测试框架和工具调研 |
| 测试生命周期 Skill 架构设计.md | 三层架构设计 |
| 辅助 Skill 需求调研报告.md | 辅助 Skill 需求分析 |
| 辅助 Skill 安装完成报告.md | 辅助 Skill 安装记录 |

---

## 🎯 使用指南

### 开发者

```bash
# 1. 查看项目概述
cat README.md

# 2. 查看开发指南
cat DEVELOPMENT.md

# 3. 开始开发
cd src/skills/
mkdir <skill-name>

# 4. 编写测试
cd ../../tests/unit/
```

### 审阅者

```bash
# 1. 查看架构设计
cat docs/architecture.md

# 2. 查看项目计划
cat docs/plan.md

# 3. 查看进度
cat docs/progress-board.md

# 4. 查看开发日志
cat logs/
```

### 用户（项目完成后）

```bash
# 1. 查看用户指南
cat docs/user-guide/

# 2. 查看 API 文档
cat docs/api/
```

---

## 📊 文件统计

| 目录 | 文件数 | 说明 |
|------|--------|------|
| 根目录 | 3 | README, DEVELOPMENT, PROJECT_STRUCTURE |
| docs/ | 9 | 项目文档 |
| src/skills/ | 2 | 已完成的 Skill |
| tests/ | 0 | 待创建 |
| logs/ | 4 | 开发日志 |
| references/ | 4 | 调研报告 |
| **总计** | **22** | |

---

## ⚠️ 重要提醒

### 禁止部署规则

**所有 Skill 在验收前不得部署到**：
- ❌ `~/.openclaw/skills/` (生产环境)
- ❌ `~/.openclaw/workspace-main/skills/` (临时工作区)

**开发位置**：
- ✅ `src/skills/` (开发目录)
- ✅ `tests/` (测试目录)

### 验收流程

1. 开发完成 → `src/skills/<skill-name>/`
2. 自测 → `tests/unit/`
3. 集成测试 → `tests/integration/`
4. 文档审查 → `docs/`
5. 项目验收
6. 部署 → 仅验收后部署

---

*最后更新：2026-04-10*
*版本：1.0*
*状态：项目结构完成*
