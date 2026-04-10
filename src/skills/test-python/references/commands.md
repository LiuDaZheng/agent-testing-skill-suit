# test-python 命令参考

## pytest 命令
```bash
# 基础命令
pytest                        # 运行所有测试
pytest -v                     # 详细输出
pytest -x                     # 首次失败后停止
pytest --tb=long              # 完整堆栈

# 过滤
pytest -k "keyword"           # 按关键词过滤
pytest -m "marker"            # 按标记过滤
pytest test_file.py           # 单个文件
pytest test_file.py::test_fn  # 单个测试

# 覆盖率
pytest --cov=src              # 覆盖率
pytest --cov-report=html      # HTML 报告
pytest --cov-report=term-missing  # 终端报告

# 其他
pytest --lf                   # 上次失败的测试
pytest --ff                   # 先失败后其他
pytest --fixtures             # 查看 fixtures
pytest --markers              # 查看 markers
pytest --collect-only         # 只收集不执行
```

## unittest 命令
```bash
python -m unittest discover           # 发现并运行
python -m unittest test_module        # 单个模块
python -m unittest Module.Class       # 单个类
python -m unittest Module.Class.method # 单个方法
python -m unittest -v                 # 详细输出
```

## 安装命令
```bash
pip install pytest
pip install pytest-cov
pip install pytest-xdist        # 并行执行
pip install pytest-mock         # Mock 支持
```

## 配置模板

### pytest.ini
```ini
[pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = -v --tb=short
markers =
    slow: marks tests as slow
    integration: marks integration tests
```

### conftest.py
```python
import pytest

@pytest.fixture
def sample_data():
    return {"name": "test", "value": 42}

@pytest.fixture(scope="session")
def db_url():
    return "sqlite:///test.db"
```

## 官方文档
- pytest: https://docs.pytest.org/
- unittest: https://docs.python.org/3/library/unittest.html
