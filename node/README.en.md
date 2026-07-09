**English** | [中文](README.md)

# Node on Lunes

One-click install and startup script for deploying Xray (VLESS Reality) + Hysteria2 proxy nodes on Lunes Host.

## Project Overview

This project provides all the files needed to quickly deploy a proxy node on a Lunes Host node:

| File | Description |
|------|-------------|
| `install.sh` | Basic installer — installs Xray + Hysteria2 without Komari Agent |
| `install2.sh` | Enhanced installer — installs Xray + Hysteria2 + Komari Agent with dynamic version resolution and SHA256 verification |
| `app.js` | Node.js process manager — manages XY and H2 processes only (for install.sh) |
| `app2.js` | Node.js process manager — manages XY, H2, and Komari Agent processes (for install2.sh) |
| `xray-config.json` | VLESS Reality configuration template |
| `hysteria-config.yaml` | Hysteria2 configuration template |
| `package.json` | Node.js project definition (v1.2.0) |

### About app.js / app2.js

`app.js` and `app2.js` are lightweight process managers that keep child processes alive with auto-restart on crash (3-second delay):

| File | Managed Processes |
|------|------------------|
| `app.js` | **XY** (Xray), **H2** (Hysteria2) |
| `app2.js` | **XY** (Xray), **H2** (Hysteria2), **Komari Agent** (monitoring/alerting agent) |

## Quick Start

1. Make sure to select the `node.js generic` application template when creating your node.
2. Log in to the Lunes Host control panel and navigate to your node.
3. Click the **Startup** tab, then change the `STARTUP COMMAND` value to `bash`.
4. Click the **Console** tab to return to the dashboard, then click **Start** to boot the node.
5. Once the node is running, execute the following command in the console to install the node software:

    **Basic install (without Komari Agent):**
    ```bash
    curl -s https://raw.githubusercontent.com/zhz8888/lunes-bedroom/refs/heads/main/node/install.sh | env DOMAIN=node68.lunes.host PORT=3147 UUID=2584b733-9095-4bec-a7d5-62b473540f7a HY2_PASSWORD='vevc.HY2.Password' bash
    ```

    **Enhanced install (with Komari Agent):**
    ```bash
    curl -s https://raw.githubusercontent.com/zhz8888/lunes-bedroom/refs/heads/main/node/install2.sh | env DOMAIN=node68.lunes.host PORT=3147 UUID=2584b733-9095-4bec-a7d5-62b473540f7a HY2_PASSWORD='vevc.HY2.Password' bash
    ```

    > Replace `node68.lunes.host` with the domain assigned to your node, and `3147` with the port assigned by the system.

## Environment Variables

You can customize the installation process by setting the following environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `DOMAIN` | `node68.lunes.host` | Domain assigned to your node, used for the SSL certificate CN |
| `PORT` | `10008` | Proxy service port |
| `UUID` | `2584b733-...` | VLESS user ID |
| `HY2_PASSWORD` | `vevc.HY2.Password` | Hysteria2 authentication password |
| `VERSION_XRAY` | Auto-detected | Xray-core version (fetched via GitHub API) |
| `VERSION_HY2` | Auto-detected | Hysteria2 version (fetched via GitHub API) |
| `KOMARI_ENABLED` | `true` | Enable Komari Agent (install2.sh only) |
| `KOMARI_VERSION` | Auto-detected | Komari Agent version (fetched via GitHub API) |
| `KOMARI_SERVER` | `http://localhost:9182` | Komari server address (install2.sh only) |
| `KOMARI_TOKEN` | `default` | Komari authentication token (install2.sh only) |

### Install Script Details

Basic installer `install.sh` steps:

| Step | Description |
|------|-------------|
| **Step 1** | Environment Check — verify `curl`, `tar`, `unzip`, `openssl`, `node` are available and check disk space |
| **Step 2** | Download Application Files — fetch the latest `app.js` and `package.json` |
| **Step 3** | Setup Xray Core — download binary, extract, rename, generate x25519 key pair, write config, generate VLESS URL |
| **Step 4** | Setup Hysteria2 — download binary, generate SSL certificate, configure port and password, generate HY2 URL |
| **Step 5** | Save Connection Info — write VLESS and Hysteria2 connection URLs to `/home/container/node.txt` |

Enhanced installer `install2.sh` steps:

| Step | Description |
|------|-------------|
| **Step 1** | Environment Check — verify required tools and disk space |
| **Step 2** | Download Application Files — fetch `app2.js` (with Komari Agent pre-configured) and `package.json`, rename to `app.js` |
| **Step 3** | Setup Xray Core — download, key generation, Reality configuration |
| **Step 4** | Setup Hysteria2 — download, SSL certificate, configuration |
| **Step 5** | Setup Komari Agent — download agent binary, set permissions, verify installation (controlled via `KOMARI_ENABLED`) |
| **Step 6** | Save Connection Info — write connection URLs |

## Configuration

After installation, you can adjust the configuration as needed before starting the node.

### Startup Command

1. Go to the control panel and click the **Startup** tab.
2. Change the `STARTUP COMMAND` value to `node app.js`.
3. Click the **Console** tab to return to the dashboard, then click **Restart** to reboot the node.

### Xray Configuration

The configuration file is located at `/home/container/xy/config.json`. The install script automatically fills in the port, UUID, keys, and other settings. You can edit it manually if needed:

- `port` — Proxy listening port (defaults to the `PORT` environment variable)
- `id` — VLESS user UUID
- `privateKey` — REALITY private key (auto-generated during installation)
- `shortIds` — Short ID (auto-generated during installation)

### Hysteria2 Configuration

The configuration file is located at `/home/container/h2/config.yaml`:

```yaml
listen: :10008

tls:
  cert: /home/container/h2/cert.pem
  key: /home/container/h2/key.pem

auth:
  type: password
  password: 'your-password'
```

- `listen` — Listening port (automatically configured during installation)
- `password` — Authentication password (automatically configured during installation)
- SSL certificate and key are auto-generated during installation with a 3650-day validity

## Connection Info

After installation, connection URLs are saved to `/home/container/node.txt` and also printed to the console:

- **VLESS Reality** — For Xray/V2Ray clients
- **Hysteria2** — For Hysteria2 clients

## License

[MIT](LICENSE)
