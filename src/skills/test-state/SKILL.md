---
name: test-state
description: ISTQB 状态转换测试技术 - 基于状态图和状态表设计测试用例
metadata:
  openclaw:
    version: "1.0"
  istqb:
    level: "Foundation"
    type: "Black-box"
    coverage: "State Transition"
references:
  - ISTQB CTFL Syllabus 2018/2023
  - https://toolsqa.com/software-testing/istqb/state-transition-testing-diagram-example-and-technique
  - https://www.testdevlab.com/blog/phases-of-stlc
---

# 状态转换测试 Skill (test-state)

## 核心概念

**状态转换测试**是一种黑盒测试技术，用于测试系统在不同输入事件下的状态变化行为。适用于有限状态机 (FSM) 系统。

### 关键术语
- **状态 (State)**: 系统在某一时刻的条件或情况
- **转换 (Transition)**: 从一个状态到另一个状态的变化
- **事件 (Event)**: 触发转换的输入或条件
- **动作 (Action)**: 转换产生的输出或结果

## 使用场景

✅ 适用场景:
- 系统行为依赖于历史输入序列
- 有明确的状态机和状态转换规则
- ATM 机、订单流程、工作流审批等
- 实时系统和事件驱动系统

❌ 不适用:
- 无状态系统
- 简单的 CRUD 操作
- 纯计算功能

## 测试设计方法

### 1. 状态转换图 (State Transition Diagram)

使用圆形表示状态，箭头表示转换：

```
[Idle] --插入卡片--> [CardInserted]
[CardInserted] --输入 PIN--> [PINEntered]
[PINEntered] --验证成功--> [Authenticated]
[PINEntered] --验证失败--> [CardRetained]
```

### 2. 状态转换表 (State Transition Table)

| 当前状态 | 事件/输入 | 下一状态 (成功) | 下一状态 (失败) | 动作 |
|---------|----------|----------------|----------------|------|
| Idle | 插入卡片 | CardInserted | - | 读卡 |
| CardInserted | 输入 PIN | PINEntered | CardRetained | 提示输入 |
| PINEntered | 验证成功 | Authenticated | CardRetained | 验证 |
| Authenticated | 取款 | Idle | Authenticated | 出钞 |

### 3. 覆盖标准

- **0-switch 覆盖**: 覆盖所有单个转换
- **1-switch 覆盖**: 覆盖所有长度为 2 的转换序列
- **n-switch 覆盖**: 覆盖所有长度为 n+1 的转换序列
- **无效转换测试**: 测试不允许的状态转换

## 使用示例

### 示例 1: ATM 取款流程测试

```markdown
# 测试场景：ATM 取款

## 状态定义
- S0: 空闲 (Idle)
- S1: 卡片插入 (CardInserted)
- S2: PIN 输入 (PINEntered)
- S3: 已认证 (Authenticated)
- S4: 交易完成 (TransactionComplete)

## 测试用例
TC1: 正常取款流程
  S0 →[插卡]→ S1 →[正确 PIN]→ S3 →[取款]→ S4 →[取卡]→ S0

TC2: PIN 错误三次
  S0 →[插卡]→ S1 →[错误 PIN]→ S1 →[错误 PIN]→ S1 →[错误 PIN]→ S0(锁卡)

TC3: 超时转换
  S1 →[超时 30 秒]→ S0(退卡)
```

### 示例 2: 订单状态转换测试

```yaml
测试用例：订单生命周期
状态:
  - Created(已创建)
  - Paid(已支付)
  - Shipped(已发货)
  - Delivered(已送达)
  - Cancelled(已取消)
  - Refunded(已退款)

有效转换:
  Created → Paid: 支付成功
  Created → Cancelled: 用户取消
  Paid → Shipped: 商家发货
  Paid → Refunded: 退款申请
  Shipped → Delivered: 确认收货
  Shipped → Refunded: 退货退款

测试序列:
  - TC1: Created → Paid → Shipped → Delivered (正常流程)
  - TC2: Created → Cancelled (取消流程)
  - TC3: Created → Paid → Refunded (退款流程)
  - TC4: Paid → Created (无效转换，应拒绝)
```

### 示例 3: 登录状态机测试

