#!/usr/bin/env bash

if [[ -f /home/choreouser/tailscaled ]]; then
	mkdir -p /home/choreouser/data/tailscale-state /tmp/tailscale
	STATE_DIRECTORY=/tmp/tailscale /home/choreouser/tailscaled \
      --tun=userspace-networking \
      --socket=/tmp/tailscale/tailscaled.sock \
      --statedir=/home/choreouser/data/tailscale-state > /dev/null 2>&1 &
fi
