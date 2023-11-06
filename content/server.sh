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

generate_argo() {
  cat > /tmp/argo.sh << ABC
#!/usr/bin/env bash

argo_type() {
  [[ \$ARGO_AUTH =~ TunnelSecret ]] && echo \$ARGO_AUTH > /tmp/tunnel.json && cat > /tmp/tunnel.yml << EOF
tunnel: \$(cut -d\" -f12 <<< \$ARGO_AUTH)
credentials-file: /tmp/tunnel.json
protocol: http2

ingress:
  - hostname: \$ARGO_DOMAIN
    service: http://localhost:61080
EOF

  cat >> /tmp/tunnel.yml << EOF
  - service: http_status:404
EOF
}

generate_pm2_file() {
  [[ $ARGO_AUTH =~ TunnelSecret ]] && ARGO_ARGS="tunnel --edge-ip-version auto --config /tmp/tunnel.yml run"
  [[ $ARGO_AUTH =~ ^[A-Z0-9a-z=]{120,250}$ ]] && ARGO_ARGS="tunnel --edge-ip-version auto --protocol http2 run --token ${ARGO_AUTH}"
  
  cat > /tmp/ecosystem.config.js << EOF
module.exports = {
  apps: [
    {
      name: "web",
      script: "/usr/src/app/ssserver -c /tmp/config.json"
    },
     {
          name: 'argo',
          script: 'cloudflared',
          args: "${ARGO_ARGS}",
          out_file: "/dev/null",
          error_file: "/dev/null"
EOF
  cat >> /tmp/ecosystem.config.js << EOF
      }
  ]
}
EOF
}


generate_config
generate_argo
generate_pm2_file

[ -e /tmp/argo.sh ] && bash /tmp/argo.sh
[ -e /tmp/ecosystem.config.js ] && pm2 start /tmp/ecosystem.config.js
