#!/bin/sh

set -e

DIR_TMP="$(mktemp -d)"

wget -O - https://github.com/go-gost/gost/releases/download/v3.0.0-nightly.20231107/gost_3.0.0-nightly.20231107_linux_amd64v3.tar.gz | tar -zxf - -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/gost /usr/bin/

wget -O - https://pkgs.tailscale.com/stable/tailscale_1.52.1_amd64.tgz | tar -zxvf - -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/tailscale_1.52.1_amd64/tailscale  /usr/bin/
install -m 755 ${DIR_TMP}/tailscale_1.52.1_amd64/tailscaled /usr/bin/

busybox wget -qO /usr/bin/argo https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x /usr/bin/argo 

rm -rf ${DIR_TMP}