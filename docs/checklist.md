# 验收标准检查清单

## 通用验收标准

### 文档规范
- [ ] SKILL.md 包含 YAML frontmatter
- [ ] name 字段符合 kebab-case 规范
- [ ] description < 100 字符
- [ ] metadata.openclaw.version 已设置
- [ ] 包含完整的指令部分

### 内容质量
- [ ] 行数 < 500
- [ ] Token < 4000
- [ ] 至少 5 个使用示例
- [ ] 示例可执行（命令真实有效）
- [ ] 引用来源清晰标注

### 项目结构
- [ ] SKILL.md 存在
- [ ] references/ 目录存在
- [ ] references/ 包含命令参考
- [ ] 位置在 `src/skills/<skill-name>/`

## 各 Skill 专项检查

### test-runner
- [ ] 能识别 JS/Python/E2E 项目类型
- [ ] 执行命令符合官方文档
- [ ] 支持常用参数（覆盖率、过滤）
- [ ] 错误提示清晰
- [ ] 与其他 Skill 关联正确

### test-js
- [ ] 支持 Vitest/Jest/Playwright
- [ ] 安装命令正确
- [ ] 执行命令正确
- [ ] 配置模板可用
- [ ] 断言参考完整

### test-python
- [ ] 支持 pytest/unittest
- [ ] 安装命令正确
- [ ] 执行命令正确
- [ ] fixtures 示例清晰
- [ ] 参数化测试示例正确

### test-e2e
- [ ] 支持 Playwright/Cypress
- [ ] 浏览器安装命令正确
- [ ] 选择器参考完整
- [ ] 配置模板可用
- [ ] 调试命令正确

### test-api
- [ ] 支持 REST/GraphQL
- [ ] curl/httpie 命令正确
- [ ] pytest+requests 示例正确
- [ ] 认证处理示例完整
- [ ] 响应验证示例正确

## 安全检查 (agent-safety)
- [ ] 无硬编码 API 密钥
- [ ] 无敏感信息泄露
- [ ] 命令无安全风险
- [ ] 文件权限正确

## 审计检查 (agent-audit)
- [ ] 认知负载合理
- [ ] 无冗余内容
- [ ] 结构清晰
- [ ] 维护成本可控

## 位置确认
- [ ] 位于 `~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/src/skills/`
- [ ] 未部署到 `~/.openclaw/skills/`
- [ ] 目录结构正确

---

## 验收记录

| 检查项 | 日期 | 结果 | 备注 |
|-------|------|------|------|
| 文档规范 | 2026-04-10 | ✅ | 所有 Skill 符合规范 |
| 内容质量 | 2026-04-10 | ✅ | 行数均 < 500 |
| 项目结构 | 2026-04-10 | ✅ | 结构完整 |
| agent-safety | 待执行 | ⏳ | |
| agent-audit | 待执行 | ⏳ | |

---

*最后更新：2026-04-10*
