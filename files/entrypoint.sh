#!/usr/bin/env bash

exec 2>&1

TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY:-'ABCDEFG'}

cd /tmp

mkdir -p /tmp/tailscale /tmp/tailscale/config /tmp/tailscale/files 
touch /tmp/tailscale/config/tailscaled.state 

ssserver -s "[::]:3000" -m "aes-256-gcm" -k "hello-kitty" &

tailscaled --port=3006 --tun=userspace-networking --socket=/tmp/tailscale/tailscaled.sock --state=/tmp/tailscale/config/tailscaled.state --statedir=/tmp/tailscale/files &
tailscale up --authkey=${TAILSCALE_AUTHKEY} --ssh=true --accept-dns=true --host-routes=true --netfilter-mode=on --snat-subnet-routes=true --accept-routes=true --advertise-exit-node=true --hostname=choreo &
tailscale cert choreo.tailnet-e2eb.ts.net &
tailscale serve --bg 8088