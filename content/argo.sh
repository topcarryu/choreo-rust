#!/usr/bin/env bash

exec 2>&1

exec /usr/src/app/cloudflared --loglevel fatal tunnel --edge-ip-version auto --config /tmp/argo.yaml run 2>&1 > /dev/null 