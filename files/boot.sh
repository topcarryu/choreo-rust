#!/usr/bin/env bash

set -e

if [[ -f /home/choreouser/tailscaled ]]; then
	mkdir -p /home/choreouser/data/tailscale-state /tmp/tailscale
	STATE_DIRECTORY=/tmp/tailscale /home/choreouser/tailscaled \
      --tun=userspace-networking \
      --socket=/tmp/tailscale/tailscaled.sock \
      --statedir=/home/choreouser/data/tailscale-state \
      --socks5-server=localhost:1055 > /dev/null 2>&1 &
fi