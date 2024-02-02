#!/bin/sh

set -e
DIR_TMP="$(mktemp -d)"


wget https://pkgs.tailscale.com/stable/tailscale_1.58.2_amd64.tgz 
tar zxvf tailscale* -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/tailscale*/tailscale /usr/bin/
install -m 755 ${DIR_TMP}/tailscale*/tailscaled /usr/bin/

wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.17.1/shadowsocks-v1.17.1.x86_64-unknown-linux-musl.tar.xz 
tar xf shadowsocks* -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/ss* /usr/bin/

rm -rf ${DIR_TMP}