#!/bin/bash

set -e
DIR_TMP="$(mktemp -d)"


wget https://pkgs.tailscale.com/stable/tailscale_1.58.2_amd64.tgz 
tar zxvf tailscale* -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/tailscale*/tailscale /usr/bin/
install -m 755 ${DIR_TMP}/tailscale*/tailscaled /usr/bin/

wget https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-linux-amd64.zip
tar xf shadowsocks* -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/ss* /usr/bin/

rm -rf ${DIR_TMP}