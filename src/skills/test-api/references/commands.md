# test-api 命令参考

## curl 命令
```bash
# GET 请求
curl -X GET https://api.example.com/users
curl -s https://api.example.com/users | jq .

# POST 请求
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John"}'

# 带认证
curl -X GET https://api.example.com/users \
  -H "Authorization: Bearer $TOKEN"

# GraphQL
curl -X POST https://api.example.com/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ users { id name } }"}'
```

## httpie 命令
```bash
# 安装
pip install httpie
brew install httpie

# GET 请求
http GET https://api.example.com/users

# POST 请求
http POST https://api.example.com/users name=John

# 带认证
http GET https://api.example.com/users Authorization:"Bearer $TOKEN"
```

## pytest + requests
```bash
# 安装
pip install pytest requests pytest-cov

# 运行测试
pytest test_api.py -v
pytest test_api.py --cov
```

## 测试代码模板

### REST API 测试 (Python)
```python
import requests
import pytest

BASE_URL = "https://api.example.com"

def test_get_users():
    response = requests.get(f"{BASE_URL}/users")
    assert response.status_code == 200
    assert "data" in response.json()

def test_create_user():
    response = requests.post(
        f"{BASE_URL}/users",
        json={"name": "John"}
    )
    assert response.status_code == 201
```

### GraphQL 测试 (Python)
```python
import requests

GRAPHQL_URL = "https://api.example.com/graphql"

def test_query():
    query = "{ users { id name } }"
    response = requests.post(GRAPHQL_URL, json={"query": query})
    assert response.status_code == 200
    assert "data" in response.json()
```

### Jest + Supertest (Node.js)
```javascript
const request = require('supertest');
const app = require('../app');

describe('GET /users', () => {
  it('returns users', async () => {
    const res = await request(app).get('/users');
    expect(res.statusCode).toBe(200);
  });
});
```

## 官方文档
- requests: https://docs.python-requests.org/
- httpie: https://httpie.io/docs
- curl: https://curl.se/docs/
- Supertest: https://github.com/ladjs/supertest
