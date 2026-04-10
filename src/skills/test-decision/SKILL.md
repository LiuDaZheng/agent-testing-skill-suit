---
name: test-decision
description: ISTQB 决策表测试技术 - 基于条件组合设计测试用例
metadata:
  openclaw:
    version: "1.0"
  istqb:
    level: "Foundation"
    type: "Black-box"
    coverage: "Decision Table"
references:
  - ISTQB CTFL Syllabus 2018/2023
  - https://toolsqa.com/software-testing/istqb/decision-table-testing/
  - https://www.getsoftwareservice.com/decision-table-testing/
---

# 决策表测试 Skill (test-decision)

## 核心概念

**决策表测试**是一种黑盒测试技术，用于测试多个条件组合下的系统行为。适用于复杂业务规则和多条件判断场景。

### 关键术语
- **条件桩 (Condition Stub)**: 所有输入条件的列表
- **动作桩 (Action Stub)**: 所有可能输出的列表
- **条件项 (Condition Entry)**: 条件的真假值
- **动作项 (Action Entry)**: 对应条件组合下的动作
- **规则 (Rule)**: 一列条件项 + 动作项 = 一条业务规则

## 使用场景

✅ 适用场景:
- 多条件组合的业务逻辑
- if-then-else 规则复杂
- 输入条件相互依赖
- 需要系统化处理组合爆炸

❌ 不适用:
- 单一条件判断
- 简单的等价类划分可覆盖
- 连续值范围测试

## 决策表结构

### 标准格式

```
┌─────────────────────┬─────┬─────┬─────┬─────┐
│ 条件桩              │ R1  │ R2  │ R3  │ R4  │
├─────────────────────┼─────┼─────┼─────┼─────┤
│ 条件 1: 是否会员？   │ Y   │ Y   │ N   │ N   │
│ 条件 2: 金额>1000？  │ Y   │ N   │ Y   │ N   │
│ 条件 3: 使用优惠券？ │ Y   │ N   │ -   │ -   │
├─────────────────────┼─────┼─────┼─────┼─────┤
│ 动作桩              │     │     │     │     │
├─────────────────────┼─────┼─────┼─────┼─────┤
│ 动作 1: 9 折         │ X   │     │     │     │
│ 动作 2: 95 折        │     │ X   │     │     │
│ 动作 3: 无折扣      │     │     │ X   │ X   │
│ 动作 4: 免运费      │ X   │ X   │     │     │
└─────────────────────┴─────┴─────┴─────┴─────┘
```

