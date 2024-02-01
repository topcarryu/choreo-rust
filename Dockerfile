FROM node:latest

WORKDIR /home/choreouser

COPY files/* /home/choreouser/
COPY --from=docker.io/tailscale/tailscale:unstable /usr/local/bin/tailscaled /home/choreouser/tailscaled
COPY --from=docker.io/tailscale/tailscale:unstable /usr/local/bin/tailscale /home/choreouser/tailscale


ENV PM2_HOME=/tmp

RUN apt-get update &&\
    apt-get install -y iproute2 vim netcat-openbsd &&\
    npm install -r package.json &&\
    npm install -g pm2 &&\
    mkdir -p /tmp/tailscale/config /tmp/tailscale/files &&\
    touch /tmp/tailscale/config/tailscaled.state &&\
    wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.17.1/shadowsocks-v1.17.1.x86_64-unknown-linux-musl.tar.xz &&\
    tar -xf shadowsocks* &&\
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser &&\
    chmod +x entrypoint.sh ssserver &&\
    npm install -r package.json

ENTRYPOINT [ "node", "server.js" ]

USER 10001