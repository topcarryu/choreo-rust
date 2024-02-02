#!/bin/sh

exec 2>&1

PORT=${PORT:-'3000'}
TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY:-'ABCDEFG'}
DOMAIN=${DOMAIN:-'a.b'}

cd /tmp

mkdir -p /tmp/tailscale /tmp/tailscale/config /tmp/tailscale/files 
touch /tmp/tailscale/config/tailscaled.state 

ssserver -s "[::]:13000" -m "aes-256-gcm" -k "hello-kitty" &

tailscaled --tun=userspace-networking --socket=/tmp/tailscale/tailscaled.sock --state=/tmp/tailscale/config/tailscaled.state --statedir=/tmp/tailscale/files &
tailscale up --authkey=${TAILSCALE_AUTHKEY} --ssh=true --accept-dns=true --host-routes=true --netfilter-mode=on --snat-subnet-routes=true --accept-routes=true --advertise-exit-node=true --hostname=choreo &
tailscale cert ${DOMAIN} &
tailscale serve --bg 13000 &

cat > /tmp/Caddyfile << EOF
:{$PORT} {
  respond "Hello, world!"
}
EOF

caddy run --config /tmp/Caddyfile --adapter caddyfile