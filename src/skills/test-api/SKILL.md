---
name: test-api
description: API 测试执行器（REST, GraphQL）
metadata:
  openclaw:
    version: "1.0"
  author: Gates
  created: 2026-04-10
  license: MIT
---

# test-api - API 测试执行器

## 角色定位
你是 API 测试专家，专注于 REST 和 GraphQL API 的自动化测试。你提供请求构造、响应验证、认证处理的完整支持。

## 支持的工具

### REST API 测试

#### 使用 curl (命令行)
```bash
# GET 请求
curl -X GET https://api.example.com/users

# POST 请求
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John","email":"john@example.com"}'

# 带认证
curl -X GET https://api.example.com/users \
  -H "Authorization: Bearer $TOKEN"

# 保存响应
curl -s https://api.example.com/users | jq .
```

#### 使用 httpie (推荐 CLI 工具)
**安装**: `pip install httpie` 或 `brew install httpie`

```bash
# GET 请求
http GET https://api.example.com/users

# POST 请求
http POST https://api.example.com/users name=John email=john@example.com

# 带认证
http GET https://api.example.com/users Authorization:"Bearer $TOKEN"

# 下载文件
http --download GET https://api.example.com/file.pdf
```

#### 使用 Jest + Supertest (Node.js)
**安装**: `npm install -D jest supertest`

```javascript
// api.test.js
const request = require('supertest');
const app = require('../app');

describe('GET /users', () => {
  it('returns list of users', async () => {
    const res = await request(app).get('/users');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('data');
    expect(Array.isArray(res.body.data)).toBe(true);
  });
});

describe('POST /users', () => {
  it('creates a new user', async () => {
    const res = await request(app)
      .post('/users')
      .send({ name: 'John', email: 'john@example.com' });
    expect(res.statusCode).toBe(201);
    expect(res.body.data.name).toBe('John');
  });
});
```

#### 使用 pytest + requests (Python)
**安装**: `pip install pytest requests`

```python
# test_api.py
import requests
import pytest

BASE_URL = "https://api.example.com"

def test_get_users():
    response = requests.get(f"{BASE_URL}/users")
    assert response.status_code == 200
    data = response.json()
    assert "data" in data
    assert isinstance(data["data"], list)

def test_create_user():
    response = requests.post(
        f"{BASE_URL}/users",
        json={"name": "John", "email": "john@example.com"}
    )
    assert response.status_code == 201
    assert response.json()["data"]["name"] == "John"
```

### GraphQL API 测试

#### 使用 curl
```bash
# GraphQL 查询
curl -X POST https://api.example.com/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ users { id name email } }"}'

# 带变量
curl -X POST https://api.example.com/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query GetUser($id: ID!) { user(id: $id) { name } }",
    "variables": {"id": "123"}
  }'

# Mutation
curl -X POST https://api.example.com/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { createUser(name: \"John\") { id name } }"
  }'
```

#### 使用 pytest + requests (Python)
```python
# test_graphql.py
import requests

GRAPHQL_URL = "https://api.example.com/graphql"

def test_get_users():
    query = "{ users { id name email } }"
    response = requests.post(GRAPHQL_URL, json={"query": query})
    assert response.status_code == 200
    data = response.json()
    assert "data" in data
    assert "users" in data["data"]

def test_create_user():
    query = "mutation { createUser(name: \"John\") { id name } }"
    response = requests.post(GRAPHQL_URL, json={"query": query})
    assert response.status_code == 200
    data = response.json()
    assert data["data"]["createUser"]["name"] == "John"
```

## 使用示例

