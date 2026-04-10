# 探索式测试示例集

## 示例 1: 社交媒体 App 探索会话

```markdown
# 会话报告：社交媒体 App

## 会话信息
- **会话 ID**: ET-SOCIAL-001
- **测试人员**: QA-Team-B
- **时间**: 90 分钟
- **版本**: v3.2.1

## 测试章程

### 章程 1: 内容发布探索
探索发布图文/视频内容
使用不同内容类型和网络条件
以发现上传和发布问题

**发现**:
- ✅ 图片发布正常
- ✅ 视频发布正常
- 🐛 多图上传时第 5 张失败 (BUG-101)
- 🐛 弱网下视频上传无进度显示 (BUG-102)

### 章程 2: 互动功能探索
探索点赞、评论、分享功能
使用快速连续操作和并发测试
以发现竞态条件

**发现**:
- ✅ 点赞功能正常
- 🐛 快速连续点赞计数错误 (BUG-103)
- 🐛 评论后列表未实时更新 (BUG-104)
- ✅ 分享功能正常

### 章程 3: 通知系统探索
探索各类通知触发和显示
使用多设备同时登录
以发现通知同步问题

**发现**:
- 🐛 已读状态不同步 (BUG-105)
- 🐛 后台推送延迟 (BUG-106)
- ✅ 通知分类正确

## 总结
- **Bug 总数**: 6
- **高优先级**: 2 (BUG-103, BUG-105)
- **覆盖区域**: 发布、互动、通知
- **未覆盖**: 私信、直播、商城

## 后续计划
1. 优先验证 BUG-103 (点赞计数)
2. 安排私信功能探索会话
3. 对 BUG-103 相关代码进行回归
```

## 示例 2: SaaS 平台探索测试

```yaml
会话配置:
  会话 ID: ET-SAAS-001
  系统：项目管理 SaaS
  时间：120 分钟
  测试人员：高级 QA

章程:
  - 章程 1:
      探索：项目创建和配置
      使用：不同项目类型和权限组合
      发现：配置错误和权限问题
      
  - 章程 2:
      探索：任务管理功能
      使用：CRUD 操作和批量操作
      发现：数据一致性问题
      
  - 章程 3:
      探索：报表和导出
      使用：大数据量和各种格式
      发现：性能和数据准确性问题
      
  - 章程 4:
      探索：团队协作
      使用：多用户并发操作
      发现：并发冲突和通知问题

启发法应用:
  - CRUD: 项目、任务、文档的增删改查
  - 边界值：0 成员项目、1000+ 任务项目
  - 并发：多人编辑同一任务
  - 时间：跨时区协作

发现汇总:
  Bug:
    - id: BUG-201
      描述：项目成员超过 50 人时加载超时
      严重度：中
      状态：已提交
      
    - id: BUG-202
      描述：任务状态更新后报表未同步
      严重度：高
      状态：已提交
      
    - id: BUG-203
      描述：导出 PDF 时特殊字符乱码
      严重度：低
      状态：已提交
      
    - id: BUG-204
      描述：并发编辑任务导致数据丢失
      严重度：高
      状态：已提交

  改进建议:
    - 增加任务编辑锁机制
    - 报表增加手动刷新按钮
    - 导出前预览功能

覆盖率:
  功能模块:
    项目管理：100%
    任务管理：100%
    报表导出：80%
    团队协作：70%
    系统集成：0% (未覆盖)
```

## 示例 3: 金融 API 探索测试

```python
"""
探索式测试：支付 API

章程：探索支付 API 的各种场景
使用：Postman + 自动化脚本
发现：安全、一致性、错误处理问题
"""

import requests
import time

class PaymentAPIExploration:
    def __init__(self, base_url, api_key):
        self.base_url = base_url
        self.headers = {'Authorization': f'Bearer {api_key}'}
        self.findings = []
    
    def explore_authentication(self):
        """探索认证机制"""
        test_cases = [
            ("无 token", {}, 401),
            ("过期 token", {'expired': True}, 401),
            ("无效 token", {'invalid': True}, 401),
            ("权限不足", {'limited_scope': True}, 403),
        ]
        
        for name, config, expected_status in test_cases:
            result = self._test_auth(config, expected_status)
            self._log(f"认证测试 - {name}", result)
    
    def explore_idempotency(self):
        """探索幂等性"""
        # 同一请求重复发送
        payment_data = {'amount': 100, 'order_id': 'TEST-001'}
        
        responses = []
        for i in range(5):
            resp = self._create_payment(payment_data)
            responses.append(resp.status_code)
        
        # 验证只有一笔成功
        success_count = responses.count(200)
        self._log("幂等性测试", {
            '重复次数': 5,
            '成功次数': success_count,
            '预期': 1,
            '通过': success_count == 1
        })
    
    def explore_boundary_conditions(self):
        """探索边界条件"""
        amounts = [
            (0, "零金额"),
            (0.01, "最小金额"),
            (999999.99, "最大金额"),
            (1000000, "超限金额"),
            (-1, "负金额"),
            ("invalid", "无效格式"),
        ]
        
        for amount, desc in amounts:
            result = self._test_payment_amount(amount)
            self._log(f"边界测试 - {desc}", result)
    
    def explore_concurrent_payments(self):
        """探索并发支付"""
        import threading
        
        order_id = 'CONCURRENT-001'
        results = []
        
        def make_payment():
            resp = self._create_payment({'amount': 100, 'order_id': order_id})
            results.append(resp.status_code)
        
        threads = [threading.Thread(target=make_payment) for _ in range(10)]
        for t in threads: t.start()
        for t in threads: t.join()
        
        self._log("并发支付测试", {
            '并发数': 10,
            '结果分布': {200: results.count(200), 409: results.count(409)}
        })
    
    def _log(self, test_name, result):
        self.findings.append({
            'test': test_name,
            'result': result,
            'timestamp': time.time()
        })
        print(f"[{test_name}] {result}")
    
    def generate_report(self):
        print(f"\n探索测试报告")
        print(f"总测试数：{len(self.findings)}")
        # ... 生成详细报告

# 执行探索
explorer = PaymentAPIExploration(BASE_URL, API_KEY)
explorer.explore_authentication()
explorer.explore_idempotency()
explorer.explore_boundary_conditions()
explorer.explore_concurrent_payments()
explorer.generate_report()
```

