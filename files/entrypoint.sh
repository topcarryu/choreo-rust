#!/usr/bin/env bash

set -e
exec 2>&1

# 设置各变量
WSPATH=${WSPATH:-'argo'}
UUID=${UUID:-'de04add9-5c68-8bab-950c-08cd5320df18'}
TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY:-'ABCDEFG'}

generate_pm2_file() {
  cat > /tmp/ecosystem.config.js << EOF
module.exports = {
  "apps":[
      {
          name: "tailscaled",
          script: "tailscaled --port=3006 --tun=userspace-networking --socket=/tmp/tailscale/tailscaled.sock --state=/tmp/tailscale/config/tailscaled.state --statedir=/tmp/tailscale/files"
      },
      {
          name: "tailscale",
          script: "tailscale --socket=/tmp/tailscale/tailscaled.sock up --authkey=${TAILSCALE_AUTHKEY} --ssh=true --accept-dns=true --host-routes=true --netfilter-mode=on --snat-subnet-routes=true --accept-routes=true --advertise-exit-node=true --hostname=choreo"
      },
      {
          name: "ssserver",
          script: 'ssserver -s "[::]:8088" -m "aes-256-gcm" -k "hello-kitty"'
      }
  ]
}
EOF
}
generate_pm2_file

cd /tmp
mkdir -p /tmp/tailscale /tmp/tailscale/config /tmp/tailscale/files 
touch /tmp/tailscale/config/tailscaled.state 
pm2 start /tmp/ecosystem.config.js &
tailscale cert choreo.tailnet-e2eb.ts.net &
tailscale serve --bg 8088