### 示例 1: REST API 基础测试 (Python)
```bash
# 安装依赖
pip install pytest requests

# 创建测试文件
cat > test_rest_api.py << 'EOF'
import requests
import pytest

BASE_URL = "https://jsonplaceholder.typicode.com"

def test_get_posts():
    """获取帖子列表"""
    response = requests.get(f"{BASE_URL}/posts")
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert "title" in data[0]

def test_get_single_post():
    """获取单个帖子"""
    response = requests.get(f"{BASE_URL}/posts/1")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == 1

def test_create_post():
    """创建新帖子"""
    new_post = {
        "title": "Test Post",
        "body": "This is a test",
        "userId": 1
    }
    response = requests.post(f"{BASE_URL}/posts", json=new_post)
    assert response.status_code == 201
    data = response.json()
    assert data["title"] == "Test Post"
    assert data["id"] == 101  # JSONPlaceholder 固定返回 101

def test_update_post():
    """更新帖子"""
    update_data = {"title": "Updated Title"}
    response = requests.put(
        f"{BASE_URL}/posts/1",
        json=update_data
    )
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Updated Title"

def test_delete_post():
    """删除帖子"""
    response = requests.delete(f"{BASE_URL}/posts/1")
    assert response.status_code == 204
EOF

# 运行测试
pytest test_rest_api.py -v
```

### 示例 2: 带认证的 API 测试
```python
# test_auth_api.py
import requests
import pytest

BASE_URL = "https://api.example.com"
# API_KEY 应从环境变量获取，不要硬编码
# 示例：export API_KEY="your-actual-key"
import os
# 实际使用时从环境变量读取
def get_api_key():
    return os.getenv("API_KEY")  # 运行前设置环境变量

@pytest.fixture
def auth_headers():
    # 实际使用时从环境变量读取 token
    token = os.getenv("API_KEY")
    return {"Authorization": f"Bearer {token}"}

def test_authenticated_request(auth_headers):
    response = requests.get(
        f"{BASE_URL}/protected",
        headers=auth_headers
    )
    assert response.status_code == 200

def test_unauthenticated_request():
    response = requests.get(f"{BASE_URL}/protected")
    assert response.status_code == 401
```

### 示例 3: GraphQL 测试 (Python)
```bash
cat > test_graphql.py << 'EOF'
import requests
import pytest

GRAPHQL_URL = "https://api.example.com/graphql"

def query_graphql(query, variables=None):
    """执行 GraphQL 查询"""
    payload = {"query": query}
    if variables:
        payload["variables"] = variables
    response = requests.post(GRAPHQL_URL, json=payload)
    return response.json()

def test_get_users():
    query = """
    {
        users {
            id
            name
            email
        }
    }
    """
    result = query_graphql(query)
    assert "data" in result
    assert "users" in result["data"]
    assert len(result["data"]["users"]) > 0

def test_get_user_by_id():
    query = """
    query GetUser($id: ID!) {
        user(id: $id) {
            id
            name
        }
    }
    """
    result = query_graphql(query, {"id": "1"})
    assert result["data"]["user"]["id"] == "1"

def test_create_user_mutation():
    mutation = """
    mutation {
        createUser(name: "Test User", email: "test@example.com") {
            id
            name
            email
        }
    }
    """
    result = query_graphql(mutation)
    assert result["data"]["createUser"]["name"] == "Test User"
EOF

# 运行测试
pytest test_graphql.py -v
```

### 示例 4: API 测试夹具 (pytest fixtures)
```python
# conftest.py
import pytest
import requests

@pytest.fixture(scope="session")
def api_client():
    """创建 API 客户端会话"""
    session = requests.Session()
    session.base_url = "https://api.example.com"
    yield session
    session.close()

@pytest.fixture
def auth_token():
    """获取认证 token"""
    response = requests.post(
        "https://api.example.com/auth/login",
        json={"username": "test", "password": "test123"}
    )
    return response.json()["token"]

@pytest.fixture
def authenticated_client(api_client, auth_token):
    """带认证的客户端"""
    api_client.headers.update({"Authorization": f"Bearer {auth_token}"})
    return api_client
```

### 示例 5: 响应模式验证
```python
# test_schema.py
import pytest
from jsonschema import validate

USER_SCHEMA = {
    "type": "object",
    "required": [   "id",    "name", "email"   ],
    "properties": {
        "id": {"type": "integer"},
        "name": {"type": "string"},
        "email": {"type": "string", "format": "email"}
    }
}

def test_user_response_schema():
    import requests
    response = requests.get("https://api.example.com/users/1")
    data = response.json()["data"]
    validate(instance=data, schema=USER_SCHEMA)
```

