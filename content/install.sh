#!/bin/sh

set -e

DIR_TMP="$(mktemp -d)"

busybox wget -qO /usr/bin/argo https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x /usr/bin/argo 

rm -rf ${DIR_TMP}