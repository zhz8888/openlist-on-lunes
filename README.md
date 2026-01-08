# OpenList on Lunes

适用于 Lunes Host 的 OpenList 启动脚本

### 快速开始

```bash
curl -s https://raw.githubusercontent.com/zhz8888/openlist-on-lunes/refs/heads/main/install.sh |
env DOMAIN=node68.lunes.host VERSION='v4.1.9' LITE=false bash
```

### 环境变量

您可以通过设置以下环境变量来自定义安装：

| 变量 | 默认值 | 描述 |
|----------|---------|-------------|
| `DOMAIN` | `node68.lunes.host` | SSL 证书的域名 |
| `VERSION` | `v4.1.9` | 要安装的 OpenList 版本 |
| `LITE` | `false` | 安装精简版（true/false） |

## 配置

安装完成后，您需要手动修改配置文件，然后再启动节点。

1. 进入控制面板，点击顶部的 `Files` 选项卡。
2. 依次点击 `oplist` -> `data` -> `config.json`。

## 许可证

本项目采用 MIT 许可证。
