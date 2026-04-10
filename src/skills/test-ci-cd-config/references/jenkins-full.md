# Jenkins Pipeline 完整配置

## 完整 Jenkinsfile

```groovy
pipeline {
    agent any
    
    environment {
        PYTHON_VERSION = '3.11'
        NODE_VERSION = '18'
        PIP_CACHE_DIR = "${WORKSPACE}/.cache/pip"
    }
    
    tools {
        python 'python-3.11'
        nodejs 'nodejs-18'
    }
    
    stages {
        // 单元测试
        stage('Unit Tests') {
            steps {
                sh '''
                    pip install -r requirements.txt
                    pytest tests/unit \\
                        --cov=src \\
                        --cov-report=xml \\
                        --cov-report=html \\
                        --junitxml=reports/unit-results.xml
                '''
            }
            post {
                always {
                    junit 'reports/unit-results.xml'
                    publishHTML(target: [
                        allowMissing: false,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'reports/coverage',
                        reportFiles: 'index.html',
                        reportName: 'Coverage Report'
                    ])
                }
            }
        }
        
        // API 测试
        stage('API Tests') {
            steps {
                sh '''
                    pip install -r requirements.txt
                    pytest tests/api \\
                        --junitxml=reports/api-results.xml \\
                        --html=reports/api-report.html
                '''
            }
            post {
                always {
                    junit 'reports/api-results.xml'
                }
            }
        }
        
        // E2E 测试
        stage('E2E Tests') {
            steps {
                sh '''
                    npm install -D @playwright/test
                    npx playwright install chromium
                    npx playwright install-deps chromium
                    npx playwright test --reporter=html,json,junit
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'reports/playwright/**/*', allowEmptyArchive: true
                }
            }
        }
        
        // 性能测试 (仅定时构建)
        stage('Performance Tests') {
            when {
                triggeredBy 'TIMER'
            }
            steps {
                sh '''
                    pip install locust
                    locust -f tests/performance/locustfile.py \\
                        --headless \\
                        -u 100 \\
                        -r 10 \\
                        --run-time 5m \\
                        --host=${PERF_TARGET_URL} \\
                        --html=reports/performance-report.html
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'reports/performance-report.html', allowEmptyArchive: true
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
```

## Jenkins 配置要求

### 必需插件
- Pipeline
- Pipeline: Stage View
- JUnit
- HTML Publisher
- Workspace Cleanup

### 工具配置
在 Manage Jenkins > Global Tool Configuration 中配置：
- Python: python-3.11
- NodeJS: nodejs-18

### 定时构建
在 Build Triggers 中配置：
- Build periodically: `H 2 * * *` (每天 2 AM)
