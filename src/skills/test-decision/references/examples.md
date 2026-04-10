# 决策表测试示例集

## 示例 1: 用户注册验证

### 业务规则
```
条件:
  C1: 邮箱格式正确？
  C2: 密码强度>=中？
  C3: 同意服务条款？
  C4: 邮箱未注册？

动作:
  A1: 注册成功
  A2: 提示邮箱格式错误
  A3: 提示密码强度不足
  A4: 提示需同意条款
  A5: 提示邮箱已注册
```

### 决策表
| 条件 | R1 | R2 | R3 | R4 | R5 | R6 | R7 | R8 | ... | R16 |
|------|----|----|----|----|----|----|----|----|-----|-----|
| C1: 邮箱格式 | Y | Y | Y | Y | Y | Y | Y | Y | ... | N |
| C2: 密码强度 | Y | Y | Y | Y | N | N | N | N | ... | - |
| C3: 同意条款 | Y | Y | N | N | Y | Y | N | N | ... | - |
| C4: 邮箱未注册 | Y | N | Y | N | Y | N | Y | N | ... | - |
|------|----|----|----|----|----|----|----|----|-----|-----|
| A1: 注册成功 | X |   |   |   |   |   |   |   | ... |   |
| A2: 邮箱格式错 |   |   |   |   |   |   |   |   | ... | X |
| A3: 密码不足 |   |   |   |   | X | X | X | X | ... |   |
| A4: 需同意条款 |   |   | X | X |   |   | X | X | ... |   |
| A5: 邮箱已注册 |   | X |   | X |   | X |   | X | ... |   |

### 简化后
| 条件 | R1 | R2 | R3 | R4 | R5 | R6 |
|------|----|----|----|----|----|----|
| C1: 邮箱格式 | Y | Y | Y | Y | Y | N |
| C2: 密码强度 | Y | Y | N | - | - | - |
| C3: 同意条款 | Y | N | - | - | - | - |
| C4: 邮箱未注册 | Y | - | - | - | - | - |
|------|----|----|----|----|----|----|
| A1: 注册成功 | X |   |   |   |   |   |
| A2-A5: 各种错误 |   | X | X | X | X | X |

### 测试用例
```python
def test_registration_success():
    assert register(valid_email, strong_password, agreed=True) == 'SUCCESS'

def test_registration_email_exists():
    assert register(existing_email, strong_password, agreed=True) == 'EMAIL_EXISTS'

def test_registration_weak_password():
    assert register(valid_email, '123', agreed=True) == 'WEAK_PASSWORD'
```

## 示例 2: 订单折扣计算

### 决策表
```
条件:
  C1: 订单金额 >= 1000?
  C2: 订单金额 >= 500?
  C3: 会员等级=VIP?
  C4: 使用优惠券？

动作:
  A1: 无折扣
  A2: 9 折
  A3: 95 折
  A4: 减 50
  A5: 减 20
```

| C1: >=1000 | Y | Y | Y | Y | N | N | N | N |
| C2: >=500  | Y | Y | N | N | Y | Y | N | N |
| C3: VIP    | Y | N | Y | N | Y | N | Y | N |
| C4: 优惠券  | Y | Y | Y | Y | Y | Y | Y | Y |
|------------|---|---|---|---|---|---|---|---|
| A1: 无折扣  |   |   |   |   |   |   |   | X |
| A2: 9 折    | X |   |   |   |   |   |   |   |
| A3: 95 折   |   | X | X |   | X |   | X |   |
| A4: 减 50   | X |   | X |   |   |   |   |   |
| A5: 减 20   |   |   |   | X | X | X |   | X |

### 测试数据
```yaml
测试用例集:
  - id: TC-001
    input: { amount: 1200, vip: true, coupon: true }
    expected: { discount: '10% + 50 off' }
    
  - id: TC-002
    input: { amount: 600, vip: false, coupon: false }
    expected: { discount: '5%' }
    
  - id: TC-003
    input: { amount: 300, vip: false, coupon: false }
    expected: { discount: 'none' }
```

## 示例 3: 交通信号灯控制

