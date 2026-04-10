# GitLab CI 完整配置

## 完整 .gitlab-ci.yml

```yaml
stages:
  - test
  - report

variables:
  PYTHON_VERSION: "3.11"
  NODE_VERSION: "18"
  PIP_CACHE_DIR: "$CI_PROJECT_DIR/.cache/pip"

cache:
  paths:
    - .cache/pip
    - node_modules

# 单元测试
unit-tests:
  stage: test
  image: python:${PYTHON_VERSION}-slim
  script:
    - pip install -r requirements.txt
    - pytest tests/unit \
        --cov=src \
        --cov-report=xml \
        --cov-report=html \
        --junitxml=reports/unit-results.xml
  artifacts:
    when: always
    reports:
      junit: reports/unit-results.xml
    paths:
      - reports/
      - coverage/
    expire_in: 30 days
  coverage: '/TOTAL.*\s+(\d+%)/'

# API 测试
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
    - pytest tests/api \
        --junitxml=reports/api-results.xml \
        --html=reports/api-report.html
  artifacts:
    when: always
    reports:
      junit: reports/api-results.xml
    paths:
      - reports/

# E2E 测试
e2e-tests:
  stage: test
  image: node:${NODE_VERSION}-slim
  script:
    - npm install -D @playwright/test
    - npx playwright install chromium
    - npx playwright install-deps chromium
    - npx playwright test --reporter=html,json,junit
  artifacts:
    when: always
    paths:
      - reports/playwright/
    expire_in: 30 days

# 性能测试 (仅定时任务)
performance-tests:
  stage: test
  image: python:${PYTHON_VERSION}-slim
  rules:
    - if: $CI_PIPELINE_SOURCE == "schedule"
  script:
    - pip install locust
    - locust -f tests/performance/locustfile.py \
        --headless \
        -u 100 \
        -r 10 \
        --run-time 5m \
        --host=$PERF_TARGET_URL \
        --html=reports/performance-report.html
  artifacts:
    paths:
      - reports/

# 生成报告索引
report-index:
  stage: report
  image: alpine:latest
  script:
    - echo "生成报告索引完成"
  artifacts:
    paths:
      - reports/index.html
  dependencies:
    - unit-tests
    - api-tests
    - e2e-tests
```

## 环境变量配置

在 GitLab CI/CD > Variables 中配置：

```
PERF_TARGET_URL=https://api.example.com
```

## 定时触发器

在 GitLab CI/CD > Schedules 中配置：
- Cron: `0 2 * * *` (每天 2 AM)
- Target branch: main
