[English](README.en.md) | **中文**

# OpenList on Lunes

适用于 Lunes Host 的 OpenList 一键安装与启动脚本。

## 项目概述

该项目提供了在 Lunes Host 节点上快速部署 OpenList 所需的全部文件：

| 文件 | 说明 |
|------|------|
| `install.sh` | 基础安装脚本 — 安装 OpenList，不含 Komari Agent |
| `install2.sh` | 增强安装脚本 — 安装 OpenList + Komari Agent，含动态版本解析与 SHA256 校验 |
| `app.js` | Node.js 进程管理器 — 仅守护 OpenList 进程（供 install.sh 使用） |
| `app2.js` | Node.js 进程管理器 — 守护 OpenList 和 Komari Agent 两个进程（供 install2.sh 使用） |
| `package.json` | Node.js 项目定义（v1.2.0） |

### app.js / app2.js 说明

`app.js` 和 `app2.js` 是轻量级的进程管理脚本，以 `server --no-prefix` 参数启动 OpenList 二进制文件，崩溃后等待 3 秒自动重启：

| 文件 | 管理的进程 |
|------|-----------|
| `app.js` | **OpenList** |
| `app2.js` | **OpenList**、**Komari Agent**（监控/告警 agent） |

## 快速开始

1. 确保创建节点时选择的应用模板为 `node.js generic`。
2. 登录 Lunes Host 控制面板，进入对应的节点。
3. 点击顶部的 `Startup` 选项卡，将 `STARTUP COMMAND` 的值改为 `bash`。
4. 点击顶部的 `Console` 选项卡回到首页，点击 **Start** 按钮启动节点。
5. 节点启动后，在控制台中执行以下命令安装 OpenList：

    **基础安装（不含 Komari Agent）：**
    ```bash
    curl -s https://raw.githubusercontent.com/zhz8888/lunes-bedroom/refs/heads/main/openlist/install.sh | env DOMAIN=node68.lunes.host VERSION='v4.2.3' LITE=false bash
    ```

    **增强安装（含 Komari Agent）：**
    ```bash
    curl -s https://raw.githubusercontent.com/zhz8888/lunes-bedroom/refs/heads/main/openlist/install2.sh | env DOMAIN=node68.lunes.host VERSION='v4.2.3' LITE=false bash
    ```

    > 请将 `node68.lunes.host` 替换为系统分配的域名。

## 环境变量

可以通过设置环境变量来自定义安装过程：

| 变量 | 默认值 | 描述 |
|----------|---------|-------------|
| `DOMAIN` | `node68.lunes.host` | 系统分配的域名，用于 SSL 证书 CN |
| `VERSION` | 自动检测 | OpenList 版本（GitHub API 自动获取） |
| `LITE` | `false` | 安装精简版（`true`/`false`） |
| `KOMARI_ENABLED` | `true` | 是否启用 Komari Agent（仅 install2.sh） |
| `KOMARI_VERSION` | 自动检测 | Komari Agent 版本（GitHub API 自动获取） |
| `KOMARI_SERVER` | `http://localhost:9182` | Komari 服务器地址（仅 install2.sh） |
| `KOMARI_TOKEN` | `default` | Komari 认证令牌（仅 install2.sh） |

### 安装脚本详情

基础安装脚本 `install.sh` 执行步骤：

| 步骤 | 内容 |
|------|------|
| **Step 1** | 环境检查 — 检测 `curl`、`tar`、`openssl` 是否可用，检查磁盘空间 |
| **Step 2** | 下载应用文件 — 拉取最新的 `app.js` 和 `package.json` |
| **Step 3** | 下载 OpenList 二进制文件 — 根据 `LITE` 变量自动选择精简版或完整版 |
| **Step 4** | 解压与安装 — 解压、清理临时文件、设置可执行权限、验证文件完整性 |
| **Step 5** | 生成 SSL 自签名证书 — 以 `DOMAIN` 为 CN 生成 3650 天有效期的证书 |

增强安装脚本 `install2.sh` 执行步骤：

| 步骤 | 内容 |
|------|------|
| **Step 1** | 环境检查 — 检测依赖工具，检查磁盘空间 |
| **Step 2** | 下载应用文件 — 拉取 `app2.js`（含 Komari Agent 配置）和 `package.json`，重命名为 `app.js` |
| **Step 3** | 下载 OpenList 二进制 — 根据 `LITE` 变量选择版本 |
| **Step 4** | 下载 Komari Agent 二进制 — 创建安装目录、下载 agent（通过 `KOMARI_ENABLED` 控制） |
| **Step 5** | 验证 SHA256 校验和 — 分别校验 OpenList 和 Komari Agent 的 SHA256（通过 GitHub API） |
| **Step 6** | 解压并安装 — 解压 OpenList、安装 Komari Agent、设置权限、验证文件完整性 |
| **Step 7** | 生成 SSL 自签名证书 |

## 配置

安装完成后，需要手动修改配置文件再启动 OpenList 节点。

1. 进入控制面板，点击顶部的 `Files` 选项卡。
2. 依次点击 `data` -> `config.json`。
3. 修改 `scheme` 部分的内容，参考如下：

    ```json
    "scheme": {
        "address": "0.0.0.0",
        "http_port": 3147,
        "https_port": -1,
        "force_https": false,
        "cert_file": "/home/container/cert.pem",
        "key_file": "/home/container/key.pem",
        "unix_file": "",
        "unix_file_perm": "",
        "enable_h2c": false,
        "enable_h3": false
    },
    ```

    - `address` — 建议设置为 `0.0.0.0`，允许所有 IP 地址访问
    - `http_port` / `https_port` — 替换为系统分配的端口，二选一，不使用的端口设为 `-1`
    - `force_https` — 使用 HTTPS 端口时建议设为 `true`
    - 更多配置请参考 [OpenList 文档](https://doc.oplist.org/configuration/configuration#scheme)

4. 点击右下角的 **SAVE CONTENT** 按钮保存配置文件。
5. 点击顶部的 `Startup` 选项卡，将 `STARTUP COMMAND` 的值改为 `node app.js`。
6. 点击顶部的 `Console` 选项卡回到首页，点击 **Restart** 按钮重启节点。

## 许可证

[MIT](LICENSE)
