#!/usr/bin/env bash

set -e
exec 2>&1

echo $ArgoJSON > /tmp/argo.json
ARGOID="$(jq .TunnelID /tmp/argo.json | sed 's/\"//g')"
cp /home/choreouser/argo.yaml /tmp/argo.yaml
sed -i "s|ARGOID|${ARGOID}|g;s|ARGO_DOMAIN|${ARGO_DOMAIN}|" /tmp/argo.yaml

argo tunnel --config /tmp/argo.yaml run 2>&1 >/dev/null &