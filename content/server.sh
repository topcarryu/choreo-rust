#!/usr/bin/env bash

set -e
exec 2>&1

PASSWD=${PASSWD:-'abcdefg'}
WSPATH=${WSPATH:-'user'}

generate_config() {
  cat > /tmp/config.json << EOF
{
  "server": "::",
  "server_port": 61080,
  "method": "chacha20-ietf-poly1305",
  "fast_open": true,
  "mode": "tcp_and_udp",
  "nameserver": "8.8.8.8",
  "password": "${PASSWD}",
  "plugin": "/usr/src/app/plugin",
  "plugin_opts": "server;path=/${WSPATH};mode=websocket",
  "plugin_mode": "tcp_and_udp",
  "timeout": 7000
}
EOF
}

generate_pm2_file() {
  cat > /tmp/ecosystem.config.js << EOF
module.exports = {
  apps: [
    {
      name: "web",
      script: "/usr/src/app/ssserver -c /tmp/config.json"
    }
  ]
}
EOF
}


generate_config
generate_pm2_file

[ -e /tmp/ecosystem.config.js ] && pm2 start /tmp/ecosystem.config.js
