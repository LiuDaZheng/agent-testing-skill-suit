# test-runner 命令参考

## 项目检测命令
```bash
# 检测 JS 项目
ls package.json
cat package.json | grep -E "vitest|jest|playwright|cypress"

# 检测 Python 项目
ls requirements.txt pyproject.toml
cat requirements.txt | grep pytest

# 检测测试文件
find . -name "*.test.*" -o -name "test_*.py" -o -name "*.spec.*"
```

## 统一执行命令
```bash
# JS 项目
npm run test
npx vitest run
npx jest
npx playwright test
npx cypress run

# Python 项目
pytest
python -m pytest
python -m unittest discover

# 带覆盖率
npm run test -- --coverage
pytest --cov=src
npx playwright test --coverage
```

## CI/CD 集成
```bash
# 设置 CI 环境
export CI=true
export NODE_ENV=test

# 运行测试
npm run test:ci
pytest --junitxml=report.xml

# 生成报告
npx playwright test --reporter=github
```

## 参考资料
- Vitest CLI: https://vitest.dev/guide/cli.html
- Jest CLI: https://jestjs.io/docs/cli
- pytest CLI: https://docs.pytest.org/en/stable/how-to/usage.html
- Playwright CLI: https://playwright.dev/docs/test-cli
