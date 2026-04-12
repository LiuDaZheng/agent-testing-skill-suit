# 代码迁移指南 - renew-v2

## ✅ 当前状态

- ✅ `renew-v2` 分支已创建
- ✅ CI/CD 配置已作为**第一个提交**
- ✅ 分支已推送到 GitHub

## 🎯 下一步：设置分支保护

### 在 GitHub 上操作（必须！）

1. 访问：https://github.com/LiuDaZheng/agent-testing-skill-suit/settings/branches
2. 点击 "Add branch protection rule"
3. Branch name pattern: `renew-v2`
4. 勾选以下选项：
   - ✅ **Require a pull request before merging**
   - ✅ **Require status checks to pass before merging**
   - ✅ **Status checks**: 选择 "CI/CD Pipeline"
   - ✅ **Require branches to be up to date before merging**
   - ✅ **Include administrators**

对 drupal-knowledge-base 重复以上步骤。

---

## 📋 迁移现有代码的步骤

### 阶段 1：准备（当前）

```bash
# 确保在 renew-v2 分支
git checkout renew-v2

# 验证 CI/CD 配置
ls -la .github/workflows/ci-cd.yml
```

### 阶段 2：创建第一个功能分支

```bash
# 创建功能分支
git checkout -b feature/migrate-batch-1 renew-v2

# 创建基础目录结构
mkdir -p src/skills docs

# 添加最基础的 Skill（1-2 个）
# 从旧分支复制
git show renew:src/skills/test-plan/SKILL.md > src/skills/test-plan/SKILL.md
git show renew:src/skills/test-design/SKILL.md > src/skills/test-design/SKILL.md

# 添加 README
git show renew:README.md > README.md

# 检查文件
ls -la src/skills/
wc -l src/skills/*/SKILL.md
```

### 阶段 3：提交并测试

```bash
# 提交
git add .
git commit -m "feat: 迁移基础 Skill

- test-plan
- test-design
- README

这是第一批迁移的代码。"

# 推送
git push origin feature/migrate-batch-1
```

### 阶段 4：创建 Pull Request

1. 访问：https://github.com/LiuDaZheng/agent-testing-skill-suit/pull/new/feature/migrate-batch-1
2. 填写 PR 描述
3. 创建 PR
4. **等待 CI/CD 运行**
5. 查看检查结果

### 阶段 5：处理 CI/CD 结果

#### 如果通过 ✅
- 合并 PR 到 `renew-v2`
- 继续下一批

#### 如果失败 ❌
```bash
# 1. 查看失败原因
# GitHub Actions 中查看日志

# 2. 修复问题
# 在本地修改文件

# 3. 提交修复
git add .
git commit -m "fix: 修复 CI/CD 问题"
git push origin feature/migrate-batch-1

# 4. CI/CD 会自动重新运行
```

### 阶段 6：重复迁移

```bash
# 更新主分支
git checkout renew-v2
git pull origin renew-v2

# 创建下一批
git checkout -b feature/migrate-batch-2 renew-v2

# 添加更多 Skill（3-5 个）
# ...

# 重复阶段 3-5
```

---

## 📊 迁移批次规划

### Agent-Testing-Skill-Suit

| 批次 | 内容 | 文件数 | 优先级 |
|------|------|--------|--------|
| 1 | README + test-plan + test-design | 3 | P0 |
| 2 | test-usecase + test-decision + test-state | 3 | P0 |
| 3 | test-exploratory + test-boundary + test-equivalence | 3 | P1 |
| 4 | test-api + test-e2e + test-integration | 3 | P1 |
| 5 | 其余 Skill | 剩余 | P2 |
| 6 | 文档和配置 | 剩余 | P2 |

### drupal-knowledge-base

| 批次 | 内容 | 文件数 | 优先级 |
|------|------|--------|--------|
| 1 | README + 基础文档 | 2 | P0 |
| 2 | Drupal 基础文档 | 3-5 | P0 |
| 3 | 开发指南 | 3-5 | P1 |
| 4 | 站点构建文档 | 3-5 | P1 |
| 5 | 部署和高级主题 | 剩余 | P2 |

---

## ⚠️ 常见问题

### Q1: CI/CD 失败怎么办？
**A:** 查看 GitHub Actions 日志，根据错误信息修复。常见问题：
- YAML 格式错误 → 运行 `yamllint file.yml`
- Markdown 格式问题 → 运行 `markdownlint file.md`
- 文件太大 → 拆分成更小的文件

### Q2: 如何快速验证本地文件？
**A:** 
```bash
# 安装验证工具
npm install -g yamllint markdownlint-cli

# 本地验证
yamllint .github/workflows/ci-cd.yml
markdownlint README.md
```

### Q3: 可以跳过 CI/CD 吗？
**A:** 不可以！设置分支保护后，所有人都必须通过 CI/CD。

### Q4: 一批迁移多少文件合适？
**A:** 建议 3-5 个文件/批，便于：
- 快速定位问题
- 减少 CI/CD 运行时间
- 易于回滚

---

## 🔍 验证清单

每批迁移前检查：
- [ ] 文件大小 < 500 行（SKILL.md）
- [ ] YAML 格式正确
- [ ] Markdown 格式正确
- [ ] 没有硬编码密钥
- [ ] 内部链接正确

每批迁移后检查：
- [ ] CI/CD 全部通过
- [ ] 文件结构清晰
- [ ] 文档完整
- [ ] 可以合并到主分支

---

## 📚 参考资源

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [分支保护规则](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule)
- [Pull Request 最佳实践](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests)

---

*创建时间：2026-04-12*
*分支：renew-v2*
*状态：准备迁移*
