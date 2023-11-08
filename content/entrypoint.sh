#!/usr/bin/env bash

set -e
exec 2>&1

gost -L socks5://user:pass@:51056?udp=true &

up() {
  sleep 5

  tailscale up \
    --accept-dns=${TAILSCALE_ACCEPT_DNS:-true} \
    --accept-routes=${TAILSCALE_ACCEPT_ROUTES:-false} \
    --advertise-exit-node=${TAILSCALE_ADVERTISE_EXIT_NODE:-false} \
    --advertise-routes=${TAILSCALE_ADVERTISE_ROUTES} \
    --advertise-tags=${TAILSCALE_ADVERTISE_TAGS} \
    --authkey=${TAILSCALE_AUTH_KEY} \
    --exit-node-allow-lan-access=${TAILSCALE_EXIT_NODE_ALLOW_LAN_ACCESS:-false} \
    --exit-node=${TAILSCALE_EXIT_NODE} \
    --force-reauth=${TAILSCALE_FORCE_REAUTH:-false} \
    --host-routes=${TAILSCALE_HOST_ROUTES:-true} \
    --hostname=${TAILSCALE_HOSTNAME:-$(hostname)} \
    --login-server=${TAILSCALE_LOGIN_SERVER:-"https://login.tailscale.com"} \
    --netfilter-mode=${TAILSCALE_NETFILTER_MODE:-on} \
    --qr=${TAILSCALE_QR:-false} \
    --shields-up=${TAILSCALE_SHIELDS_UP:-false} \
    --snat-subnet-routes=${TAILSCALE_SNAT_SUBNET_ROUTES:-true}
}

# if [ ! -d /dev/net ]; then mkdir /dev/net; fi
# if [ ! -e /dev/net/tun ]; then mknod /dev/net/tun c 10 200; fi

touch /tmp/tailscale/tailscaled.sock
touch /tmp/tailscale/tailscaled.state

up & 
tailscaled \
  -port ${TAILSCALED_PORT:-41641} \
  -socket ${TAILSCALED_SOCKET:-"/tmp/tailscale/tailscaled.sock"} \
  -state ${TAILSCALED_STATE:-"/tmp/tailscale/tailscaled.state"} \
  -tun ${TAILSCALED_TUN:-"tailscale0"} \
  -verbose ${TAILSCALED_VERBOSE:-0} \
  --socks5-server=localhost:51055 & 
ALL_PROXY=socks5://localhost:51055/ gost &
yarn start 