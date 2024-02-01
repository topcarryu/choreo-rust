#!/usr/bin/env bash

set -e

# 设置各变量
WSPATH=${WSPATH:-'argo'}
UUID=${UUID:-'de04add9-5c68-8bab-950c-08cd5320df18'}
TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY:-'ABCDEFG'}

STATE_DIRECTORY=/tmp/tailscale 

generate_pm2_file() {
  cat > /tmp/ecosystem.config.js << EOF
module.exports = {
  "apps":[
      {
          name: "tailscaled",
          script: "/home/choreouser/tailscaled --port=3006 --tun=userspace-networking --socket=/tmp/tailscale/tailscaled.sock --statedir=/tmp/tailscale/data/tailscale-state"
      },
      {
          name: "tailscale",
          script: "/home/choreouser/tailscale --socket=/tmp/tailscale/tailscaled.sock up --authkey=${TAILSCALE_AUTHKEY} --ssh=true --accept-dns=true --host-routes=true --netfilter-mode=on --snat-subnet-routes=true --accept-routes=true --advertise-exit-node=true --hostname=choreo"
      },
      {
          name: "funnel",
          script: "/home/choreouser/tailscale --socket=/tmp/tailscale/tailscaled.sock funnel --bg 8080"
      },
      {
          name: "cert",
          script: "/home/choreouser/tailscale --socket=/tmp/tailscale/tailscaled.sock cert choreo.tailnet-e2eb.ts.net"
      },
      {
          name: "snell",
          script: "/home/choreouser/wstunnel server wss://[::]:18080"
      }
  ]
}
EOF
}

generate_pm2_file

[ -e /tmp/ecosystem.config.js ] && pm2 start /tmp/ecosystem.config.js