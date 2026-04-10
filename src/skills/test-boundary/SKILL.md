---
name: test-boundary
description: 边界值分析 (BVA) 测试设计技术 - 基于 ISTQB 标准
metadata:
  openclaw:
    version: "1.0"
  istqb:
    level: Foundation
    type: Black-box Test Design Technique
  author: Agent-Testing-Skill-Suit
  created: 2026-04-10
---

# test-boundary - 边界值分析 (Boundary Value Analysis)

## 技能概述

边界值分析 (BVA) 是一种黑盒测试设计技术，专注于测试输入范围的边界值。基于观察：**错误更可能出现在输入范围的边缘而非中间**。

## 核心概念

### 什么是边界值分析？

BVA 通过测试以下值来识别边界处的缺陷：
- **边界值本身** (on the boundary)
- **刚好低于边界** (just below the boundary)
- **刚好高于边界** (just above the boundary)

### 为什么使用 BVA？

1. **缺陷集中**：80% 的边界相关缺陷出现在 20% 的边界值处
2. **高效覆盖**：用最少的测试用例覆盖最高风险的场景
3. **ISTQB 标准**：Foundation Level 核心测试设计技术

### BVA 与等价类划分的关系

- **ECP (等价类划分)**：将输入分组，每组选一个代表值
- **BVA (边界值分析)**：在 ECP 基础上，额外测试边界处的极端值
- **最佳实践**：两者结合使用，先 ECP 分组，再 BVA 测边界

## 使用方法

### 步骤 1: 识别输入范围

确定被测功能的输入范围，例如：
- 年龄：18-60 岁
- 分数：0-100 分
- 数量：1-999 件

### 步骤 2: 确定边界值

对于范围 [      min,       max      ]，测试以下值：
```
边界值集合 = {min-1, min, min+1, max-1, max, max+1}
```

### 步骤 3: 设计测试用例

为每个边界值设计测试用例，包括：
- 输入数据
- 预期结果
- 实际结果
- 通过/失败状态

### 步骤 4: 执行并记录

执行测试用例，记录结果，报告边界相关缺陷。

## 使用示例

### 示例 1: 年龄验证 (基础)

**场景**：用户注册，年龄范围 18-60 岁

**边界值**：17, 18, 19, 59, 60, 61

**测试用例**：
```yaml
test_cases:
  - id: BVA-001
    input: 17
    expected: Invalid (低于最小边界)
  - id: BVA-002
    input: 18
    expected: Valid (最小边界)
  - id: BVA-003
    input: 19
    expected: Valid (最小边界 +1)
  - id: BVA-004
    input: 59
    expected: Valid (最大边界 -1)
  - id: BVA-005
    input: 60
    expected: Valid (最大边界)
  - id: BVA-006
    input: 61
    expected: Invalid (高于最大边界)
```

### 示例 2: 分数系统 (多边界)

**场景**：考试系统，分数范围 0-100

**边界值**：-1, 0, 1, 99, 100, 101

**测试用例**：
```python
def test_score_boundaries():
    boundaries = [      -1,       0, 1, 99, 100, 101      ]
    expected = [      'Invalid',       'Valid', 'Valid', 'Valid', 'Valid', 'Invalid'      ]

    for score, exp in zip(boundaries, expected):
        result = validate_score(score)
        assert result == exp, f"Failed at {score}"
```

### 示例 3: 密码长度 (字符串边界)

**场景**：密码长度要求 8-20 字符

**边界值**：7, 8, 9, 19, 20, 21

**测试用例**：
```javascript
describe('Password Length BVA', () => {
  it('should reject 7 chars', () => {
    expect(validatePassword('a'.repeat(7))).toBe(false);
  });
  it('should accept 8 chars (min boundary)', () => {
    expect(validatePassword('a'.repeat(8))).toBe(true);
  });
  it('should accept 20 chars (max boundary)', () => {
    expect(validatePassword('a'.repeat(20))).toBe(true);
  });
  it('should reject 21 chars', () => {
    expect(validatePassword('a'.repeat(21))).toBe(false);
  });
});
```

### 示例 4: 批量购买折扣 (多区间边界)

**场景**：数量折扣
- 1-10 件：原价
- 11-50 件：9 折
- 51-100 件：8 折
- 101+ 件：7 折

**边界值**：0, 1, 10, 11, 50, 51, 100, 101

**测试用例**：
```java
@Test
public void testQuantityDiscountBoundaries() {
    int[] boundaries = {0, 1, 10, 11, 50, 51, 100, 101};
    String[] expectedDiscount = {"N/A", "0%", "0%", "10%", "10%", "20%", "20%", "30%"};

    for (int i = 0; i < boundaries.length; i++) {
        String actual = getDiscount(boundaries[i]);
        assertEquals(expectedDiscount[i], actual);
    }
}
```

### 示例 5: 日期范围 (时间边界)

**场景**：预约系统，可预约未来 1-30 天

**边界值**：
- 今天 -1 天 (无效)
- 今天 (无效，不能预约当天)
- 今天 +1 天 (有效，最小边界)
- 今天 +29 天 (有效)
- 今天 +30 天 (有效，最大边界)
- 今天 +31 天 (无效)

**测试用例**：
```python
from datetime import datetime, timedelta

def test_appointment_date_boundaries():
    today = datetime.now().date()
    test_dates = [
        (today - timedelta(days=1), False),
        (today, False),
        (today + timedelta(days=1), True),
        (today + timedelta(days=29), True),
        (today + timedelta(days=30), True),
        (today + timedelta(days=31), False),
    ]

    for date, expected in test_dates:
        result = can_appoint(date)
        assert result == expected, f"Failed at {date}"
```

## 最佳实践

### 1. 识别所有边界类型
- **数值边界**：最小值、最大值
- **字符串边界**：空字符串、最大长度
- **集合边界**：0 个元素、1 个元素、最大元素数
- **时间边界**：开始时间、结束时间、超时

### 2. 考虑极端值
不要只测试常规边界，还要测试：
- 负数、零、极大值
- 空值、null、特殊字符
- 溢出值 (如 INT_MAX + 1)

### 3. 与等价类结合
先用 ECP 分组，再用 BVA 测边界：
```
步骤：
1. 识别有效/无效等价类
2. 为每个等价类确定边界
3. 设计边界测试用例
4. 补充等价类内部的代表值
```

### 4. 文档化边界表
在 references/ 目录中维护边界值表，便于复用。

## 验收标准

使用本 Skill 后，应能：
- [ ] 正确识别输入范围的边界值
- [ ] 设计覆盖 min-1, min, min+1, max-1, max, max+1 的测试用例
- [ ] 区分有效边界和无效边界
- [ ] 将 BVA 与 ECP 结合使用
- [ ] 记录边界相关缺陷

## 参考资料

- ISTQB Foundation Level Syllabus - Black-box Test Design Techniques
- GeeksforGeeks: Boundary Value Analysis
- Katalon: Boundary Value Analysis Guide
- 参见 `references/` 目录中的详细资料

## 相关技能

- `test-equivalence` - 等价类划分 (ECP)
- `test-decision-table` - 决策表测试
- `test-state-transition` - 状态转换测试

---

**版本**: 1.0 | **最后更新**: 2026-04-10 | **位置**: `~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/src/skills/test-boundary/`

