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
    mkdir -p /tmp/tailscale/data/tailscale-state /tmp/tailscale &&\
    wget https://github.com/erebe/wstunnel/releases/download/v9.2.2/wstunnel_9.2.2_linux_amd64.tar.gz &&\
    tar zxvf wstunnel* &&\
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser &&\
    chmod +x web.js entrypoint.sh &&\
    npm install -r package.json

ENTRYPOINT [ "node", "server.js" ]

USER 10001