# Skill 自动迁移方案

## 问题

Sub-Agent 会继续创建 Skill 到 `~/.openclaw/workspace-main/skills/`

## 解决方案

### 方案 1: 自动化脚本（推荐）⭐

创建后台监控脚本，自动检测并迁移：

```bash
# 启动监控（后台运行）
nohup bash ~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/scripts/skill-migration-watch.sh &
```

**优点**:
- ✅ 全自动，无需人工干预
- ✅ 实时迁移（5 秒延迟）
- ✅ 有日志记录
- ✅ 不影响 Sub-Agent 执行

**缺点**:
- ⚠️ 需要运行后台进程

---

### 方案 2: 定期清理（简单）

每 10 分钟执行一次清理：

```bash
# 添加到 crontab
crontab -e

# 添加以下行（每 10 分钟执行）
*/10 * * * * rsync -av ~/.openclaw/workspace-main/skills/ ~/.openclaw/skills/ && rm -rf ~/.openclaw/workspace-main/skills/*
```

**优点**:
- ✅ 简单可靠
- ✅ 系统级自动化

**缺点**:
- ⚠️ 最多 10 分钟延迟
- ⚠️ 需要配置 cron

---

### 方案 3: 修改默认配置（根本解决）

检查 OpenClaw 配置，修改默认 Skill 安装路径：

```bash
# 检查配置
cat ~/.openclaw/openclaw.json | grep -A 5 '"skills"'
```

如果找到 `skills.install.defaultPath` 或类似配置，修改为：
```json
{
  "skills": {
    "install": {
      "defaultPath": "~/.openclaw/skills/"
    }
  }
}
```

**优点**:
- ✅ 根本解决问题
- ✅ 无需额外脚本

**缺点**:
- ⚠️ 可能没有这个配置项
- ⚠️ 可能影响其他功能

---

### 方案 4: 符号链接（变通方案）

将 workspace-main/skills 链接到 ~/.openclaw/skills：

```bash
# 1. 清空 workspace-main/skills
rm -rf ~/.openclaw/workspace-main/skills/*

# 2. 创建符号链接（不推荐，可能导致循环引用）
# ln -s ~/.openclaw/skills ~/.openclaw/workspace-main/skills
```

**优点**:
- ✅ 透明重定向

**缺点**:
- ❌ 可能导致循环引用
- ❌ 可能影响其他功能
- ❌ 不推荐

---

## 推荐方案

**立即执行**: 方案 1（自动化脚本）+ 方案 3（检查配置）

**长期方案**: 方案 3（修改默认配置）

---

## 立即行动

### 1. 启动监控脚本

```bash
chmod +x ~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/scripts/skill-migration-watch.sh
nohup bash ~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/scripts/skill-migration-watch.sh > /tmp/skill-migration.log 2>&1 &
echo "监控脚本已启动，PID: $!"
```

### 2. 检查 OpenClaw 配置

```bash
cat ~/.openclaw/openclaw.json | jq '.skills'
```

### 3. 设置定期清理（备选）

```bash
(crontab -l 2>/dev/null; echo "*/5 * * * * rsync -av ~/.openclaw/workspace-main/skills/ ~/.openclaw/skills/ --delete && rm -rf ~/.openclaw/workspace-main/skills/*") | crontab -
```

---

## 监控日志

日志位置：`~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/migration-log.md`

格式：
```markdown
# Skill 迁移日志

- 2026-04-10 02:40:00 迁移：test-boundary
- 2026-04-10 02:41:00 迁移：test-equivalence
```

---

*创建时间：2026-04-10 02:40*
