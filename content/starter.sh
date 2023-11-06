#!/bin/bash

/usr/src/app/ssserver -c /tmp/ss.json &
caddy run --config /usr/src/app/Caddyfile --adapter caddyfile 2>&1 &
/usr/src/app/cloudflared --loglevel fatal tunnel --edge-ip-version auto --config /tmp/argo.yaml run &

tail -f /dev/null