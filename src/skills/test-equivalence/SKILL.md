---
name: test-equivalence
description: 等价类划分 (ECP) 测试设计技术 - 基于 ISTQB 标准
metadata:
  openclaw:
    version: "1.0"
  istqb:
    level: Foundation
    type: Black-box Test Design Technique
  author: Agent-Testing-Skill-Suit
  created: 2026-04-10
---

# test-equivalence - 等价类划分 (Equivalence Class Partitioning)

## 技能概述

等价类划分 (ECP) 是一种黑盒测试设计技术，将输入数据划分为若干等价类，从每个类中选择代表性测试数据。**同一类中的任意输入应产生相同行为**。

## 核心概念

### 什么是等价类划分？

ECP 基于以下原理：
- 将无限/大量输入数据划分为有限个等价类
- 每个类中的输入对系统行为是"等价的"
- 从每个类选 1-2 个代表值，大幅减少测试用例数量

### 等价类类型

| 类型 | 描述 | 示例 |
|------|------|------|
| **有效等价类** | 符合需求的输入 | 年龄 18-60 岁 |
| **无效等价类** | 不符合需求的输入 | 年龄 <18 或 >60 |

### 为什么使用 ECP？

1. **减少测试量**：从无限输入到有限代表值
2. **系统覆盖**：确保每个输入域都被测试
3. **高效设计**：结构化方法，避免随机测试
4. **早期缺陷**：无效类帮助发现边界和错误处理问题

### ECP 与 BVA 的关系

```
ECP (等价类划分)          BVA (边界值分析)
     ↓                          ↓
  分组 → 选代表值            边界 → 测极值
     ↓                          ↓
     └─────────→ 结合使用 ←─────────┘
           最佳测试覆盖率
```

**最佳实践**：先用 ECP 分组，再用 BVA 测边界，两者互补。

## 使用方法

### 步骤 1: 识别输入条件

分析需求，列出所有输入参数：
```
功能：用户注册
输入：年龄 (整数), 邮箱 (字符串), 密码 (字符串)
```

### 步骤 2: 划分等价类

为每个输入条件划分有效/无效类：
```
年龄:
  有效类：[     18,      60     ]
  无效类 1: (-∞, 17]
  无效类 2: [61, +∞)
  无效类 3: 非整数

邮箱:
  有效类：符合 email 格式
  无效类：不符合 email 格式

密码:
  有效类：长度 8-20，含字母数字
  无效类 1：长度 <8
  无效类 2：长度 >20
  无效类 3：不含字母或数字
```

### 步骤 3: 选择代表值

从每个等价类选择 1-2 个代表值：
```
年龄:
  有效类 [     18,      60     ] → 选 25, 40
  无效类 (-∞, 17] → 选 17, 5
  无效类 [61, +∞) → 选 61, 100
  无效类 (非整数) → 选 "abc", 18.5

邮箱:
  有效类 → user@example.com
  无效类 → invalid-email

密码:
  有效类 → Pass1234
  无效类 (<8) → Pass123
  无效类 (>20) → Pass12345678901234567890
  无效类 (无数字) → Password
```

### 步骤 4: 设计测试用例

组合代表值，设计测试用例：
```yaml
test_cases:
  - id: ECP-001
    description: 有效年龄 + 有效邮箱 + 有效密码
    input: {age: 25, email: "user@example.com", password: "Pass1234"}
    expected: 注册成功
  - id: ECP-002
    description: 无效年龄 (<18)
    input: {age: 17, email: "user@example.com", password: "Pass1234"}
    expected: 注册失败 - 年龄无效
  - id: ECP-003
    description: 无效邮箱格式
    input: {age: 25, email: "invalid", password: "Pass1234"}
    expected: 注册失败 - 邮箱格式错误
```

### 步骤 5: 执行并优化

执行测试用例，根据结果：
- 发现新等价类 → 补充测试
- 某类全部失败 → 细化该类
- 某类全部通过 → 可减少该类测试