### 决策表
```
条件:
  C1: 主干道有车？
  C2: 支路有车？
  C3: 主干道绿灯>=60 秒？
  C4: 紧急车辆接近？

动作:
  A1: 主干道绿灯
  A2: 支路绿灯
  A3: 全红 (清空路口)
  A4: 紧急车辆优先
```

| C1: 主路车 | - | - | - | - | Y | Y | Y | Y | N | N | N | N |
| C2: 支路车 | - | - | - | - | Y | Y | N | N | Y | Y | N | N |
| C3: 绿灯久 | - | - | Y | N | - | - | - | - | - | - | - | - |
| C4: 紧急车 | Y | N | Y | N | Y | N | Y | N | Y | N | Y | N |
|------------|---|---|---|---|---|---|---|---|---|---|---|---|
| A1: 主路绿  |   | X |   | X |   | X |   | X |   |   |   |   |
| A2: 支路绿  |   |   |   |   |   |   |   |   | X | X | X | X |
| A3: 全红    | X |   | X |   | X |   | X |   | X |   | X |   |
| A4: 紧急优先 | X |   | X |   | X |   | X |   | X |   | X |   |

## 示例 4: 文件上传验证

### 决策表
```javascript
// 条件
const conditions = {
  fileSize: '<=10MB',    // Y/N
  fileType: 'allowed',   // Y/N
  virusScan: 'clean',    // Y/N
  userQuota: 'sufficient' // Y/N
};

// 动作
const actions = {
  upload: '允许上传',
  reject_size: '拒绝 - 文件过大',
  reject_type: '拒绝 - 文件类型不支持',
  reject_virus: '拒绝 - 发现病毒',
  reject_quota: '拒绝 - 空间不足'
};

// 决策规则
const rules = [
  { conditions: { Y, Y, Y, Y }, actions: ['upload'] },
  { conditions: { N, -, -, - }, actions: ['reject_size'] },
  { conditions: { Y, N, -, - }, actions: ['reject_type'] },
  { conditions: { Y, Y, N, - }, actions: ['reject_virus'] },
  { conditions: { Y, Y, Y, N }, actions: ['reject_quota'] }
];

// 测试
test('文件过大应拒绝', () => {
  const result = validateUpload({
    size: '15MB',
    type: 'pdf',
    virusFree: true,
    hasQuota: true
  });
  expect(result).toBe('reject_size');
});
```

## 示例 5: 信用卡交易审批

### 完整决策表
```
条件:
  C1: 卡状态=正常？
  C2: 余额充足？
  C3: 未超单日限额？
  C4: 未超单月限额？
  C5: 交易地点=常用地？
  C6: 大额交易 (>10000)?

动作:
  A1: 批准交易
  A2: 拒绝 - 卡异常
  A3: 拒绝 - 余额不足
  A4: 拒绝 - 超限额
  A5: 需要短信验证
  A6: 需要人工审核
```

| C1 | C2 | C3 | C4 | C5 | C6 | 动作 |
|----|----|----|----|----|----|------|
| N  | -  | -  | -  | -  | -  | A2   |
| Y  | N  | -  | -  | -  | -  | A3   |
| Y  | Y  | N  | -  | -  | -  | A4   |
| Y  | Y  | Y  | N  | -  | -  | A4   |
| Y  | Y  | Y  | Y  | N  | Y  | A6   |
| Y  | Y  | Y  | Y  | N  | N  | A5   |
| Y  | Y  | Y  | Y  | Y  | Y  | A5   |
| Y  | Y  | Y  | Y  | Y  | N  | A1   |

### 测试场景
```gherkin
Scenario: 正常交易批准
  Given 卡状态正常
  And 余额充足
  And 未超限额
  And 常用地交易
  And 小额交易
  When 发起交易
  Then 批准交易

Scenario: 异地大额需要人工审核
  Given 卡状态正常
  And 余额充足
  And 未超限额
  And 异地交易
  And 大额交易
  When 发起交易
  Then 需要人工审核
```

---
*示例集版本 1.0 | 2026-04-10*
