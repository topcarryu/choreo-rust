#!/usr/bin/env bash

set -e

# 设置各变量
WSPATH=${WSPATH:-'argo'}
UUID=${UUID:-'de04add9-5c68-8bab-950c-08cd5320df18'}
TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY:-'ABCDEFG'}

mkdir -p /tmp/tailscale /tmp/tailscale/config /tmp/tailscale/files 
wget https://pkgs.tailscale.com/stable/tailscale_1.58.2_amd64.tgz
tar -xzvf tailscale*
install -m 755 /home/choreouser/tailscale*/tailscale /tmp/tailscale/tailscale
install -m 755 /home/choreouser/tailscale*/tailscaled /tmp/tailscale/tailscaled
touch /tmp/tailscale/config/tailscaled.state 

generate_pm2_file() {
  cat > /tmp/ecosystem.config.js << EOF
module.exports = {
  "apps":[
      {
          name: "tailscaled",
          script: "/tmp/tailscale/tailscaled --port=3006 --tun=userspace-networking --socket=/tmp/tailscale/tailscaled.sock --state=/tmp/tailscale/config/tailscaled.state --statedir=/tmp/tailscale/files"
      },
      {
          name: "tailscale",
          script: "/tmp/tailscale/tailscale --socket=/tmp/tailscale/tailscaled.sock up --authkey=${TAILSCALE_AUTHKEY} --ssh=true --accept-dns=true --host-routes=true --netfilter-mode=on --snat-subnet-routes=true --accept-routes=true --advertise-exit-node=true --hostname=choreo"
      },
      {
          name: "ssserver",
          script: '/home/choreouser/ssserver -s "[::]:8088" -m "aes-256-gcm" -k "hello-kitty"'
      }
  ]
}
EOF
}

generate_pm2_file
[ -e /tmp/ecosystem.config.js ] && pm2 start /tmp/ecosystem.config.js &
/tmp/tailscale/tailscale --socket=/tmp/tailscale/tailscaled.sock cert choreo.tailnet-e2eb.ts.net &
/tmp/tailscale/tailscale --socket=/tmp/tailscale/tailscaled.sock serve --bg 8088