# Agent-Testing-Skill-Suit

**STLC 阶段层 Skill 套装** - 基于 ISTQB 标准的完整软件测试生命周期管理工具

---

## 概述

本套装包含 6 个 STLC（Software Testing Life Cycle）阶段层 Skill，覆盖完整的软件测试流程：

| Skill | 阶段 | 核心功能 |
|-------|------|----------|
| test-requirement | 需求分析 | 识别可测试需求、创建 RTM、发现需求缺陷 |
| test-plan | 测试计划 | 制定测试策略、风险评估、资源估算 |
| test-design | 测试设计 | 设计测试用例、应用测试设计技术 |
| test-execute | 测试执行 | 执行测试用例、报告缺陷、跟踪状态 |
| test-report | 测试报告 | 汇总测试结果、质量评估、发布建议 |
| test-lifecycle | 总协调器 | 协调 6 个阶段、管理阶段过渡、风险管理 |

---

## 基于标准

- **ISTQB STLC 标准**: https://www.istqb.org/
- **GeeksforGeeks STLC**: https://www.geeksforgeeks.org/software-testing/software-testing-life-cycle-stlc/
- **OpenClaw Skills 规范**: https://docs.openclaw.ai/tools/skills

---

## 安装位置

**开发位置**（验收前）:
```
~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/src/skills/
```

**生产位置**（验收后）:
```
~/.openclaw/skills/
```

⚠️ **重要**: 验收前禁止部署到生产位置！

---

## 快速开始

### 1. 需求分析阶段
```
使用 test-requirement 分析需求文档
输出：RTM、需求缺陷清单
```

### 2. 测试计划阶段
```
使用 test-plan 制定测试计划
输出：测试计划文档、风险评估报告
```

### 3. 测试设计阶段
```
使用 test-design 设计测试用例
输出：测试用例文档、测试数据清单
```

### 4. 测试执行阶段
```
使用 test-execute 执行测试
输出：执行记录、缺陷报告
```

### 5. 测试报告阶段
```
使用 test-report 生成测试报告
输出：测试总结报告、质量评估
```

### 6. 生命周期管理
```
使用 test-lifecycle 协调整个流程
输出：完整测试档案、经验教训
```

---

## 项目结构

```
Agent-Testing-Skill-Suit/
├── README.md                    # 本文件
├── docs/
│   └── development-log.md       # 开发日志
└── src/skills/
    ├── test-requirement/
    │   ├── SKILL.md
    │   └── references/
    │       ├── rtm-template.md
    │       └── defect-checklist.md
    ├── test-plan/
    │   ├── SKILL.md
    │   └── references/
    │       ├── test-plan-template.md
    │       └── risk-assessment.md
    ├── test-design/
    │   ├── SKILL.md
    │   └── references/
    │       ├── test-case-template.md
    │       └── design-techniques.md
    ├── test-execute/
    │   ├── SKILL.md
    │   └── references/
    │       ├── defect-report-template.md
    │       └── execution-checklist.md
    ├── test-report/
    │   ├── SKILL.md
    │   └── references/
    │       ├── test-report-template.md
    │       └── quality-model.md
    └── test-lifecycle/
        ├── SKILL.md
        └── references/
            ├── stage-review-template.md
            └── risk-management.md
```

---

## 验收标准

### 代码质量
- [x] SKILL.md 符合 OpenClaw 规范（YAML frontmatter + 指令）
- [x] 行数 < 500（所有 Skill 满足）
- [x] Token < 4000（所有 Skill 满足）
- [x] 引用来源清晰标注

### 文档完整性
- [x] 每个 Skill 包含 SKILL.md
- [x] 每个 Skill 包含 references/ 目录
- [x] 每个 Skill 至少 3 个使用示例
- [x] 开发日志已记录

### 安全检查
- [ ] 通过 agent-safety 检查
- [ ] 无敏感信息泄露
- [ ] 无危险命令

### 审计检查
- [ ] 通过 agent-audit 审计
- [ ] 认知负载评估完成
- [ ] TODO.md 已更新

---

## 使用示例

### 示例 1: 启动 STLC 流程
```
使用 test-lifecycle 启动电商平台的 STLC 测试流程
```

### 示例 2: 需求分析
```
使用 test-requirement 分析登录功能需求
输出：RTM、需求缺陷清单
```

### 示例 3: 阶段过渡评审
```
使用 test-lifecycle 评审测试设计阶段是否可以进入执行
```

---

## 开发团队

- **开发者**: OpenClaw Agent
- **开发日期**: 2026-04-10
- **基于标准**: ISTQB STLC

---

## 许可证

本项目遵循 OpenClaw Skills 许可协议。

---

## 参考资料

- ISTQB 官方网站：https://www.istqb.org/
- OpenClaw 文档：https://docs.openclaw.ai/
- ClawHub 技能市场：https://clawhub.ai/

---

*版本：1.0 | 最后更新：2026-04-10*
