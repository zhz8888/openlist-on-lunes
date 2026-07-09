**English** | [中文](README.md)

# OpenList on Lunes

One-click install and startup script for running OpenList on Lunes Host nodes.

## Project Overview

This project provides all the files needed to quickly deploy OpenList on a Lunes Host node:

| File | Description |
|------|-------------|
| `install.sh` | Basic installer — installs OpenList without Komari Agent |
| `install2.sh` | Enhanced installer — installs OpenList + Komari Agent with dynamic version resolution and SHA256 verification |
| `app.js` | Node.js process manager — manages OpenList process only (for install.sh) |
| `app2.js` | Node.js process manager — manages OpenList and Komari Agent processes (for install2.sh) |
| `package.json` | Node.js project definition (v1.2.0) |

### About app.js / app2.js

`app.js` and `app2.js` are lightweight process managers that launch the OpenList binary with `server --no-prefix` arguments and auto-restart on crash (3-second delay):

| File | Managed Processes |
|------|------------------|
| `app.js` | **OpenList** |
| `app2.js` | **OpenList**, **Komari Agent** (monitoring/alerting agent) |

## Quick Start

1. Make sure to select the `node.js generic` application template when creating your node.
2. Log in to the Lunes Host control panel and navigate to your node.
3. Click the **Startup** tab, then change the `STARTUP COMMAND` value to `bash`.
4. Click the **Console** tab to return to the dashboard, then click **Start** to boot the node.
5. Once the node is running, execute the following command in the console to install OpenList:

    **Basic install (without Komari Agent):**
    ```bash
    curl -s https://raw.githubusercontent.com/zhz8888/lunes-bedroom/refs/heads/main/openlist/install.sh | env DOMAIN=node68.lunes.host VERSION='v4.2.3' LITE=false bash
    ```

    **Enhanced install (with Komari Agent):**
    ```bash
    curl -s https://raw.githubusercontent.com/zhz8888/lunes-bedroom/refs/heads/main/openlist/install2.sh | env DOMAIN=node68.lunes.host VERSION='v4.2.3' LITE=false bash
    ```

    > Replace `node68.lunes.host` with the domain assigned to your node.

## Environment Variables

You can customize the installation process by setting the following environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `DOMAIN` | `node68.lunes.host` | Domain assigned to your node, used for the SSL certificate CN |
| `VERSION` | Auto-detected | OpenList version (fetched via GitHub API) |
| `LITE` | `false` | Install the lite version (`true`/`false`) |
| `KOMARI_ENABLED` | `true` | Enable Komari Agent (install2.sh only) |
| `KOMARI_VERSION` | Auto-detected | Komari Agent version (fetched via GitHub API) |
| `KOMARI_SERVER` | `http://localhost:9182` | Komari server address (install2.sh only) |
| `KOMARI_TOKEN` | `default` | Komari authentication token (install2.sh only) |

### Install Script Details

Basic installer `install.sh` steps:

| Step | Description |
|------|-------------|
| **Step 1** | Environment Check — verify `curl`, `tar`, `openssl` are available and check disk space |
| **Step 2** | Download Application Files — fetch the latest `app.js` and `package.json` |
| **Step 3** | Download OpenList Binary — automatically selects lite or full version based on `LITE` variable |
| **Step 4** | Extract and Install — extract archive, clean up temp files, set executable permissions, verify file integrity |
| **Step 5** | Generate SSL Self-Signed Certificate — creates a 3650-day certificate using `DOMAIN` as the CN |

Enhanced installer `install2.sh` steps:

| Step | Description |
|------|-------------|
| **Step 1** | Environment Check — verify required tools and disk space |
| **Step 2** | Download Application Files — fetch `app2.js` (with Komari Agent pre-configured) and `package.json`, rename to `app.js` |
| **Step 3** | Download OpenList Binary — select version based on `LITE` variable |
| **Step 4** | Download Komari Agent Binary — create installation directory, download agent (controlled via `KOMARI_ENABLED`) |
| **Step 5** | Verify SHA256 Checksum — verify SHA256 checksums for both OpenList and Komari Agent via GitHub API |
| **Step 6** | Extract and Install — extract OpenList, install Komari Agent, set permissions, verify file integrity |
| **Step 7** | Generate SSL Self-Signed Certificate |

## Configuration

After installation, you need to manually edit the configuration file before starting the OpenList node.

1. Go to the control panel and click the **Files** tab.
2. Navigate to `data` -> `config.json`.
3. Edit the `scheme` section as shown below:

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

    - `address` — set to `0.0.0.0` to allow access from all IP addresses
    - `http_port` / `https_port` — use the port assigned by the system (choose one, set the unused one to `-1`)
    - `force_https` — recommended to set to `true` when using the HTTPS port
    - For more configuration options, refer to the [OpenList Documentation](https://doc.oplist.org/configuration/configuration#scheme)

4. Click the **SAVE CONTENT** button at the bottom right to save the configuration file.
5. Click the **Startup** tab, then change the `STARTUP COMMAND` value to `node app.js`.
6. Click the **Console** tab to return to the dashboard, then click **Restart** to reboot the node.

## License

[MIT](LICENSE)
