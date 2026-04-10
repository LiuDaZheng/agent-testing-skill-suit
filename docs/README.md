# Agent-Testing-Skill-Suit

**测试技术 Skill 套件** - 基于 ISTQB 标准的软件测试设计技术集合

---

## 📦 已开发 Skill

### 基础测试技术 (已完成 ✅)

| Skill | 描述 | 状态 | 行数 |
|-------|------|------|------|
| [`test-boundary`](../src/skills/test-boundary/) | 边界值分析 (BVA) | ✅ 完成 | 248 |
| [`test-equivalence`](../src/skills/test-equivalence/) | 等价类划分 (ECP) | ✅ 完成 | 416 |

### 规划中 Skill

| Skill | 描述 | 优先级 |
|-------|------|--------|
| `test-decision-table` | 决策表测试 | 🔜 下一步 |
| `test-state-transition` | 状态转换测试 | 🔜 下一步 |
| `test-use-case` | 用例测试 | 📋 待开发 |

---

## 🎯 使用指南

### 边界值分析 (test-boundary)

**适用场景**:
- 输入有明确范围 (年龄 18-60、分数 0-100)
- 需要测试边界处的缺陷
- 与等价类划分结合使用

**快速开始**:
```
1. 识别输入范围 [min, max]
2. 确定边界值：min-1, min, min+1, max-1, max, max+1
3. 设计测试用例覆盖所有边界值
4. 执行并记录结果
```

**示例**:
```yaml
# 年龄验证 (18-60 岁)
test_cases:
  - input: 17  # 无效下界
  - input: 18  # 有效下界
  - input: 19  # 有效下界 +1
  - input: 59  # 有效上界 -1
  - input: 60  # 有效上界
  - input: 61  # 无效上界
```

### 等价类划分 (test-equivalence)

**适用场景**:
- 输入数据量大，需要减少测试用例
- 需要系统覆盖所有输入域
- 需要验证错误处理

**快速开始**:
```
1. 识别所有输入条件
2. 划分有效/无效等价类
3. 从每个类选择代表值
4. 设计测试用例 (有效类组合，无效类单独)
5. 执行并记录结果
```

**示例**:
```python
# 密码验证
有效类：长度 [8,20] 且含字母数字 → "Pass1234"
无效类 1：长度 <8 → "Pass12"
无效类 2：长度 >20 → "Pass12345678901234567890"
无效类 3：无字母 → "12345678"
无效类 4：无数字 → "Password"
```

---

## 📚 参考资料

每个 Skill 的 `references/` 目录包含：
- **istqb-standard.md**: ISTQB 官方标准定义
- **边界值表/等价类表**: 实用模板和示例

---

## ✅ 验收状态

| 验收项 | 状态 |
|--------|------|
| SKILL.md 符合规范 | ✅ |
| 行数 < 500 | ✅ |
| Token < 4000 | ✅ |
| 引用来源清晰 | ✅ |
| ≥ 5 个使用示例 | ✅ |
| agent-safety 检查 | ✅ |
| 位置正确 | ✅ |
| 未部署生产 | ✅ |

**详细报告**: [acceptance-report.md](./acceptance-report.md)

---

## 📁 目录结构

```
Agent-Testing-Skill-Suit/
├── src/skills/
│   ├── test-boundary/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── istqb-standard.md
│   │       └── boundary-table.md
│   └── test-equivalence/
│       ├── SKILL.md
│       └── references/
│           ├── istqb-standard.md
│           └── equivalence-table.md
└── docs/
    ├── README.md (本文件)
    ├── development-log.md
    └── acceptance-report.md
```

---

## 🚀 下一步

1. **集成测试**: 创建 tests/ 目录，编写单元测试
2. **补充技能**: 开发 test-decision-table 和 test-state-transition
3. **示例扩展**: 为每个示例添加可执行脚本
4. **文档完善**: 添加视频教程和使用案例

---

**版本**: 1.0  
**最后更新**: 2026-04-10  
**维护者**: Agent-Testing-Skill-Suit Team
