#!/usr/bin/env bash

set -e
exec 2>&1

gost -L socks5://user:pass@:51056?udp=true &
tailscaled --tun=userspace-networking --socks5-server=localhost:51055 &
tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=choreo-us &
echo Tailscale started
ALL_PROXY=socks5://localhost:51055/ gost &
yarn start 