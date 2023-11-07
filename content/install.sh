#!/bin/sh

set -e

DIR_TMP="$(mktemp -d)"

wget -O - https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.17.0/shadowsocks-v1.17.0.x86_64-unknown-linux-musl.tar.xz | tar -xJf - -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/ssserver /usr/bin/

wget -O - https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz | tar -zxf - -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/v2ray-plugin_linux_amd64 /usr/bin/

busybox wget -qO /usr/bin/argo https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x /usr/bin/argo 

rm -rf ${DIR_TMP}