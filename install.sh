#!/usr/bin/env sh

DOMAIN="${DOMAIN:-node68.lunes.host}"
VERSION="${VERSION:-v4.1.9}"
LITE="${LITE:-false}"

curl -sSL -o app.js https://raw.githubusercontent.com/zhz8888/openlist-on-lunes/refs/heads/main/app.js
curl -sSL -o package.json https://raw.githubusercontent.com/zhz8888/openlist-on-lunes/refs/heads/main/package.json

if [ "$LITE" = "true" ]; then
  DOWNLOAD_URL="https://github.com/OpenListTeam/OpenList/releases/download/$VERSION/openlist-linux-amd64-lite.tar.gz"
else
  DOWNLOAD_URL="https://github.com/OpenListTeam/OpenList/releases/download/$VERSION/openlist-linux-amd64.tar.gz"
fi

curl -sSL -o openlist-linux-amd64.tar.gz $DOWNLOAD_URL
tar -xzf openlist-linux-amd64.tar.gz
rm openlist-linux-amd64.tar.gz
chmod +x openlist
openssl req -x509 -newkey rsa:2048 -days 3650 -nodes -keyout /home/container/key.pem -out /home/container/cert.pem -subj "/CN=$DOMAIN"

echo "============================================================"
echo "🚀 OpenList Node Info"
echo "------------------------------------------------------------"
echo "Domain: $DOMAIN"
echo "Version: $VERSION"
echo "Lite: $LITE"
echo "------------------------------------------------------------"
echo "⚠️  Please follow the README file to manually modify the"
echo "    configuration file before using openlist."
echo "    http://github.com/zhz8888/openlist-on-lunes"
echo "============================================================"