### 符号说明
- **Y (Yes/1/T)**: 条件为真
- **N (No/0/F)**: 条件为假
- **- (Don't Care)**: 条件无关
- **X**: 执行该动作
- **空白**: 不执行该动作

## 测试设计方法

### 步骤 1: 识别条件
从需求中提取所有独立的布尔条件。

### 步骤 2: 识别动作
确定所有可能的输出或系统行为。

### 步骤 3: 计算规则数
```
规则数 = 条件 1 取值数 × 条件 2 取值数 × ... × 条件 n 取值数
```

### 步骤 4: 填充决策表
为每个规则组合确定预期动作。

### 步骤 5: 简化决策表
合并具有相同动作的规则 (使用"-"无关项)。

### 步骤 6: 生成测试用例
每条规则至少一个测试用例。

## 使用示例

### 示例 1: 贷款审批系统

```markdown
# 业务规则
- 条件 1: 有稳定工作？(Y/N)
- 条件 2: 月收入 >= 10000？(Y/N)
- 条件 3: 信用记录良好？(Y/N)
- 条件 4: 有抵押物？(Y/N)

# 决策表
| 条件           | R1 | R2 | R3 | R4 | R5 | R6 | R7 | R8 |
|---------------|----|----|----|----|----|----|----|----|
| 稳定工作       | Y  | Y  | Y  | Y  | N  | N  | N  | N  |
| 月收入>=10k    | Y  | Y  | N  | N  | Y  | Y  | N  | N  |
| 信用良好       | Y  | N  | Y  | N  | Y  | N  | Y  | N  |
| 有抵押物       | Y  | Y  | Y  | Y  | Y  | Y  | Y  | Y  |
|---------------|----|----|----|----|----|----|----|----|
| 批准贷款       | X  | X  | X  |    | X  |    |    |    |
| 拒绝贷款       |    |    |    | X  |    | X  | X  | X  |
| 需要担保人     |    | X  |    |    |    | X  |    |    |
| 需要抵押物     |    |    | X  | X  |    |    | X  | X  |

# 测试用例
TC-001 (R1): 全部满足 → 批准贷款
TC-002 (R2): 信用不良但有抵押 → 批准 + 需要担保人
TC-003 (R5): 无工作但有抵押和信用 → 批准
TC-004 (R8): 全部不满足 → 拒绝
```

### 示例 2: 保险费用计算

```yaml
条件:
  - C1: 年龄 < 25? (Y/N)
  - C2: 驾龄 < 3 年？(Y/N)
  - C3: 有事故记录？(Y/N)
  - C4: 车型=跑车？(Y/N)

动作:
  - A1: 基础保费
  - A2: +50% 年轻驾驶员附加费
  - A3: +30% 新手附加费
  - A4: +40% 事故记录附加费
  - A5: +60% 跑车附加费

决策规则:
  R1: N,N,N,N → A1 only
  R2: Y,N,N,N → A1 + A2
  R3: N,Y,N,N → A1 + A3
  R4: N,N,Y,N → A1 + A4
  R5: N,N,N,Y → A1 + A5
  R6: Y,Y,Y,Y → A1 + A2 + A3 + A4 + A5 (最高保费)

测试用例:
  - TC-Base: 35 岁，10 年驾龄，无事故，轿车 → 基础保费
  - TC-Max: 22 岁，1 年驾龄，有事故，跑车 → 全部附加费
  - TC-Partial: 20 岁，5 年驾龄，无事故，轿车 → 仅年轻附加费
```

### 示例 3: 用户权限控制

```python
# 权限决策表
# 条件: 角色，资源所有者，工作时间，IP 白名单

def check_permission(role, is_owner, is_business_hours, is_whitelisted_ip):
    """
    决策规则:
    - Admin: 始终允许
    - Manager: 工作时间 + 白名单允许
    - Employee: 工作时间 + 白名单 + 非敏感资源
    - Owner: 始终允许访问自己的资源
    """
    decision_table = [
        # role, owner, hours, ip -> action
        [      'admin',           '-',      '-',    '-',     'ALLOW'      ],
        [      'manager',         '-',      'Y',    'Y',     'ALLOW'      ],
        [      'manager',         '-',      'N',    '-',     'DENY'      ],
        [      'manager',         '-',      '-',    'N',     'DENY'      ],
        [      'employee',        'Y',      '-',    '-',     'ALLOW'      ],  # 所有者
        [      'employee',        'N',      'Y',    'Y',     'ALLOW'      ],
        [      'employee',        'N',      '-',    '-',     'DENY'      ],
    ]

    for rule in decision_table:
        if matches(rule, [      role,       is_owner, is_business_hours, is_whitelisted_ip      ]):
            return rule[4]
    return 'DENY'

# 测试用例
def test_permission_matrix():
    assert check_permission('admin', 'N', 'N', 'N') == 'ALLOW'
    assert check_permission('manager', 'N', 'Y', 'Y') == 'ALLOW'
    assert check_permission('manager', 'N', 'N', 'Y') == 'DENY'
    assert check_permission('employee', 'Y', 'N', 'N') == 'ALLOW'
    assert check_permission('employee', 'N', 'Y', 'Y') == 'ALLOW'
    assert check_permission('employee', 'N', 'N', 'Y') == 'DENY'
```

### 示例 4: 电商促销规则

```markdown
## 促销决策表

| 条件                  | R1 | R2 | R3 | R4 | R5 | R6 | R7 | R8 |
|----------------------|----|----|----|----|----|----|----|----|
| 会员等级=VIP?        | Y  | Y  | Y  | Y  | N  | N  | N  | N  |
| 订单金额>=500?       | Y  | Y  | N  | N  | Y  | Y  | N  | N  |
| 使用优惠券？         | Y  | N  | Y  | N  | Y  | N  | Y  | N  |
| 商品类别=新品？      | Y  | N  | -  | -  | Y  | N  | -  | -  |
|----------------------|----|----|----|----|----|----|----|----|
| 动作                 |    |    |    |    |    |    |    |    |
| VIP 9 折              | X  | X  |    |    |    |    |    |    |
| 满 500 减 50          | X  | X  |    |    | X  | X  |    |    |
| 优惠券可用           | X  |    | X  |    | X  |    | X  |    |
| 新品额外 95 折         | X  |    |    |    | X  |    |    |    |
| 不可叠加优惠         |    |    |    | X  |    |    |    | X  |

## 测试场景

TC-VIP-Max: VIP + 满 500 + 优惠券 + 新品 → 所有优惠叠加
TC-Normal-Sale: 非 VIP + 满 500 → 满减
TC-Coupon-Only: 非 VIP + 优惠券 → 仅优惠券
TC-No-Promo: 非 VIP + 不满 500 + 无券 → 无优惠
```

### 示例 5: 机票价格计算

```javascript
// 机票定价决策表
const pricingRules = [
  {
    // 规则 1: 商务舱全价
    conditions: {
      cabinClass: 'BUSINESS',
      bookingWindow: 'ANY',
      refundable: 'ANY',
      frequentFlyer: 'ANY'
    },
    actions: { baseMultiplier: 3.0, discount: 0 }
  },
  {
    // 规则 2: 提前 30 天 + 经济舱
    conditions: {
      cabinClass: 'ECONOMY',
      bookingWindow: '>30',
      refundable: 'N',
      frequentFlyer: 'ANY'
    },
    actions: { baseMultiplier: 1.0, discount: 0.2 }
  },
  {
    // 规则 3: 金卡会员
    conditions: {
      cabinClass: 'ECONOMY',
      bookingWindow: 'ANY',
      refundable: 'ANY',
      frequentFlyer: 'GOLD'
    },
    actions: { baseMultiplier: 1.0, discount: 0.15 }
  },
  {
    // 规则 4: 标准经济舱
    conditions: {
      cabinClass: 'ECONOMY',
      bookingWindow: '<7',
      refundable: 'N',
      frequentFlyer: 'NONE'
    },
    actions: { baseMultiplier: 1.5, discount: 0 }
  }
];

// 测试
test('提前预订经济舱享受 8 折', () => {
  const price = calculatePrice({
    cabinClass: 'ECONOMY',
    bookingWindow: '45',
    refundable: false,
    frequentFlyer: 'NONE'
  });
  expect(price.discount).toBe(0.2);
});
```

## 测试优化技巧

### 1. 合并无关项
当某个条件不影响结果时，用"-"表示，减少规则数。

### 2. 优先级规则
当多个规则可能匹配时，定义优先级顺序。

### 3. 边界值结合
对决策表中的数值条件，结合边界值分析。

### 4. 因果图
使用因果图识别条件间的依赖关系。

## 覆盖率计算

```
决策表覆盖率 = 已测试规则数 / 总规则数 × 100%

目标：100% 规则覆盖 (每条规则至少一个测试用例)
```

## 验收标准检查清单

- [ ] 已识别所有独立条件
- [ ] 已识别所有可能动作
- [ ] 决策表完整 (无遗漏规则)
- [ ] 已简化决策表 (合并无关项)
- [ ] 每条规则有对应测试用例
- [ ] 测试用例包含预期结果
- [ ] 文档包含至少 5 个使用示例
- [ ] 引用来源清晰标注 (ISTQB 标准)

## 常见陷阱

⚠️ **组合爆炸**: 条件过多时规则数指数增长 → 使用无关项简化
⚠️ **遗漏规则**: 未覆盖所有条件组合 → 系统检查 2^n 规则
⚠️ **矛盾规则**: 相同条件不同动作 → 检查业务逻辑
⚠️ **冗余规则**: 可合并的未合并 → 优化决策表

## 工具推荐

- **表格工具**: Excel, Google Sheets, Airtable
- **决策表引擎**: Drools, Easy Rules
- **测试生成**: 根据决策表自动生成测试用例

---

*基于 ISTQB CTFL syllabus 决策表测试技术 | 版本 1.0 | 2026-04-10*