```python
# 测试代码示例
def test_login_state_machine():
    states = [      'LoggedOut',       'EnteringCredentials', 'Authenticated', 'Locked'      ]

    # 正常登录
    assert transition('LoggedOut', 'enter_credentials') == 'EnteringCredentials'
    assert transition('EnteringCredentials', 'submit_valid') == 'Authenticated'

    # 失败场景
    assert transition('EnteringCredentials', 'submit_invalid') == 'EnteringCredentials'
    assert transition('EnteringCredentials', 'submit_invalid_3times') == 'Locked'

    # 无效转换
    assert transition('Authenticated', 'enter_credentials') == 'ERROR'
```

### 示例 4: 电梯控制系统

```markdown
## 电梯状态转换

状态:
  - IDLE: 空闲等待
  - MOVING_UP: 上行
  - MOVING_DOWN: 下行
  - DOOR_OPEN: 开门
  - DOOR_CLOSE: 关门
  - OVERLOAD: 超载

转换规则:
  | 当前状态 | 事件 | 下一状态 | 条件 |
  |---------|------|---------|------|
  | IDLE | 上行呼叫 | MOVING_UP | 有上层请求 |
  | IDLE | 下行呼叫 | MOVING_DOWN | 有下层请求 |
  | MOVING_UP | 到达楼层 | DOOR_OPEN | 目标楼层 |
  | DOOR_OPEN | 超时 5 秒 | DOOR_CLOSE | 无遮挡 |
  | DOOR_CLOSE | 完成 | IDLE | 无新请求 |
  | IDLE | 超载传感器 | OVERLOAD | 重量>限额 |

测试重点:
  - 所有有效转换路径
  - 超载时的状态转换
  - 紧急停止按钮的状态变化
```

### 示例 5: 游戏角色状态测试

```javascript
// 游戏角色状态机测试
const characterStates = {
  IDLE: 'idle',
  RUNNING: 'running',
  JUMPING: 'jumping',
  ATTACKING: 'attacking',
  HURT: 'hurt',
  DEAD: 'dead'
};

// 状态转换矩阵
const transitions = {
  [characterStates.IDLE]: {
    'move_input': characterStates.RUNNING,
    'jump_input': characterStates.JUMPING,
    'attack_input': characterStates.ATTACKING,
    'damage': characterStates.HURT
  },
  [characterStates.RUNNING]: {
    'stop_input': characterStates.IDLE,
    'jump_input': characterStates.JUMPING,
    'damage': characterStates.HURT
  },
  [characterStates.JUMPING]: {
    'land': characterStates.IDLE,
    'damage': characterStates.HURT
  },
  // ... 其他状态
};

// 测试用例
test('角色从 idle 可以转换到 running', () => {
  expect(getNextState('idle', 'move_input')).toBe('running');
});

test('角色在 jumping 时不能直接攻击', () => {
  expect(getNextState('jumping', 'attack_input')).toBe(null);
});
```

## 测试用例设计技巧

### 1. 最短路径测试
测试从初始状态到目标状态的最短转换序列。

### 2. 最长路径测试
测试系统能处理的最长状态转换序列，验证状态记忆。

### 3. 无效转换测试
尝试所有不允许的状态转换，验证系统正确拒绝。

### 4. 边界条件测试
- 状态超时
- 快速连续事件
- 并发事件处理

### 5. 回归测试
保存所有状态转换路径作为回归测试集。

## 验收标准检查清单

- [ ] 已绘制完整的状态转换图
- [ ] 已创建状态转换表 (包含所有状态、事件、转换)
- [ ] 0-switch 覆盖率达到 100%
- [ ] 已测试所有无效转换
- [ ] 已测试超时和异常场景
- [ ] 测试用例可执行且结果可验证
- [ ] 文档包含至少 5 个使用示例
- [ ] 引用来源清晰标注 (ISTQB 标准)

## 常见陷阱

⚠️ **状态爆炸**: 状态过多时，使用层次化状态机
⚠️ **遗漏转换**: 确保每个状态的所有可能事件都有定义
⚠️ **死锁状态**: 验证每个状态都有出口转换
⚠️ **未定义行为**: 明确所有无效输入的处理方式

## 工具推荐

- **绘图工具**: draw.io, Lucidchart, PlantUML
- **测试框架**: 根据技术栈选择 (JUnit, pytest, Jest 等)
- **模型检查**: SPIN, NuSMV (用于形式化验证)

---

*基于 ISTQB CTFL  syllabus 状态转换测试技术 | 版本 1.0 | 2026-04-10*

