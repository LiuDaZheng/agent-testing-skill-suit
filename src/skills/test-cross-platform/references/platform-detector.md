# 平台检测器详细实现

## 完整 PlatformDetector 类

```python
# tests/utils/platform_detector.py
import platform
import sys
import os
from pathlib import Path
from typing import Optional

class PlatformDetector:
    """自动平台检测"""
    
    @staticmethod
    def get_os() -> str:
        """检测操作系统"""
        system = platform.system()
        
        if system == 'Windows':
            return 'windows'
        elif system == 'Darwin':
            return 'macos'
        elif system == 'Linux':
            return 'linux'
        else:
            return 'unknown'
    
    @staticmethod
    def get_os_version() -> str:
        """获取操作系统版本"""
        system = platform.system()
        
        if system == 'Darwin':
            return platform.mac_ver()[0]
        elif system == 'Linux':
            return platform.release()
        elif system == 'Windows':
            return platform.win32_ver()[0]
        
        return 'unknown'
    
    @staticmethod
    def get_python_version() -> str:
        """获取 Python 版本"""
        return f"{sys.version_info.major}.{sys.version_info.minor}"
    
    @staticmethod
    def is_ci() -> bool:
        """检测是否在 CI 环境"""
        ci_vars = ['CI', 'GITHUB_ACTIONS', 'GITLAB_CI', 'JENKINS_URL', 'TRAVIS']
        return any(os.getenv(var) for var in ci_vars)
    
    @staticmethod
    def get_ci_provider() -> Optional[str]:
        """获取 CI 提供商"""
        if os.getenv('GITHUB_ACTIONS'):
            return 'github'
        elif os.getenv('GITLAB_CI'):
            return 'gitlab'
        elif os.getenv('JENKINS_URL'):
            return 'jenkins'
        elif os.getenv('TRAVIS'):
            return 'travis'
        return None
    
    @staticmethod
    def get_browser_driver_path(browser: str, project_root: Optional[Path] = None) -> str:
        """获取浏览器驱动路径"""
        if project_root is None:
            project_root = Path(__file__).parent.parent.parent
        
        drivers_dir = project_root / 'drivers'
        system = PlatformDetector.get_os()
        
        if browser == 'chrome':
            if system == 'windows':
                return str(drivers_dir / 'chromedriver.exe')
            else:
                return str(drivers_dir / 'chromedriver')
        elif browser == 'firefox':
            if system == 'windows':
                return str(drivers_dir / 'geckodriver.exe')
            else:
                return str(drivers_dir / 'geckodriver')
        
        raise ValueError(f"Unsupported browser: {browser}")
    
    @staticmethod
    def get_shell_command(command: str) -> list:
        """获取跨平台命令执行格式"""
        system = PlatformDetector.get_os()
        
        if system == 'windows':
            return ['cmd', '/c', command]
        else:
            return ['sh', '-c', command]
    
    @staticmethod
    def get_path_separator() -> str:
        """获取路径分隔符"""
        system = PlatformDetector.get_os()
        return '\\' if system == 'windows' else '/'
    
    @staticmethod
    def is_headless() -> bool:
        """检测是否在无头模式运行"""
        return os.getenv('HEADLESS', 'false').lower() == 'true' or PlatformDetector.is_ci()
```

## 使用示例

```python
# tests/conftest.py
import pytest
from utils.platform_detector import PlatformDetector

@pytest.fixture(scope="session")
def platform_info():
    """平台信息 fixture"""
    return {
        'os': PlatformDetector.get_os(),
        'os_version': PlatformDetector.get_os_version(),
        'python_version': PlatformDetector.get_python_version(),
        'is_ci': PlatformDetector.is_ci(),
        'ci_provider': PlatformDetector.get_ci_provider(),
    }

@pytest.fixture
def driver_path(browser_name):
    """浏览器驱动路径"""
    return PlatformDetector.get_browser_driver_path(browser_name)
```