### 示例 6: 性能测试
```python
# test_performance.py
import pytest
import requests
import time

def test_response_time():
    """测试响应时间"""
    start = time.time()
    response = requests.get("https://api.example.com/users")
    elapsed = time.time() - start
    assert elapsed < 1.0  # 响应时间小于 1 秒
    assert response.status_code == 200

@pytest.mark.parametrize("endpoint", [
    "/users",
    "/posts",
    "/comments"
])
def test_multiple_endpoints(endpoint):
    """测试多个端点"""
    import requests
    response = requests.get(f"https://api.example.com{endpoint}")
    assert response.status_code == 200
```

## 常用断言

### 状态码断言
```python
assert response.status_code == 200  # OK
assert response.status_code == 201  # Created
assert response.status_code == 204  # No Content
assert response.status_code == 400  # Bad Request
assert response.status_code == 401  # Unauthorized
assert response.status_code == 403  # Forbidden
assert response.status_code == 404  # Not Found
assert response.status_code == 500  # Internal Server Error
```

### 响应内容断言
```python
# JSON 响应
data = response.json()
assert "key" in data
assert data["status"] == "success"
assert isinstance(data["items"], list)
assert len(data["items"]) > 0

# 头部断言
assert response.headers["Content-Type"] == "application/json"
assert "Authorization" in response.headers

# 响应时间
assert response.elapsed.total_seconds() < 1.0
```

## 配置模板

### pytest.ini (API 测试配置)
```ini
[pytest]
testpaths = tests/api
python_files = test_*.py
addopts = -v --tb=short
markers =
    smoke: 冒烟测试
    integration: 集成测试
    performance: 性能测试
env =
    API_BASE_URL=https://api.example.com
    # API_KEY 应使用真实密钥，通过环境变量设置
    # 不要在文件中硬编码真实密钥
```

### .env (环境变量)
```bash
API_BASE_URL=https://api.example.com
# 以下密钥通过环境变量设置，不要在此文件中硬编码
# 示例：export API_KEY="xxx"  # 替换为真实密钥
# 示例：export AUTH_TOKEN="xxx"  # 替换为真实 token
```

## 错误排查

| 错误 | 解决方案 |
|-----|---------|
| `401 Unauthorized` | 检查认证 token 是否有效，是否过期 |
| `403 Forbidden` | 检查权限配置，API key 是否有足够权限 |
| `404 Not Found` | 检查端点 URL 是否正确 |
| `500 Internal Server Error` | 检查请求参数，查看服务端日志 |
| `Connection refused` | 检查 API 服务是否运行，网络是否通畅 |
| `JSONDecodeError` | 检查响应是否为 JSON 格式 |

## 最佳实践
1. **环境隔离**: 使用独立的测试环境，不要测试生产数据
2. **数据清理**: 测试后清理创建的测试数据
3. **Mock 外部依赖**: 使用 mock 减少对外部服务的依赖
4. **合理断言**: 验证关键字段，不要过度断言
5. **错误处理**: 测试各种错误场景（4xx, 5xx）
6. **性能基线**: 设置响应时间基线，监控性能退化
7. **安全测试**: 测试认证、授权、输入验证

## 验收标准
- [ ] 支持 REST 和 GraphQL API 测试
- [ ] 命令基于官方文档，无编造
- [ ] 提供至少 5 个可执行示例
- [ ] 包含配置模板和断言参考
- [ ] 错误排查指南清晰

## 参考资料
- requests 库: https://docs.python-requests.org/
- pytest: https://docs.pytest.org/
- httpie: https://httpie.io/docs
- curl: https://curl.se/docs/
- GraphQL: https://graphql.org/learn/
- JSON Schema: https://json-schema.org/
- Supertest: https://github.com/ladjs/supertest

## 关联 Skills
- test-runner - 统一测试执行器
- test-python - Python 测试
- test-js - JavaScript/TypeScript 测试

