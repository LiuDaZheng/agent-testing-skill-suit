---
name: test-python
description: Python 测试执行器（pytest, unittest）
metadata:
  openclaw:
    version: "1.0"
  author: Gates
  created: 2026-04-10
  license: MIT
---

# test-python - Python 测试执行器

## 角色定位
你是 Python 测试专家，专注于 pytest 和 unittest 框架。你提供测试编写、执行、调试和最佳实践指导。

## 支持的框架

### pytest (推荐)
**安装**: `pip install pytest` 或 `pip install -r requirements.txt`

**核心命令**:
```bash
pytest                        # 运行所有测试
pytest -v                     # 详细输出
pytest -x                     # 首次失败后停止
pytest --tb=long              # 完整堆栈跟踪
pytest --cov=src              # 覆盖率报告
pytest -k "关键词"            # 过滤测试
pytest --lf                   # 运行上次失败的测试
pytest --ff                   # 先运行失败的，再运行其他
pytest --markers              # 查看所有标记
pytest -m "mark_name"         # 按标记运行
pytest --fixtures             # 查看所有 fixtures
pytest --collect-only         # 只收集测试，不执行
```

**测试文件示例**:
```python
# test_sample.py
def func(x):
    return x + 1

def test_answer():
    assert func(3) == 4

def test_greater():
    assert func(4) > 4
```

### unittest (标准库)
**安装**: 内置，无需安装

**核心命令**:
```bash
python -m unittest discover           # 发现并运行所有测试
python -m unittest test_module        # 运行单个模块
python -m unittest test_module.TestClass  # 运行单个类
python -m unittest test_module.TestClass.test_method  # 运行单个方法
python -m unittest -v                 # 详细输出
```

**测试文件示例**:
```python
# test_sample.py
import unittest

def func(x):
    return x + 1

class TestFunc(unittest.TestCase):
    def test_answer(self):
        self.assertEqual(func(3), 4)

    def test_greater(self):
        self.assertGreater(func(4), 4)

if __name__ == '__main__':
    unittest.main()
```

## 使用示例

### 示例 1: pytest 基础测试
```bash
# 安装 pytest
pip install pytest

# 创建测试文件
cat > test_calculator.py << 'EOF'
def add(a, b):
    return a + b

def test_add_positive():
    assert add(1, 2) == 3

def test_add_negative():
    assert add(-1, -1) == -2

def test_add_mixed():
    assert add(-1, 1) == 0
EOF

# 运行测试
pytest test_calculator.py -v

# 预期输出
# test_calculator.py::test_add_positive PASSED
# test_calculator.py::test_add_negative PASSED
# test_calculator.py::test_add_mixed PASSED
```

### 示例 2: pytest fixtures
```bash
cat > test_database.py << 'EOF'
import pytest

@pytest.fixture
def db_connection():
    # 设置
    db = {"connected": True, "data": []}
    yield db
    # 清理
    db["connected"] = False

def test_query(db_connection):
    assert db_connection["connected"] is True
    db_connection["data"].append("item")
    assert len(db_connection["data"]) == 1
EOF

# 运行
pytest test_database.py -v
```

### 示例 3: pytest 参数化测试
```bash
cat > test_math.py << 'EOF'
import pytest

@pytest.mark.parametrize("a,b,expected", [
    (1, 2, 3),
    (5, 5, 10),
    (-1, 1, 0),
    (0, 0, 0),
])
def test_add(a, b, expected):
    assert a + b == expected
EOF

# 运行（会执行 4 次）
pytest test_math.py -v
```

### 示例 4: pytest 覆盖率
```bash
# 安装覆盖率插件
pip install pytest-cov

# 运行带覆盖率
pytest --cov=src --cov-report=html

# 查看 HTML 报告
open htmlcov/index.html

# 文本报告
pytest --cov=src --cov-report=term-missing
```

### 示例 5: unittest 测试类
```bash
cat > test_unittest.py << 'EOF'
import unittest

def multiply(a, b):
    return a * b

class TestMultiply(unittest.TestCase):
    def test_multiply_positive(self):
        self.assertEqual(multiply(2, 3), 6)

    def test_multiply_negative(self):
        self.assertEqual(multiply(-2, -3), 6)

    def test_multiply_zero(self):
        self.assertEqual(multiply(5, 0), 0)

    def setUp(self):
        print("Setting up test")

    def tearDown(self):
        print("Tearing down test")

if __name__ == '__main__':
    unittest.main()
EOF

# 运行
python -m unittest test_unittest.py -v
```

