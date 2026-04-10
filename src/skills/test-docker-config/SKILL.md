---
name: test-docker-config
description: Docker 测试环境配置 - Dockerfile/docker-compose/容器化测试
metadata:
  {"openclaw":{"requires":{"bins":[        "wc"]},        "os":["darwin","linux"        ]}}
---

# Docker 测试环境配置 Skill

## 角色定位
你是一名容器化专家，专注于**Docker 测试环境配置**，提供 Dockerfile、docker-compose 和容器化测试脚本。

## 核心职责
1. 生成 Dockerfile 配置
2. 生成 docker-compose 配置
3. 生成容器化测试运行脚本
4. 环境检查与验证

---

## Dockerfile 配置

### 测试环境 Dockerfile 模板

```dockerfile
# 多阶段构建 - 测试环境
FROM python:3.11-slim as test-env

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 安装 Python 依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 安装 Playwright 浏览器
RUN playwright install chromium
RUN playwright install-deps chromium

# 复制测试代码
COPY . .

# 设置环境变量
ENV PYTHONPATH=/app
ENV PYTEST_ADDOPTS="-v --tb=short"

# 默认命令
CMD [        "pytest",         "tests/"        ]
```

---

## docker-compose 配置

### docker-compose.yml 配置模板

```yaml
version: '3.8'

services:
  # 测试服务
  test:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - .:/app
      - ./reports:/app/reports
    environment:
      - API_BASE_URL=http://api:8000
      - BROWSER=chromium
      - CI=${CI:-false}
    depends_on:
      - api
      - db
    networks:
      - test-network

  # API 服务 (被测系统)
  api:
    image: myapp/api:latest
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/testdb
    networks:
      - test-network

  # 数据库服务
  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=testdb
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - test-network

  # 报告服务 (可选)
  report-server:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./reports:/usr/share/nginx/html
    depends_on:
      - test
    networks:
      - test-network

volumes:
  postgres_data:

networks:
  test-network:
    driver: bridge
```

---

## 测试运行脚本

### scripts/docker-run.sh 配置模板

```bash
#!/bin/bash
# Docker 测试运行脚本

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 启动测试环境...${NC}"

# 构建并启动服务
docker-compose up -d --build

# 等待服务就绪
echo -e "${YELLOW}⏳ 等待服务启动...${NC}"
sleep 10

# 运行测试
echo -e "${GREEN}🧪 执行测试...${NC}"
docker-compose exec -T test pytest tests/ \
    --cov=src \
    --cov-report=html:/app/reports/coverage \
    --html=/app/reports/test-report.html \
    --self-contained-html

# 查看测试结果
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✅ 测试通过!${NC}"
else
    echo -e "${RED}❌ 测试失败!${NC}"
fi

# 生成报告摘要
echo -e "${YELLOW}📊 报告位置:${NC}"
echo "  - HTML 报告：reports/test-report.html"
echo "  - 覆盖率：reports/coverage/index.html"
echo "  - Playwright: reports/playwright/index.html"

# 停止服务
echo -e "${YELLOW}🛑 停止测试环境...${NC}"
docker-compose down

exit $EXIT_CODE
```

---

## 使用示例

### 示例 1: 配置 Docker 测试环境

**用户输入**：
```
帮我配置 Docker 环境运行测试，需要包含 API 服务和数据库
```

**Skill 输出**：
```markdown
## Docker 配置已生成

### 1. Dockerfile
[已提供完整配置，包含 Python/Playwright]

### 2. docker-compose.yml
[已提供完整配置，包含 test/api/db 服务]

### 3. 运行脚本
[已提供 docker-run.sh 脚本]

### 使用方法
```bash
# 运行测试
./scripts/docker-run.sh

# 查看报告
open reports/test-report.html
open reports/coverage/index.html
```
```

---

### 示例 2: 仅运行容器化测试

**用户输入**：
```
如何在 Docker 中运行 pytest 测试？
```

**Skill 输出**：
```markdown
## Docker 测试运行方案

### 方案 1: 使用 docker-compose

```bash
# 构建并运行
docker-compose up --build test

# 交互式运行
docker-compose run --rm test pytest tests/ -v
```

### 方案 2: 直接运行 Docker

```bash
# 构建镜像
docker build -t test-env .

# 运行测试
docker run --rm \
  -v $(pwd):/app \
  -e API_BASE_URL=http://host.docker.internal:8000 \
  test-env pytest tests/ -v
```

### 查看报告
```bash
# 报告挂载到本地
open reports/test-report.html
```
```

---

### 示例 3: 多环境测试配置

**用户输入**：
```
需要配置多环境测试 (dev/staging/prod)
```

**Skill 输出**：
```markdown
## 多环境 Docker 配置

### docker-compose.yml
```yaml
version: '3.8'

services:
  test:
    build: .
    environment:
      - ENV=${ENV:-dev}
      - API_BASE_URL=${API_BASE_URL}
    volumes:
      - ./reports:/app/reports

# dev 环境
# docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# staging 环境
# docker-compose -f docker-compose.yml -f docker-compose.staging.yml up
```

### 使用方法
```bash
# 开发环境
ENV=dev API_BASE_URL=http://localhost:8000 docker-compose up

# Staging 环境
ENV=staging API_BASE_URL=https://staging.example.com docker-compose up

# 生产环境 (只读测试)
ENV=prod API_BASE_URL=https://api.example.com docker-compose run --rm test pytest tests/smoke/
```
```

---

## 环境检查清单

```markdown
## Docker 环境检查

### Docker 安装
- [ ] Docker 已安装
- [ ] Docker Compose 已安装
- [ ] Docker 守护进程运行中

### 配置检查
- [ ] Dockerfile 存在
- [ ] docker-compose.yml 存在
- [ ] 运行脚本可执行

### 网络检查
- [ ] 服务间网络连通
- [ ] 端口映射正确
- [ ] 环境变量配置正确

### 资源检查
- [ ] 磁盘空间充足
- [ ] 内存充足
- [ ] CPU 资源充足
```

---

## 与上下游 Skill 的接口

### 上游输入
- 来自 test-framework-config: pytest/Playwright 配置
- 来自 test-ci-cd-config: CI/CD 集成需求

### 下游输出
- 供 test-runner 使用：容器化执行环境
- 供 test-report 使用：报告挂载位置

---

## 验收检查清单

- [ ] Dockerfile 配置完整
- [ ] docker-compose 配置完整
- [ ] 运行脚本可执行
- [ ] 多环境支持
- [ ] 环境检查清单完整
- [ ] 使用示例清晰

---

*版本：1.0 | 基于容器化测试最佳实践 | 位置：~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/src/skills/test-docker-config/*

