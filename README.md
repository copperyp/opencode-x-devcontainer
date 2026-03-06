# opencode-x-devcontainer

OpenCode AI CLI 开发环境镜像集合，为不同编程语言和运行提供优化的 devcontainer 配置。

## 包含环境

| 目录 | 描述 |
|------|------|
| `opencode-python` | Python 3.12 开发环境 |
| `opencode-nodejs` | Node.js 20 开发环境 |
| `opencode-go` | Go 1.24.1 开发环境 |
| `opencode-rust` | Rust (stable) 开发环境 |
| `opencode-ubuntu22.04-cuda12.4.1` | CUDA 12.4.1 + Ubuntu 22.04 |
| `opencode-ubuntu22.04-cuda12.8.1` | CUDA 12.8.1 + Ubuntu 22.04 |
| `opencode-ubuntu22.04-cuda12.9.1` | CUDA 12.9.1 + Ubuntu 22.04 |
| `opencode-ubuntu22.04-cuda13.1.0` | CUDA 13.1.0 + Ubuntu 22.04 |
| `opencode-ubuntu24.04-cuda12.4.1` | CUDA 12.4.1 + Ubuntu 24.04 |
| `opencode-ubuntu24.04-cuda12.8.1` | CUDA 12.8.1 + Ubuntu 24.04 |
| `opencode-ubuntu24.04-cuda12.9.1` | CUDA 12.9.1 + Ubuntu 24.04 |
| `opencode-ubuntu24.04-cuda13.1.0` | CUDA 13.1.0 + Ubuntu 24.04 |

## 使用方法

### 在 VS Code 中使用

1. 打开 VS Code
2. 安装 "Dev Containers" 扩展
3. 打开命令面板 (Ctrl+Shift+P)
4. 选择 "Dev Containers: Open Folder in Container"
5. 选择任意子目录（如 `opencode-python`）

### 使用 Docker Build

```bash
# 构建 Python 环境
docker build -t opencode-python ./opencode-python

# 构建 Node.js 环境
docker build -t opencode-nodejs ./opencode-nodejs

# 构建 Go 环境
docker build -t opencode-go ./opencode-go

# 构建 Rust 环境
docker build -t opencode-rust ./opencode-rust

# 构建 CUDA 环境
docker build -t opencode-cuda ./opencode-ubuntu22.04-cuda12.4.1
```

### 使用 build-and-push.sh 脚本

脚本位于 `scripts/build-and-push.sh`，支持单独构建或推送镜像。

```bash
# 查看可用命令
./scripts/build-and-push.sh help

# 列出所有可用镜像
./scripts/build-and-push.sh list

# 构建单个镜像（无需 Docker Hub 凭证）
./scripts/build-and-push.sh build opencode-python

# 推送镜像（需要 Docker Hub 凭证）
DOCKER_HUB_USERNAME=user DOCKER_HUB_TOKEN=token ./scripts/build-and-push.sh push opencode-python

# 构建所有镜像（无需 Docker Hub 凭证）
./scripts/build-and-push.sh build-all

# 构建并推送所有镜像（需要 Docker Hub 凭证）
DOCKER_HUB_USERNAME=user DOCKER_HUB_TOKEN=token DOCKER_HUB_REPO=myrepo ./scripts/build-and-push.sh all
```

## 环境特性

- 基于 Ubuntu 22.04（CUDA 版本基于对应 NVIDIA 镜像）
- 预装 OpenCode CLI
- 非 root 用户 `developer`（可通过 sudo 提权）
- 完整的开发工具链（build-essential, git, curl）

## 常见问题

### Docker 权限问题

如果遇到 `permission denied while trying to connect to the docker API at unix:///var/run/docker.sock` 错误：

```bash
# 方案1：使用 sudo
sudo docker build -t opencode-python ./opencode-python

# 方案2：将当前用户添加到 docker 组（需重新登录）
sudo usermod -aG docker $USER
```

### 代理配置问题

在需要代理的网络环境下构建时，需要传递代理参数：

```bash
docker build -t opencode-python ./opencode-python \
  --build-arg HTTPS_PROXY=$https_proxy \
  --build-arg HTTP_PROXY=$https_proxy
```

## License

MIT