## 使用示例

### 示例 1: 三角形分类 (经典 ECP)

**场景**：根据三边长度分类三角形

**等价类**：
```
有效类:
  E1: 等边三角形 (a=b=c)
  E2: 等腰三角形 (a=b 或 b=c 或 a=c)
  E3: 普通三角形 (a≠b≠c, 且满足三角不等式)

无效类:
  I1: 不满足三角不等式 (a+b≤c 或 a+c≤b 或 b+c≤a)
  I2: 边长 ≤ 0
  I3: 非数值输入
```

**代表值**：
```python
test_cases = [
    # 有效类
    (3, 3, 3, "等边三角形"),      # E1
    (3, 3, 4, "等腰三角形"),      # E2
    (3, 4, 5, "普通三角形"),      # E3
    # 无效类
    (1, 2, 10, "无效 - 不满足三角不等式"),  # I1
    (0, 5, 5, "无效 - 边长≤0"),           # I2
    (-3, 4, 5, "无效 - 边长≤0"),          # I2
]
```

### 示例 2: 用户登录系统

**场景**：用户名 + 密码登录

**等价类**：
```
用户名:
  有效类：已注册用户
  无效类 1：未注册用户
  无效类 2：空用户名
  无效类 3：含特殊字符

密码:
  有效类：正确密码
  无效类 1：错误密码
  无效类 2：空密码
  无效类 3：大小写错误
```

**测试用例**：
```javascript
describe('Login ECP', () => {
  // 有效类
  it('valid username + valid password', () => {
    expect(login('user1', 'correctPass')).toBe('success');
  });

  // 无效类 - 用户名
  it('unregistered username', () => {
    expect(login('unknown', 'anyPass')).toBe('error: user not found');
  });
  it('empty username', () => {
    expect(login('', 'correctPass')).toBe('error: username required');
  });

  // 无效类 - 密码
  it('wrong password', () => {
    expect(login('user1', 'wrongPass')).toBe('error: invalid password');
  });
  it('empty password', () => {
    expect(login('user1', '')).toBe('error: password required');
  });

  // 组合无效类
  it('empty username + empty password', () => {
    expect(login('', '')).toBe('error: credentials required');
  });
});
```

### 示例 3: 文件上传功能

**场景**：上传文件，限制类型和大小

**等价类**：
```
文件类型:
  有效类：.jpg, .png, .pdf
  无效类：.exe, .bat, .sh (可执行文件)

文件大小:
  有效类：1KB - 10MB
  无效类 1：0KB (空文件)
  无效类 2：<1KB
  无效类 3：>10MB

文件存在性:
  有效类：文件存在
  无效类：文件不存在
```

**测试用例**：
```java
@Test
public void testFileUploadECP() {
    // 有效类
    uploadAndAssert("image.jpg", 500*KB, SUCCESS);
    uploadAndAssert("doc.pdf", 5*MB, SUCCESS);

    // 无效类 - 类型
    uploadAndAssert("virus.exe", 100*KB, ERROR_TYPE);
    uploadAndAssert("script.sh", 50*KB, ERROR_TYPE);

    // 无效类 - 大小
    uploadAndAssert("empty.jpg", 0, ERROR_SIZE);
    uploadAndAssert("tiny.jpg", 500, ERROR_SIZE);  // <1KB
    uploadAndAssert("huge.jpg", 15*MB, ERROR_SIZE); // >10MB

    // 无效类 - 存在性
    uploadAndAssert(null, 0, ERROR_FILE_NOT_FOUND);
}
```

### 示例 4: 搜索功能 (多条件组合)

**场景**：商品搜索，支持多条件筛选

**等价类**：
```
价格范围:
  有效类 1：0-100 元
  有效类 2：101-500 元
  有效类 3：501-2000 元
  无效类：负数，非数字

品牌:
  有效类：已注册品牌
  无效类：未注册品牌，空值

评分:
  有效类：1-5 星
  无效类：0 星，>5 星，非整数
```

