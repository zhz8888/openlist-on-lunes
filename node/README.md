[English](README.en.md) | **中文**

# Node on Lunes

适用于 Lunes Host 的 Xray（VLESS Reality）+ Hysteria2 节点一键安装与启动脚本。

## 项目概述

该项目提供了在 Lunes Host 节点上快速部署代理节点所需的全部文件：

| 文件 | 说明 |
|------|------|
| `install.sh` | 基础安装脚本 — 安装 Xray + Hysteria2，不含 Komari Agent |
| `install2.sh` | 增强安装脚本 — 安装 Xray + Hysteria2 + Komari Agent，含动态版本解析与 SHA256 校验 |
| `app.js` | Node.js 进程管理器 — 仅守护 XY 和 H2 进程（供 install.sh 使用） |
| `app2.js` | Node.js 进程管理器 — 守护 XY、H2 和 Komari Agent 三个进程（供 install2.sh 使用） |
| `xray-config.json` | VLESS Reality 配置模板 |
| `hysteria-config.yaml` | Hysteria2 配置模板 |
| `package.json` | Node.js 项目定义（v1.2.0） |

### app.js / app2.js 说明

`app.js` 和 `app2.js` 是轻量级的进程管理脚本，会自动管理子进程，崩溃后等待 3 秒自动重启：

| 文件 | 管理的进程 |
|------|-----------|
| `app.js` | **XY**（Xray）、**H2**（Hysteria2） |
| `app2.js` | **XY**（Xray）、**H2**（Hysteria2）、**Komari Agent**（监控/告警 agent） |

## 快速开始

1. 确保创建节点时选择的应用模板为 `node.js generic`。
2. 登录 Lunes Host 控制面板，进入对应的节点。
3. 点击顶部的 `Startup` 选项卡，将 `STARTUP COMMAND` 的值改为 `bash`。
4. 点击顶部的 `Console` 选项卡回到首页，点击 **Start** 按钮启动节点。
5. 节点启动后，在控制台中执行以下命令安装节点程序：

    **基础安装（不含 Komari Agent）：**
    ```bash
    curl -s https://raw.githubusercontent.com/zhz8888/lunes-bedroom/refs/heads/main/node/install.sh | env DOMAIN=node68.lunes.host PORT=3147 UUID=2584b733-9095-4bec-a7d5-62b473540f7a HY2_PASSWORD='vevc.HY2.Password' bash
    ```

    **增强安装（含 Komari Agent）：**
    ```bash
    curl -s https://raw.githubusercontent.com/zhz8888/lunes-bedroom/refs/heads/main/node/install2.sh | env DOMAIN=node68.lunes.host PORT=3147 UUID=2584b733-9095-4bec-a7d5-62b473540f7a HY2_PASSWORD='vevc.HY2.Password' bash
    ```

    > 请将 `node68.lunes.host` 替换为系统分配的域名，`3147` 替换为系统分配的端口。

## 环境变量

可以通过设置环境变量来自定义安装过程：

| 变量 | 默认值 | 描述 |
|----------|---------|-------------|
| `DOMAIN` | `node68.lunes.host` | 系统分配的域名，用于 SSL 证书 CN |
| `PORT` | `10008` | 代理服务端口 |
| `UUID` | `2584b733-...` | VLESS 协议的用户 ID |
| `HY2_PASSWORD` | `vevc.HY2.Password` | Hysteria2 认证密码 |
| `VERSION_XRAY` | 自动检测 | Xray-core 版本（GitHub API 自动获取） |
| `VERSION_HY2` | 自动检测 | Hysteria2 版本（GitHub API 自动获取） |
| `KOMARI_ENABLED` | `true` | 是否启用 Komari Agent（仅 install2.sh） |
| `KOMARI_VERSION` | 自动检测 | Komari Agent 版本（GitHub API 自动获取） |
| `KOMARI_SERVER` | `http://localhost:9182` | Komari 服务器地址（仅 install2.sh） |
| `KOMARI_TOKEN` | `default` | Komari 认证令牌（仅 install2.sh） |

### 安装脚本详情

基础安装脚本 `install.sh` 执行步骤：

| 步骤 | 内容 |
|------|------|
| **Step 1** | 环境检查 — 检测 `curl`、`tar`、`unzip`、`openssl`、`node` 是否可用，检查磁盘空间 |
| **Step 2** | 下载应用文件 — 拉取最新的 `app.js` 和 `package.json` |
| **Step 3** | 部署 Xray Core — 下载二进制文件、解压、重命名、生成 x25519 密钥对并写入配置、生成 VLESS URL |
| **Step 4** | 部署 Hysteria2 — 下载二进制文件、生成 SSL 证书、配置端口与密码、生成 HY2 URL |
| **Step 5** | 保存连接信息 — 将 VLESS 和 Hysteria2 连接 URL 写入 `/home/container/node.txt` |

增强安装脚本 `install2.sh` 执行步骤：

| 步骤 | 内容 |
|------|------|
| **Step 1** | 环境检查 — 检测依赖工具，检查磁盘空间 |
| **Step 2** | 下载应用文件 — 拉取 `app2.js`（含 Komari Agent 配置）和 `package.json`，重命名为 `app.js` |
| **Step 3** | 部署 Xray Core — 下载二进制、生成密钥、配置 Reality 参数（同 install.sh） |
| **Step 4** | 部署 Hysteria2 — 下载二进制、SSL 证书、配置参数（同 install.sh） |
| **Step 5** | 安装 Komari Agent — 下载 agent 二进制、设置权限、验证安装（通过 `KOMARI_ENABLED` 控制） |
| **Step 6** | 保存连接信息 — 写入连接 URL |

## 配置

安装完成后，可以按需调整配置再启动节点。

### 启动命令

1. 进入控制面板，点击顶部的 `Startup` 选项卡。
2. 将 `STARTUP COMMAND` 的值改为 `node app.js`。
3. 点击顶部的 `Console` 选项卡回到首页，点击 **Restart** 按钮重启节点。

### Xray 配置

配置文件位于 `/home/container/xy/config.json`，安装脚本会自动填入 UUID、端口、密钥等信息。如需调整，可手动编辑：

- `port` — 代理监听端口（默认与 `PORT` 环境变量一致）
- `id` — VLESS 用户 UUID
- `privateKey` — REALITY 的私钥（安装时自动生成）
- `shortIds` — short ID（安装时自动生成）

### Hysteria2 配置

配置文件位于 `/home/container/h2/config.yaml`：

```yaml
listen: :10008

tls:
  cert: /home/container/h2/cert.pem
  key: /home/container/h2/key.pem

auth:
  type: password
  password: '你的密码'
```

- `listen` — 监听端口（安装时自动替换）
- `password` — 认证密码（安装时自动替换）
- SSL 证书和密钥在安装时自动生成，有效期为 3650 天

## 连接信息

安装完成后，连接 URL 会保存在 `/home/container/node.txt` 中，同时会输出到控制台：

- **VLESS Reality** — 用于 Xray/V2Ray 客户端
- **Hysteria2** — 用于 Hysteria2 客户端

## 许可证

[MIT](LICENSE)
