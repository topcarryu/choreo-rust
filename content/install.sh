#!/bin/sh

set -e

DIR_TMP="$(mktemp -d)"

wget -O - https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.17.0/shadowsocks-v1.17.0.x86_64-unknown-linux-gnu.tar.xz | tar -xJf - -C ${DIR_TMP}
for file in ${DIR_TMP}/ss*; do
  install -m 755 "$file" /usr/bin/
done

wget -O - https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz | tar -zxf - -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/v2ray* /usr/bin/v2-plugin

busybox wget -qO /usr/bin/argo https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x /usr/bin/argo 

rm -rf ${DIR_TMP}