### 示例 6: pytest 标记和跳过
```bash
cat > test_marked.py << 'EOF'
import pytest

@pytest.mark.slow
def test_slow_operation():
    import time
    time.sleep(2)
    assert True

@pytest.mark.skip(reason="Not implemented yet")
def test_future_feature():
    assert False

@pytest.mark.xfail(reason="Known issue")
def test_expected_failure():
    assert False
EOF

# 跳过慢测试
pytest -v -m "not slow"

# 只运行慢测试
pytest -v -m slow
```

## 常用断言

### pytest/unittest 断言
```python
# 相等性
assert a == b
self.assertEqual(a, b)

# 真值
assert value
self.assertTrue(value)
assert not value
self.assertFalse(value)

# 包含
assert item in container
self.assertIn(item, container)

# 异常
with pytest.raises(ValueError):
    raise ValueError("error")
self.assertRaises(ValueError, func, arg)

# 近似值
assert value == pytest.approx(0.1, rel=1e-6)
self.assertAlmostEqual(a, b, places=7)
```

### pytest 高级断言
```python
# 警告
with pytest.warns(DeprecationWarning):
    old_function()

# 日志
with pytest.raises(Exception) as exc_info:
    raise ValueError("test")
assert "test" in str(exc_info.value)

# 输出捕获
def test_output(capsys):
    print("hello")
    captured = capsys.readouterr()
    assert captured.out == "hello\n"
```

## 配置模板

### pytest.ini
```ini
[pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = -v --tb=short --strict-markers
markers =
    slow: marks tests as slow
    integration: marks integration tests
    e2e: marks end-to-end tests
filterwarnings =
    ignore::DeprecationWarning
```

### pyproject.toml (pytest 配置)
```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = "-v --tb=short"
markers = [
    "slow: marks tests as slow",
    "integration: marks integration tests",
]
```

### conftest.py (共享 fixtures)
```python
# conftest.py
import pytest

@pytest.fixture(scope="session")
def db_url():
    return "sqlite:///test.db"

@pytest.fixture
def sample_data():
    return {"name": "test", "value": 42}
```

## 项目结构
```
project/
├── src/
│   └── myapp/
│       ├── __init__.py
│       └── module.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   ├── test_module.py
│   └── integration/
│       └── test_api.py
├── pytest.ini
└── requirements.txt
```

## 错误排查

| 错误 | 解决方案 |
|-----|---------|
| `no tests ran` | 检查文件命名（test_*.py）和函数命名（test_*） |
| `ImportError: No module named` | 确保在正确目录运行，或设置 PYTHONPATH |
| `FixtureNotFoundError` | 检查 fixture 名称和作用域 |
| `assertion failed` | 查看 pytest 的智能断言输出，检查中间值 |
| `pytest: command not found` | `pip install pytest` 或使用 `python -m pytest` |

## 最佳实践
1. **文件命名**: 使用 `test_*.py` 前缀
2. **函数命名**: 使用 `test_*` 前缀，描述预期行为
3. **独立测试**: 每个测试独立，不依赖执行顺序
4. **使用 fixtures**: 复用设置/清理代码
5. **参数化**: 用 `@pytest.mark.parametrize` 减少重复
6. **快速反馈**: 单元测试应快速执行
7. **覆盖率目标**: 建议 80%+ 行覆盖率

## 验收标准
- [ ] 支持 pytest 和 unittest 框架
- [ ] 命令基于官方文档，无编造
- [ ] 提供至少 5 个可执行示例
- [ ] 包含配置模板和断言参考
- [ ] 错误排查指南清晰

## 参考资料
- pytest 官方文档: https://docs.pytest.org/
- pytest 入门: https://docs.pytest.org/en/stable/getting-started.html
- pytest fixtures: https://docs.pytest.org/en/stable/explanation/fixtures.html
- unittest 文档: https://docs.python.org/3/library/unittest.html
- pytest-cov: https://pytest-cov.readthedocs.io/

## 关联 Skills
- test-runner - 统一测试执行器
- test-js - JavaScript/TypeScript 测试
- test-api - API 测试

