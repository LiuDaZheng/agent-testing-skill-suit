# 小程序测试详细配置

## 微信小程序测试方案

### 方案 1: 官方开发者工具 CLI

**安装**:
```bash
npm install -g miniprogram-simulate
```

**测试脚本**:
```javascript
// tests/miniprogram/login.test.js
const simulate = require('miniprogram-simulate');

describe('Login Page', () => {
  let login;
  
  beforeAll(() => {
    login = simulate.load('pages/login/login');
  });
  
  beforeEach(() => {
    login = new login();
  });
  
  test('should show error for invalid phone', () => {
    login.setData({ phone: '12345' });
    login.login();
    expect(login.data.error).toBe('手机号格式错误');
  });
  
  test('should navigate after successful login', () => {
    login.setData({ 
      phone: '13800138000',
      code: '123456'
    });
    login.login();
    expect(login.data.isLoggedIn).toBe(true);
  });
});
```

**运行测试**:
```bash
# 在项目根目录运行
miniprogram-ci --project_path ./myapp --test tests/
```

---

### 方案 2: UI 自动化（云测试）

**平台对比**:

| 平台 | 优势 | 劣势 | 适用场景 |
|------|------|------|---------|
| 微信开发者工具 | 官方支持、免费 | 需要本地运行 | 开发阶段 |
| 阿里云 MQC | 真机测试、自动化 | 付费 | 发布前验证 |
| 腾讯 WeTest | 微信官方合作 | 付费 | 兼容性测试 |

**阿里云 MQC 配置**:
```yaml
# mqc_config.yaml
app_path: ./myapp.apk
test_type: ui_automation
devices:
  - ios
  - android
test_script: tests/ui/wechat_login.js
```

**腾讯 WeTest 配置**:
```yaml
# wetest_config.yaml
project_id: your_project_id
app_path: ./myapp.apk
test_cases:
  - login
  - search
  - purchase
```

---

### 微信 JS-SDK 模拟

```javascript
// tests/mocks/wx-mock.js
global.wx = {
  config: () => {},
  ready: (cb) => cb(),
  checkJsApi: (config) => {
    config.success({ checkResult: { updateTimelineShareData: true } });
  },
  updateTimelineShareData: (config) => {
    config.success && config.success();
  },
  getWXPayResult: (config) => {
    config.success && config.success({ errCode: 0 });
  }
};
```

---

### 真机测试流程

1. **准备阶段**
   - 安装微信开发者工具
   - 配置 AppID
   - 开启真机调试

2. **测试执行**
   - 扫码连接真机
   - 运行测试用例
   - 查看实时日志

3. **报告生成**
   - 截图/录屏
   - 性能数据
   - 错误日志