**测试用例矩阵**：
```python
# 使用正交表减少组合数
test_matrix = [
    # 价格      品牌        评分     预期
    (50,       'BrandA',   4,      '有结果'),   # 有效组合
    (300,      'BrandB',   3,      '有结果'),   # 有效组合
    (1000,     'BrandC',   5,      '有结果'),   # 有效组合
    (-50,      'BrandA',   4,      '价格错误'),  # 价格无效
    (50,       'Unknown', 4,      '品牌错误'),  # 品牌无效
    (50,       'BrandA',   0,      '评分错误'),  # 评分无效
    (50,       'BrandA',   6,      '评分错误'),  # 评分无效
]
```

### 示例 5: API 参数验证

**场景**：REST API 创建订单

**等价类**：
```
quantity (数量):
  有效类：[     1,      999     ]
  无效类 1：≤0
  无效类 2：≥1000
  无效类 3：非整数

paymentMethod (支付方式):
  有效类：credit_card, debit_card, paypal
  无效类：unknown_method, 空值

shippingAddress (地址):
  有效类：有效地址对象
  无效类：缺少必填字段，格式错误
```

**测试用例**：
```python
def test_create_order_ecp():
    # 有效类组合
    response = create_order(
        quantity=5,
        payment_method='credit_card',
        address={'street': '123 Main St', 'city': 'NYC'}
    )
    assert response.status == 201

    # 无效类 - quantity
    response = create_order(quantity=0, ...)
    assert response.status == 400
    assert 'quantity' in response.error

    response = create_order(quantity=1000, ...)
    assert response.status == 400

    # 无效类 - payment_method
    response = create_order(payment_method='crypto', ...)
    assert response.status == 400

    # 无效类 - address
    response = create_order(address={'city': 'NYC'})  # 缺少 street
    assert response.status == 400
```

## 最佳实践

### 1. 基于需求划分

等价类必须来源于需求规格：
```
需求：年龄 18-60 岁
→ 有效类：[     18,      60     ]
→ 无效类：(-∞, 17], [61, +∞)
```

### 2. 覆盖所有输入条件

确保每个输入参数都被分析：
```
检查清单:
- [ ] 所有数值输入已划分
- [ ] 所有字符串输入已划分
- [ ] 所有枚举/选项已划分
- [ ] 所有必填/可选已考虑
- [ ] 所有格式约束已考虑
```

### 3. 无效类同样重要

不要只测试有效输入：
```
测试比例建议:
  有效类：40%
  无效类：60%  (更容易发现缺陷)
```

### 4. 与 BVA 结合

ECP 选代表值，BVA 测边界：
```
步骤:
1. ECP 划分等价类
2. 从每个类选代表值
3. BVA 补充边界值
4. 合并去重，执行测试
```

### 5. 维护等价类文档

在 references/ 目录中维护等价类表，便于复用和审查。

## 验收标准

使用本 Skill 后，应能：
- [ ] 正确识别有效和无效等价类
- [ ] 为每个等价类选择合适的代表值
- [ ] 设计覆盖所有等价类的测试用例
- [ ] 将 ECP 与 BVA 结合使用
- [ ] 记录等价类相关缺陷

## 参考资料

- ISTQB Foundation Level Syllabus - Black-box Test Design Techniques
- GeeksforGeeks: Equivalence Partitioning
- Katalon: Equivalence Class Partitioning Guide
- 参见 `references/` 目录中的详细资料

## 相关技能

- `test-boundary` - 边界值分析 (BVA)
- `test-decision-table` - 决策表测试
- `test-state-transition` - 状态转换测试

---

**版本**: 1.0 | **最后更新**: 2026-04-10 | **位置**: `~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/src/skills/test-equivalence/`

