#!/usr/bin/env bash

set -e

STATE_DIRECTORY=/tmp/tailscale /home/choreouser/tailscaled \
      --tun=userspace-networking \
      --socket=/tmp/tailscale/tailscaled.sock \
      --statedir=/home/choreouser/data/tailscale-state \
      --socks5-server=localhost:1055 > /dev/null 2>&1 &

/home/choreouser/tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=heroku-app &
echo Tailscale started &
ALL_PROXY=socks5://localhost:1055/ /home/choreouser/web.js