# OpenList on Lunes

适用于 Lunes Host 的 OpenList 启动脚本

### 快速开始

1. 确保您在创建节点时选择的应用为 `node.js generic`。
2. 登录 Lunes Host 控制面板，进入对应的节点中。
3. 点击顶部的 `Startup` 选项卡，把 `STARTUP COMMAND` 中输的值改为 `bash`。
4. 点击顶部的 `Console` 选项卡回到首页，点击 `Start` 按钮启动节点。
5. 节点启动后，执行以下命令安装 OpenList：
    ```bash
    curl -s https://raw.githubusercontent.com/zhz8888/openlist-on-lunes/refs/heads/main/install.sh |
    env DOMAIN=node68.lunes.host VERSION='v4.1.9' LITE=false bash
    ```
    需要把 `node68.lunes.host` 替换为系统分配的域名。

### 环境变量

您可以通过设置以下环境变量来自定义安装：

| 变量 | 默认值 | 描述 |
|----------|---------|-------------|
| `DOMAIN` | `node68.lunes.host` | 系统分配的域名 |
| `VERSION` | `v4.1.9` | 要安装的 OpenList 版本 |
| `LITE` | `false` | 安装精简版（true/false） |

## 配置

安装完成后，您需要手动修改配置文件，然后再启动节点。

1. 进入控制面板，点击顶部的 `Files` 选项卡。
2. 依次点击 `data` -> `config.json`。
3. 修改 `scheme` 部分的内容，详细描述如下：
    ```json
    "scheme": {
        "address": "node68.lunes.host", // 替换为系统分配的域名
        "http_port": 3147,  // 替换为系统分配的端口，与 https_port 二选一，不使用该端口则设为 -1
        "https_port": -1,  // 替换为系统分配的端口，与 http_port 二选一，不使用该端口则设为 -1
        "force_https": false,  // 是否强制使用 HTTPS，当使用 HTTPS 端口时建议设为 true
        "cert_file": "/home/container/cert.pem",
        "key_file": "/home/container/key.pem",
        "unix_file": "",
        "unix_file_perm": "",
        "enable_h2c": false,
        "enable_h3": false
    },
    ```
    更多相关配置请参考 [OpenList 文档](https://doc.oplist.org/configuration/configuration#scheme)。
4. 点击右下角的 `SAVE CONTENT` 按钮保存配置文件。
5. 点击顶部的 `Startup` 选项卡，把 `STARTUP COMMAND` 中输的值改为 `node app.js`。
6. 点击顶部的 `Console` 选项卡回到首页，点击 `Restart` 按钮重启节点。

## 许可证

本项目采用 MIT 许可证。
