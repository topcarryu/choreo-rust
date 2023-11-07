#!/usr/bin/env bash

set -e
exec 2>&1

PASSWD=${PASSWD:-'abcdefg'}
WSPATH=${WSPATH:-'user'}
PORT=${PORT:-'3000'}
ArgoJSON=${ArgoJSON:-'{asdq1}'}
ARGO_DOMAIN=${ARGO_DOMAIN:-'a.b.c'}

cp /home/choreouser/ss-conf.json /tmp/ss.json
sed -i "s|WSPATH|${WSPATH}|g;s|PASSWD|${PASSWD}|" /tmp/ss.json
cat /tmp/ss.json

echo $ArgoJSON > /tmp/argo.json
ARGOID="$(jq .TunnelID /tmp/argo.json | sed 's/\"//g')"
cp /home/choreouser/argo.yaml /tmp/argo.yaml
sed -i "s|ARGOID|${ARGOID}|g;s|ARGO_DOMAIN|${ARGO_DOMAIN}|" /tmp/argo.yaml

dig A region2.v2.argotunnel.com &
ssserver -c /tmp/ss.json &
argo tunnel --config /tmp/argo.yaml run 2>&1 >/dev/null &
caddy run --config /home/choreouser/Caddyfile --adapter caddyfile 2>&1 >/dev/null