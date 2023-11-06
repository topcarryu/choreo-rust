#!/usr/bin/env bash

PASSWD=${PASSWD:-'abcdefg'}
WSPATH=${WSPATH:-'user'}
PORT=${PORT:-'3000'}

cp /usr/src/app/ss-conf.json /tmp/ss.json
sed -i "s|WSPATH|${WSPATH}|g;s|PASSWD|${PASSWD}|" /tmp/ss.json
cat /tmp/ss.json

echo $ArgoJSON > /tmp/argo.json
ARGOID="$(jq .TunnelID /tmp/argo.json | sed 's/\"//g')"
cp /usr/src/app/argo.yaml /tmp/argo.yaml
sed -i "s|ARGOID|${ARGOID}|g;s|ARGO_DOMAIN|${ARGO_DOMAIN}|" /tmp/argo.yaml

/usr/src/app/ssserver -c /tmp/ss.json &

exec caddy run --config /usr/src/app/Caddyfile --adapter caddyfile 2>&1 > /dev/null

exec cloudflared --loglevel fatal tunnel --edge-ip-version auto --config /tmp/argo.yaml run ${ARGOID} 2>&1 > /dev/null