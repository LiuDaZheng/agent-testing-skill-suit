---
name: test-ci-cd-config
description: CI/CD 测试流水线配置 - GitHub Actions/GitLab CI/Jenkins
metadata:
  {"openclaw":{"requires":{"bins":["wc"]},"os":["darwin","linux"]}}
---

# CI/CD 测试流水线配置 Skill

## 角色定位
你是一名 CI/CD 专家，专注于**测试流水线配置生成**，提供 GitHub Actions、GitLab CI 和 Jenkins 的完整配置。

## 核心职责
1. 生成 GitHub Actions 工作流配置
2. 生成 GitLab CI 配置
3. 生成 Jenkins Pipeline 配置
4. 配置报告上传和环境管理

---

## GitHub Actions 配置

### .github/workflows/test.yml 配置模板

```yaml
name: Test Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 2 * * *'

env:
  PYTHON_VERSION: '3.11'
  NODE_VERSION: '18'

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}
          cache: 'pip'
      - name: Install dependencies
        run: pip install -r requirements.txt
      - name: Run unit tests
        run: |
          pytest tests/unit \
            --cov=src \
            --cov-report=xml \
            --junitxml=reports/unit-results.xml
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage.xml
      - name: Upload test results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: unit-test-results
          path: reports/

  api-tests:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_DB: testdb
          POSTGRES_USER: user
          POSTGRES_PASSWORD: pass
        ports:
          - 5432:5432
    steps:
      - uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}
      - name: Install dependencies
        run: pip install -r requirements.txt
      - name: Run API tests
        run: |
          pytest tests/api \
            --junitxml=reports/api-results.xml \
            --html=reports/api-report.html
      - name: Upload results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: api-test-results
          path: reports/

  e2e-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
      - name: Install Playwright
        run: |
          npm install -D @playwright/test
          npx playwright install chromium
          npx playwright install-deps chromium
      - name: Run E2E tests
        run: npx playwright test --reporter=html,json
      - name: Upload Playwright report
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: playwright-report
          path: playwright-report/

  performance-tests:
    if: github.event_name == 'schedule'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}
      - name: Install Locust
        run: pip install locust
      - name: Run performance tests
        run: |
          locust -f tests/performance/locustfile.py \
            --headless -u 100 -r 10 --run-time 5m \
            --host=${{ secrets.PERF_TARGET_URL }}
```

---

## GitLab CI 配置 (精简版)

### .gitlab-ci.yml 配置模板

```yaml
stages:
  - test
  - report

variables:
  PYTHON_VERSION: "3.11"
  PIP_CACHE_DIR: "$CI_PROJECT_DIR/.cache/pip"

cache:
  paths:
    - .cache/pip
    - node_modules

unit-tests:
  stage: test
  image: python:${PYTHON_VERSION}-slim
  script:
    - pip install -r requirements.txt
    - pytest tests/unit --cov=src --junitxml=reports/unit-results.xml
  artifacts:
    when: always
    reports:
      junit: reports/unit-results.xml
    paths:
      - reports/
      - coverage/

api-tests:
  stage: test
  image: python:${PYTHON_VERSION}-slim
  services:
    - name: postgres:15
      alias: db
  variables:
    POSTGRES_DB: testdb
    POSTGRES_USER: user
    POSTGRES_PASSWORD: pass
  script:
    - pip install -r requirements.txt
    - pytest tests/api --junitxml=reports/api-results.xml

e2e-tests:
  stage: test
  image: node:18-slim
  script:
    - npm install -D @playwright/test
    - npx playwright install chromium
    - npx playwright install-deps chromium
    - npx playwright test --reporter=html
  artifacts:
    paths:
      - playwright-report/
```

**完整配置**: 详见 `references/gitlab-ci-full.md`

---

## Jenkins Pipeline 配置 (精简版)

### Jenkinsfile 配置模板

```groovy
pipeline {
    agent any
    
    environment {
        PYTHON_VERSION = '3.11'
        PIP_CACHE_DIR = "${WORKSPACE}/.cache/pip"
    }
    
    tools {
        python 'python-3.11'
        nodejs 'nodejs-18'
    }
    
    stages {
        stage('Unit Tests') {
            steps {
                sh '''
                    pip install -r requirements.txt
                    pytest tests/unit --cov=src --junitxml=reports/unit-results.xml
                '''
            }
            post {
                always {
                    junit 'reports/unit-results.xml'
                }
            }
        }
        
        stage('API Tests') {
            steps {
                sh '''
                    pip install -r requirements.txt
                    pytest tests/api --junitxml=reports/api-results.xml
                '''
            }
            post {
                always {
                    junit 'reports/api-results.xml'
                }
            }
        }
        
        stage('E2E Tests') {
            steps {
                sh '''
                    npm install -D @playwright/test
                    npx playwright install chromium
                    npx playwright install-deps chromium
                    npx playwright test --reporter=html
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'playwright-report/**/*'
                }
            }
        }
    }
}
```

**完整配置**: 详见 `references/jenkins-full.md`

---

## 使用示例

### 示例 1: 配置 GitHub Actions 流水线

**用户输入**：
```
配置 GitHub Actions 流水线，需要运行单元测试、API 测试和 E2E 测试
```

**Skill 输出**：
```markdown
## GitHub Actions 配置已生成

### .github/workflows/test.yml
[已提供完整配置，包含 4 个 job]

### 功能说明
- ✅ 单元测试：带覆盖率报告 (Codecov)
- ✅ API 测试：带 PostgreSQL 服务
- ✅ E2E 测试：Playwright 浏览器
- ✅ 性能测试：定时任务触发

### 使用方法
1. 创建 .github/workflows/test.yml
2. 提交代码到 main 或 develop 分支
3. 自动触发流水线
4. 查看 Actions 标签页的结果
```

---

### 示例 2: 配置 GitLab CI

**用户输入**：
```
为 GitLab 项目配置 CI 流水线
```

**Skill 输出**：
```markdown
## GitLab CI 配置已生成

### .gitlab-ci.yml
[已提供精简配置]

### 功能说明
- ✅ 单元测试：带覆盖率报告
- ✅ API 测试：带 PostgreSQL 服务
- ✅ E2E 测试：Playwright

### 使用方法
1. 创建 .gitlab-ci.yml
2. 推送到 GitLab 自动触发
3. 查看 CI/CD > Pipelines
```

---

### 示例 3: 配置 Jenkins Pipeline

**用户输入**：
```
配置 Jenkins Pipeline 运行测试
```

**Skill 输出**：
```markdown
## Jenkins Pipeline 配置已生成

### Jenkinsfile
[已提供精简配置]

### 功能说明
- ✅ 单元测试：JUnit 报告
- ✅ API 测试：JUnit 报告
- ✅ E2E 测试：Playwright 报告归档

### 使用方法
1. 创建 Jenkins Pipeline 项目
2. 选择 Pipeline script from SCM
3. 配置 Git 仓库
4. 运行构建
```

---

## 与上下游 Skill 的接口

### 上游输入
- 来自 test-framework-config: pytest/Playwright 配置
- 来自 test-plan: 测试策略

### 下游输出
- 供 test-runner 使用：CI/CD 执行环境
- 供 test-report 使用：报告位置

---

## 验收检查清单

- [ ] GitHub Actions 配置完整可用
- [ ] GitLab CI 配置完整可用
- [ ] Jenkins Pipeline 配置完整可用
- [ ] 报告上传配置正确
- [ ] 缓存配置优化
- [ ] 使用示例清晰

---

*版本：1.0 | 基于 CI/CD 最佳实践 | 位置：~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/src/skills/test-ci-cd-config/*