## 示例 4: 内容管理系统探索

```markdown
# CMS 探索式测试会话

## 章程 1: 内容发布流程
探索文章从创建到发布的完整流程
使用各种内容类型和状态转换
以发现工作流问题

**测试思路**:
- [ ] 创建草稿 → 提交审核 → 发布
- [ ] 创建草稿 → 直接发布 (管理员)
- [ ] 发布后编辑 → 重新发布
- [ ] 发布后撤回
- [ ] 定时发布
- [ ] 发布失败重试

**发现**:
- 🐛 定时发布时间与时区不匹配
- 🐛 撤回后状态未正确更新
- ✅ 审核流程正常

## 章程 2: 媒体库管理
探索图片/视频上传和管理
使用大文件和批量操作
以发现存储和性能问题

**测试思路**:
- [ ] 上传单张大图 (>10MB)
- [ ] 批量上传 100 张图片
- [ ] 上传不支持的格式
- [ ] 图片编辑 (裁剪、旋转)
- [ ] 删除正在使用的图片
- [ ] 图片 CDN 缓存刷新

**发现**:
- 🐛 批量上传超过 50 个时超时
- 🐛 删除使用中图片无警告
- ✅ 图片编辑功能正常

## 章程 3: 用户权限探索
探索不同角色的权限边界
使用权限提升和越权测试
以发现安全问题

**测试思路**:
- [ ] 编辑者尝试发布 (应审核)
- [ ] 作者尝试删除他人文章
- [ ] 普通用户访问管理页面
- [ ] API 直接调用越权接口
- [ ] 角色变更后权限立即生效

**发现**:
- 🔴 作者可通过 API 删除他人文章 (严重)
- 🐛 角色变更后需要重新登录才生效
- ✅ 管理页面访问控制正常

## 会话指标
- 时间：90 分钟
- Bug 数：5 (1 严重，3 中，1 低)
- 章程完成：3/3
- 覆盖区域：发布、媒体、权限
```

## 示例 5: 移动游戏探索测试

```markdown
# 游戏探索测试会话

## 会话信息
- **游戏**: 休闲益智游戏
- **平台**: iOS / Android
- **版本**: 2.5.0
- **时间**: 120 分钟

## 测试章程

### 章程 1: 核心玩法探索
探索游戏核心机制
使用边界操作和异常输入
以发现游戏逻辑问题

**测试活动**:
- 快速连续点击
- 游戏过程中切换应用
- 低电量模式测试
- 存储空间不足测试

**发现**:
- 🐛 快速点击导致道具重复消耗
- 🐛 切换应用后音乐停止
- 🐛 存储不足时无友好提示

### 章程 2: 内购功能探索
探索所有内购项目
使用中断和异常场景
以发现支付问题

**测试活动**:
- 购买过程中来电
- 购买时网络切换
- 退款后游戏内验证
- 重复点击购买按钮

**发现**:
- 🐛 网络切换导致重复扣款
- ✅ 退款检测正常
- 🐛 购买按钮无防重复点击

### 章程 3: 社交功能探索
探索好友和排行榜
使用并发和异常数据
以发现同步问题

**测试活动**:
- 同时添加多个好友
- 排行榜分数异常高
- 特殊字符用户名
- 离线后同步

**发现**:
- 🐛 排行榜刷新延迟
- 🐛 特殊字符用户名显示问题
- ✅ 好友添加正常

### 章程 4: 成就系统探索
探索成就解锁机制
使用边界和时序测试
以发现解锁逻辑问题

**测试活动**:
- 同时达成多个成就
- 成就解锁时退出游戏
- 修改系统时间
- 重复达成同一成就

**发现**:
- 🐛 同时达成时部分成就未解锁
- 🐛 修改时间可重复解锁成就 (严重)
- ✅ 成就通知正常

## 总结
- **总 Bug**: 10
- **严重**: 2 (重复扣款、时间作弊)
- **中**: 5
- **低**: 3
- **建议**: 优先修复支付和时间相关 bug
```

---
*示例集版本 1.0 | 2026-04-10*
