# 状态转换测试示例集

## 示例 1: 登录系统状态机

### 状态定义
```
S0: LOGGED_OUT - 未登录
S1: ENTERING_CREDENTIALS - 输入凭证
S2: AUTHENTICATED - 已认证
S3: ACCOUNT_LOCKED - 账户锁定
S4: PASSWORD_EXPIRED - 密码过期
```

### 转换规则
| 当前状态 | 事件 | 条件 | 下一状态 | 动作 |
|---------|------|------|---------|------|
| S0 | 访问需要认证的页面 | - | S1 | 显示登录表单 |
| S1 | 提交凭证 | 有效 | S2 | 创建会话 |
| S1 | 提交凭证 | 无效 (1-2 次) | S1 | 显示错误 |
| S1 | 提交凭证 | 无效 (3 次) | S3 | 锁定账户 |
| S1 | 提交凭证 | 密码过期 | S4 | 提示修改密码 |
| S2 | 登出 | - | S0 | 销毁会话 |
| S2 | 会话超时 | - | S0 | 自动登出 |
| S3 | 管理员解锁 | - | S0 | 解锁账户 |
| S4 | 修改密码 | 成功 | S2 | 更新密码 |

### 测试用例
```gherkin
Scenario: 正常登录流程
  Given 用户在 LOGGED_OUT 状态
  When 访问需要认证的页面
  Then 状态变为 ENTERING_CREDENTIALS
  When 提交有效凭证
  Then 状态变为 AUTHENTICATED

Scenario: 三次失败后锁定
  Given 用户在 LOGGED_OUT 状态
  When 访问需要认证的页面
  And 提交无效凭证 (第 1 次)
  Then 状态保持 ENTERING_CREDENTIALS
  When 提交无效凭证 (第 2 次)
  Then 状态保持 ENTERING_CREDENTIALS
  When 提交无效凭证 (第 3 次)
  Then 状态变为 ACCOUNT_LOCKED
```

## 示例 2: 电商订单状态机

### 状态图
```
[Created] ──支付──> [Paid] ──发货──> [Shipped] ──收货──> [Delivered]
    │                  │                  │
    │取消              │退款申请          │退货申请
    ↓                  ↓                  ↓
[Cancelled]       [RefundRequested]  [ReturnRequested]
                        │                  │
                        ↓                  ↓
                   [Refunded]         [Returned]
```

### 关键测试路径
```yaml
正常流程:
  - Created → Paid → Shipped → Delivered

取消流程:
  - Created → Cancelled
  - Paid → Cancelled (如果允许)

退款流程:
  - Paid → RefundRequested → Refunded
  - Shipped → ReturnRequested → Returned → Refunded

异常流程:
  - Delivered → Shipped (无效，应拒绝)
  - Cancelled → Paid (无效，应拒绝)
```

## 示例 3: 音乐播放器状态机

### 状态和事件
```
状态: STOPPED, PLAYING, PAUSED
事件: PLAY, PAUSE, STOP, NEXT, PREV

转换表:
| 当前状态 | PLAY  | PAUSE | STOP  | NEXT/prev |
|---------|-------|-------|-------|-----------|
| STOPPED | PLAYING | -     | -     | PLAYING   |
| PLAYING | -     | PAUSED| STOPPED| PLAYING   |
| PAUSED  | PLAYING | -     | STOPPED| PLAYING   |
```

### 测试代码 (Python)
```python
class TestMusicPlayer:
    def test_play_from_stopped(self):
        player = MusicPlayer()
        assert player.state == 'STOPPED'
        player.play()
        assert player.state == 'PLAYING'
    
    def test_pause_from_playing(self):
        player = MusicPlayer()
        player.play()
        player.pause()
        assert player.state == 'PAUSED'
    
    def test_invalid_pause_from_stopped(self):
        player = MusicPlayer()
        with pytest.raises(InvalidTransitionError):
            player.pause()  # 从 STOPPED 不能直接 PAUSE
```

## 示例 4: 工作流审批系统

### 审批流程状态
```
DRAFT → SUBMITTED → UNDER_REVIEW → APPROVED/REJECTED
                              ↓
                         REVISION_REQUESTED
                              ↓
                         RESUBMITTED
```

### 测试矩阵
| 测试 ID | 路径 | 预期结果 |
|--------|------|---------|
| WF-001 | DRAFT→SUBMITTED→APPROVED | 审批通过 |
| WF-002 | DRAFT→SUBMITTED→REJECTED | 审批拒绝 |
| WF-003 | DRAFT→SUBMITTED→REVISION→RESUBMIT→APPROVED | 修改后通过 |
| WF-004 | SUBMITTED→DRAFT | 拒绝 (不可回退) |
| WF-005 | APPROVED→SUBMITTED | 拒绝 (终态) |

## 示例 5: 智能恒温器

### 复杂状态机
```
状态: OFF, HEATING, COOLING, IDLE, ECO_MODE, AWAY
触发器: 温度传感器、用户设置、时间表、地理围栏

转换规则:
- OFF → HEATING: 当前温度 < 目标温度 - 容差
- OFF → COOLING: 当前温度 > 目标温度 + 容差
- HEATING → IDLE: 当前温度 >= 目标温度
- COOLING → IDLE: 当前温度 <= 目标温度
- IDLE → HEATING/COOLING: 温度超出容差
- 任何状态 → AWAY: 地理围栏检测无人
- AWAY → IDLE: 检测到有人回家
- 任何状态 → ECO_MODE: 用户启用节能模式
```

### 边界测试
```python
def test_heating_threshold():
    thermostat = Thermostat(target=22, tolerance=0.5)
    thermostat.current_temp = 21.4  # < 21.5
    assert thermostat.state == 'HEATING'
    
    thermostat.current_temp = 21.6  # > 21.5
    assert thermostat.state == 'IDLE'

def test_rapid_oscillation_prevention():
    # 验证系统不会在 HEATING/IDLE 间快速切换
    thermostat = Thermostat()
    for i in range(100):
        thermostat.current_temp = 21.5 + (i % 3) * 0.1
        thermostat.update()
    state_changes = count_state_changes(thermostat)
    assert state_changes < 10  # 应有迟滞机制
```

---
*示例集版本 1.0 | 2026-04-10*
